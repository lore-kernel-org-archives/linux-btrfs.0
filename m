Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34428 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3BZFfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 00:35:09 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so4150329wid.6
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 21:35:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
	<CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
Date: Mon, 25 Feb 2013 21:35:08 -0800
Message-ID: <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com>
Subject: Re: lvm volume like support
From: Suman C <schakrava@gmail.com>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, zvol like feature where a btrfs subvolume like construct can be
made available as a LUN/block device. This device can then be used by
any application that wants a raw block device. iscsi is another
obvious usecase. Having thin provisioning support would make it pretty
awesome.

Suman

On Mon, Feb 25, 2013 at 5:46 PM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Tue, Feb 26, 2013 at 11:59 AM, Mike Fleetwood
> <mike.fleetwood@googlemail.com> wrote:
>> On 25 February 2013 23:35, Suman C <schakrava@gmail.com> wrote:
>>> Hi,
>>>
>>> I think it would be great if there is a lvm volume or zfs zvol type
>>> support in btrfs.
>
>
>> Btrfs already has capabilities to add and remove block devices on the
>> fly.  Data can be stripped or mirrored or both.  Raid 5/6 is in
>> testing at the moment.
>> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
>> https://btrfs.wiki.kernel.org/index.php/UseCases#RAID
>>
>> Which specific features do you think btrfs is lacking?
>
>
> I think he's talking about zvol-like feature.
>
> In zfs, instead of creating a
> filesystem-that-is-accessible-as-a-directory, you can create a zvol
> which behaves just like any other standard block device (e.g. you can
> use it as swap, or create ext4 filesystem on top of it). But it would
> also have most of the benefits that a normal zfs filesystem has, like:
> - thin provisioning (sparse allocation, snapshot & clone)
> - compression
> - integrity check (via checksum)
>
> Typical use cases would be:
> - swap in a pure-zfs system
> - virtualization (xen, kvm, etc)
> - NAS which exports the block device using iscsi/AoE
>
> AFAIK no such feature exist in btrfs yet.
>
> --
> Fajar
