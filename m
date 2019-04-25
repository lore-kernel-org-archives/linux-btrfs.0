Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91E3C43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9FF2081C
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQp5jcha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfDYOj7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:39:59 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:43680 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfDYOj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:39:59 -0400
Received: by mail-vk1-f193.google.com with SMTP id g18so6743vki.10
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 07:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=kFvuexxR269/eejOUNrJ4n80WtQE4eeKGs6C6vxnTgg=;
        b=iQp5jchaUZwDKv3JGCLqepQVUPc9uhSL6IIVALAz1hK8v/K2B5IY40KN4jax/ldU/S
         dVX3xwu13gCT+4l88wLQOEI0ktp4llJRy0jrMz3ieiQoeWSAhUuGgyu+B3g2FvvNiNs5
         bdkTTcZttl9WiBBD3SMmzrZEMmnxRlorLH1kYMHsWk+uQ+OAW/CXiNN8wsnk4eKPQTdT
         J4FtnHgql69CjqdLo1KyOC/QsXyNY36hSEzwVGFOxiGE+9NdHSx8i0SvMOBQ5Z9q9TNc
         fIX8PDqnvEBltJY3lIK7NuT/AaVoYIAttZxtsVbHeDu5rAnxQWIRo/GzV2NdKS9dN7hr
         VVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=kFvuexxR269/eejOUNrJ4n80WtQE4eeKGs6C6vxnTgg=;
        b=Qo7ZJ8BvR+q9SOccBWJe9xcH4lfvkRw85eUU2G4mVdHs/TdJgkMwGr1yFZYmAMFTvZ
         hCMRzt2tUxSk3qlm+oQ1L3fDoTU8KRMGAYtqqxo8i4MnEvm6mcIAIVKd8aAdTrmrUmnT
         Y2vQSy4bjm9mKRERtP+4vSM3AGHMI0ushBuJnYEt9ZUaIAj0hyS0z38Usftr+Gws8ynj
         mg59njYi6XMhb/eNPbQ+Q8O1K6AK3mAjprXSZ2w4rhfKOaJDPZTss0ySO5d07TfNtskT
         Xl0GNKNqyQOFaCJpH2/TlAIlvGYxiKTMx5Y5lwc6ZcFko/R7BOUrfiU71UOmPTd5lPEm
         EFUQ==
X-Gm-Message-State: APjAAAUIVBGKR/n052QWu3GZN6CwvKuD88C4yA6oyC2v84Dtz3Q2tBJE
        oYpFzm9sG/Ux/khdt0p0es6Apy9Z0ffK0qZC18Q=
X-Google-Smtp-Source: APXvYqygLIEeTfaz3pbKOpYsoxW+SJcKKCVOw99mEqBxb4J3xhdCCIv/rbQvtFwhXNs0qqdKskzBftpAJe8edJ9vSYE=
X-Received: by 2002:a1f:ce07:: with SMTP id e7mr11428779vkg.23.1556203197767;
 Thu, 25 Apr 2019 07:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com> <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
In-Reply-To: <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 25 Apr 2019 15:39:46 +0100
Message-ID: <CAL3q7H7-Rxw2RvyR1=U0d9euTK8TuRaxPg2HsLt1GcfrN0EAGA@mail.gmail.com>
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 9:17 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/23 =E4=B8=8B=E5=8D=887:33, David Sterba wrote:
> > On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
> >> On 2019/4/23 =E4=B8=8A=E5=8D=885:09, Jakob Unterwurzacher wrote:
> >>> I have a user who is reporting ENOSPC errors when running gocryptfs o=
n
> >>> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395=
 ).
> >>>
> >>> What is interesting is that the error gets thrown at write time. This
> >>> is not supposed to happen, because gocryptfs does
> >>>
> >>>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
> >>>
> >>> before writing.
> >>>
> >>> I wrote a minimal reproducer in C: https://github.com/rfjakob/falloca=
te_write
> >>> This is what it looks like on ext4:
> >>>
> >>>     $ ../fallocate_write/fallocate_write
> >>>     reading from /dev/urandom
> >>>     writing to ./blob.379Q8P
> >>>     writing blocks of 132096 bytes each
> >>>     [...]
> >>>     fallocate failed: No space left on device
> >>>
> >>> On btrfs, it will instead look like this:
> >>>
> >>>     [...]
> >>>     pwrite failed: No space left on device
> >>>
> >>> Is this a bug in btrfs' fallocate implementation or am I reading the
> >>> guarantees that fallocate gives me wrong?
> >>
> >> Since v4.7, this commit changed the how btrfs do NodataCOW check:
> >> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
> >>
> >> Before that commit, btrfs always check if they need to reserve space f=
or
> >> COW, while after that patch, btrfs never checks unless we have no spac=
e.
> >>
> >> However this screws up other nodatacow space check.
> >> And due to its age and deep changeset, it's pretty hard to fix it.
> >> I have tried several times, but it will only cause more problems.
> >
> > What if the commit is reverted, if the problem is otherwise hard to fix=
?
> > This seems to break the semantics of fallocate so the performance shoul=
d
> > not the main concern here.
>
> My blur memory of the underflow case is something like below: (failed to
> locate the old thread)
>
> - fallocate
> - pwrite in to the reallocated range
>   At this timing, we can do nocow, thus no data space is reserved.
>
> - Something happened to make that preallocated extent shared, without
>   writing back dirty pages.
>   Some possible causes are snapshot and reflink.
>   However nowadays, snapshots will write all dirty inodes, and reflink
>   will write the source range to disk.

Nowadays? It's like that for 11 years now.
It's been like that in clone since it was introduced (2008, commit
f2eb0a241f0e5c135d93243b0236cb1f14c305e0)
and in the snapshot creation ioctl since 2008 as well (commit
dc17ff8f11d129db9e83ab7244769e4eae05e14d).

>
>   Maybe it's a small window inside create_snapshot() between
>   btrfs_start_delalloc_snapshot() and btrfs_commit_transaction() calls?
>
> - dirty pages get written back
>   We created ordered extent, but at this timing, we can't do nocow any
>   more, we need to fallback to cow.
>   However at the buffered write timing, we didn't reserved data space.
>   Now we will underflow data space reservation.
>
> However nowadays there are some new mechanism to handle this case more
> gracefully, like btrfs_root::will_be_snapshotted.
>
> I'll double check if reverting that patch in latest kernel still cause
> problem.
> But any idea on the possible problem is welcomed.

To me it seems the problem is not yet well formulated, therefore it's
hard to give ideas/suggestions.

The one you pointed isn't related to the issue reported by Jakob,
since it involves only a single file (I couldn't reproduce it anyway).
So what's your explanation for Jakob's test case, which happens for
him on a fresh filesystem with a single file?

I could only see the potential bytes_may_use counter leak issue I
mentioned previously.

Perhaps creating a test case for fstests will make it clear and avoid
so many replies back and forth in this thread and others.

Thanks

>
> Thanks,
> Qu




>
--
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
