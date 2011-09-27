From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: break out of orphan cleanup if we can't make progress
Date: Tue, 27 Sep 2011 16:44:13 +0200
Message-ID: <20110927144413.GE22205@twin.jikos.cz>
References: <1317066989-22566-1-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317066989-22566-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2011 at 03:56:29PM -0400, Josef Bacik wrote:
> I noticed while running xfstests 83 that if we didn't have enough space to
> delete our inode the orphan cleanup would just loop.  This is because it keeps
> finding the same orphan item and keeps trying to kill it but can't because we
> don't get an error back from iput for deleting the inode.

It would make more sense to catch this error rather than bailing out.
One undeletable orphan forbids any following orphans to be deleted until
next mount(?), dunno.

But still better than current behaviour, the while loops over and over
and the box is near to unaccessbile (I don't remember if I had to
powerswitch it or if a ssh & sysrq-b worked).

> So keep track of the
> last guy we tried to kill, if it's the same as the one we're trying to kill
> currently we know we are having problems and can just error out.  I don't have a
> way to test this so look hard and make sure it's right.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/inode.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 446531a..bcd7463 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2230,6 +2230,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  	struct btrfs_key key, found_key;
>  	struct btrfs_trans_handle *trans;
>  	struct inode *inode;
> +	u64 last_objectid = 0;
>  	int ret = 0, nr_unlink = 0, nr_truncate = 0;
>  
>  	if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEANUP_STARTED))
> @@ -2281,9 +2282,20 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  		 * crossing root thing.  we store the inode number in the
>  		 * offset of the orphan item.
>  		 */
> +
> +		if (found_key.offset == last_objectid) {
> +			printk(KERN_ERR "btrfs: Error removing orphan entry, "
> +			       "stopping orphan cleanup\n");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
>  		found_key.objectid = found_key.offset;
>  		found_key.type = BTRFS_INODE_ITEM_KEY;
>  		found_key.offset = 0;
> +
> +		last_objectid = found_key.offset;
> +
>  		inode = btrfs_iget(root->fs_info->sb, &found_key, root, NULL);
>  		ret = PTR_RET(inode);
>  		if (ret && ret != -ESTALE)
> -- 
> 1.7.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
