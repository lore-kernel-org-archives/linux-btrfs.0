Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36281 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752408AbdHPTwR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 15:52:17 -0400
Received: by mail-ua0-f179.google.com with SMTP id k43so17785989uaf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 12:52:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51e051fa-3731-d2fe-7eab-cb324fd38576@gmx.com>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com> <1502496618.6092.6.camel@scientia.net>
 <20170812074248.GA3352@infradead.org> <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net> <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net> <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net> <20170816131230.GA28619@clm-mbp.thefacebook.com>
 <51e051fa-3731-d2fe-7eab-cb324fd38576@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 16 Aug 2017 13:52:15 -0600
Message-ID: <CAJCQCtSgGdsctmiJ4Sq+E5Qr1aoC87EiFUrkH7Eeu8GTZ6XvyQ@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Mason <clm@fb.com>, Christoph Anton Mitterer <calestyo@scientia.net>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 16, 2017 at 8:01 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> BTW, when Fujitsu tested the postgresql workload on btrfs, the result is
> quite interesting.
>
> For HDD, when number of clients is low, btrfs shows obvious performance
> drop.
> And the problem seems to be mandatory metadata COW, which leads to
> superblock FUA updates.
> And when number of clients grow, difference between btrfs and other fses
> gets much smaller, the bottleneck is the HDD itself.
>
> While for SSD, when number of clients is low, btrfs is almost the same
> performance as other fses, nodatacow/nodatasum only provides marginal
> difference.
> But when number of clients grows, btrfs falls far behind other fses.
> The reason seems to be related to how postgresql commit its transaction,
> which always fsync its journal sequentially without concurrency.


I wonder to what degree fsync is used as a hammer for a problem that
needs more granular indicators to solve, like fsadvise() and even
extending it?

But I'm also curious if the above behaviors you report, how it changes
by combining SSD and HDD via either dm-cache or bcache? Do the worst
aspects of SSD and HDD get muted in that case? Or do the worst aspects
become even worse across the board?


-- 
Chris Murphy
