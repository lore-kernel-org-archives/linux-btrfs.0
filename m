Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56132 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3EVKhQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 May 2013 06:37:16 -0400
Received: by mail-ie0-f178.google.com with SMTP id tp5so500629ieb.23
        for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 03:37:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B79474121B224887AA38B74B8B7EAC71@moshePC>
References: <1366189907-16942-1-git-send-email-sbehrens@giantdisaster.de>
	<CAOcd+r274=ZxUkNqfgDZsy+R0irzZB2WO9CX0Dfz8uNZi4GN9g@mail.gmail.com>
	<B79474121B224887AA38B74B8B7EAC71@moshePC>
Date: Wed, 22 May 2013 13:37:15 +0300
Message-ID: <CAOcd+r0NGc7cw1+2=3FgeRVY0fp8_bSD3eArYLnJRh7=01R8qw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: clear received_uuid field for new writable snapshots
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stephan,
I fully understand the first part of your fix, and I believe it's
quite critical. Indeed, a writable snapshot should have no evidence
that it has an ancestor that was once "received".

Can you pls let me know that I understand the second part of your fix.
In btrfs-progs the following code in tree_search() would have
prevented us from mistakenly selecting such snapshot as a parent for
"receive":
        if (type == subvol_search_by_received_uuid) {
            entry = rb_entry(n, struct subvol_info,
                    rb_received_node);
            comp = memcmp(entry->received_uuid, uuid,
                    BTRFS_UUID_SIZE);
            if (!comp) {
                if (entry->stransid < stransid)
                    comp = -1;
                else if (entry->stransid > stransid)
                    comp = 1;
                else
                    comp = 0;
            }
The code checks both received_uuid (which would have been wrongly
equal to what we need), but also the stransid (which was the ctransid
on the send side), which would have been zero, so it wouldn't match.

Now after your fix, the stransid field becomes not needed, correct?
Because if we have a valid received_uuid, this means that either we
are the "received" snapshot, or our whole chain of ancestors are
read-only, and eventually there was an ancestor that was "received".
So we have valid data and can be used as a parent. Is it still needed
after your fix to check the stransid field ? (it doesn't hurt to check
it)

Clearring/Not clearing the rtransid - does it bring any value?
rtransid is the local transid of when we had completed the "receive"
process for this snap. Is there any interesting usage of this value?

Thanks,
Alex.


On Wed, Apr 17, 2013 at 12:11 PM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
>
> For created snapshots, the full root_item is copied from the source
> root and afterwards selectively modified. The current code forgets
> to clear the field received_uuid. The only problem is that it is
> confusing when you look at it with 'btrfs subv list', since for
> writable snapshots, the contents of the snapshot can be completely
> unrelated to the previously received snapshot.
> The receiver ignores such snapshots anyway because he also checks
> the field stransid in the root_item and that value used to be reset
> to zero for all created snapshots.
>
> This commit changes two things:
> - clear the received_uuid field for new writable snapshots.
> - don't clear the send/receive related information like the stransid
>   for read-only snapshots (which makes them useable as a parent for
>   the automatic selection of parents in the receive code).
>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/transaction.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ffac232..94cbd10 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1170,13 +1170,17 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>         memcpy(new_root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
>         memcpy(new_root_item->parent_uuid, root->root_item.uuid,
>                         BTRFS_UUID_SIZE);
> +       if (!(root_flags & BTRFS_ROOT_SUBVOL_RDONLY)) {
> +               memset(new_root_item->received_uuid, 0,
> +                      sizeof(new_root_item->received_uuid));
> +               memset(&new_root_item->stime, 0, sizeof(new_root_item->stime));
> +               memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
> +               btrfs_set_root_stransid(new_root_item, 0);
> +               btrfs_set_root_rtransid(new_root_item, 0);
> +       }
>         new_root_item->otime.sec = cpu_to_le64(cur_time.tv_sec);
>         new_root_item->otime.nsec = cpu_to_le32(cur_time.tv_nsec);
>         btrfs_set_root_otransid(new_root_item, trans->transid);
> -       memset(&new_root_item->stime, 0, sizeof(new_root_item->stime));
> -       memset(&new_root_item->rtime, 0, sizeof(new_root_item->rtime));
> -       btrfs_set_root_stransid(new_root_item, 0);
> -       btrfs_set_root_rtransid(new_root_item, 0);
>
>         old = btrfs_lock_root_node(root);
>         ret = btrfs_cow_block(trans, root, old, NULL, 0, &old);
> --
> 1.8.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
