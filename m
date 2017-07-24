Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35769 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753605AbdGXNqg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 09:46:36 -0400
Received: by mail-it0-f43.google.com with SMTP id h199so34508527ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 06:46:36 -0700 (PDT)
Subject: Re: Best Practice: Add new device to RAID1 pool
To: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <18d96f74-00a8-9bb9-dddc-f50940d0971e@gmail.com>
Date: Mon, 24 Jul 2017 09:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <1500895655.2781.6.camel@cloud.haefemeier.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-24 07:27, Cloud Admin wrote:
> Hi,
> I have a multi-device pool (three discs) as RAID1. Now I want to add a
> new disc to increase the pool. I followed the description on https://bt
> rfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices and
> used 'btrfs add <device> <btrfs path>'. After that I called a balance
> for rebalancing the RAID1 using 'btrfs balance start <btrfs path>'.
> Is that anything or should I need to call a resize (for example) or
> anything else? Or do I need to specify filter/profile parameters for
> balancing?
> I am a little bit confused because the balance command is running since
> 12 hours and only 3GB of data are touched. This would mean the whole
> balance process (new disc has 8TB) would run a long, long time... and
> is using one cpu by 100%.

Based on what you're saying, it sounds like you've either run into a 
bug, or have a huge number of snapshots on this filesystem.  What you 
described is exactly what you should be doing when expanding an array 
(add the device, then run a full balance).  The fact that it's taking 
this long isn't normal, unless you have very slow storage devices.
