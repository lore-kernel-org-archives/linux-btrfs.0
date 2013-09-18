Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3IRP0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 11:26:40 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8F211A51CB
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 17:26:38 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: remove leftovers from hg times
Date: Wed, 18 Sep 2013 17:26:33 +0200
Message-Id: <1379517993-5785-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 .hgignore  |  1 -
 .hgtags    | 15 ---------------
 version.sh | 20 --------------------
 3 files changed, 36 deletions(-)
 delete mode 100644 .hgignore
 delete mode 100644 .hgtags

diff --git a/.hgignore b/.hgignore
deleted file mode 100644
index 6702033..0000000
--- a/.hgignore
+++ /dev/null
@@ -1 +0,0 @@
-version.h
diff --git a/.hgtags b/.hgtags
deleted file mode 100644
index 2aa4389..0000000
--- a/.hgtags
+++ /dev/null
@@ -1,15 +0,0 @@
-9cebac62e0c9df99a4ac5a9d489efe0c2e957713 v0.2
-1ef7cf63ac2c67e99b1a1c084554e9c87b08d2b0 v0.3
-c760f17dde33c970fc91ece5360567320396b627 v0.4
-c969452d5ae70db57fdd668557fbdb07756101e8 v0.4
-85bf731757729f25aaf76e47837b39122bea569f v0.5
-75b9a16fff1ae31c572317f2516476750fd1919a v0.6
-f4810b8d5822f06f7104806477863756886eb57f v0.8
-99eb8cf2ca515c2d747ec132e166222089b17056 v0.9
-548ea8d7514ba7fed921983029e5ef690fb3ef0a v0.10
-b3e59089dab67cc3ba52f83f41e9650773d89bd7 v0.11
-5e8f040cdf7c1d7e2cb583444b9434c31b673935 v0.12
-58b803dc9faeb19f2260f8aa37a8a4590fae085b v0.13
-969099968b60600901f90531fddd2f18e32ac336 v0.14
-e6571e2ce0c8ac9fcad9b5b638008e7c8980bf4d v0.15
-2b26e4f8c71ea411d7df35f23e38627cdcbef310 v0.16
diff --git a/version.sh b/version.sh
index b81040e..971646b 100644
--- a/version.sh
+++ b/version.sh
@@ -24,26 +24,6 @@ if [ $? == 0 -a -d .git ]; then
     fi
 fi
 
-which hg &> /dev/null
-if [ $? == 0 -a -d .hg ]; then
-	last=$(hg tags | grep -m1 -o '^v[0-9.]\+')
-	 
-	# now check if the repo has commits since then...
-	if [[ $(hg id -t) == $last || \
-	    $(hg di -r "$last:." | awk '/^diff/{print $NF}' | sort -u) == .hgtags ]]
-	then
-	    # check if it's dirty
-	    if [[ $(hg id | cut -d' ' -f1) == *+ ]]; then
-		v=$last+
-	    else
-		v=$last
-	    fi
-	else
-	    # includes dirty flag
-	    v=$last+$(hg id -i)
-	fi
-fi
- 
 echo "#ifndef __BUILD_VERSION" > .build-version.h
 echo "#define __BUILD_VERSION" >> .build-version.h
 echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
-- 
1.8.3.1

