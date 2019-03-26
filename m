Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73AAC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 12:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FCEB2075E
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553603719;
	bh=E7osxTx9JvP47/blPGI1MFe+Co93UUQ76Kwnx+hRj1A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lLowGX14WQPTUTYb/nDZNJ4mZuTrzNSak+NxyKa4/LsVeRLhii5xh8zflQMluNy4G
	 +ZcfUobVGKFOWzPf7T+DveP9Lg5H3yoASxj31bKr6clirER4LPw8BBYFFiX4vMB9QN
	 U/QCBM3nx8nO/fVx1Tq2+zJZ4FznHAM/l/JpSqSs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfCZMfS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbfCZMfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 08:35:18 -0400
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3E72075E
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553603717;
        bh=E7osxTx9JvP47/blPGI1MFe+Co93UUQ76Kwnx+hRj1A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oBKXGwyBRBXBsAKEvXb2iseEyZt/LdWvEJdHnl89zyt6EwcIexZ2PePbqU6Rq/AlR
         ZqdZjuBMh/uGiSEp3kfnYvTaCm3RAGrbkYWVkkWfWUvBXthLxlZpolxwyv709ziNIV
         NZzTsBObRq3MavNRoKB0gJXP5vpHomN8JJuEeobE=
Received: by mail-vk1-f176.google.com with SMTP id h71so2757607vkf.5
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 05:35:17 -0700 (PDT)
X-Gm-Message-State: APjAAAWmxWxx0imdodX4h/G9tz0Zbi4kVxqN8BwKGXyHVa/ilNCSOjGF
        9VHiiLfb+CasxIbebwnXhwvsOvbMnhD8ZELWtak=
X-Google-Smtp-Source: APXvYqyIGimHaSWNBm/slpiz/JaOT1Bf6ZIKPUXAUz0zWqoDx280aTTZ9a8GPMpmfOeBvB9Ubz2HrZyauomuP7qUszU=
X-Received: by 2002:a1f:b587:: with SMTP id e129mr17612189vkf.23.1553603716313;
 Tue, 26 Mar 2019 05:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190326104956.10314-1-fdmanana@kernel.org> <d828e591-22f6-faf2-76ec-1f52397ba858@suse.com>
In-Reply-To: <d828e591-22f6-faf2-76ec-1f52397ba858@suse.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 26 Mar 2019 12:35:05 +0000
X-Gmail-Original-Message-ID: <CAL3q7H56EUFNBBt7ZL8sojzgh=+QJQUzOBBOez75-WVjbCZ4=A@mail.gmail.com>
Message-ID: <CAL3q7H56EUFNBBt7ZL8sojzgh=+QJQUzOBBOez75-WVjbCZ4=A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not allow trimming when a fs is mounted with
 the nologreplay option
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 12:17 PM Nikolay Borisov <nborisov@suse.com> wrote:
>
>
>
> On 26.03.19 =D0=B3. 12:49 =D1=87., fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Whan a filesystem is mounted with the nologreplay mount option, which
> > requires it to be mounted in RO mode as well, we can not allow discard =
on
> > free space inside block groups, because log trees refer to extents that
> > are not pinned in a block group's free space cache (pinning the extents=
 is
> > precisely the first phase of replaying a log tree).
> >
> > So do not allow the fitrim ioctl to do anything when the filesystem is
> > mounted with the nologreplay option, because later it can be mounted RW
> > without that option, which causes log replay to happen and result in
> > either a failure to replay the log trees (leading to a mount failure), =
a
> > crash or some silent corruption.
> >
> > Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Does it make sense to make the check a bit more specific and only return
> EROFS when NOLOGREPLAY and the log tree has non-null generation?

It would make sense checking if there's actually a log tree as well.
Neither the xfs nor ext4 (which is already in Linus' tree) do such
equivalent checks, nor the proposed fstests test case makes sure a
journal/log exists.

Not against it, but this isn't a common use case either.

>
> In any case:
>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>
> > ---
> >  fs/btrfs/ioctl.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 494f0f10d70e..01808934d21f 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -501,6 +501,16 @@ static noinline int btrfs_ioctl_fitrim(struct file=
 *file, void __user *arg)
> >       if (!capable(CAP_SYS_ADMIN))
> >               return -EPERM;
> >
> > +     /*
> > +      * If the fs is mounted with nologreplay, which requires it to be
> > +      * mounted in RO mode as well, we can not allow discard on free s=
pace
> > +      * inside block groups, because log trees refer to extents that a=
re not
> > +      * pinned in a block group's free space cache (pinning the extent=
s is
> > +      * precisely the first phase of replaying a log tree).
> > +      */
> > +     if (btrfs_test_opt(fs_info, NOLOGREPLAY))
> > +             return -EROFS;
> > +
> >       rcu_read_lock();
> >       list_for_each_entry_rcu(device, &fs_info->fs_devices->devices,
> >                               dev_list) {
> >
