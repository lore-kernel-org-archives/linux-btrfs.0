From: Josef Bacik <josef@redhat.com>
Subject: Re: [review] Btrfs: Allow shrinking close to used space
Date: Wed, 25 Feb 2009 15:02:29 -0500
Message-ID: <20090225200229.GB10849@unused.rdu.redhat.com>
References: <m34oyixrcp.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m34oyixrcp.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 25, 2009 at 02:13:10PM -0500, Chris Ball wrote:
> Hi,
> 
> This patch (against experimental HEAD) attempts to make shrinking more
> robust, by only updating device size if we've succeeded in creating
> enough free space without any failures in btrfs_relocate_chunk().
> 
> Here's a log with my patch applied.  The two things to note are that a
> near-limit shrink now works, and that a failed shrink (in this case,
> trying to shrink to less than the used space) no longer updates the
> device size erroneously:
> 
>   http://dev.laptop.org/~cjb/btrfs/shrink-log
> 
> Please review carefully -- I'm still new to btrfs.  The short version of
> the patch is:
> 
> * create a success path, as a break out of the while(1) relocating
>   (rather than going to the "done" label).
> * move the device size updating code into that path
> * leave "path->reada = 2;" behind in the entry path, since path is
>   used by the searching operation rather than the later resize.
> 
> Thanks!
> 
> Signed-off-by: Chris Ball <cjb@laptop.org>
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1316139..e2fa072 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1815,30 +1815,8 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>  	if (!path)
>  		return -ENOMEM;
>  
> -	trans = btrfs_start_transaction(root, 1);
> -	if (!trans) {
> -		ret = -ENOMEM;
> -		goto done;
> -	}
> -
>  	path->reada = 2;
>  
> -	lock_chunks(root);
> -
> -	device->total_bytes = new_size;
> -	if (device->writeable)
> -		device->fs_devices->total_rw_bytes -= diff;

So I think you still want to do this part, to keep the allocator from actually
allocating new space in the area we are trying to cull with the shrink, we just
don't want to update the ondisk stuff just yet, so everything else can be moved
to below the loop.

So this
> -	ret = btrfs_update_device(trans, device);
> -	if (ret) {
> -		unlock_chunks(root);
> -		btrfs_end_transaction(trans, root);
> -		goto done;
> -	}
> -	WARN_ON(diff > old_total);
> -	btrfs_set_super_total_bytes(super_copy, old_total - diff);

to here should all be moved below like you have it.  Other than that it looks
good.  Thanks,

Josef
