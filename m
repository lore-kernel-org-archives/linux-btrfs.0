Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25443 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933459AbcJ0CdR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 22:33:17 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Ignore clang complete file
Date: Thu, 27 Oct 2016 10:32:48 +0800
Message-Id: <20161027023248.19561-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While most guys are using ctags and cscope with vim, new completion tool
like vim-clang_completion is gaining its popularity, due to its compiler
level accuracy simpleness to use.

Since ctags and cscope are already in .gitignore, I see no reason to
reject .clang_complete.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 214103d..98b3657 100644
--- a/.gitignore
+++ b/.gitignore
@@ -64,6 +64,7 @@ config/py-compile
 config/test-driver
 configure
 cscope.out
+.clang_complete
 depcomp
 libtool
 Makefile
-- 
2.10.1



