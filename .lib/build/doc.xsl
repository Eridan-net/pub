<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="fn" -->
  <xsl:template match="/">
    <doc uri="{document-uri(.)}">
      <xsl:analyze-string select="document-uri(.)" regex="(\w*://)(.*)">
        <xsl:matching-substring>
          <protocol><xsl:value-of select="regex-group(1)"/>
          </protocol>
          <path><xsl:value-of select="regex-group(2)"/>
          </path>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </doc>
  </xsl:template>
</xsl:stylesheet>
