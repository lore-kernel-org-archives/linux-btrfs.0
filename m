Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000D2C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 10:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5C42084A
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 10:42:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="jEi7iiVR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfAVKmB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:42:01 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:37405 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfAVKmB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 05:42:01 -0500
Received: by mail-it1-f196.google.com with SMTP id b5so19423653iti.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 02:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SnCM70gnZS9kRm34zqcQRy7Ruge8VldUGCOOs8W0m20=;
        b=jEi7iiVRAY47VCCR6qbgKEFzoN6nw6IQAf5hX33T+eDxVTFBrMyV4B8cyJWtDNIfW9
         AUQMfnW/1kJNl58QKkJ/ZNXrroNKRxaCi3/UREtPyCDoNeKPhqr+Xg0u5pZlelMRtK0S
         zd1Jp3FheUGKF8dJva3tVH4unwUHn6pjKtHbp8b1ZR9/aaq2Ld/pBYdqjFVeRjSV75GV
         jes0bQ1g5y0dVwp9TwqYIJOGJRMDMJVkWNrRwfYqEn7vIrne8kJbySEHUdPNeJ/TlVn6
         Ag6Ge1ixC5spLswKx0qcCHpNaVABJ5LG8Uy1IY6lrX8fp33A2L7mFVHZ5ifQwdfzqyzi
         xV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SnCM70gnZS9kRm34zqcQRy7Ruge8VldUGCOOs8W0m20=;
        b=s+ePTrFtPj4/l3dJrAguvNwpLyOD2HvpKghK7yD6qPPB/qQJ9DQqOhVhtMeWl2rnVg
         vY/AcvM05b9losHO+BuYMSCdvG3sb2g6C7OAoWb3uKIDOQx4eky1Jj0Vmw9fIN/GSSKu
         34R/kpL40YscPKtqMay+Ms+aq0OYAcXT5DYTaZH5Zp5jIgPsZ8bboo1NjMMhjdflprVF
         IJiADxWnk2uxGk5ipwb8P2PM4pFphh6feS0riwwo7qiL70wrYYyI6NvS1cMlH3Su0DMJ
         XxjzpediQUw60D+J6pmlQlu0ECSvTI9VK97lPg4Qog/xUSdHcTbypYas6UN3JYpCHP0Z
         iWGw==
X-Gm-Message-State: AJcUukdWvAGVY/R9jh00b6cz/BJ4NPSULcsZRsapVwhc8Hky4J8q4Fwy
        vuS4EztvqOZl42AwJZAH5e+5mmIxpotr3HDaaXJYYA==
X-Google-Smtp-Source: ALg8bN4FyrxDR8Z9or0r1Fvr533KC4jfSqbh80FGcuwX/zmTStGI9xZzWrn7BAQy84dnWghPLnO8UDMoS8oESPJCrbg=
X-Received: by 2002:a02:9d0:: with SMTP id 77mr19486233jam.14.1548153720103;
 Tue, 22 Jan 2019 02:42:00 -0800 (PST)
MIME-Version: 1.0
References: <1417543669-22685-1-git-send-email-fdmanana@suse.com>
 <CAOcd+r3U9x20gAsrOtDC1pd1qO-Zy_QiWrmQysvKjbLJOUDH_A@mail.gmail.com> <CAL3q7H7G7PzkPG7ukSBXFR+7q9AK_PryW=T5DNFNnMpiojnA4A@mail.gmail.com>
In-Reply-To: <CAL3q7H7G7PzkPG7ukSBXFR+7q9AK_PryW=T5DNFNnMpiojnA4A@mail.gmail.com>
From:   Alex Lyakas <alex@zadara.com>
Date:   Tue, 22 Jan 2019 12:41:49 +0200
Message-ID: <CAOcd+r3Z1N5ibGN6QAufzM=erBPQmwjP02GzGJoPbi+b+Wa9WA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: fix unprotected deletion from pending_chunks list
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Filipe,

Thank you for your response. I realize it was a long time, ago, but we
are just now in the process of moving to stable kernel 4.14.x.

Regarding the fix, I see now the relevant code in "btrfs_remove_block_group":
    mutex_lock(&fs_info->chunk_mutex);
    if (!list_empty(&em->list)) {
        /* We're in the transaction->pending_chunks list. */
        free_extent_map(em);
    }
