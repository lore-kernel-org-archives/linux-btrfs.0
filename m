Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45578 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751434AbdJLMJE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 08:09:04 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: David Sterba <dsterba@suse.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH] configure.ac: allow '--with-convert=' to accept comma-separated values
Date: Thu, 12 Oct 2017 13:08:54 +0100
Message-Id: <20171012120854.28748-1-slyfox@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the change configure refused to accept it's defaults explicitly:
    $ ./configure --enable-convert --with-convert=ext2,reiserfs
    ...
    configure: error: unknown tokens for --with-convert: ,

After the change both converters are enabled:
    $ ./configure --enable-convert --with-convert=ext2,reiserfs
    ...
            btrfs-convert:      yes (ext2,reiserfs)

Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index f273bbe9..adceafc3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -148,7 +148,7 @@ AC_SUBST([BTRFSCONVERT_EXT2])
 AC_SUBST([BTRFSCONVERT_REISERFS])
 
 # catch typos
-tmp=$(echo "$with_convert" | sed -e 's/auto//' | sed -e 's/ext2//' | sed -e 's/reiserfs//' | sed -e 's/,\+/,/')
+tmp=$(echo "$with_convert" | sed -e 's/auto//' | sed -e 's/ext2//' | sed -e 's/reiserfs//' | sed -e 's/,\+//')
 if ! test "x$tmp" = "x"; then
 	AC_MSG_ERROR([unknown tokens for --with-convert: $tmp])
 fi
-- 
2.14.2

