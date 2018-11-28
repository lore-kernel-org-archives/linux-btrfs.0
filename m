Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1F6C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 14:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80959206B6
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 14:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IW+rGuRg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80959206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbeK2BmO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 20:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbeK2BmN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 20:42:13 -0500
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25B702086B
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543416020;
        bh=of0TUJKmXe/OdrJBSNNixcfaKAD20C9Kwx/g+yRgoFc=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=IW+rGuRgXQomtdGQ+loj27yXgctmryLABQOA6LZcoHyMqBhETqCepXIPn24OCvj+P
         AmAhvo6oY5pRH3IYYt6/3I2WKhPP0J3CO7NyU6lKqp5J+V+d1LP6Xzc5LL+O9rV5LX
         GfwSg6eJNGZNF5QX2oiT3kLXGH2Yt6Xx3iBHHa1Q=
Received: by mail-ua1-f48.google.com with SMTP id d21so8970224uap.9
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 06:40:20 -0800 (PST)
X-Gm-Message-State: AA+aEWYiaBXw0oH0tideaisE4Js6vnnRYTn2/naRdCvOHZ4loZnSKzBI
        1bJA0i7I9+ZQ/tzjVM8KDWC6MM/0Tp9TtbXV17Q=
X-Google-Smtp-Source: AFSGD/U4TysAOvxaiVltnLJdt4Jrll6cCHh5sdlK9PaNJLJav5HobojvH4ISmuqvqeWTkez2DObLe8vR/a+8T/FyzJU=
X-Received: by 2002:ab0:3259:: with SMTP id r25mr14683993uan.108.1543416019012;
 Wed, 28 Nov 2018 06:40:19 -0800 (PST)
MIME-Version: 1.0
References: <20181123134543.20199-1-fdmanana@kernel.org> <20181123182540.7206-1-fdmanana@kernel.org>
 <20181126181711.GI2842@twin.jikos.cz> <CAL3q7H5kGb9otnqmOGddOGvnT3BnNG6hZHVaBUaOJrOXawVNAA@mail.gmail.com>
 <20181128142217.GO2842@twin.jikos.cz>
