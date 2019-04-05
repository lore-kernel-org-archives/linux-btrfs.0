Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B80C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 05:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46AC221738
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 05:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="quiokCJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfDEFv0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 01:51:26 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:45702 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfDEFv0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 01:51:26 -0400
Received: by mail-ot1-f52.google.com with SMTP id e5so4564483otk.12
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2019 22:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NMx5cTFHUN+FEG+1qKeWNUH+Cg11JJfPv2nWN9sk8UQ=;
        b=quiokCJZMWis2jSiaVAaJFnnT317k7+HUZd+x0JK2RK2yVwu47ki4lVSSGpleCKIbj
         epsC1FofHG73Ap9AjdfNieZ7uB4TOVmkPxrCGtS3ydPG6wH62taM3UfarNKtCDSRK8/n
         YRaHcKefsfEWZm5av4oSqgmxFT3HffK0UkIfsDNtDnH2a93hYtdc2YKl/csDzKXBjk90
         sqaPUaz59haGG/fH9n0Lp+zBv08Mv5+p/fJreGpUyKMU0mnkjOEHe/FVNazbulfOrJWd
         SubwDxQSBNUKqK8NrfCoN813gmFBgJRK9Wukt5+iE40tvbeHebCkADYguVwtJOT/HYQ0
         leHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NMx5cTFHUN+FEG+1qKeWNUH+Cg11JJfPv2nWN9sk8UQ=;
        b=fsAtxp0mbkINdeyvN0SMRd9Hdh7+bL6GHE2JWrAdvQ1M6e/yAaA51wS/Wm4eY4NGHa
         56X6H6UB9Us5vSVN2RXCeEweoCznqOjPlPO1AcllOu6GVdfWNaEJ/SAC1UUbwnMvbmeq
         CYx0KNFZNOiNPUJBBrfLNVFQyf21fpvXfjI4zEBHNBTGpzqPL8gJH4NvhPga4SxZCFnU
         hycWgo1wWdECyNvF90bg3tJFs5DFdiSHSh8dpIaHAJYimovZBbX8JfnYFhY3aBQwn4yH
         uyzMALBMjYVRz/Jb9bT8JtPnKrjjz8iFeMBmZpDZO7Kn4khxswGT5M+4DCOpJWRVdR0U
         jvRw==
X-Gm-Message-State: APjAAAWBSD2xATddIri7ULk7yg1pufEQqXfTIQsFX2qjWD8hCz54dlNO
        Qh0C7NnjljBFw5C4xTBEBwQMqW86TL5X5mQseRhLXEHw
X-Google-Smtp-Source: APXvYqxUT5+B35oXMJPBsbBFvb/qeW9Hj6Z+SKi/6ZuuTQ462MQEh3KVT3LBygfojLcitw5H57CmRDvjyzd/rvoMt1U=
X-Received: by 2002:a9d:7f89:: with SMTP id t9mr6965416otp.169.1554443485826;
 Thu, 04 Apr 2019 22:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
 <CAG3pWA=pzd+xxCrZ92b4TBw5iWtsHkfJQ4nsNrnqcBz_6dX4Hg@mail.gmail.com>
 <CAJCQCtTgfVY9g+A3m=FA_k0O-kbMGifz8QF62W2LMVmW_C8wnA@mail.gmail.com>
 <CAG3pWAkZdzD-W2HHd46bdyAzHwLdOt-t+LVXhWgV_bBkUmKBVg@mail.gmail.com> <CAJCQCtQs_oBAXB4UzY1xGuZatqrCb0=+3y9g8T2f2v+6eEg9RQ@mail.gmail.com>
In-Reply-To: <CAJCQCtQs_oBAXB4UzY1xGuZatqrCb0=+3y9g8T2f2v+6eEg9RQ@mail.gmail.com>
From:   Glenn Trigg <ggtrigg@gmail.com>
Date:   Fri, 5 Apr 2019 16:51:14 +1100
Message-ID: <CAG3pWAmMHnsC_cgiy+5Rt5vunW6cAw8FcZW_zHPWOQttx2Z=Nw@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Chris,

