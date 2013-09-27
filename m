Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3I0XSR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 19:18:17 -0400
Date: Fri, 27 Sep 2013 16:18:14 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't delete ordered roots from list during
 cleanup
Message-ID: <20130927231814.GB30372@lenny.home.zabbo.net>
References: <1380314266-28871-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380314266-28871-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 27, 2013 at 04:37:46PM -0400, Josef Bacik wrote:
> During transaction cleanup after an abort we are just removing roots from the
> ordered roots list which is incorrect.  We have a BUG_ON() to make sure that the
> root is still part of the ordered roots list when we put our ordered extent
> which we were tripping in this case.  So do like we do everywhere else and just
> move it to the tail of the ordered roots list and allow the normal cleanup to
> take care of stuff.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/disk-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f38211f..872b4ce 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3835,7 +3835,8 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
>  	while (!list_empty(&splice)) {
>  		root = list_first_entry(&splice, struct btrfs_root,
>  					ordered_root);
> -		list_del_init(&root->ordered_root);
> +		list_move_tail(&root->ordered_root,
> +			       &fs_info->ordered_roots);

This function basically only does:

	lock
	list_for_each
		lock
		list_for_each
			set_bit

Could we instead add a bit to the root or trans or fs_info or anything
else that could be trivialy set in _destroy_all_ordered_extents and
tested in _finish_ordered_io()?  It'd remove a bunch of tedious locking
and iteration here.

The similar metaphor in the core page cache is (address_space->flags |
AS_EIO).

Would that be too coarse or racey?

- z
