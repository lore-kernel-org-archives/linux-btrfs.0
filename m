Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lekensteyn.nl ([178.21.112.251]:52995 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbbAEOKP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Jan 2015 09:10:15 -0500
Received: by lekensteyn.nl with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA256:128)
	(Exim 4.80)
	(envelope-from <peter@lekensteyn.nl>)
	id 1Y88MH-0006Y6-5u
	for linux-btrfs@vger.kernel.org; Mon, 05 Jan 2015 15:10:13 +0100
From: Peter Wu <peter@lekensteyn.nl>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Documentation: fix broken conversion
Date: Mon,  5 Jan 2015 15:10:09 +0100
Message-Id: <1420467009-11738-1-git-send-email-peter@lekensteyn.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixes various formatting issues:

Fixes quoting issues in various manpages. Before/After excerpts for
mkfs.btrfs(8), btrfs-qgroup(8):

    mkfs.btrfs [-A|--alloc-start '<alloc-start>']
    mkfs.btrfs [-A|--alloc-start <alloc-start>]
    id 0/<subvolume id>''
    id 0/<subvolume id>
    If multiple '<attr>'s is given, use comma to separate.
    If multiple <attr>s is given, use comma to separate.

The one that is most apparent is the removal of text in
btrfs-subvolume(8) and others. Before/After:

    list [options] [-G <value>] [-C <value>] [--sort=rootid,gen,ogen,path] <path>
    list [options] [-G [+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>
    create [-i <qgroupid>] <name>
    create [-i <qgroupid>] [<dest>]<name>

This happens because `<foo>` was replaced by `'<foo>'` in the sed
expression, which is then treated as a constrained quote. As a result,
the `[...]` before the string gets interpreted as "quoted text
attributes".

In this patch, the sed expression is dropped and asciidoc is configured
to recognize `<...>` as a unconstrained quoted string (such that
`<attr>s` is correctly emphasized) and to avoid adding quotes in
contexts where it is not needed.

A remaining problem is that some texts (the one between brackets) do not
add the emphasis for `<...>`. While this could be solved by replacing
`[` and `]` with `&#91;` and `&#93;` using sed, it introduces formatting
problems in btrfs-zero-log(8) because the context is ignored.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 Documentation/Makefile      | 8 +++-----
 Documentation/asciidoc.conf | 6 ++++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index ef4f1bd..72ab77b 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -113,10 +113,8 @@ clean:
 	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 
 %.xml : %.txt asciidoc.conf
-	$(QUIET_ASCIIDOC)$(RM) $@.tmp[12] $@ && \
-	sed -e "s/\(<[^>]\+>\)/'\1'/g" < $< > $@.tmp1 && \
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
 		$(ASCIIDOC_EXTRA) -abtrfs_version=$(BTRFS_VERSION) \
-		-o $@.tmp2 $@.tmp1 && \
-	mv $@.tmp2 $@ && \
-	rm -f -- $@.tmp1
+		-o $@+ $< && \
+	mv $@+ $@
diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf
index 313f185..1ea7459 100644
--- a/Documentation/asciidoc.conf
+++ b/Documentation/asciidoc.conf
@@ -10,6 +10,12 @@
 [macros]
 (?su)[\\]?(?P<name>linkbtrfs):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=
 
+[tags]
+bracket-emphasis={1?[{1}]}<emphasis>&lt;|&gt;</emphasis>
+
+[quotes]
+&lt;|&gt;=#bracket-emphasis
+
 [attributes]
 asterisk=&#42;
 plus=&#43;
-- 
2.2.1

