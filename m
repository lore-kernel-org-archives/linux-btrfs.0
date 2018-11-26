Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD83AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 20:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885C4205C9
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 20:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Es4x5IRa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 885C4205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbeK0HF7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 02:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbeK0HF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 02:05:58 -0500
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE32205C9
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 20:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543263043;
        bh=5smcp4gNFqIuFO/t8JZ42BgitUaBlJTrsYtn2fGFAmc=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=Es4x5IRacZzZCTCdxL1KwZmtJN03dWWeO/FvTdKaUtS+48XLO1aTIuw1vnfQGRE1O
         GqixflKoUAxMuDNttfhKSxtv+FSdPRGI/tNAQE274TcbunqDyLhDWIkahB7MXB3wc9
         DyR37hLZl7++/wtxWIBlgA5IUK8Ag99os+GWcGZU=
Received: by mail-vs1-f48.google.com with SMTP id b74so12195191vsd.9
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 12:10:43 -0800 (PST)
X-Gm-Message-State: AGRZ1gJ38Fk9BB2ZFQuaJpOvkpRM1NhvzxED1DamCCqPLbDEMNVsXHY5
        PMW3/Kz4/afnwZLB2V157PC5XmbdiswjbEVFv5M=
X-Google-Smtp-Source: AJdET5dSIcVbtMRN1xhyw5Iqps69NEzNPIGOQb4FVIDlGAA52NnVQ4kClULWPPy7D3jprIatsgNyVHtiLgsf9z0u+Tk=
X-Received: by 2002:a67:3b1b:: with SMTP id i27mr12349619vsa.14.1543263042204;
 Mon, 26 Nov 2018 12:10:42 -0800 (PST)
MIME-Version: 1.0
References: <20181123134543.20199-1-fdmanana@kernel.org> <20181123182540.7206-1-fdmanana@kernel.org>
 <20181126181711.GI2842@twin.jikos.cz>
In-Reply-To: <20181126181711.GI2842@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 26 Nov 2018 20:10:30 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5kGb9otnqmOGddOGvnT3BnNG6hZHVaBUaOJrOXawVNAA@mail.gmail.com>
Message-ID: <CAL3q7H5kGb9otnqmOGddOGvnT3BnNG6hZHVaBUaOJrOXawVNAA@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock with memory reclaim during scrub
To:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 6:17 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Fri, Nov 23, 2018 at 06:25:40PM +0000, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When a transaction commit starts, it attempts to pause scrub and it blocks
> > until the scrub is paused. So while the transaction is blocked waiting for
> > scrub to pause, we can not do memory allocation with GFP_KERNEL from scrub,
> > otherwise we risk getting into a deadlock with reclaim.
> >
> > Checking for scrub pause requests is done early at the beginning of the
> > while loop of scrub_stripe() and later in the loop, scrub_extent() and
> > scrub_raid56_parity() are called, which in turn call scrub_pages() and
> > scrub_pages_for_parity() respectively. These last two functions do memory
> > allocations using GFP_KERNEL. Same problem could happen while scrubbing
> > the super blocks, since it calls scrub_pages().
> >
> > So make sure GFP_NOFS is used for the memory allocations because at any
> > time a scrub pause request can happen from another task that started to
> > commit a transaction.
> >
> > Fixes: 58c4e173847a ("btrfs: scrub: use GFP_KERNEL on the submission path")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >
> > V2: Make using GFP_NOFS unconditionial. Previous version was racy, as pausing
> > requests migth happen just after we checked for them.
> >
> > V3: Use memalloc_nofs_save() just like V1 did.
> >
> > V4: Similar problem happened for raid56, which was previously missed, so
> >     deal with it as well as the case for scrub_supers().
>
> Enclosing the whole scrub to 'nofs' seems like the best option and
> future proof. What I missed in 58c4e173847a was the "don't hold big lock
> under GFP_KERNEL allocation" pattern.
>
> >  fs/btrfs/scrub.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > index 3be1456b5116..e08b7502d1f0 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -3779,6 +3779,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
> >       struct scrub_ctx *sctx;
> >       int ret;
> >       struct btrfs_device *dev;
> > +     unsigned int nofs_flag;
> >
> >       if (btrfs_fs_closing(fs_info))
> >               return -EINVAL;
> > @@ -3882,6 +3883,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
> >       atomic_inc(&fs_info->scrubs_running);
> >       mutex_unlock(&fs_info->scrub_lock);
> >
> > +     /*
> > +      * In order to avoid deadlock with reclaim when there is a transaction
> > +      * trying to pause scrub, make sure we use GFP_NOFS for all the
> > +      * allocations done at btrfs_scrub_pages() and scrub_pages_for_parity()
> > +      * invoked by our callees. The pausing request is done when the
> > +      * transaction commit starts, and it blocks the transaction until scrub
> > +      * is paused (done at specific points at scrub_stripe() or right above
> > +      * before incrementing fs_info->scrubs_running).
>
> This hilights why there's perhaps no point in trying to make the nofs
> section smaller, handling all the interactions between scrub and
> transaction would be too complex.
>
> Reviewed-by: David Sterba <dsterba@suse.com>

Well, the worker tasks can also not use gfp_kernel, since the scrub
task waits for them to complete before pausing.
I missed this, and 2 reviewers as well, so perhaps it wasn't that
trivial and I shouldn't feel that I miserably failed to identify all
cases for something rather trivial. V5 sent.
