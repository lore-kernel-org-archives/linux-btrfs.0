Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33459 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaBPOX7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 09:23:59 -0500
Date: Sun, 16 Feb 2014 06:23:53 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, jbacik@fb.com
Message-ID: <20140216142352.GN27097@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392558191-14475-1-git-send-email-fdmanana@gmail.com>
 <20140214015426.GH27097@merlins.org>
Subject: Re: How to recover from failing btrfs send | btrfs receive?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Fillipe, I see you have another fix for btrfs send (attached below), 
as ell as your other patch on Jan 21st (neither are in my 3.12.7).

>From my error below, 
> ERROR: rmdir o1845158-142-0 failed. No such file or directory
can you tell if I'm having a different problem than the two patches
you sent?

More generally, could you hint how I can tell what this 
 rmdir o1845158-142-0
refers to, considering that it looks like a made up filename by btrfs
send/receive?

I'm happy to go to 3.13.3 and apply both patches if you think it'll
help.

Thanks,
Marc

On Wed, Feb 12, 2014 at 06:22:07AM -0800, Marc MERLIN wrote:
> So, I've veen running this for a few weeks, and soon should have
> something half decent to share for others to use.
> 
> Unfortunately, one of my backups is now failing like so:
> 
> btrfs send -p "$src_snap" "$src_newsnap" | btrfs receive "$dest_pool/"
> + btrfs send -p /mnt/btrfs_pool1/home_ro.20140209_12:00:01 home_ro.20140212_05:37:49
> + btrfs receive /mnt/btrfs_pool2//
> At subvol home_ro.20140212_05:37:49
> At snapshot home_ro.20140212_05:37:49
> ERROR: rmdir o1845158-142-0 failed. No such file or directory
> 
> This looks like it got in an unfinished state it can't recover from.
> 
> This was with kernel 3.12.7.
> 
> Can I self fix this somehow, I know I can use rsync to make both sides
> the sames, but incremental send/receive will not work anymore after
> that, correct?
> 
> Except, not really. Now I'm confused.
> legolas:/mnt/btrfs_pool1# rsync -avSH --delete --dry-run  /mnt/btrfs_pool1/home_ro.20140209_12:00:01/. /mnt/btrfs_pool2/home_ro.20140209_12\:00\:01/.
> sending incremental file list
> ./
> 
> sent 116867233 bytes  received 265427 bytes  92194.14 bytes/sec
> total size is 129135042766  speedup is 1102.47 (DRY RUN)
> legolas:/mnt/btrfs_pool1# 
> 
> (I know I start the entire backup over from scratch, but for obvious
> reasons, restarting an entire backup from scratch each time I get an
> error isn't great since it could take hours or days to backup that much
> data)
> 
> Suggestions welcome :)
> 
> Thanks,
> Marc

On Sun, Feb 16, 2014 at 01:43:11PM +0000, Filipe David Borba Manana wrote:
> This fixes yet one more case not caught by the commit titled:
> 
>    Btrfs: fix infinite path build loops in incremental send
> 
> In this case, even before the initial full send, we have a directory
> which is a child of a directory with a higher inode number. Then we
> perform the initial send, and after we rename both the child and the
> parent, without moving them around. After doing these 2 renames, an
> incremental send sent a rename instruction for the child directory
> which contained an invalid "from" path (referenced the parent's old
> name, not the new one), which made the btrfs receive command fail.
> 
> Steps to reproduce:
> 
>     $ mkfs.btrfs -f /dev/sdb3
>     $ mount /dev/sdb3 /mnt/btrfs
>     $ mkdir -p /mnt/btrfs/a/b
>     $ mkdir /mnt/btrfs/d
>     $ mkdir /mnt/btrfs/a/b/c
>     $ mv /mnt/btrfs/d /mnt/btrfs/a/b/c
>     $ btrfs subvolume snapshot -r /mnt/btrfs /mnt/btrfs/snap1
>     $ btrfs send /mnt/btrfs/snap1 -f /tmp/base.send
>     $ mv /mnt/btrfs/a/b/c /mnt/btrfs/a/b/x
>     $ mv /mnt/btrfs/a/b/x/d /mnt/btrfs/a/b/x/y
>     $ btrfs subvolume snapshot -r /mnt/btrfs /mnt/btrfs/snap2
>     $ btrfs send -p /mnt/btrfs/snap1 /mnt/btrfs/snap2 -f /tmp/incremental.send
> 
>     $ umout /mnt/btrfs
>     $ mkfs.btrfs -f /dev/sdb3
>     $ mount /dev/sdb3 /mnt/btrfs
>     $ btrfs receive /mnt/btrfs -f /tmp/base.send
>     $ btrfs receive /mnt/btrfs -f /tmp/incremental.send
> 
> The second btrfs receive command failed with:
>   "ERROR: rename a/b/c/d -> a/b/x/y failed. No such file or directory"
> 
> A test case for xfstests follows.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/send.c |   41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index b6d416c..7dbed58 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2847,19 +2847,48 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>  {
>  	struct fs_path *from_path = NULL;
>  	struct fs_path *to_path = NULL;
> +	struct fs_path *name = NULL;
>  	u64 orig_progress = sctx->send_progress;
>  	struct recorded_ref *cur;
> +	u64 parent_ino, parent_gen;
>  	int ret;
>  
> +	name = fs_path_alloc();
>  	from_path = fs_path_alloc();
> -	if (!from_path)
> -		return -ENOMEM;
> +	if (!name || !from_path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  
> -	sctx->send_progress = pm->ino;
> -	ret = get_cur_path(sctx, pm->ino, pm->gen, from_path);
> +	ret = del_waiting_dir_move(sctx, pm->ino);
> +	ASSERT(ret == 0);
> +
> +	ret = get_first_ref(sctx->parent_root, pm->ino,
> +			    &parent_ino, &parent_gen, name);
>  	if (ret < 0)
>  		goto out;
>  
> +	if (parent_ino == sctx->cur_ino) {
> +		/* child only renamed, not moved */
> +		ASSERT(parent_gen == sctx->cur_inode_gen);
> +		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen,
> +				   from_path);
> +		if (ret < 0)
> +			goto out;
> +		ret = fs_path_add_path(from_path, name);
> +		if (ret < 0)
> +			goto out;
> +	} else {
> +		/* child moved and maybe renamed too */
> +		sctx->send_progress = pm->ino;
> +		ret = get_cur_path(sctx, pm->ino, pm->gen, from_path);
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	fs_path_free(name);
> +	name = NULL;
> +
>  	to_path = fs_path_alloc();
>  	if (!to_path) {
>  		ret = -ENOMEM;
> @@ -2867,9 +2896,6 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>  	}
>  
>  	sctx->send_progress = sctx->cur_ino + 1;
> -	ret = del_waiting_dir_move(sctx, pm->ino);
> -	ASSERT(ret == 0);
> -
>  	ret = get_cur_path(sctx, pm->ino, pm->gen, to_path);
>  	if (ret < 0)
>  		goto out;
> @@ -2893,6 +2919,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>  	}
>  
>  out:
> +	fs_path_free(name);
>  	fs_path_free(from_path);
>  	fs_path_free(to_path);
>  	sctx->send_progress = orig_progress;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