In-Reply-To: <20181128142217.GO2842@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 28 Nov 2018 14:40:07 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6nEFPa20iPLuap7xNpSugTScDt+Z1zvf1WS1dOpOtFDg@mail.gmail.com>
Message-ID: <CAL3q7H6nEFPa20iPLuap7xNpSugTScDt+Z1zvf1WS1dOpOtFDg@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock with memory reclaim during scrub
To:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 2:22 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Mon, Nov 26, 2018 at 08:10:30PM +0000, Filipe Manana wrote:
> > On Mon, Nov 26, 2018 at 6:17 PM David Sterba <dsterba@suse.cz> wrote:
> > >
> > > On Fri, Nov 23, 2018 at 06:25:40PM +0000, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > When a transaction commit starts, it attempts to pause scrub and it blocks
> > > > until the scrub is paused. So while the transaction is blocked waiting for
> > > > scrub to pause, we can not do memory allocation with GFP_KERNEL from scrub,
> > > > otherwise we risk getting into a deadlock with reclaim.
> > > >
> > > > Checking for scrub pause requests is done early at the beginning of the
> > > > while loop of scrub_stripe() and later in the loop, scrub_extent() and
> > > > scrub_raid56_parity() are called, which in turn call scrub_pages() and
> > > > scrub_pages_for_parity() respectively. These last two functions do memory
> > > > allocations using GFP_KERNEL. Same problem could happen while scrubbing
> > > > the super blocks, since it calls scrub_pages().
> > > >
> > > > So make sure GFP_NOFS is used for the memory allocations because at any
> > > > time a scrub pause request can happen from another task that started to
> > > > commit a transaction.
> > > >
> > > > Fixes: 58c4e173847a ("btrfs: scrub: use GFP_KERNEL on the submission path")
> > > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > > ---
> > > >
> > > > V2: Make using GFP_NOFS unconditionial. Previous version was racy, as pausing
> > > > requests migth happen just after we checked for them.
> > > >
> > > > V3: Use memalloc_nofs_save() just like V1 did.
> > > >
> > > > V4: Similar problem happened for raid56, which was previously missed, so
> > > >     deal with it as well as the case for scrub_supers().
> > >
> > > Enclosing the whole scrub to 'nofs' seems like the best option and
> > > future proof. What I missed in 58c4e173847a was the "don't hold big lock
> > > under GFP_KERNEL allocation" pattern.
> > >
> > > >  fs/btrfs/scrub.c | 12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > >
> > > > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > > > index 3be1456b5116..e08b7502d1f0 100644
> > > > --- a/fs/btrfs/scrub.c
> > > > +++ b/fs/btrfs/scrub.c
> > > > @@ -3779,6 +3779,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
> > > >       struct scrub_ctx *sctx;
> > > >       int ret;
> > > >       struct btrfs_device *dev;
> > > > +     unsigned int nofs_flag;
> > > >
> > > >       if (btrfs_fs_closing(fs_info))
> > > >               return -EINVAL;
> > > > @@ -3882,6 +3883,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
> > > >       atomic_inc(&fs_info->scrubs_running);
> > > >       mutex_unlock(&fs_info->scrub_lock);
> > > >
> > > > +     /*
> > > > +      * In order to avoid deadlock with reclaim when there is a transaction
> > > > +      * trying to pause scrub, make sure we use GFP_NOFS for all the
> > > > +      * allocations done at btrfs_scrub_pages() and scrub_pages_for_parity()
> > > > +      * invoked by our callees. The pausing request is done when the
> > > > +      * transaction commit starts, and it blocks the transaction until scrub
> > > > +      * is paused (done at specific points at scrub_stripe() or right above
> > > > +      * before incrementing fs_info->scrubs_running).
> > >
> > > This hilights why there's perhaps no point in trying to make the nofs
> > > section smaller, handling all the interactions between scrub and
> > > transaction would be too complex.
> > >
> > > Reviewed-by: David Sterba <dsterba@suse.com>
> >
> > Well, the worker tasks can also not use gfp_kernel, since the scrub
> > task waits for them to complete before pausing.
> > I missed this, and 2 reviewers as well, so perhaps it wasn't that
> > trivial and I shouldn't feel that I miserably failed to identify all
> > cases for something rather trivial. V5 sent.
>
> You can say that you left it there intentionally, such cookies are a
> good drill for reviewers to stay sharp.

Unfortunately for me, it was not on purpose.

However there's the small drill of, for the workers only, potentially
moving the memalloc_nofs_save() and
restore to scrub_handle_errored_block(), since the only two possible
gfp_kernel allocations for workers
are during the case where a repair is needed:

scrub_bio_end_io_worker()
  scrub_block_complete()
    scrub_handle_errored_block()
      lock_full_stripe()
        insert_full_stripe_lock()
          -> kmalloc with GFP_KERNEL


scrub_bio_end_io_worker()
   scrub_block_complete()
     scrub_handle_errored_block()
       scrub_write_page_to_dev_replace()
         scrub_add_page_to_wr_bio()
           -> kzalloc with GFP_KERNEL

Just to avoid some duplication.

>
> When I started the conversions of GFP_NOFS -> GFP_KERNEL, scrub looked
> quite safe in this respect but turns out it's not. I was wondering if we
> could add some lock assertions before GFP_KERNEL allocations, like:
>
>         assert_lock_not_held(fs_info->device_list_mutex)
>         kmalloc(GFP_KERNEL)
>
> and add more locks per subsystem (eg. the scrub lock) and possibly some
> convenience wrappers. Michal's scope GFS_NOFS patch series has a
> debugging warning where NOFS is used in context where it does not need
> to, while having the 'must not hold an important lock' would be a good
> debugging helper too.
