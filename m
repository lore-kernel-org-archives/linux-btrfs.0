Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:37407 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbdHHNT1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Aug 2017 09:19:27 -0400
Received: by mail-lf0-f66.google.com with SMTP id x16so2387550lfb.4
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Aug 2017 06:19:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <751f296a-d26c-83a9-d105-e85f73fdcd06@manjaro.org>
References: <b5d1a891-efc0-e49e-ff91-4409c26491d2@manjaro.org> <751f296a-d26c-83a9-d105-e85f73fdcd06@manjaro.org>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Tue, 8 Aug 2017 15:19:10 +0200
Message-ID: <CANznX5FDMU5z4bJEpBeF+WmknhHWpQNbSaa8okbJAZhKz71y5Q@mail.gmail.com>
Subject: Re: how to benchmark schedulers
To: Bernhard Landauer <oberon@manjaro.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think you should consider using Linux 4.12 which has bfq (bfq-mq)
for blk-mq. So, you don't need out-of-tree BFQ patches if you switch
to blk-mq (but now you are free to do so even if you have HDDs or SSDs
which benefit from software schedulers since you have some multi-queue
schedulers for them). Just make sure to enable blk-mq (has to be a
boot parameter or build-time choice) in order to gain access to
bfq-mq. And remember that bfq-mq has to be activated manually (the
build-time choice for a default scheduler is not valid for multi-queue
schedulers, you will default to "none" which is effectively the new
"no-op").
Note: there is only one BFQ in 4.12 and it's bfq-mq which runs under
the name of simply BFQ (not bfq-mq, I only used that name to make it
clear that BFQ in 4.12 is a multi-queue version of BFQ).

I always wondered if Btrfs makes any use of FUA if it's enabled for
compatible SATA devices (it's disabled by default because there are
some drives with faulty firmware).

I also wonder if RAID10 is any better (or actually worse?) for
metadata (and system) chunks than RAID1.

On Tue, Aug 8, 2017 at 1:59 PM, Bernhard Landauer <oberon@manjaro.org> wrote:
> Hello everyone
>
> I am looking for a way to test different available schedulers with Manjaro's
> bfq-patched kernels on sytems with both SSD and spinning drives. Since
> phoronix-test-suite apparently is currently useless for this task due to its
> bad config for bfq I am looking for alternatives. Do you have any
> suggestions for me?
> Thank you.
>
> kind regards
> Bernhard Landauer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