...
However, this brings another doubt. Let's say we indeed performed
free_extent_map in the above code. But later we may do:
        /*
         * Our em might be in trans->transaction->pending_chunks which
         * is protected by fs_info->chunk_mutex ([lock|unlock]_chunks),
         * and so is the fs_info->pinned_chunks list.
         *
         * So at this point we must be holding the chunk_mutex to avoid
         * any races with chunk allocation (more specifically at
         * volumes.c:contains_pending_extent()), to ensure it always
         * sees the em, either in the pending_chunks list or in the
         * pinned_chunks list.
         */
        list_move_tail(&em->list, &fs_info->pinned_chunks);

So we have dropped the ref that was held by
"transaction->pending_chunks" list, and now we moved the "em" to the
pinned_chunks without a ref. But the code assumes that "pinned_chunks"
also has a ref on the "em". For example in close_ctree, we do:
    while (!list_empty(&fs_info->pinned_chunks)) {
        struct extent_map *em;

        em = list_first_entry(&fs_info->pinned_chunks,
                      struct extent_map, list);
        list_del_init(&em->list);
        free_extent_map(em);
    }

Can you please comment on that?

Thanks,
Alex.


On Mon, Jan 21, 2019 at 10:06 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Mon, Jan 21, 2019 at 7:07 PM Alex Lyakas <alex@zadara.com> wrote:
> >
> > Hi Filipe,
> >
> > On Tue, Dec 2, 2014 at 8:08 PM Filipe Manana <fdmanana@suse.com> wrote:
> > >
> > > On block group remove if the corresponding extent map was on the
> > > transaction->pending_chunks list, we were deleting the extent map
> > > from that list, through remove_extent_mapping(), without any
> > > synchronization with chunk allocation (which iterates that list
> > > and adds new elements to it). Fix this by ensure that this is done
> > > while the chunk mutex is held, since that's the mutex that protects
> > > the list in the chunk allocation code path.
> > >
> > > This applies on top (depends on) of my previous patch titled:
> > > "Btrfs: fix race between fs trimming and block group remove/allocation"
> > >
> > > But the issue in fact was already present before that change, it only
> > > became easier to hit after Josef's 3.18 patch that added automatic
> > > removal of empty block groups.
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >  fs/btrfs/extent-tree.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > index 17d429d..a7b81b4 100644
> > > --- a/fs/btrfs/extent-tree.c
> > > +++ b/fs/btrfs/extent-tree.c
> > > @@ -9524,19 +9524,25 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
> > >                 list_move_tail(&em->list, &root->fs_info->pinned_chunks);
> > >         }
> > >         spin_unlock(&block_group->lock);
> > > -       unlock_chunks(root);
> > >
> > >         if (remove_em) {
> > >                 struct extent_map_tree *em_tree;
> > >
> > >                 em_tree = &root->fs_info->mapping_tree.map_tree;
> > >                 write_lock(&em_tree->lock);
> > > +               /*
> > > +                * The em might be in the pending_chunks list, so make sure the
> > > +                * chunk mutex is locked, since remove_extent_mapping() will
> > > +                * delete us from that list.
> > > +                */
> > >                 remove_extent_mapping(em_tree, em);
> > >                 write_unlock(&em_tree->lock);
> > If the "em" was in pending_chunks, it will be deleted from that list
> > by "remove_extent_mapping". But it looks like in this case we also
> > need to drop the extra ref on "em", which was held by pending_chunks
> > list. I don't see it being done anywhere else. So we should check
> > before the remove_extent_mapping() call whether "em" was in
> > pending_chunks, and, if yes, drop the extra ref?
>
> This was part of a large patch set that fixed multiple issues with
> automatic removal of block groups.
> Dropping the extent map reference was done on another patch of that patch set:
>
> commit 495e64f4fe0363bc79fa0dfb41c271787e01b5c3
> Author: Filipe Manana <fdmanana@suse.com>
> Date:   Tue Dec 2 18:07:30 2014 +0000
>
>     Btrfs: fix fs mapping extent map leak
>
> Over 4 years ago....
>
> >
> > Thanks,
> > Alex.
> >
> >
> > >                 /* once for the tree */
> > >                 free_extent_map(em);
> > >         }
> > >
> > > +       unlock_chunks(root);
> > > +
> > >         btrfs_put_block_group(block_group);
> > >         btrfs_put_block_group(block_group);
> > >
> > > --
> > > 2.1.3
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
