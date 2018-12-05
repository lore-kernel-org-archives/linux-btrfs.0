Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD68C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 05:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2479206B7
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 05:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksaTA4cl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2479206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbeLEFry (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 00:47:54 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33596 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbeLEFry (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 00:47:54 -0500
Received: by mail-io1-f67.google.com with SMTP id t24so15732651ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2018 21:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2UR7psxlxHExbZarV4QARlSI3oYk2UI8HMgL8MUxqpg=;
        b=ksaTA4cltRXEbIwaO2u4QbKr4T9s+T3VfYjGqAkqKoP4Fgy0sr2xGT8rKd1LHUl1y7
         ARNDxH72A6KqRI+gGRHps9gMWZLq38VszZCerTnFEqX1remUlfYu5NrZ2xY0070trRDK
         jCB/voATFtDRxqhYRZEiJG8IIFIrSQ94kUrlkcQWnm9HxI5JqIJFBT33YDBjOYPUcL1l
         Zdo5mkINtPya7n7CHLr6KDsRJlmJvlU4XzSIXoqIi4Qu/FzhHTt9i9z/Outep9dhUYxX
         dc+HXM/7oMSN80ITUVmRH9pXOebT8/v+cvrTBLSi3Oonj7LA3kIc+2aruNIehOo//+c/
         jbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2UR7psxlxHExbZarV4QARlSI3oYk2UI8HMgL8MUxqpg=;
        b=Uy0YtBo0ODprDkGBvOqqgFLaZb8hPQu3gICt9pvsREwpy/qCPXUs9ozEfbdA1RRaCI
         b15Tqu6MJDEtkgm5erUG6RjB/ku88wQ2DMY5jTW0YKpxtzj+ru0etez63FidYyDVD3LU
         ddsqunqiZTftGhhPFWqlMyoSS376DYWUz4jOKz9fdSCF3Oc/YA2H1GX/hy3RG8sPMQ8O
         Qh5aWOmZdDUcUNkKnnS7raKCbn4eLoWGT5uGo7ztKEDHuQwSy4N7evUfPfl3yfJ/XX8F
         DUpgDSn4JrUtTOX6nPPOOj/EXr8j6+G4SWbT3GrorFHt/NFqjDRu9d0lUjoZa02JfsL2
         Z2uQ==
X-Gm-Message-State: AA+aEWZdMxd+JomyN7synni+gAnwW5DWZk+nrV0JasVDAf42zULTggDU
        /NUfN6fWDYjvT8k1zUiemU42P/Z0mBxa0GXpHIc=
X-Google-Smtp-Source: AFSGD/UZjVYoBtsGxqsDDSlzDhC57hTULSAHJdseC/Wmfkj129fqgI9p0g640umyI2TvwWMs0c4FxLm5SrUDbA7R/io=
X-Received: by 2002:a6b:720d:: with SMTP id n13mr21111384ioc.90.1543988872283;
 Tue, 04 Dec 2018 21:47:52 -0800 (PST)
MIME-Version: 1.0
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
 <35c0af18-35ea-fd2a-5388-c6ee4ce9f434@gmx.com> <CAOv1SKA=psv4wu18YiWy89UAB-R+o5+2qt9jvu6TKjf9EeOvNA@mail.gmail.com>
 <8bb26660-0dbf-1fbd-9472-b64daa88d252@gmx.com>
In-Reply-To: <8bb26660-0dbf-1fbd-9472-b64daa88d252@gmx.com>
From:   Mike Javorski <mike.javorski@gmail.com>
Date:   Tue, 4 Dec 2018 21:47:40 -0800
Message-ID: <CAOv1SKA5B1smo7qOkCNrBqx9ZnV4=RB2MP8+Um+vSVig9Nq3vA@mail.gmail.com>
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Will do, thanks!

- mike
On Tue, Dec 4, 2018 at 9:24 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/12/5 =E4=B8=8A=E5=8D=886:33, Mike Javorski wrote:
> > On Tue, Dec 4, 2018 at 2:18 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
> >>
> >>
> >>
> >> On 2018/12/4 =E4=B8=8A=E5=8D=8811:32, Mike Javorski wrote:
> >>> Need a bit of advice here ladies / gents. I am running into an issue
> >>> which Qu Wenruo seems to have posted a patch for several weeks ago
> >>> (see https://patchwork.kernel.org/patch/10694997/).
> >>>
> >>> Here is the relevant dmesg output which led me to Qu's patch.
> >>> ----
> >>> [   10.032475] BTRFS critical (device sdb): corrupt leaf: root=3D2
> >>> block=3D24655027060736 slot=3D20 bg_start=3D13188988928 bg_len=3D1080=
4527104,
> >>> invalid block group size, have 10804527104 expect (0, 10737418240]
> >>> [   10.032493] BTRFS error (device sdb): failed to read block groups:=
 -5
> >>> [   10.053365] BTRFS error (device sdb): open_ctree failed
> >>> ----
> >>
> >> Exactly the same symptom.
> >>
> >>>
> >>> This server has a 16 disk btrfs filesystem (RAID6) which I boot
> >>> periodically to btrfs-send snapshots to. This machine is running
> >>> ArchLinux and I had just updated  to their latest 4.19.4 kernel
> >>> package (from 4.18.10 which was working fine). I've tried updating to
> >>> the 4.19.6 kernel that is in testing, but that doesn't seem to resolv=
e
> >>> the issue. From what I can see on kernel.org, the patch above is not
> >>> pushed to stable or to Linus' tree.
> >>>
> >>> At this point the question is what to do. Is my FS toast?
> >>
> >> If there is no other problem at all, your fs is just fine.
> >> It's my original patch too sensitive (the excuse for not checking chun=
k
> >> allocator carefully enough).
> >>
> >> But since you have the down time, it's never a bad idea to run a btrfs
> >> check --readonly to see if your fs is really OK.
> >>
> >
> > After running for 4 hours...
> >
> > UUID: 25b16375-b90b-408e-b592-fb07ed116d58
> > [1/7] checking root items
> > [2/7] checking extents
> > [3/7] checking free space cache
> > [4/7] checking fs roots
> > [5/7] checking only csums items (without verifying data)
> > [6/7] checking root refs
> > [7/7] checking quota groups
> > found 24939616169984 bytes used, no error found
> > total csum bytes: 24321980768
> > total tree bytes: 41129721856
> > total fs tree bytes: 9854648320
> > total extent tree bytes: 737804288
> > btree space waste bytes: 7483785005
> > file data blocks allocated: 212883520618496
> >  referenced 212876546314240
> >
> > So things appear good to go. I will keep an eye out for the patch to
> > land before upgrading the kernel again.
> >
> >>> Could I
> >>> revert to the 4.18.10 kernel and boot safely?
> >>
> >> If your btrfs check --readonly doesn't report any problem, then you're
> >> completely fine to do so.
> >> Although I still recommend to go RAID10 other than RAID5/6.
> >
> > I understand the risk, but don't have the funds to buy sufficient
> > disks to operate in RAID10.
>
> Then my advice would be, for any powerloss, please run a full-disk scrub
> (and of course ensure there is not another powerloss during scrubbing).
>
> I know this sounds silly and slow, but at least it should workaround the
> write hole problem.
>
> Thanks,
> Qu
>
> > The data is mostly large files and
> > activity is predominantly reads, so risk is currently acceptable given
> > the backup server. All super critical data is backed up to (very slow)
> > cloud storage.
> >
> >>
> >> Thanks,
> >> Qu
> >>
> >>> I don't know if the 4.19
> >>> boot process may have flipped some bits which would make reverting
> >>> problematic.
> >>>
> >>> Thanks much,
> >>>
> >>> - mike
> >>>
> >>
>
