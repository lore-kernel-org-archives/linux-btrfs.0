From: Sage Weil <sage@newdream.net>
Subject: [PATCH 4/5] Btrfs: return transid to userspace from SNAP_CREATE_ASYNC ioctl
Date: Mon, 22 Mar 2010 12:13:29 -0700
Message-ID: <1269285210-19085-5-git-send-email-sage@newdream.net>
References: <1269285210-19085-1-git-send-email-sage@newdream.net>
 <1269285210-19085-2-git-send-email-sage@newdream.net>
 <1269285210-19085-3-git-send-email-sage@newdream.net>
 <1269285210-19085-4-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1269285210-19085-4-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure about this one.  The idea is to start a snapshot
commit with the SNAP_CREATE_ASYNC ioctl, and wait for it with
the WAIT_SYNC ioctl.  I'm not sure that modifying
btrfs_ioctl_vol_args is the way to do that.  That technically
changes the ABI (albeit in a way that nobody will actually
notice).  I'm not sure it's worth creating a second, different
ioctl_async_vol_args struct and complicating ioctl.c funcs.

OTOH, a WAIT_SYNC without an explicit trans will almost always
accomplish the same thing.  Worst case we wait a bit longer than
needed (for a second racing commit to complete).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    7 +++++++
 fs/btrfs/ioctl.h |    4 +++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7ea4ff0..fd824a7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -885,6 +885,13 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 				     async ? &transid : NULL);
 		fput(src_file);
 	}
+	if (!ret && async) {
+		struct btrfs_ioctl_vol_args __user *user_vol_args = arg;
+
+		if (copy_to_user(&user_vol_args->transid, &transid,
+				 sizeof(transid)))
+			return -EFAULT;
+	}
 out:
 	kfree(vol_args);
 	return ret;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index d9169d8..4f7fe37 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -22,12 +22,14 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
-#define BTRFS_PATH_NAME_MAX 4087
+#define BTRFS_PATH_NAME_MAX 4071
 
 /* this should be 4k */
 struct btrfs_ioctl_vol_args {
 	__s64 fd;
 	char name[BTRFS_PATH_NAME_MAX + 1];
+	__u64 transid;
+	__u64 reserved;
 };
 
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
-- 
1.6.6.1

