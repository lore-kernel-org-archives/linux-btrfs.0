Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9675C46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 18:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D969207DD
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 18:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="UTeSWE3g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D969207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbeJZDXI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 23:23:08 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:33134 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbeJZDXI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 23:23:08 -0400
Received: by mail-lf1-f41.google.com with SMTP id w16-v6so5502686lfc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 11:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=JtBdBeh+TMbWaFkDVY1EN1diYPaz+xyZG38AdiIL3BM=;
        b=UTeSWE3gnsIj3XPq/TKOR0qG+bK0cIFkLh2rWDnFw0CI2gqzsEf1GJ0FR7oV1ah59F
         Zu/iR59olhTVnv0ecwfaEIv6YtVyPInX6sfWgB97ZpQM4fSoW4FthM7BGyfPiJfcx0HQ
         S+5j6OqEIeK8SJgO2TNurcUE/U/gGnMQLZPA1RHk2TSLgvKPrf7fxM3ES5IIycN4qYeY
         2oWUveHDLrrszWLOlXl6DDAKtMCrxTzoFZvYdsFNtsUYB8eScmHbcp9az/F8Fw9NwORV
         h4oeBvH6x4YfG0grg/qk92UP9K7qRnI4zHaauSGyIeuUNAhLuQmh7WPBQiL2TuGdAvBX
         wRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=JtBdBeh+TMbWaFkDVY1EN1diYPaz+xyZG38AdiIL3BM=;
        b=Awc+ZlJJHKPzxr5dtRLPRKwhVed1uI8vbyPg/a1uNnOTT36LVcIKC0Rz7O5CTcj3i0
         kcmKdhVQc2HW7csVjqFtQWAn9cfMzNnZSinrduyz90i9KfF+SF+ctRDC/r+MLxOEyY68
         PystuoJ856qRCwlaKdrQLFMf0l58bZ1/I2mCU0AtYh0AN2dk4kSXlRdDTa9n0E8A3Zyi
         fzWrHIdLWbjYgLWNnKj/NnyClqfuvM+cPWzTabHPBqhITbPnTinbOtXHJWD8PG5jF3ZU
         MO1agkNYIMTq7dSCwrQ/oiLRGKielg+j/XTHkjNjx+Jifnvie+RKxT9vSWIKcDO+oM9N
         JmEg==
X-Gm-Message-State: AGRZ1gLYVYxUBbLAwGe3Zw/YybpTYof11ZfqUdaIwnSjqgKMsfaOR56f
        BNqpS2DjJS5HI6MRHQecPA1acnFh92X2+VdtTre6cYc84SE=
X-Google-Smtp-Source: AJdET5eNnpCuMBezc42OpiaUoxlM+PjBmPV2pKnAI8zvUwOvN7wuT2vG17yVsJ5b1FOnu74SUXuBbdusdPqOV/GupTY=
X-Received: by 2002:a19:f89:: with SMTP id 9mr261148lfp.10.1540493349837; Thu,
 25 Oct 2018 11:49:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:6f0e:0:0:0:0:0 with HTTP; Thu, 25 Oct 2018 11:49:09
 -0700 (PDT)
X-Originating-IP: [174.29.142.179]
In-Reply-To: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
References: <63eaecce7b60646b7322146ea3f707ba@mail.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 25 Oct 2018 12:49:09 -0600
X-Google-Sender-Auth: raOmAI5toru5U2NcWLPw2EFLWnA
Message-ID: <CAJCQCtQrPKMUaGgg-t+0q8fACy0cys_CBi_5CSp2mr+xa5TeNQ@mail.gmail.com>
Subject: Re: Kernel crash related to LZO compression
To:     Dmitry Katsubo <dma_k@mail.ru>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 25, 2018 at 9:56 AM, Dmitry Katsubo <dma_k@mail.ru> wrote:
> Dear btrfs community,
>
> My excuses for the dumps for rather old kernel (4.9.25), nevertheless I
> wonder
> about your opinion about the below reported kernel crashes.
>
> As I could understand the situation (correct me if I am wrong), it happened
> that some data block became corrupted which resulted the following kernel
> trace
> during the boot:
>
> kernel BUG at /build/linux-fB36Cv/linux-4.9.25/fs/btrfs/extent_io.c:2318!
> invalid opcode: 0000 [#1] SMP
> Call Trace:
>  [<f8c63739>] ? end_bio_extent_readpage+0x4e9/0x680 [btrfs]
>  [<f8c951eb>] ? end_compressed_bio_read+0x3b/0x2d0 [btrfs]
>  [<f8c771de>] ? btrfs_scrubparity_helper+0xce/0x2d0 [btrfs]
>  [<de07ebb1>] ? process_one_work+0x141/0x380
>  [<de07ee31>] ? worker_thread+0x41/0x460
>  [<de0840e4>] ? kthread+0xb4/0xd0
>  [<de07edf0>] ? process_one_work+0x380/0x380
>  [<de084030>] ? kthread_park+0x50/0x50
>  [<de5aae03>] ? ret_from_fork+0x1b/0x28
>
> The problematic file turned out to be the one used by systemd-journald
> /var/log/journal/c496cea41ebc4700a0dfaabf64a21be4/system.journal
> which was trying to read it (or append to it) during the boot and that was
> causing the system crash (see attached bootN_dmesg.txt).
>
> I've rebooted in safe mode and tried to copy the data from this partition to
> another location using btrfs-restore, however kernel was crashing as well
> with
> a bit different symphom (see attached copyN_dmesg.txt):
>
> Call Trace:
>  [<f8b4c760>] ? lzo_decompress_biovec+0x1b0/0x2b0 [btrfs]
>  [<d71a8828>] ? vmalloc+0x38/0x40
>  [<f8b4d415>] ? end_compressed_bio_read+0x265/0x2d0 [btrfs]
>  [<f8b2f1de>] ? btrfs_scrubparity_helper+0xce/0x2d0 [btrfs]
>  [<d707ebb1>] ? process_one_work+0x141/0x380
>  [<d707ee31>] ? worker_thread+0x41/0x460
>  [<d70840e4>] ? kthread+0xb4/0xd0
>  [<d75aae03>] ? ret_from_fork+0x1b/0x28
>
> Just to keep away from the problem, I've removed this file and also removed
> "compress=lzo" mount option.
>
> Are there any updates / fixes done in that area? Is lzo option safe to use?


It should be safe even with that kernel. I'm not sure this is
compression related. There is a corruption bug related to inline
extents and corruption that had been fairly elusive but I think it's
fixed now. I haven't run into it though.

I would say the first step no matter what if you're using an older
kernel, is to boot a current Fedora or Arch live or install media,
mount the Btrfs and try to read the problem files and see if the
problem still happens. I can't even being to estimate the tens of
thousands of line changes since kernel 4.9.

What profile are you using for this Btrfs? Is this a raid56? What do
you get for 'btrfs fi us <mountpoint>' ?



-- 
Chris Murphy
