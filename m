From: Mark Lord <lkml@rtr.ca>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Mon, 17 Aug 2009 22:01:26 -0400
Message-ID: <4A8A0B76.1030800@rtr.ca>
References: <4A89C1DA.6040601@rtr.ca> <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932740AbZHRCB2@vger.kernel.org>
In-Reply-To: <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Kay Sievers wrote:
> On Mon, Aug 17, 2009 at 22:47, Mark Lord<lkml@rtr.ca> wrote:
>> Chris / list,
>>
>> stat(2) seems to return invalid major/minor device info
>> for btrfs filesystems.
>>
>> Why?  Is this a bug?
> 
> This is not invalid and not a bug. It's a superblock without a device,
> and expected behavior.
> 
> There is no one-to-one relation from a btrfs mountpoint to a device,
> it's a tree, and therefore therefore there can not be a single
> major/minor.
..

Sure there is for the most common case.
When there is only a single device, stat() should return that device.
When there are several, it should do something different.

But really, it should be using DM/LVM when there are multiple devices.
