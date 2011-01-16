From: David Nicol <davidnicol@gmail.com>
Subject: ioctl #21 kernel patch that (1) actually works, to wait for
 dead_roots cleaning and (2) provides framework for adding facility for
 user-space waiting for anything else deferred
Date: Sun, 16 Jan 2011 14:52:39 -0600
Message-ID: <AANLkTi=d2vknDC4V+Xer9FEZ20VRtXJtLD06yY4YWVo3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>,
	"chris.mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here is the latest ioctl #21 kernel patch;
it  (1) actually works, unlike the last one, which only waited until
the to-do list was emptied at the beginning of the cleaning function,
which wasn't actually helpful
and (2) provides framework for adding facility for user-space waiting
for anything else deferred, with "deferred iputs" penciled in as the
next thing to allow waiting for -- which probably currently suffers
from a similar problem with the to-do list getting emptied before the
work is done -- but which is out of the scope of the sponsor's
requirements.  Another pair of atomics might be required to make that
work right too. I don't know if waiting for deferred iputs is holding
anyone or anything back.

Going forward, I imagine ioctl #21, with it's flags field, to be the
ioctl that newly deferred and backgrounded activities use to allow
waiting for their completion. This means that any move to background
something would include extending the BICW_TEST macro to include
testing for completion of the deferred activity, adjusting the maximum
flag value in strict mode, and adding more wakeup calls around the
code that handles the new deferred thing.

A flags field of 0xFFFA should always mean "wait for completion of
everything you know how to wait for."

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29c2009..250f2f1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -895,6 +895,8 @@ struct btrfs_fs_info {
 	struct list_head trans_list;
 	struct list_head hashers;
 	struct list_head dead_roots;
+	atomic_t dead_roots_cleaners ;
+	wait_queue_head_t cleaner_notification_registration;
 	struct list_head caching_block_groups;

 	spinlock_t delayed_iput_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..d2741c5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1450,7 +1450,9 @@ static int cleaner_kthread(void *arg)
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
 			btrfs_run_delayed_iputs(root);
+			wake_up_all(&root->fs_info->cleaner_notification_registration);
 			btrfs_clean_old_snapshots(root);
+			wake_up_all(&root->fs_info->cleaner_notification_registration);
 			mutex_unlock(&root->fs_info->cleaner_mutex);
 		}

@@ -1581,6 +1583,8 @@ struct btrfs_root *open_ctree(struct super_block =
*sb,
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
+	atomic_set(&fs_info->dead_roots_cleaners,0);
+	init_waitqueue_head(&fs_info->cleaner_notification_registration);
 	INIT_LIST_HEAD(&fs_info->delayed_iputs);
 	INIT_LIST_HEAD(&fs_info->hashers);
 	INIT_LIST_HEAD(&fs_info->delalloc_inodes);
@@ -2393,7 +2397,9 @@ int btrfs_commit_super(struct btrfs_root *root)

 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(root);
+	wake_up_all(&root->fs_info->cleaner_notification_registration);
 	btrfs_clean_old_snapshots(root);
+	wake_up_all(&root->fs_info->cleaner_notification_registration);
 	mutex_unlock(&root->fs_info->cleaner_mutex);

 	/* wait until ongoing cleanup work done */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..b669f19 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1212,6 +1212,66 @@ static noinline int
btrfs_ioctl_ino_lookup(struct file *file,
 	return ret;
 }

+static int btrfs_ioctl_cleaner_wait(struct btrfs_root *root, void __us=
er *arg)
+{
+        struct btrfs_ioctl_cleaner_wait_args *bicwa;
+        long remainingjiffies;
+        int err;
+
+	bicwa =3D memdup_user(arg, sizeof(*bicwa));
+	if (IS_ERR(bicwa))
+		return PTR_ERR(bicwa);
+
+        err =3D -EINVAL;
+
+        /* flag bit 0x04 means, error on unknown flag.
+           the highest possible valid flag value at this rev is 0x07. =
*/
+        if (((bicwa->flags & 4) =3D=3D 4) &&( bicwa->flags > 7) ){
+	    kfree(bicwa);
+            return err;
+        };
+
+#define BICW_TEST ( \
+       /* flag bit 0x01: suppress wait for dead_roots */              =
      \
+       (bicwa->flags & 1 =3D=3D 1 || ( list_empty(&root->fs_info->dead=
_roots))  \
+              && ( atomic_read(&root->fs_info->dead_roots_cleaners) =3D=
=3D 0 ))  \
+                                                                      =
      \
+       /* flag bit 0x02: wait for delayed iputs */                    =
      \
+  &&   (bicwa->flags & 2 =3D=3D 0 || list_empty(&root->fs_info->delaye=
d_iputs)) \
+                                                                      =
      \
+       /* 0x04 is consumed earlier */                                 =
      \
+       /* add the next one at 0x08 */                                 =
      \
+)
+
+        if (bicwa->ms > 0)
+	{
+            unsigned long millisecs =3D bicwa->ms;
+            remainingjiffies =3D wait_event_interruptible_timeout(
+                 root->fs_info->cleaner_notification_registration,
+                 BICW_TEST, msecs_to_jiffies(millisecs)
+            );
+            if (remainingjiffies > 0)
+                  err =3D 0;
+            else if (remainingjiffies < 0 )
+                  err =3D -EAGAIN;
+            else
+                  err =3D -ETIME;
+        }
+	else
+	{
+            err =3D wait_event_interruptible(
+                 root->fs_info->cleaner_notification_registration,
+                 BICW_TEST
+            );
+        };
+
+	kfree(bicwa);
+        return err;
+
+#undef BICWATEST
+}
+
+
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 					     void __user *arg)
 {
@@ -2003,6 +2063,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_snap_create(file, argp, 1);
 	case BTRFS_IOC_SNAP_DESTROY:
 		return btrfs_ioctl_snap_destroy(file, argp);
+	case BTRFS_IOC_CLEANER_WAIT:
+		return btrfs_ioctl_cleaner_wait(root, argp);
 	case BTRFS_IOC_DEFAULT_SUBVOL:
 		return btrfs_ioctl_default_subvol(file, argp);
 	case BTRFS_IOC_DEFRAG:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..9af8530 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -138,6 +138,11 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };

+struct btrfs_ioctl_cleaner_wait_args{
+        __u32 ms;
+        __u32 flags;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -178,4 +183,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_CLEANER_WAIT _IOW(BTRFS_IOCTL_MAGIC, 21, \
+				    struct btrfs_ioctl_cleaner_wait_args)
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 66e4c66..1e3909d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1205,6 +1205,7 @@ int btrfs_clean_old_snapshots(struct btrfs_root *=
root)
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info =3D root->fs_info;

+	atomic_inc(&fs_info->dead_roots_cleaners);
 	mutex_lock(&fs_info->trans_mutex);
 	list_splice_init(&fs_info->dead_roots, &list);
 	mutex_unlock(&fs_info->trans_mutex);
@@ -1219,5 +1220,6 @@ int btrfs_clean_old_snapshots(struct btrfs_root *=
root)
 		else
 			btrfs_drop_snapshot(root, NULL, 1);
 	}
+	atomic_dec(&fs_info->dead_roots_cleaners);
 	return 0;
 }


--=20
=E2=80=9CThe aeroplane is fatally defective. It is merely a toy=E2=80=94=
a sporting
play-thing. =C2=A0It can never become commercially practical." -- Nikol=
a
Tesla
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
