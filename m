Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692FDC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 11:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E5DD2077C
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 11:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pmt+Lsho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfDPLkO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 07:40:14 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:39319 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfDPLkO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 07:40:14 -0400
Received: by mail-ua1-f67.google.com with SMTP id d5so6600190uan.6
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 04:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=F8ZNUM8EXURhs0CWZ8QWK24FuHUs/I5DsUlH8B+d7SQ=;
        b=Pmt+LshoDsigyKRK4/sUAy6pC2kDX9Z8MYEVDw7+UXI1pG4k0y7R8OA7Za1Fb+xSyT
         7bP4akhKru5bPAM3Uue1s1NdpAST77SvAF4f1D+X1eYkT6LNrG7VUTyiJHCjy5G2z463
         7O0uBGMzbYeg1/S2TAWlvEi37mCoRKoYCOy/iI4xkw1AFwnaxxQi6vv1IphWb7mca68I
         QY8BBLJw6S6ny49X3hAS7OWmwM3bgdit+7L1KiUtZSMmsyY+HOnT3zrzUkxJ7jjvREzE
         2B18mkDwdfQ7Uj1ogYvZrDoM1JZA/2eSq0NESuNIaLphjWB698kMS+/H92YaCdBk/A37
         byhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=F8ZNUM8EXURhs0CWZ8QWK24FuHUs/I5DsUlH8B+d7SQ=;
        b=I1ZCS0RhofEiopMdjHt0c5qmV90Lj4HQODs8veiaTpwmRQ1teNO8F5Yed9O2KrvNtz
         M5NQMSip9DU5kIz2cxDn88ROHjzbdUP7NSgklwGVo2kJdBdatOq5z6wgIY6GP1EOco/E
         j2ec6e5IJ2qZcq6pHoAe7TZlGK+Gktr2fcm47u5OZ7i3eroc+WqGJKGsov7FJ5tm2jjo
         de3mXRJhxFgGGafJ98CIGwqjJAuSRLB7qTe6iahVbNTgv6Q9QQ2WP8mmx9BE/y/gBEdq
         NZ3tTHAzwWC+O6K5cGI8N9bP/0Oc/g/BK/pqc+l8g2wLRyebDESlEcriUD3qGL85Vs3l
         FgUw==
X-Gm-Message-State: APjAAAWurZpRhi1vwUmc2dzf9tCSr0STybGXW8D2xk5mWjUZEbrDu4RK
        UpgGGs7AajsYv5YsX4Pp1ASKpo6FuQRYvATcMBqszg==
X-Google-Smtp-Source: APXvYqwCRQQY7kyQOEhza9U1RekFehKYJZX8cFHxTar8wjiaSD10MOXCWD6OqAzVZ+NYh8txZCl8TLBBARK0cgde8Tw=
X-Received: by 2002:ab0:2495:: with SMTP id i21mr41110494uan.49.1555414812219;
 Tue, 16 Apr 2019 04:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190416102144.12173-1-wqu@suse.com> <20190416102144.12173-2-wqu@suse.com>
 <CAL3q7H7h8LJr98RBZeXbH12LFM4VO5SA1N1XVfAEPhEoZPv8dQ@mail.gmail.com> <2a5af300-3db0-8fd7-cacb-012988a79b7a@suse.de>
In-Reply-To: <2a5af300-3db0-8fd7-cacb-012988a79b7a@suse.de>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 16 Apr 2019 11:40:01 +0000
Message-ID: <CAL3q7H6mGevfZ767Xraj=e=T_4qPD_1CpTPu8k9WWpu7As9BzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Avoid nested chunk allocation call
To:     Qu Wenruo <wqu@suse.de>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 12:32 PM Qu Wenruo <wqu@suse.de> wrote:
>
>
>
> On 2019/4/16 =E4=B8=8B=E5=8D=887:22, Filipe Manana wrote:
> > On Tue, Apr 16, 2019 at 11:23 AM Qu Wenruo <wqu@suse.com> wrote:
> >>
> >> There is a hidden call loop which can trigger itself:
> >>
> >> btrfs_reserve_extent()             <--|
> >> |- do_chunk_alloc()                   |
> >>    |- btrfs_alloc_chunk()             |
> >>       |- btrfs_insert_item()          |
> >>          |- btrfs_reserve_extent() <--|
> >>
> >> Currently, we're using root->ref_cows to determine whether we should d=
o
> >> chunk prealloc to avoid such loop.
> >>
> >> But that's still a hidden trap. Instead of solving it using some hidde=
n
> >> tricks, this patch will make chunk/block group allocation exclusive.
> >>
> >> Now if do_chunk_alloc() determines to alloc chunk, it will set a speci=
al
> >> flag in transaction handler so it new do_chunk_alloc() will refuse to
> >> allocate new chunk until current chunk allocation finishes.
> >
> > What if the chunk allocated during the recursion is of a different type=
?
> > I.e. we're allocating a data chunk, then when inserting the items in th=
e
> > extent, chunk, device, etc trees, we run out of metadata data space and
> > need to allocate a metadata chunk. What you are doing skips the allocat=
ion
> > of the metadata chunk and makes the inserts/updates of the trees fail
> > with ENOSPC.
>
> That's why we do preallocation to avoid such problem.

