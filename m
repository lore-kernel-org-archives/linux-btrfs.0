Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32347C43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 09:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E594720675
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 09:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9VjqhH2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfDZJJM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:09:12 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43182 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfDZJJM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 05:09:12 -0400
Received: by mail-vs1-f66.google.com with SMTP id t23so1499446vso.10;
        Fri, 26 Apr 2019 02:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=TvUOukXXyxFa9CqmUNSq3KzLDs0BUp6xRIqDRAFNpLw=;
        b=K9VjqhH2o1aMOxzedMzrYNiIvHPpghYdsY+ijs5MK/K3vwtG0GgrDmGkucjLBXHP21
         OhVMUKIDTwU4Fthad81wfp2npOvAW2cb5v/cNTbzhNiGy+qHho0x8b0XMeTNVtc7LIkI
         isqC7gA8AOVlwzKsCKs1fJwBFPjReBevhsVqXVeb3raafzlWjppqGRg0CHVW24/MFY6W
         HbM1LU5alk9oUKGwATMnetKbflrApAAcuQec3k0JeZQkmN1OI1YtC6XVivz3NDENx4uu
         12yxhSwxcUbrqL1pAlrWFHhpWala4m2GQ3UJRVg6/0CyEBObWz4FLp2j0iuT9ejPzAH3
         +p1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=TvUOukXXyxFa9CqmUNSq3KzLDs0BUp6xRIqDRAFNpLw=;
        b=TqcmcsAQllYoBP9l3BXqqTnzFUKu4qxdXlaW7kCFGBmTW0QF4/s/EP6G8Mewqns7Nv
         AjPBDlUqTM0tzkw5Q6T/GUw8MSLuhboA6qQCVZW5KVoGecB5e0+16q6BC05hY2DAL8oA
         +uPovhs+0NtVH1T8P9LK44L0+J8lW4sP4dA8CD2ehHRlzgjaxYemqx9O+XQTCdGBg94K
         MWgM+3OHLJPjI/gtqPS+QiA076urQHFrpJoAilu+uAE9cpyBdTqxV9Z8Uk3QK5mQse33
         ABlkTUYiCu9i0UkuOO2oICVkThST78IkYxUvlciDlD39QPBgmbh+s1eoNQ8h5ZIq/Bb6
         B2LA==
X-Gm-Message-State: APjAAAVd1RicT5WfUk/FBarpSTMo2L00tzufpeFIXdi6naLcv3YYX6uq
        pKZUcCHqnjsDI0b1Egmr7UhlevUs69sM9u3mCEmvmQ==
X-Google-Smtp-Source: APXvYqyVIEIuI5hnNmDeFFnovMXA1PTCnIMePNQ1BJUEwVdYoUbd1GYs7ov6al29w0MbMgIExKKjSYN6DkH+oedwgHc=
X-Received: by 2002:a67:af1a:: with SMTP id v26mr20971192vsl.99.1556269750937;
 Fri, 26 Apr 2019 02:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
 <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com> <06b5b693-8017-7ec0-b17a-c723291f00c7@suse.com>
 <950b2924-9edd-d9d7-ace0-bc3e2ab07a6a@gmx.com> <CAL3q7H6-9mxYyzi8Y0N8Vvgf4qRgrqURqHASE_4Du-jLmywuBQ@mail.gmail.com>
 <cfcaf75e-7e89-cf1f-9293-6a022762f22c@gmx.com> <20b22fc6cdc288ed9aaf0be1a6cdeb7b@synology.com>
 <1fcaaa0c-cf7b-38dc-0af9-c90773c9af07@gmx.com> <50d35084420d7fed439d74fd29b12d7d@synology.com>
 <cc92c057-915a-b83e-f308-2f0fcbd5107d@gmx.com> <bc2fd2ad-1ca9-48d1-d8ff-13eec7eabd02@gmx.com>
