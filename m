Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36843 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbdFUXT4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 19:19:56 -0400
Received: by mail-wr0-f179.google.com with SMTP id c11so199215wrc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 16:19:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <34ac2dd7-88ba-6de7-d8e2-061c283bb9c1@inwind.it>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com> <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
 <34ac2dd7-88ba-6de7-d8e2-061c283bb9c1@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Jun 2017 17:19:54 -0600
Message-ID: <CAJCQCtSNg_RsxzdgBU5Bb1R9NoZHxYTB=K4NnL1qs6OdnaV=WQ@mail.gmail.com>
Subject: Re: Exactly what is wrong with RAID5/6
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 21, 2017 at 2:12 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:


>
> Generally speaking, when you write "two failure" this means two failure at the same time. But the write hole happens even if these two failures are not at the same time:
>
> Event #1: power failure between the data stripe write and the parity stripe write. The stripe is incoherent.
> Event #2: a disk is failing: if you try to read the data from the remaining data and the parity you have wrong data.
>
> The likelihood of these two event at the same time (power failure and  in the next boot a disk is failing) is quite low. But in the life of a filesystem, these two event likely happens.
>
> However BTRFS has an advantage: a simple scrub may (crossing finger) recover from event #1.

Event #3: the stripe is read, missing a data strip due to event #2,
and is wrongly reconstructed due to event #1, Btrfs computes crc32c on
the reconstructed data and compares to extent csum, which then fails
and EIO happens.

Btrfs is susceptible to the write hole happening on disk. But it's
still detected and corrupt data isn't propagated upward.




-- 
Chris Murphy