Ok, I wasn't aware about such preallocation in btrfs-progs.

>
> Just as the old code shows, even when we're allocating data chunks, it
> will try to check metadata space first.
>
> And for the profile we're asking, we over-allocate 2M, definitely not
> the best solution but should be enough for extent/chunk tree update.
>
> To make it as good as kernel, we need a lot of accounting which is not
> here in btrfs-progs.
>
> So in your case, every btrfs_reserve_extent() call should either trigger
>  chunk allocation (either metadata or data, or both), or have 2M overhead=
.
>
> If that 2M can not meet the metadata space requirement for
> chunk/extent/root tree update, then we hit the problem you described.
>
> However 2M looks pretty generous to me, so it should just work.

Yes, that should be enough even for 64Kb nodes and trees with 8 (max) level=
s.

thanks

>
> Thanks,
> Qu
>
> >
> > thanks
> >
> >
> >
> >>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>  check/main.c  |  2 +-
> >>  extent-tree.c | 12 ++++++++++++
> >>  transaction.c |  3 ++-
> >>  transaction.h |  3 ++-
> >>  4 files changed, 17 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/check/main.c b/check/main.c
> >> index 683c322eba6f..121be4b73c4f 100644
> >> --- a/check/main.c
> >> +++ b/check/main.c
> >> @@ -10185,7 +10185,7 @@ int cmd_check(int argc, char **argv)
> >>                         goto close_out;
> >>                 }
> >>
> >> -               trans->reinit_extent_tree =3D true;
> >> +               trans->reinit_extent_tree =3D 1;
> >>                 if (init_extent_tree) {
> >>                         printf("Creating a new extent tree\n");
> >>                         ret =3D reinit_extent_tree(trans, info,
> >> diff --git a/extent-tree.c b/extent-tree.c
> >> index 8c9cdeff3b02..e25ddf02e5cc 100644
> >> --- a/extent-tree.c
> >> +++ b/extent-tree.c
> >> @@ -1873,10 +1873,21 @@ static int do_chunk_alloc(struct btrfs_trans_h=
andle *trans,
> >>             (flags & BTRFS_BLOCK_GROUP_SYSTEM))
> >>                 return 0;
> >>
> >> +       /*
> >> +        * We're going to allocate new chunk, during the process, we w=
ill
> >> +        * allocate new tree blocks, which can trigger new chunk alloc=
ation
> >> +        * again.
> >> +        * Avoid such loop call
> >> +        */
> >> +       if (trans->allocating_chunk)
> >> +               return 0;
> >> +       trans->allocating_chunk =3D 1;
> >> +
> >>         ret =3D btrfs_alloc_chunk(trans, fs_info, &start, &num_bytes,
> >>                                 space_info->flags);
> >>         if (ret =3D=3D -ENOSPC) {
> >>                 space_info->full =3D 1;
> >> +               trans->allocating_chunk =3D 0;
> >>                 return 0;
> >>         }
> >>
> >> @@ -1885,6 +1896,7 @@ static int do_chunk_alloc(struct btrfs_trans_han=
dle *trans,
> >>         ret =3D btrfs_make_block_group(trans, fs_info, 0, space_info->=
flags,
> >>                                      start, num_bytes);
> >>         BUG_ON(ret);
> >> +       trans->allocating_chunk =3D 0;
> >>         return 0;
> >>  }
> >>
> >> diff --git a/transaction.c b/transaction.c
> >> index 3a63988b0969..21377282f806 100644
> >> --- a/transaction.c
> >> +++ b/transaction.c
> >> @@ -46,7 +46,8 @@ struct btrfs_trans_handle* btrfs_start_transaction(s=
truct btrfs_root *root,
> >>         fs_info->generation++;
> >>         h->transid =3D fs_info->generation;
> >>         h->blocks_reserved =3D num_blocks;
> >> -       h->reinit_extent_tree =3D false;
> >> +       h->reinit_extent_tree =3D 0;
> >> +       h->allocating_chunk =3D 0;
> >>         root->last_trans =3D h->transid;
> >>         root->commit_root =3D root->node;
> >>         extent_buffer_get(root->node);
> >> diff --git a/transaction.h b/transaction.h
> >> index 34060252dd5c..b426cd112447 100644
> >> --- a/transaction.h
> >> +++ b/transaction.h
> >> @@ -28,7 +28,8 @@ struct btrfs_trans_handle {
> >>         u64 transid;
> >>         u64 alloc_exclude_start;
> >>         u64 alloc_exclude_nr;
> >> -       bool reinit_extent_tree;
> >> +       unsigned int reinit_extent_tree:1;
> >> +       unsigned int allocating_chunk:1;
> >>         u64 delayed_ref_updates;
> >>         unsigned long blocks_reserved;
> >>         unsigned long blocks_used;
> >> --
> >> 2.21.0
> >>
> >
> >
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
