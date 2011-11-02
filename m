From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: mention libattr dependency in INSTALL file
Date: Wed,  2 Nov 2011 17:14:33 +0200
Message-ID: <1320246873-25457-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 INSTALL |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/INSTALL b/INSTALL
index 6afbd90..11c388b 100644
--- a/INSTALL
+++ b/INSTALL
@@ -19,7 +19,8 @@ insmod btrfs.ko
 
 The Btrfs utility programs require libuuid to build.  This can be found
 in the e2fsprogs sources, and is usually available as libuuid or
-e2fsprogs-devel from various distros.
+e2fsprogs-devel from various distros.  The other dependency is libattr
+(libattr1-dev in Debian-based distros).
 
 Building the utilities is just make ; make install.  The programs go
 into /usr/local/bin.  The mains commands available are:
-- 
1.7.6.3

