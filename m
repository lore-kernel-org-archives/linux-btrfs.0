Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753259AbeGCBh7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 21:37:59 -0400
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
To: Marc MERLIN <marc@merlins.org>
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ee8ff481-0aac-54ec-b496-f28feab2227b@gmx.com>
Date: Tue, 3 Jul 2018 09:37:47 +0800
MIME-Version: 1.0
In-Reply-To: <20180702151853.mwlrinipbihq46zu@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月02日 23:18, Marc MERLIN wrote:
> Hi Qu,
> 
> I'll split this part into a new thread:
> 
>> 2) Don't keep unrelated snapshots in one btrfs.
>>    I totally understand that maintain different btrfs would hugely add
>>    maintenance pressure, but as explains, all snapshots share one
>>    fragile extent tree.
> 
> Yes, I understand that this is what I should do given what you
> explained.
> My main problem is knowing how to segment things so I don't end up with
> filesystems that are full while others are almost empty :)
> 
> Am I supposed to put LVM thin volumes underneath so that I can share
> the same single 10TB raid5?
> 
> If I do this, I would have
> software raid 5 < dmcrypt < bcache < lvm < btrfs
> That's a lot of layers, and that's also starting to make me nervous :)

If you could keep the number of snapshots to minimal (less than 10) for
each btrfs (and the number of send source is less than 5), one big btrfs
may work in that case.

BTW, IMHO the bcache is not really helping for backup system, which is
more write oriented.

Thanks,
Qu

> 
> Is there any other way that does not involve me creating smaller block
> devices for multiple btrfs filesystems and hope that they are the right
> size because I won't be able to change it later?
> 
> Thanks,
> Marc
> 