In-Reply-To: <bc2fd2ad-1ca9-48d1-d8ff-13eec7eabd02@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 26 Apr 2019 10:09:00 +0100
Message-ID: <CAL3q7H6t3Ot+rhY5KQ2+o3=eikyUm_03C8Dog1cTFf6rXVVsLg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     robbieko <robbieko@synology.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        linux-btrfs-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 26, 2019 at 7:59 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/26 =E4=B8=8B=E5=8D=882:32, Qu Wenruo wrote:
> >
> >
> > On 2019/4/26 =E4=B8=8A=E5=8D=8811:32, robbieko wrote:
> > [snipped]
> >>>
> >>> But now, before creating new snapshot, we will flush all data.
> >>>
> >>> This means at this time, the data will be written back *NOCOW*, just =
as
> >>> expected.
> >>>
> >>>> will_be_snapshotted will be set, and then flush
> >>>
> >>> will_be_snapshotted will also be gone.
> >>>
> >>> Thanks,
> >>> Qu
> >>>
> >>
> >> Why will will_be_snapshotted disappear?
> >>
> >> If will_be_snapshotted is removed, when volume is full,
> >> how do we ensure that snapshot and write are both
> >> simultaneous data not loss ?
> >>
> >> How do you avoid the write data between btrfs_start_delalloc_snapshot
> >> and create_pending_snapshot during this time ?
> >
> > Oh, I forgot that buffered write doesn't rely on transaction, thus it
> > has the race window between above 2 functions.
> >
> >
> > So will_be_snapshotted is to ensure buffered write at above race window
> > always reserve space for COW.
> >
> > So your patch changes the behavior from:
> >                    /------------------------ inc(will_be_snapshotted)
> >                    |
> > -------------------|-------------------------------------
> > reserve: NOCOW     | reserve: COW
> > delalloc: NOCOW    | delalloc: COW
> >
> > That reserve NOCOW->delalloc COW is causing ENOSPC.
> >
> > To new the behavior:
> >
> >                    /------------------------ inc(will_be_snapshotted)
> >                    |                     /-- inc(snapshot_force_cow)
> > -------------------|---------------------|---------------
> > reserve: NOCOW     | reserve: COW        | reserve: COW
> > delalloc: NOCOW    | delalloc: NOCOW     | delalloc: COW
> >
> > And now reserve->delalloc is either NOCOW->NOCOW or COW->COW, avoiding
> > the possible ENOSPC.
> >
> > Then it makes sense now. (although way more complex)
> >
> > Although I still have some questions about all these
> > will_be_snapshotted/snapshot_force_cow code.
> >
> > 1) Does that btrfs_start_delalloc_snapshot() in create_snapshot() call
> >    still make sense?
> >    We now have btrfs_start_delalloc_snapshot() in
> >    btrfs_start_delalloc_flush().
> >    Can we remove that call in create_snapshot() and:
> >
> > 2) Can't we make the race window smaller? (If we can remove the call in
> >    mentioned in above quiestion)
> >    E.g. move the inc(will_be_snapshotted) before
> >    btrfs_start_delalloc_snapshot() in btrfs_start_delalloc_flush(),
> >    and move inc(snapshot_force_cow) after that
> >    btrfs_start_delalloc_snapshot() call?
> >
> >    As you also mentioned, the real race window is between
> >    btrfs_start_delalloc_snapshot() and create_pending_snapshot().
>
> And another (unrelated) question:
>
> 3) Why we use such complex way to prevent race? Why not just go per-
>    subvolume freeze like various volume manager?
>
>    Current way keeps buffered write still going, but does it worth?

And that's precisely one of the advantages of Btrfs' snapshotting - it
does not block writes while snapshotting is in progress.
Blocking them is terrible for user experience - waiting for
snapshotting IO (flushing delalloc, waiting for delalloc, committing a
transaction, etc) can take seconds, or minutes, or maybe more in
extreme cases.

As a user, while I'm browsing youtube, replying to these threads,
playing games, etc, I would really hate if I experience stalls while
snapper decided to take a snapshot of my root or home subvolumes.
Not to mention the case for IO intensive applications (databases, etc).

>
>    If we freeze/block write when creating snapshot, it just falls back
>    to traditional volume manager behavior, shouldn't cause much problem,
>    and we can get rid of all these snapshot specific fixes.

So if after that we still find bugs in snapshotting, and we will for
sure, then we do what? Disable snapshotting in btrfs, remove all the
supporting code?

NACK.

>
> Thanks,
> Qu
>
> >
> > Thanks,
> > Qu
> >
> >>
> >> E.g. chattr +C /mnt
> >> Fallocate -l 4096 /mnt/small_file
> >> Fallocate -l $((64*1024*1024)) /mnt/large_file
> >>
> >> First process:
> >> While true; do
> >> dd if=3D/dev/urandom of=3D/mnt/small_file bs=3D4k count=3D1 conv=3Dnot=
runc
> >> Done
> >>
> >> Second process:
> >> While true; do
> >> dd if=3D/dev/urandom of=3D/mnt/large_file bs=3D64k count=3D1024 conv=
=3Dnotrunc
> >> Done
> >>
> >> Third process: create snapshot.
> >



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
