<!--
    This file is part of the AppVulnMS project.


    Copyright (c) 2014 Victor Dorneanu <info AAET dornea DOT nu>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

    The MIT License (MIT)
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="yes" cdata-section-elements="RawTraffic Raw"/>
<xsl:strip-space elements="*"/>

<xsl:template match="/">

	<XmlReport version="0.1">
    		<Scanner>
        			<Name>IBM Rational AppScan</Name>
        			<Version><xsl:value-of select="/XmlReport/AppScanInfo/Version/text()"/></Version>
    		</Scanner>
    		<Summary>
    			<TotalIssues><xsl:value-of select="/XmlReport/Summary/TotalIssues/text()"/></TotalIssues>
    			<ScanDuration><xsl:value-of select="/XmlReport/Summary/TotalScanDuration/text()"/></ScanDuration>
    			<Target>
    				<Host>
    					<xsl:attribute name="name"><xsl:value-of select="/XmlReport/Summary/Hosts/Host/@Name"/></xsl:attribute>
    					<Issues>
    						<xsl:attribute name="total"><xsl:value-of select="/XmlReport/Summary/TotalIssues/text()"/></xsl:attribute>
    						<High>
    							<xsl:value-of select="XmlReport/Summary/Hosts/Host/TotalHighSeverityIssues"/>
    						</High>
    						<Medium>
    							<xsl:value-of select="/XmlReport/Summary/Hosts/Host/TotalMediumSeverityIssues"/>
    						</Medium>
    						<Low>
    							<xsl:value-of select="/XmlReport/Summary/Hosts/Host/TotalLowSeverityIssues"/>
    						</Low>
    						<Informational>
    							<xsl:value-of select="/XmlReport/Summary/Hosts/Host/TotalInformationalIssues"/>
    						</Informational>
    					</Issues>
    				</Host>
    			</Target>
    		</Summary>
			<Results>
				<Vulnerabilities>
					<xsl:for-each select="/XmlReport/Results/Issues/Issue">
						<Vuln>
							<xsl:variable name="issueTypeID"><xsl:value-of select="@IssueTypeID"/></xsl:variable>
							<xsl:attribute name="type">
								<xsl:value-of select="@IssueTypeID"/>
							</xsl:attribute>
							<xsl:attribute name="error_type"></xsl:attribute>
							<Description>
								<xsl:value-of select="//IssueTypes//IssueType[@ID=$issueTypeID]/advisory/name"/>
							</Description>
							<Comments>
								<xsl:value-of select="Variant/Reasoning"/>
							</Comments>
							<Target>
								<xsl:attribute name="host"><xsl:value-of select="Url"/></xsl:attribute>
							</Target>
							<Severity>
								<xsl:value-of select="Severity"/>
							</Severity>

							<RawTraffic>
								<MergedTraffic>
									<xsl:value-of select="Variant/OriginalHttpTraffic"/>
								</MergedTraffic>
							</RawTraffic>

							<TestProbe>
								<HTTP>
									<Request>
										<xsl:attribute name="method"></xsl:attribute>
										<URL>
											<xsl:value-of select="concat('/', substring-after(Url, /XmlReport/Summary/Hosts/Host/@Name))"/>
										</URL>
										<Parsed>
											<!-- Will be generated by Python -->
										</Parsed>
										<Payload>
											<Input>
												<xsl:attribute name="type">
													<xsl:value-of select="Entity/@Type"/>
												</xsl:attribute>
												<xsl:attribute name="name">
													<xsl:value-of select="Entity/@Name"/>
												</xsl:attribute>
											</Input>
											<Raw>
												<xsl:value-of select="Variant/Difference"/>
											</Raw>
										</Payload>
									</Request>
									<Response>
										<Parsed>
											<!-- Will be generated by Python -->
										</Parsed>
									</Response>
								</HTTP>
							</TestProbe>

							<References>
								<xsl:for-each select="//IssueTypes/IssueType[@ID=$issueTypeID]/advisory/cwe/link">
									<Ref type="CWE">
										<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
										<xsl:attribute name="URL"><xsl:value-of select="@target"/></xsl:attribute>
									</Ref>
								</xsl:for-each>
								<xsl:for-each select="//IssueTypes/IssueType[@ID=$issueTypeID]/advisory/cve/link">
									<Ref type="CVE">
										<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
										<xsl:attribute name="URL"><xsl:value-of select="@target"/></xsl:attribute>
									</Ref>
								</xsl:for-each>

								<!-- Parse for other references -->
								<xsl:for-each select="//IssueTypes/IssueType[@ID=$issueTypeID]/advisory/references/link">
									<Ref>
										<xsl:attribute name="id">external-site</xsl:attribute>
										<xsl:attribute name="type"><xsl:value-of select="text()"/></xsl:attribute>
										<xsl:attribute name="URL"><xsl:value-of select="@target"/></xsl:attribute>
									</Ref>
								</xsl:for-each>
							</References>

						</Vuln>
					</xsl:for-each>
				</Vulnerabilities>
			</Results>
    	</XmlReport>
</xsl:template>
</xsl:stylesheet>

