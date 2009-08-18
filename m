From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Tue, 18 Aug 2009 23:21:49 +0200
Message-ID: <20090818212149.GS12579@kernel.dk>
References: <4A89C1DA.6040601@rtr.ca> <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com> <4A8A0B76.1030800@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A8A0B76.1030800@rtr.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 17 2009, Mark Lord wrote:
> Kay Sievers wrote:
>> On Mon, Aug 17, 2009 at 22:47, Mark Lord<lkml@rtr.ca> wrote:
>>> Chris / list,
>>>
>>> stat(2) seems to return invalid major/minor device info
>>> for btrfs filesystems.
>>>
>>> Why?  Is this a bug?
>>
>> This is not invalid and not a bug. It's a superblock without a device,
>> and expected behavior.
>>
>> There is no one-to-one relation from a btrfs mountpoint to a device,
>> it's a tree, and therefore therefore there can not be a single
>> major/minor.
> ..
>
> Sure there is for the most common case.
> When there is only a single device, stat() should return that device.
> When there are several, it should do something different.

I actually think it's quite sane, since then you get the same behaviour
on multi vs single disk file systems. The last thing you want is to have
different behaviour when you later add a disk, for instance.

-- 
Jens Axboe

