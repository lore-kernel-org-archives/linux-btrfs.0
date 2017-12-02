Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:44487 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbdLBTmQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Dec 2017 14:42:16 -0500
Received: by mail-lf0-f53.google.com with SMTP id x204so15083388lfa.11
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Dec 2017 11:42:15 -0800 (PST)
Subject: Re: btrfs-transacti hammering the system
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
 <09218217-6c17-80df-380a-6c20366c70f3@gmail.com>
 <dc6eb5d9-f514-3f49-7ab6-64ab1cf30462@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <a51ebd49-99f4-c507-e21b-5b1a4a3dc4f5@gmail.com>
Date: Sat, 2 Dec 2017 22:42:12 +0300
MIME-Version: 1.0
In-Reply-To: <dc6eb5d9-f514-3f49-7ab6-64ab1cf30462@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

01.12.2017 21:04, Austin S. Hemmelgarn пишет:
> On 2017-12-01 12:13, Andrei Borzenkov wrote:
>> 01.12.2017 20:06, Hans van Kranenburg пишет:
>>>
>>> Additional tips (forgot to ask for your /proc/mounts before):
>>> * Use the noatime mount option, so that only accessing files does not
>>> lead to changes in metadata,
>>
>> Is not 'lazytime" default today?

Sorry, it was relatime that is today's default, I mixed them up.

> It gives you correct atime + no extra
>> metadata update cause by update of atime only.
> Unless things have changed since the last time this came up, BTRFS does
> not support the 'lazytime' mount option (but it doesn't complain about
> it either).
> 

Actually since v2.27 "lazytime" is interpreted by mount command itself
and converted into MS_LAZYTIME flag, so should be available for each FS.

bor@10:~> sudo mkfs -t ext4 /dev/sdb1
mke2fs 1.43.7 (16-Oct-2017)
...

bor@10:~> sudo mount -t ext4 -o lazytime /dev/sdb1 /mnt
bor@10:~> tail /proc/self/mountinfo
...
224 66 8:17 / /mnt rw,relatime shared:152 - ext4 /dev/sdb1
rw,lazytime,data=ordered
bor@10:~> sudo umount /dev/sdb1
bor@10:~> sudo mkfs -t btrfs -f /dev/sdb1
btrfs-progs v4.13.3
...

bor@10:~> sudo mount -t btrfs -o lazytime /dev/sdb1 /mnt
bor@10:~> tail /proc/self/mountinfo
...
224 66 0:88 / /mnt rw,relatime shared:152 - btrfs /dev/sdb1
rw,lazytime,space_cache,subvolid=5,subvol=/
bor@10:~>


> Also, lazytime is independent from noatime, and using both can have
> benefits (lazytime will still have to write out the inode for every file
> read on the system every 24 hours, but with noatime it only has to write
> out the inode for files that have changed).
> 

OK, that's true.
