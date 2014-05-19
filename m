Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbaESQUM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 12:20:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 648B6AC77
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 16:20:11 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/5] btrfs-progs: doc: autoformat user-supplied arguments by sed
Date: Mon, 19 May 2014 18:20:11 +0200
Message-Id: <aaeae23458aa76a68f5e1b1fb8bf551b04f57f2e.1400515868.git.dsterba@suse.cz>
In-Reply-To: <cover.1400515867.git.dsterba@suse.cz>
References: <cover.1400515867.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert all values enclosed between <...> to italic before it goes to
asciidoc processor.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/Makefile | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index e22f5bca0ff2..45299bb29f9b 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -85,10 +85,11 @@ clean:
 %.8 : %.xml 
 	$(QUIET_XMLTO)$(RM) $@ && \
 	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
-
 %.xml : %.txt asciidoc.conf
-	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(QUIET_ASCIIDOC)$(RM) $@.tmp[12] $@ && \
+	sed -e "s/\(<[^>]\+>\)/'\1'/g" < $< > $@.tmp1 && \
 	$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
 		$(ASCIIDOC_EXTRA) -abtrfs_version=$(BTRFS_VERSION) \
-		-o $@+ $< && \
-	mv $@+ $@
+		-o $@.tmp2 $@.tmp1 && \
+	mv $@.tmp2 $@ && \
+	rm -f -- $@.tmp1
-- 
1.9.0