Thanks for spending the time and energy to help me look into this.

btrfs restore isn't very happy either, so I guess I'll wait until
btrfs-progs v5.0 comes out and see if that helps.

btrfs restore says...
% ./btrfs restore -v -D /dev/sda1 /data2
This is a dry-run, no files are going to be restored
parent transid verify failed on 628168376320 wanted 37601 found 37712
parent transid verify failed on 628168376320 wanted 37601 found 37712
parent transid verify failed on 628168376320 wanted 37601 found 37712
parent transid verify failed on 628168376320 wanted 37601 found 37712
Ignoring transid failure
ERROR: child eb corrupted: parent bytenr=628624064512 item=0 parent
level=1 child level=1
Error searching -5

and...

% ./btrfs restore -l /dev/sda1
 tree key (EXTENT_TREE ROOT_ITEM 0) 628168359936 level 1
 tree key (DEV_TREE ROOT_ITEM 0) 628642152448 level 1
 tree key (FS_TREE ROOT_ITEM 0) 628635549696 level 2
 tree key (CSUM_TREE ROOT_ITEM 0) 628168343552 level 0
 tree key (UUID_TREE ROOT_ITEM 0) 628810366976 level 0
 tree key (DATA_RELOC_TREE ROOT_ITEM 0) 628168491008 level 0

Regards,
Glenn

On Tue, 2 Apr 2019 at 04:14, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sun, Mar 31, 2019 at 11:48 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
> >
> > Hi Chris,
> >
> > After booting the fedora usb stick (running rc2), I got the same results.
> >
> > On Mon, 1 Apr 2019 at 08:35, Chris Murphy <lists@colorremedies.com> wrote:
> > >
> > > On Sat, Mar 30, 2019 at 5:43 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
> > ...
> > >
> > > I'm confused because "can't read superblock" isn't found in fs/btrfs.
> > > I'm only finding it in fs/gfs2/ops_fstype.c
> > >
> > > From what you provided, /dev/sda1 definitely has a valid btrfs
> > > superblock. I wonder if there's some other stale something or other on
> > > this partition?
> > >
> > > What do you get for
> > >
> > > $ sudo blkid
> >
> > /dev/sda1: LABEL="data" UUID="d5e50511-3e31-4de6-ba37-c5841895be9f"
> > UUID_SUB="a28b0f34-f14d-492b-995b-2dd8a78ec9bb" TYPE="btrfs"
> > PARTUUID="efa240ec-01"
> > /dev/sdc1: LABEL="data" UUID="d5e50511-3e31-4de6-ba37-c5841895be9f"
> > UUID_SUB="d9c56d7a-21a1-4197-a701-5493392e1ae1" TYPE="btrfs"
> > PARTUUID="1aae1443-c03e-4509-ad06-124a64c4df4f"
> >
> > > $ sudo wipefs -an /dev/sda1 /dev/sdc1
> >
> > /dev/sda1: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48
> > 52 66 53 5f 4d
> > /dev/sdc1: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48
> > 52 66 53 5f 4d
> >
> > > $ sudo mount -v -o ro,nologreplay,usebackuproot
> >
> > mount: /data: can't read superblock on /dev/sda1.
> >
>
> That is the sort of error I'd expect if the device were in fstab to be
> mounted at /data. But you're running this mount command while booted
> from the Fedora USB stick? I'm pretty lost at this point.
>
> Anyway, your best bet is to scrape with `btrfs restore` and then move
> on, i.e. start over with a new file system. Right now I have no
> confidence in the repair tools, but maybe a developer will come along
> and offer some different advice on additional steps. For sure any of
> the user space repair options are a last resort. There should be a
> btrfs-progs 5.0 soon that is supposed to be safer, and might be worth
> a shot. But I think it's a coin toss.
>
>
> --
> Chris Murphy
