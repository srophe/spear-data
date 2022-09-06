<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:sc="http://www.ascc.net/xml/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:srophe="https://srophe.app" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:local="http://syriaca.org/ns" version="3.0">
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes" xpath-default-namespace="http://www.tei-c.org/ns/1.0"/>
    
    <xsl:template match="/">
        <xsl:variable name="processingInstructions" select="processing-instruction()"/>
        <xsl:variable name="folderName" select="tokenize(replace(//tei:publicationStmt/tei:idno[@type='URI'],'/tei',''),'/')[last()]"/>
        <xsl:variable name="back" select="descendant::tei:back"/>
        <!-- <ab type="factoid" -->
        <xsl:for-each select="descendant::tei:ab[@type='factoid']">
            <xsl:variable name="factoidURI" select="tei:idno[@type='URI']"/>
            <xsl:variable name="factoidID" select="tokenize(tei:idno[@type='URI'],'/')[last()]"/>
            <xsl:result-document href="data/factoids/{$folderName}/{$factoidID}.xml">
                <xsl:sequence select="$processingInstructions"/>
                <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:srophe="https://srophe.app">
                    <xsl:call-template name="teiHeader">
                        <xsl:with-param name="factoidURI" select="$factoidURI"/>
                    </xsl:call-template>
                    <text>
                        <body>
                            <xsl:copy-of select="."/>
                        </body>
                        <xsl:sequence select="$back"></xsl:sequence>
                    </text>
                </TEI>
            </xsl:result-document>    
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="teiHeader">
        <xsl:param name="factoidURI"/>
        <xsl:for-each select="//tei:teiHeader">
            <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:for-each select="child::*">
                    <xsl:choose>
                        <xsl:when test="self::tei:fileDesc">
                            <fileDesc>
                                <xsl:for-each select="child::*">
                                    <xsl:choose>
                                        <xsl:when test="self::tei:publicationStmt">
                                            <publicationStmt>
                                                <xsl:for-each select="child::*">
                                                    <xsl:choose>
                                                        <xsl:when test="self::tei:idno">
                                                            <idno type="URI"><xsl:value-of select="$factoidURI"/></idno>
                                                        </xsl:when>
                                                        <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                            </publicationStmt>
                                        </xsl:when>
                                        <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </fileDesc>
                        </xsl:when>
                        <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </teiHeader>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>