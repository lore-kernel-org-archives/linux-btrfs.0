From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add a "df" ioctl for btrfs
Date: Wed, 13 Jan 2010 13:19:06 -0500
Message-ID: <20100113181905.GA2774@dhcp231-156.rdu.redhat.com>
References: <20100112202513.GA13414@localhost.localdomain> <20100113143100.GM14979@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100113143100.GM14979@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2010 at 09:31:00AM -0500, Chris Mason wrote:
> On Tue, Jan 12, 2010 at 03:25:13PM -0500, Josef Bacik wrote:
> > df is a very loaded question in btrfs.  This gives us a way to get the per-space
> > usage information so we can tell exactly what is in use where.  This will help
> > us figure out ENOSPC problems, and help users better understand where their disk
> > space is going.
> > 
> > diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> > index 9e5074c..850e0ee 100644
> > --- a/fs/btrfs/ioctl.h
> > +++ b/fs/btrfs/ioctl.h
> > @@ -54,6 +54,18 @@ struct btrfs_ioctl_subvol_leaf {
> >  	struct btrfs_ioctl_subvol_items items[];
> >  };
> >  
> > +struct btrfs_ioctl_space_info {
> > +	u32 flags;
> > +	u64 total_bytes;
> > +	u64 used_bytes;
> > +};
> 
> Could you please bump that u32 to a u64?
> 

Here you are, sorry about that.  Thanks,

Josef


>From 6c486aea6268c2e214ba3c73cb2bb1422335c84b Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@redhat.com>
Date: Wed, 13 Jan 2010 13:02:59 -0500
Subject: [PATCH] Btrfs: add a "df" ioctl for btrfs

df is a very loaded question in btrfs.  This gives us a way to get the per-space
usage information so we can tell exactly what is in use where.  This will help
us figure out ENOSPC problems, and help users better understand where their disk
space is going.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ioctl.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   15 ++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9070b86..7405e42 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1623,6 +1623,49 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	return 0;
 }
 
+long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_space_args space_args;
+	struct btrfs_ioctl_space_info space;
+	struct btrfs_ioctl_space_info *dest;
+	struct btrfs_space_info *info;
+	int ret = 0;
+
+	if (copy_from_user(&space_args,
+			   (struct btrfs_ioctl_space_args __user *)arg,
+			   sizeof(space_args)))
+		return -EFAULT;
+
+	space_args.total_spaces = 0;
+	dest = (struct btrfs_ioctl_space_info *)
+		(arg + sizeof(struct btrfs_ioctl_space_args));
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(info, &root->fs_info->space_info, list) {
+		if (!space_args.space_slots) {
+			space_args.total_spaces++;
+			continue;
+		}
+		if (space_args.total_spaces >= space_args.space_slots)
+			break;
+		space.flags = info->flags;
+		space.total_bytes = info->total_bytes;
+		space.used_bytes = info->bytes_used;
+		if (copy_to_user(dest, &space, sizeof(space))) {
+			ret = -EFAULT;
+			break;
+		}
+		dest++;
+		space_args.total_spaces++;
+	}
+	rcu_read_unlock();
+
+	if (copy_to_user(arg, &space_args, sizeof(space_args)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 /*
  * there are many ways the trans_start and trans_end ioctls can lead
  * to deadlocks.  They should only be used by applications that
@@ -1691,6 +1734,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_trans_end(file);
 	case BTRFS_IOC_SNAP_LISTING:
 		return btrfs_ioctl_snap_listing(file, argp);
+	case BTRFS_IOC_SPACE_INFO:
+		return btrfs_ioctl_space_info(root, argp);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 9e5074c..d5a8e7a 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -54,6 +54,18 @@ struct btrfs_ioctl_subvol_leaf {
 	struct btrfs_ioctl_subvol_items items[];
 };
 
+struct btrfs_ioctl_space_info {
+	u64 flags;
+	u64 total_bytes;
+	u64 used_bytes;
+};
+
+struct btrfs_ioctl_space_args {
+	u64 space_slots;
+	u64 total_spaces;
+	struct btrfs_ioctl_space_info spaces[0];
+};
+
 #define BTRFS_SUBVOL_LEAF_SIZE_MIN sizeof(struct btrfs_ioctl_subvol_leaf) + \
 	sizeof(struct btrfs_ioctl_subvol_items)
 
@@ -97,5 +109,6 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
 				   struct btrfs_ioctl_subvol_args)
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 17, u64)
-
+#define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 18, \
+				    struct btrfs_ioctl_space_args)
 #endif
-- 
1.5.4.3

