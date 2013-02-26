Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51792 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3BZBqX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 20:46:23 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so3058407wey.5
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 17:46:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
Date: Tue, 26 Feb 2013 12:46:21 +1100
Message-ID: <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
Subject: Re: lvm volume like support
From: "Fajar A. Nugraha" <list@fajar.net>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: Suman C <schakrava@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 11:59 AM, Mike Fleetwood
<mike.fleetwood@googlemail.com> wrote:
> On 25 February 2013 23:35, Suman C <schakrava@gmail.com> wrote:
>> Hi,
>>
>> I think it would be great if there is a lvm volume or zfs zvol type
>> support in btrfs.


> Btrfs already has capabilities to add and remove block devices on the
> fly.  Data can be stripped or mirrored or both.  Raid 5/6 is in
> testing at the moment.
> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
> https://btrfs.wiki.kernel.org/index.php/UseCases#RAID
>
> Which specific features do you think btrfs is lacking?


I think he's talking about zvol-like feature.

In zfs, instead of creating a
filesystem-that-is-accessible-as-a-directory, you can create a zvol
which behaves just like any other standard block device (e.g. you can
use it as swap, or create ext4 filesystem on top of it). But it would
also have most of the benefits that a normal zfs filesystem has, like:
- thin provisioning (sparse allocation, snapshot & clone)
- compression
- integrity check (via checksum)

Typical use cases would be:
- swap in a pure-zfs system
- virtualization (xen, kvm, etc)
- NAS which exports the block device using iscsi/AoE

AFAIK no such feature exist in btrfs yet.

-- 
Fajar
