Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47289 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3JTKq4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 06:46:56 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so5322930wgg.4
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Oct 2013 03:46:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377901546-22434-1-git-send-email-dsterba@suse.cz>
References: <1377901546-22434-1-git-send-email-dsterba@suse.cz>
Date: Sun, 20 Oct 2013 12:46:54 +0200
Message-ID: <CAOcd+r08hR0nK9235X_DKK5arkGoCyj6m8Q_JTBvSjdkkYHYnQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: commit transaction after deleting a subvolume
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Thank you for addressing this, David.

On Sat, Aug 31, 2013 at 1:25 AM, David Sterba <dsterba@suse.cz> wrote:
> Alex pointed out the consequences after a transaction is not committed
> when a subvolume is deleted, so in case of a crash before an actual
> commit happens will let the subvolume reappear.
>
> Original post:
> http://www.spinics.net/lists/linux-btrfs/msg22088.html
>
> Josef's objections:
> http://www.spinics.net/lists/linux-btrfs/msg22256.html
>
> While there's no need to do a full commit for regular files, a subvolume
> may get a different treatment.
>
> http://www.spinics.net/lists/linux-btrfs/msg23087.html:
>
> "That a subvol/snapshot may appear after crash if transation commit did
> not happen does not feel so good. We know that the subvol is only
> scheduled for deletion and needs to be processed by cleaner.
>
> From that point I'd rather see the commit to happen to avoid any
> unexpected surprises.  A subvolume that re-appears still holds the data
> references and consumes space although the user does not assume that.
>
> Automated snapshotting and deleting needs some guarantees about the
> behaviour and what to do after a crash. So now it has to process the
> backlog of previously deleted snapshots and verify that they're not
> there, compared to "deleted -> will never appear, can forget about it".
> "
>
> There is a performance penalty incured by the change, but deleting a
> subvolume is not a frequent operation and the tradeoff seems justified
> by getting the guarantee stated above.
>
> CC: Alex Lyakas <alex.btrfs@zadarastorage.com>
> CC: Josef Bacik <jbacik@fusionio.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e407f75..4394632 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2268,7 +2268,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  out_end_trans:
>         trans->block_rsv = NULL;
>         trans->bytes_reserved = 0;
> -       ret = btrfs_end_transaction(trans, root);
> +       ret = btrfs_commit_transaction(trans, root);
>         if (ret && !err)
>                 err = ret;
>         inode->i_flags |= S_DEAD;
> --
> 1.7.9
>
