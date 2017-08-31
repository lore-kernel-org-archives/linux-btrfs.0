Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49228 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751724AbdHaON5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 10:13:57 -0400
Subject: Re: mount time for big filesystems
To: Roman Mamedov <rm@romanrm.net>,
        Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Cc: linux-btrfs@vger.kernel.org
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
 <20170831163656.6be88191@natsu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <aecfb058-83bd-9ebd-b043-add6e245051b@gmx.com>
Date: Thu, 31 Aug 2017 22:13:46 +0800
MIME-Version: 1.0
In-Reply-To: <20170831163656.6be88191@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月31日 19:36, Roman Mamedov wrote:
> On Thu, 31 Aug 2017 12:43:19 +0200
> Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com> wrote:
> 
>> Hi,
>> this 37T filesystem took some times to mount. It has 47
>> subvolumes/snapshots and is mounted with
>> noatime,compress=zlib,space_cache. Is it normal, due to its size?

Just like Han said, this is caused by BLOCK_GROUP_ITEM scattered in the 
large extent tree.
So, it's hard to improve soon.

Some ideas like delay BLOCK_GROUP_ITEM loading can greatly enhance the 
mount speed.
But such enhancement may affect extent allocator (that's to say we can't 
do any write before at least some BLOCK_GROUP_ITEM is loaded) and may 
cause more bugs.

Other ideas like per-chunk extent tree may also greatly reduce mount 
time but need on-disk format change.
(Well, in fact btrfs on-disk format is never well designed anyway, so if 
anyone is really doing this, please make a comprehensive wiki/white 
paper for this)

> 
> If you could implement SSD caching in front of your FS (such as lvmcache or
> bcache), that would work wonders for performance in general, and especially
> for mount times. I have seen amazing results with lvmcache (of just 32 GB) for
> a 14 TB FS.

That's impressive.
Since extent tree is a super hot tree (any CoW will modify extent tree), 
it makes sense.

> 
> As for in general, with your FS size perhaps you should be using
> "space_cache=v2" for better performance, but I'm not sure if that will have
> any effect on mount time (aside from slowing down the first mount with that).
> 
Unfortunately, space tree is not loaded until used (at least for v1), so 
space_cache may not help much.

Thanks,
Qu
