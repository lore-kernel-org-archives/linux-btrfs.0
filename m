Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CFAC37120
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 20:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92DB321019
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548101162;
	bh=9H8T9vr7KL3X9X84l7X1k6KdoxJS6QgvsCME4VyTa0s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=v61i+ffYz7e8U/xRTEzKzN0qz+JQKJI2xJzAqMurEw6fDQLVXNXKYdkX+p+sz1Pj7
	 yHthF4vmKqkYa43tL2ILIzQSBI8T8EW1x2IV+WVdkcgyr+TVFWVq0mJMOOs6C27c+k
	 lXl9T0IEi/yf/ZhAIjlrl+LKGXrOtU6tQIG59olY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfAUUGB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 15:06:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbfAUUGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 15:06:01 -0500
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8411421726
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548101159;
        bh=9H8T9vr7KL3X9X84l7X1k6KdoxJS6QgvsCME4VyTa0s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2T0QIKrz7jp+ryJYxOqSbX1dleMfcFIV31MP40454HCohjfhUOINyAp5algRDJYg4
         OLQLnCCqrACx+OXPF/RwIFdnq1LE4gKOos5+FsuZST3fE+L4r1NBX1hidJLgIxujcJ
         kYrgpw7N/BJyJsRwSlv3mjlLPGoFQ79gMfl/Fqg8=
Received: by mail-vs1-f48.google.com with SMTP id x28so13292657vsh.12
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 12:05:59 -0800 (PST)
X-Gm-Message-State: AJcUukev5TKi/61PtJAbDOEt6+InIBlRsMA7HKcEonSC3Ecnb3lZLt9Y
        gQ684EZ1cM5DMIXndXg/m2UkbC+JyhbmgBEdMHI=
X-Google-Smtp-Source: ALg8bN4rKMejkIVvgFMax5MqOHj9RzS+eGLRFZX2rqKSy0yst3bZFBTQjAojbYqnqRD/yValShYiuwlJcprMacGtTj4=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr10563756vsa.99.1548101158356;
 Mon, 21 Jan 2019 12:05:58 -0800 (PST)
MIME-Version: 1.0
References: <1417543669-22685-1-git-send-email-fdmanana@suse.com> <CAOcd+r3U9x20gAsrOtDC1pd1qO-Zy_QiWrmQysvKjbLJOUDH_A@mail.gmail.com>
In-Reply-To: <CAOcd+r3U9x20gAsrOtDC1pd1qO-Zy_QiWrmQysvKjbLJOUDH_A@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 21 Jan 2019 20:05:47 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7G7PzkPG7ukSBXFR+7q9AK_PryW=T5DNFNnMpiojnA4A@mail.gmail.com>
Message-ID: <CAL3q7H7G7PzkPG7ukSBXFR+7q9AK_PryW=T5DNFNnMpiojnA4A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: fix unprotected deletion from pending_chunks list
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 21, 2019 at 7:07 PM Alex Lyakas <alex@zadara.com> wrote:
>
> Hi Filipe,
>
> On Tue, Dec 2, 2014 at 8:08 PM Filipe Manana <fdmanana@suse.com> wrote:
> >
> > On block group remove if the corresponding extent map was on the
> > transaction->pending_chunks list, we were deleting the extent map
> > from that list, through remove_extent_mapping(), without any
> > synchronization with chunk allocation (which iterates that list
> > and adds new elements to it). Fix this by ensure that this is done
> > while the chunk mutex is held, since that's the mutex that protects
> > the list in the chunk allocation code path.
> >
> > This applies on top (depends on) of my previous patch titled:
> > "Btrfs: fix race between fs trimming and block group remove/allocation"
> >
> > But the issue in fact was already present before that change, it only
> > became easier to hit after Josef's 3.18 patch that added automatic
> > removal of empty block groups.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/extent-tree.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 17d429d..a7b81b4 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -9524,19 +9524,25 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
> >                 list_move_tail(&em->list, &root->fs_info->pinned_chunks);
> >         }
> >         spin_unlock(&block_group->lock);
> > -       unlock_chunks(root);
> >
> >         if (remove_em) {
> >                 struct extent_map_tree *em_tree;
> >
> >                 em_tree = &root->fs_info->mapping_tree.map_tree;
> >                 write_lock(&em_tree->lock);
> > +               /*
> > +                * The em might be in the pending_chunks list, so make sure the
> > +                * chunk mutex is locked, since remove_extent_mapping() will
> > +                * delete us from that list.
> > +                */
> >                 remove_extent_mapping(em_tree, em);
> >                 write_unlock(&em_tree->lock);
> If the "em" was in pending_chunks, it will be deleted from that list
> by "remove_extent_mapping". But it looks like in this case we also
> need to drop the extra ref on "em", which was held by pending_chunks
> list. I don't see it being done anywhere else. So we should check
> before the remove_extent_mapping() call whether "em" was in
> pending_chunks, and, if yes, drop the extra ref?

This was part of a large patch set that fixed multiple issues with
automatic removal of block groups.
Dropping the extent map reference was done on another patch of that patch set:

commit 495e64f4fe0363bc79fa0dfb41c271787e01b5c3
Author: Filipe Manana <fdmanana@suse.com>
Date:   Tue Dec 2 18:07:30 2014 +0000

    Btrfs: fix fs mapping extent map leak

Over 4 years ago....

>
> Thanks,
> Alex.
>
>
> >                 /* once for the tree */
> >                 free_extent_map(em);
> >         }
> >
> > +       unlock_chunks(root);
> > +
> >         btrfs_put_block_group(block_group);
> >         btrfs_put_block_group(block_group);
> >
> > --
> > 2.1.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
