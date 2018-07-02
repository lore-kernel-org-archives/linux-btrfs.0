Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:38892 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752570AbeGBQ7J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 12:59:09 -0400
Received: by mail-it0-f52.google.com with SMTP id v83-v6so12885446itc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2018 09:59:08 -0700 (PDT)
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
To: Marc MERLIN <marc@merlins.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151853.mwlrinipbihq46zu@merlins.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com>
Date: Mon, 2 Jul 2018 12:59:02 -0400
MIME-Version: 1.0
In-Reply-To: <20180702151853.mwlrinipbihq46zu@merlins.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-02 11:18, Marc MERLIN wrote:
> Hi Qu,
> 
> I'll split this part into a new thread:
> 
>> 2) Don't keep unrelated snapshots in one btrfs.
>>     I totally understand that maintain different btrfs would hugely add
>>     maintenance pressure, but as explains, all snapshots share one
>>     fragile extent tree.
> 
> Yes, I understand that this is what I should do given what you
> explained.
> My main problem is knowing how to segment things so I don't end up with
> filesystems that are full while others are almost empty :)
> 
> Am I supposed to put LVM thin volumes underneath so that I can share
> the same single 10TB raid5?
Actually, because of the online resize ability in BTRFS, you don't 
technically _need_ to use thin provisioning here.  It makes the 
maintenance a bit easier, but it also adds a much more complicated layer 
of indirection than just doing regular volumes.
> 
> If I do this, I would have
> software raid 5 < dmcrypt < bcache < lvm < btrfs
> That's a lot of layers, and that's also starting to make me nervous :)
> 
> Is there any other way that does not involve me creating smaller block
> devices for multiple btrfs filesystems and hope that they are the right
> size because I won't be able to change it later?
You could (in theory) merge the LVM and software RAID5 layers, though 
that may make handling of the RAID5 layer a bit complicated if you 
choose to use thin provisioning (for some reason, LVM is unable to do 
on-line checks and rebuilds of RAID arrays that are acting as thin pool 
data or metadata).

Alternatively, you could increase your array size, remove the software 
RAID layer, and switch to using BTRFS in raid10 mode so that you could 
eliminate one of the layers, though that would probably reduce the 
effectiveness of bcache (you might want to get a bigger cache device if 
you do this).
