Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2HAMRw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 08:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120730081043.GA15702@elgon.mountain>
References: <20120730081043.GA15702@elgon.mountain>
Date: Wed, 1 Aug 2012 14:17:52 +0200
Message-ID: <CAB9VWqACDZoSM7ihQ5mwup+w_LX1rG6G5BOJGz6hC6qKbsDciA@mail.gmail.com>
Subject: Re: [patch] Btrfs: fix some endian bugs handling the root times
From: Alexander Block <ablock84@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2012 at 10:10 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> "trans->transid" is cpu endian but we want to store the data as little
> endian.  "item->ctime.nsec" is only 32 bits, not 64.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Applies to linux-next.
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 43f0012..a1fbca0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -424,7 +424,7 @@ static noinline int create_subvol(struct btrfs_root *root,
>         uuid_le_gen(&new_uuid);
>         memcpy(root_item.uuid, new_uuid.b, BTRFS_UUID_SIZE);
>         root_item.otime.sec = cpu_to_le64(cur_time.tv_sec);
> -       root_item.otime.nsec = cpu_to_le64(cur_time.tv_nsec);
> +       root_item.otime.nsec = cpu_to_le32(cur_time.tv_nsec);
>         root_item.ctime = root_item.otime;
>         btrfs_set_root_ctransid(&root_item, trans->transid);
>         btrfs_set_root_otransid(&root_item, trans->transid);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 7ac7cdc..7208ada 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1061,7 +1061,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         memcpy(new_root_item->parent_uuid, root->root_item.uuid,
>                         BTRFS_UUID_SIZE);
>         new_root_item->otime.sec = cpu_to_le64(cur_time.tv_sec);
> -       new_root_item->otime.nsec = cpu_to_le64(cur_time.tv_nsec);
> +       new_root_item->otime.nsec = cpu_to_le32(cur_time.tv_nsec);
>         btrfs_set_root_otransid(new_root_item, trans->transid);
>         memset(&new_root_item->stime, 0, sizeof(new_root_item->stime));
>         memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 6bb465c..10d8e4d 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -544,8 +544,8 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
>         struct timespec ct = CURRENT_TIME;
>
>         spin_lock(&root->root_times_lock);
> -       item->ctransid = trans->transid;
> +       item->ctransid = cpu_to_le64(trans->transid);
>         item->ctime.sec = cpu_to_le64(ct.tv_sec);
> -       item->ctime.nsec = cpu_to_le64(ct.tv_nsec);
> +       item->ctime.nsec = cpu_to_le32(ct.tv_nsec);
>         spin_unlock(&root->root_times_lock);
>  }

Thanks. I will include this patch in the next send/receive pull request.
