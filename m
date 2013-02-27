Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43848 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3B0CXZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 21:23:25 -0500
Received: by mail-wi0-f171.google.com with SMTP id hn17so5657361wib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 18:23:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302261130.31494.Martin@lichtvoll.de>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
	<CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
	<201302261130.31494.Martin@lichtvoll.de>
Date: Wed, 27 Feb 2013 13:23:23 +1100
Message-ID: <CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com>
Subject: Re: lvm volume like support
From: "Fajar A. Nugraha" <list@fajar.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Suman C <schakrava@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 9:30 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Dienstag, 26. Februar 2013 schrieb Fajar A. Nugraha:
>> On Tue, Feb 26, 2013 at 11:59 AM, Mike Fleetwood
>>
>> <mike.fleetwood@googlemail.com> wrote:
>> > On 25 February 2013 23:35, Suman C <schakrava@gmail.com> wrote:
>> >> Hi,
>> >>
>> >> I think it would be great if there is a lvm volume or zfs zvol type
>> >> support in btrfs.
>> >
>> > Btrfs already has capabilities to add and remove block devices on the
>> > fly.  Data can be stripped or mirrored or both.  Raid 5/6 is in
>> > testing at the moment.
>> > https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devic
>> > es https://btrfs.wiki.kernel.org/index.php/UseCases#RAID
>> >
>> > Which specific features do you think btrfs is lacking?
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
>
> Sounds like the RADOS block device stuff for Ceph.

Exactly.

While using files + loopback device mostly works, there were problems
regarding performance and data integrity. Not to mention the hassle in
accessing the data if it resides on a partition inside the file (e.g.
you need losetup + kpartx to access it, and you must remember to do
the reverse when you're finished with it).

In zfsonlinux it's very easy to do so since a zvol is treated pretty
much like a disk, and whenever there's a partition inside a zvol, a
coressponding device noed is also created automatically.

--
Fajar
