Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39997 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3BZFsK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 00:48:10 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm14so4155746wib.10
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 21:48:09 -0800 (PST)
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com> <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com> <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <D304C30A-71D6-4AF5-8DD4-4F7232B30AB6@yerf-it.nl>
Cc: "Fajar A. Nugraha" <list@fajar.net>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Remco Hosman - Yerf-IT <remco@yerf-it.nl>
Subject: Re: lvm volume like support
Date: Tue, 26 Feb 2013 06:48:07 +0100
To: Suman C <schakrava@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can't thus be done with a regular file and a loop back device?

Remco

On 26 Feb 2013, at 06:35, Suman C <schakrava@gmail.com> wrote:

> Yes, zvol like feature where a btrfs subvolume like construct can be
> made available as a LUN/block device. This device can then be used by
> any application that wants a raw block device. iscsi is another
> obvious usecase. Having thin provisioning support would make it pretty
> awesome.
> 
> Suman
> 
> On Mon, Feb 25, 2013 at 5:46 PM, Fajar A. Nugraha <list@fajar.net> wrote:
>> On Tue, Feb 26, 2013 at 11:59 AM, Mike Fleetwood
>> <mike.fleetwood@googlemail.com> wrote:
>>> On 25 February 2013 23:35, Suman C <schakrava@gmail.com> wrote:
>>>> Hi,
>>>> 
>>>> I think it would be great if there is a lvm volume or zfs zvol type
>>>> support in btrfs.
>> 
>> 
>>> Btrfs already has capabilities to add and remove block devices on the
>>> fly.  Data can be stripped or mirrored or both.  Raid 5/6 is in
>>> testing at the moment.
>>> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
>>> https://btrfs.wiki.kernel.org/index.php/UseCases#RAID
>>> 
>>> Which specific features do you think btrfs is lacking?
>> 
>> 
>> I think he's talking about zvol-like feature.
>> 
>> In zfs, instead of creating a
>> filesystem-that-is-accessible-as-a-directory, you can create a zvol
>> which behaves just like any other standard block device (e.g. you can
>> use it as swap, or create ext4 filesystem on top of it). But it would
>> also have most of the benefits that a normal zfs filesystem has, like:
>> - thin provisioning (sparse allocation, snapshot & clone)
>> - compression
>> - integrity check (via checksum)
>> 
>> Typical use cases would be:
>> - swap in a pure-zfs system
>> - virtualization (xen, kvm, etc)
>> - NAS which exports the block device using iscsi/AoE
>> 
>> AFAIK no such feature exist in btrfs yet.
>> 
>> --
>> Fajar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
