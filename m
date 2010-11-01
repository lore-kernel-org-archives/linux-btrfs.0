From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs-progs: ioctl: add may_alias to btrfs_ioctl_search_header
Date: Mon,  1 Nov 2010 09:34:20 -0700
Message-ID: <1288629262-5405-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This fixes the errors

btrfs-list.c: In function 'ino_resolve':
btrfs-list.c:506: error: dereferencing pointer 'sh' does break strict-aliasing rules
btrfs-list.c:504: error: dereferencing pointer 'sh' does break strict-aliasing rules
btrfs-list.c:502: note: initialized from here

when building with gcc version 4.4.4 (Debian 4.4.4-6).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 ioctl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 5a03317..4a850ff 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -87,7 +87,7 @@ struct btrfs_ioctl_search_header {
 	__u64 offset;
 	__u32 type;
 	__u32 len;
-};
+} __attribute__((__may_alias__));
 
 #define BTRFS_SEARCH_ARGS_BUFSIZE (4096 - sizeof(struct btrfs_ioctl_search_key))
 /*
-- 
1.7.0

