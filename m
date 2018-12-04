Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F48C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 05:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D205720834
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 05:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Roswejf2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D205720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbeLDF4x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 00:56:53 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43425 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeLDF4x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 00:56:53 -0500
Received: by mail-lj1-f196.google.com with SMTP id 83-v6so13706095ljf.10
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 21:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fmh6liaFTmMqR37ft2l7HPcsj6JsfFHFOuPfV9P5628=;
        b=Roswejf2AbyC0UWtC/caStLkNSeimqsuCp4QvvLQ0XcLsYVT2to9wfb7aY1Jgwl46k
         +6+O3OxwbDSekyw78LGRtfUQLWdNFaAewcW6HOoBNx57+hPvuwLxDJyXyhsAR/0MxuDu
         uXo+3skknh7HGAWYbJHqu1xY+POnW5cNpKdwS8JkLjfYGHtETapKpnteLFQv2KqogQgy
         hPiPie2e5VOv/O1Jx3kqSrGLxey+Si3YkehlfOZISLdYIAbZfsSTvGDHY9Dn8ctoMH8E
         PcfzqgWN5+c9hZQA1ojov/Yzwqjypboj9/vT/rjZnBQW56BaUHNJVzxgqzZqnnRX1yjg
         pRnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fmh6liaFTmMqR37ft2l7HPcsj6JsfFHFOuPfV9P5628=;
        b=bnxI2E423cymihuKnhzJQS9QEhNSaDQUDD5pJ2NNfdo2t/zAxtUPV3vJ6QpUxfCBTC
         iSrl8A3jsHHa8ql1QDnD+zNdFUCCDcvxfQiIau2fcSubwC5MaSfzorSM3oj99xnp5MLV
         ajFrNPxSP8m1/t8qUfA+fXQSizXB+ZSkrbTq34w0TirpJZx1Gs7wrdhSTPqL26qSVi24
         U5K7fLLawlIVAlUMyJRwxdVQMiAmgpJWMuSE+DN654oE/eDxUMPViqgz7P6Snk8ajq1v
         9F73P2i7AZzQ3BK9Qps6od/cn/MYmrXjtO9oFCgYd5GBjitmw/XH3jNkmKVwvAYhnf14
         MJqw==
X-Gm-Message-State: AA+aEWZPohRA0aiDI1U78qZgz0QXXqPx47U32JK3O1gLBEu58oywzVTu
        /h3DeIvfQKJuzmUQhQDAhpd4LihVU/net+tmJd+7m0cGeDA=
X-Google-Smtp-Source: AFSGD/UmipPEBUpUqbZqdt5URyzN1MwC6P86m9LHvhVV+GYFSd9sLJljgurs2Rs5ix6BfqtW5jS/TFNS7zeQaNmx8jc=
X-Received: by 2002:a2e:5654:: with SMTP id k81-v6mr11591105ljb.48.1543903011029;
 Mon, 03 Dec 2018 21:56:51 -0800 (PST)
MIME-Version: 1.0
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
In-Reply-To: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 3 Dec 2018 22:56:38 -0700
Message-ID: <CAJCQCtRUTavGyh2A4qZe=yT=ydcu1byBy-LKF0jKZwNdZqaEWA@mail.gmail.com>
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
To:     mike.javorski@gmail.com
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 3, 2018 at 8:32 PM Mike Javorski <mike.javorski@gmail.com> wrote:
>
> Need a bit of advice here ladies / gents. I am running into an issue
> which Qu Wenruo seems to have posted a patch for several weeks ago
> (see https://patchwork.kernel.org/patch/10694997/).
>
> Here is the relevant dmesg output which led me to Qu's patch.
> ----
> [   10.032475] BTRFS critical (device sdb): corrupt leaf: root=2
> block=24655027060736 slot=20 bg_start=13188988928 bg_len=10804527104,
> invalid block group size, have 10804527104 expect (0, 10737418240]
> [   10.032493] BTRFS error (device sdb): failed to read block groups: -5
> [   10.053365] BTRFS error (device sdb): open_ctree failed
> ----
>
> This server has a 16 disk btrfs filesystem (RAID6) which I boot
> periodically to btrfs-send snapshots to. This machine is running
> ArchLinux and I had just updated  to their latest 4.19.4 kernel
> package (from 4.18.10 which was working fine). I've tried updating to
> the 4.19.6 kernel that is in testing, but that doesn't seem to resolve
> the issue. From what I can see on kernel.org, the patch above is not
> pushed to stable or to Linus' tree.
>
> At this point the question is what to do. Is my FS toast? Could I
> revert to the 4.18.10 kernel and boot safely? I don't know if the 4.19
> boot process may have flipped some bits which would make reverting
> problematic.

That patch is not yet merged in linux-next so to use it, you'd need to
apply yourself and compile a kernel. I can't tell for sure if it'd
help.

But, the less you change the file system, the better chance of saving
it. I have no idea why there'd be a corrupt leaf just due to a kernel
version change, though.

Needless to say, raid56 just seems fragile once it runs into any kind
of trouble. I personally wouldn't boot off it at all. I would only
mount it from another system, ideally an installed system but a live
system with the kernel versions you need would also work. That way you
can get more information without changes, and booting will almost
immediately mount rw, if mount succeeds at all, and will write a bunch
of changes to the file system.

Whether it's a case of 4.18.10 not detecting corruption that 4.19
sees, or if 4.19 already caused it, the best chance is to not mount it
rw, and not run check --repair, until you get some feedback from a
developer.

The thing I'd like to see is
# btrfs rescue super -v /anydevice/
# btrfs insp dump-s -f /anydevice/

First command will tell us if all the supers are the same and valid
across all devices. And the second one, hopefully it's pointed to a
device with valid super, will tell us if there's a log root value
other than 0. Both of those are read only commands.


-- 
Chris Murphy
