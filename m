Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B549C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 17:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26C76218A2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 17:46:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iX3wWVal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfAYRqQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 12:46:16 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:39719 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfAYRqP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 12:46:15 -0500
Received: by mail-vs1-f65.google.com with SMTP id h78so6153653vsi.6
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 09:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=NUOy3hOzYKnQCxNwDuJNm19DMH6hMQ8mmsfAeJUDKUU=;
        b=iX3wWVal/a/kIQdblTSbRly7/qlHrSYdRi3nSSAwV1E2SUeFy1CRc9cFXTdgvtykNZ
         gijP+V3w5fpUi65VFhvo2a6d1ORiL+gre0sFXAASJx8AWxripwKnBcxwiQvuG6ol+P9k
         nj2e1tjiOEon80zO8HO3UtAVdIIYrLbBaSD3wYmTy3rzmYu8q+VV/xsW8CMS+gKGx9Rt
         Iakw2fXpR8TqOKraydivq1IJ0umHy0/8xp4YRMHCBjjA+LrrJJPGYUbVrkxneuVyCXgT
         mmoSBUOdYS2/mlUEjjbW6eXQOv7lEFBAx4VqikXZOzmBGQkHv/JAPzdeAVgaGX+c0jWf
         J6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=NUOy3hOzYKnQCxNwDuJNm19DMH6hMQ8mmsfAeJUDKUU=;
        b=OSZi/p3QUGyMrmlt5yoOx03cHkOwuJFMwQQ1wxVw+6pNYIlEhxps6gIRb+xWVdJ9J6
         YJzarpI7kn7Ms+NYC9K6gXpusXl1icLxcAms/LZcWIaKpLe7/HMrVOl/30iweMR08Kfl
         bU0ja5XbNlZ4nuAt5SYONDztTwV94x7bqnFpVbknd/17gGA8U0CeAQaQsKANCcKAG9fs
         iYNwX2AG5JTNDu3jslotQh6ROqB+VIgivszorNlMxeoWy+PVxmv35g2oKnj7IC/Oa+6I
         01hgDoZJWvw9eRko+Hg77dViZ1diU5HR8OSDr6sS+t/YNojcJG+d6wz+kskYmWlQoav0
         YGvQ==
X-Gm-Message-State: AJcUukenrcN5aJmzfSz5lfuI8fSMxnHSYlSEYNheWIn3iBrifowA+UD1
        Nt1KgmQeveHlbaPq8/mSGUSfx/S8pBLk/vxe04o=
X-Google-Smtp-Source: ALg8bN4KvdZqd31GF0skFUz237QGVGmiDF8jZeanfKmGi60zjwXpSfmtg2sLGdQYRCNBhWfXr0+mvG15J64Bl6YkU7A=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr4069680vsa.99.1548438373689;
 Fri, 25 Jan 2019 09:46:13 -0800 (PST)
MIME-Version: 1.0
References: <20190109144303.31847-1-nborisov@suse.com> <20190125150545.GC2900@twin.jikos.cz>
In-Reply-To: <20190125150545.GC2900@twin.jikos.cz>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 25 Jan 2019 17:46:02 +0000
Message-ID: <CAL3q7H4eTXK=hv+i418DAZSUcWRjuLbpkjXpsckaeCMLL=Q06g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Handle ENOMEM gracefully in cow_file_range_async
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <wqu@suse.com>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 25, 2019 at 3:08 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Jan 09, 2019 at 04:43:03PM +0200, Nikolay Borisov wrote:
> > If we run out of memory during delalloc filling in compress case btrfs
> > is going to BUG_ON. This is unnecessary since the higher levels code
> > (btrfs_run_delalloc_range and its callers) gracefully handle error
> > condtions and error out the page being submittede. Let's be a model
> > kernel citizen and no panic the machine due to ENOMEM and instead fail
> > the IO.
> >
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> >  fs/btrfs/inode.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index cde51ace68b5..b4b2d7f8a98b 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -1197,7 +1197,8 @@ static int cow_file_range_async(struct inode *ino=
de, struct page *locked_page,
> >                        1, 0, NULL);
> >       while (start < end) {
> >               async_cow =3D kmalloc(sizeof(*async_cow), GFP_NOFS);
> > -             BUG_ON(!async_cow); /* -ENOMEM */
> > +             if (!async_cow)
> > +                     return -ENOMEM;
>
> The error handling here is very simple and breaks the usual rule that
> all functions must clean up after themselves before returning to the
> caller.
>
> This is async submission so it can be expected to do deferred cleanup,
> but this cannot be easily seen from the function and should be better
> documented.
>
> What happens with the inode reference (igrab), what happens with all
> work queued until now, or extent range state bits.
>
> It's true that btrfs_run_delalloc_range does error handling, though it
> does that from 4 different types of conditions (nocow, prealloc,
> compression and async). I'd really like to see explained that there's
> nothing left and cause surprises later. The memory allocation failures
> are almost never tested so we have to be sure we understand the error
> handling code flow. I can't say I do after reading your changelog and
> the correctness proof is left as an exercise.
>
> The error handling was brought by 524272607e882d04 "btrfs: Handle
> delalloc error correctly to avoid ordered extent hang", so there's a
> remote chance to cause lockups when the state is not cleaned up.

So taking a quick look at this, just returning does not seem correct:

- If you have for example a dealloc range of 1Mb, submitting the first
512K async job succeeds
  but the the second one fails due to the out of memory issue, then
writepage_delalloc() will
  set the error bit on the page starting at offset 0 of the range, and
not the one at 512K.
  What if the first submitted range succeeds? What happens? I think
the error handling from the
  caller should be aware if writeback started for a part of the range
already, and if so operate only
  on the remaining of the range.

Did you actually run a test where an iteration other then the first
one fails and see if there
were no hangs, error reported to user space (by means of an fsync for
example), no leaks (kmemleak helps here), etc?

This is very fishy because of the async nature of the compression
path, each submitted job also does
error handling if anything fails, and they all get a reference for the
first page of the whole range.
Did you check if we don't end up with 2 tasks unlocking that page for examp=
le?

Pre-allocating the async_cow structures at the beginning of
cow_file_range_async(), as suggested in another reply,
seems ok to me and would not need any adjustments of the existing
error handling code.


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
