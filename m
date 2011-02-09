From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: prevent heap corruption in
	btrfs_ioctl_space_info()
Date: Wed, 9 Feb 2011 11:16:55 -0500
Message-ID: <20110209161654.GB2564@localhost.localdomain>
References: <1297260766.2327.40.camel@dan> <20110209155130.GA2564@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, chris.mason@oracle.com,
	security@kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110209155130.GA2564@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 09, 2011 at 10:51:33AM -0500, Josef Bacik wrote:
> On Wed, Feb 09, 2011 at 09:12:46AM -0500, Dan Rosenberg wrote:
> > Commit bf5fc093c5b625e4259203f1cee7ca73488a5620 refactored
> > btrfs_ioctl_space_info() and introduced several security issues.
> > 
> > space_args.space_slots is an unsigned 64-bit type controlled by a
> > possibly unprivileged caller.  The comparison as a signed int type
> > allows providing values that are treated as negative and cause the
> > subsequent allocation size calculation to wrap, or be truncated to 0.
> > By providing a size that's truncated to 0, kmalloc() will return
> > ZERO_SIZE_PTR.  It's also possible to provide a value smaller than the
> > slot count.  The subsequent loop ignores the allocation size when
> > copying data in, resulting in a heap overflow or write to ZERO_SIZE_PTR.
> > 
> > The fix changes the slot count type and comparison typecast to u64,
> > which prevents truncation or signedness errors, and also ensures that we
> > don't copy more data than we've allocated in the subsequent loop.  Note
> > that zero-size allocations are no longer possible since there is already
> > an explicit check for space_args.space_slots being 0 and truncation of
> > this value is no longer an issue.
> > 
> > Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> 
> Reviewed-by: Josef Bacik <josef@redhat.com>
> 

Argh sorry I take it back, this is wrong, we can have multiple raid types per
space info, so you need to put the slot_count-- in the inner loop farther down
to count the actual slots we're adding.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b72520b..89bfd41 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2203,7 +2203,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	int num_types = 4;
 	int alloc_size;
 	int ret = 0;
-	int slot_count = 0;
+	u64 slot_count = 0;
 	int i, c;
 
 	if (copy_from_user(&space_args,
@@ -2242,7 +2242,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 		goto out;
 	}
 
-	slot_count = min_t(int, space_args.space_slots, slot_count);
+	slot_count = min_t(u64, space_args.space_slots, slot_count);
 
 	alloc_size = sizeof(*dest) * slot_count;
 
@@ -2262,6 +2262,9 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	for (i = 0; i < num_types; i++) {
 		struct btrfs_space_info *tmp;
 
+		if (!slot_count)
+			break;
+
 		info = NULL;
 		rcu_read_lock();
 		list_for_each_entry_rcu(tmp, &root->fs_info->space_info,
@@ -2283,7 +2286,10 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 				memcpy(dest, &space, sizeof(space));
 				dest++;
 				space_args.total_spaces++;
+				slot_count--;
 			}
+			if (!slot_count)
+				break;
 		}
 		up_read(&info->groups_sem);
 	}
