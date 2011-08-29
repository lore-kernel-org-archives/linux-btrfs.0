From: Jeff Liu <jeff.liu@oracle.com>
Subject: trivial fix s/u64/u32/ for sb->s_blocksize
Date: Mon, 29 Aug 2011 22:57:46 +0800
Message-ID: <4E5BA8EA.8050407@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

in btrfs_ioctl_clone(), using u32 for super_block->s_blocksize assignment.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..03ab77a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2133,12 +2133,12 @@ static noinline long btrfs_ioctl_clone(struct 
file *file, unsigned long srcfd,
      struct extent_buffer *leaf;
      char *buf;
      struct btrfs_key key;
-    u32 nritems;
      int slot;
      int ret;
      u64 len = olen;
-    u64 bs = root->fs_info->sb->s_blocksize;
      u64 hint_byte;
+    u32 bs = root->fs_info->sb->s_blocksize;
+    u32 nritems;

      /*
       * TODO:
