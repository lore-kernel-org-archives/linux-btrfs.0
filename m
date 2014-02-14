Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:56703 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaBNOdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 09:33:11 -0500
Received: by mail-qc0-f170.google.com with SMTP id e9so20266529qcy.15
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 06:33:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140211033059.34bd0ef7@system>
References: <20140209224055.3175e70f@system>
	<pan$c13e9$73e2c595$53adb8c8$58509a35@cox.net>
	<20140211033059.34bd0ef7@system>
Date: Fri, 14 Feb 2014 15:33:10 +0100
Message-ID: <CAJbEPe6-J=0n_qOmZ06NEOha-z7Xe_WwQkDx-3OnNWbzKr+H=g@mail.gmail.com>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 February 2014 03:30, Saint Germain <saintger@gmail.com> wrote:
>> > I am experimenting with BTRFS and RAID1 on my Debian Wheezy (with
>> > backported kernel 3.12-0.bpo.1-amd64) using a a motherboard with
>> > UEFI.
>>
>> > I have installed Debian with the following partition on the first
>> > hard drive (no BTRFS subsystem):
>> > /dev/sda1: for / (BTRFS)
>> > /dev/sda2: for /home (BTRFS)
>> > /dev/sda3: for swap
>> >
>> > Then I added another drive for a RAID1 configuration (with btrfs
>> > balance) and I installed grub on the second hard drive with
>> > "grub-install /dev/sdb".
>>
>> You should be able to mount a two-device btrfs raid1 filesystem with
>> only a single device with the degraded mount option, tho I believe
>> current kernels refuse a read-write mount in that case, so you'll
>> have read-only access until you btrfs device add a second device, so
>> it can do normal raid1 mode once again.
>>
>> Meanwhile, I don't believe it's on the wiki, but it's worth noting my
>> experience with btrfs raid1 mode in my pre-deployment tests.
>> Actually, with the (I believe) mandatory read-only mount if raid1 is
>> degraded below two devices, this problem's going to be harder to run
>> into than it was in my testing several kernels ago, but here's what I
>> found:
>>
>> But as I said, if btrfs only allows read-only mounts of filesystems
>> without enough devices to properly complete the raidlevel, that
>> shouldn't be as big an issue these days, since it should be more
>> difficult or impossible to get the two devices separately mounted
>> writable in the first place, with the consequence that the differing
>> copies issue will be difficult or impossible to trigger in the first
>> place. =:^)
>>

Hello,

With your advices and Chris ones, I have now a (clean ?) partition to
start experimenting with RAID1 (and which boot correctly in UEFI
mode):
sda1 = BIOS Boot partition
sda2 = EFI System Partition
sda3 = BTFS partition
sda4 = swap partition
For the moment I haven't created subvolumes (for "/" and for "/home"
for instance) to keep things simple.

The idea is then to create a RAID1 with a sdb drive (duplicate sda
partitioning, add/balance/convert sdb3 + grub-install on sdb, add sdb
swap UUID in /etc/fstab), shutdown and remove sda to check the
procedure to replace it.

I read the last thread on the subject "lost with degraded RAID1", but
would like to really confirm what would be the current approved
procedure and if it will be valid for future BTRFS version (especially
about the read-only mount).

So what should I do from there ?
Here are a few questions:

1) Boot in degraded mode: currently with my kernel
(3.12-0.bpo.1-amd64, from Debian wheezy-backports) it seems that I can
mount in read-write mode.
However for future kernel, it seems that I will be only able to mount
read-only ? See here:
http://www.spinics.net/lists/linux-btrfs/msg20164.html
https://bugzilla.kernel.org/show_bug.cgi?id=60594

2) If I am able to mount read-write, is this the correct procedure:
  a) place a new drive in another physical location sdc (I don't think
I can use the same sda physical location ?)
  b) boot in degraded mode on sdb
  c) use the 'replace' command to replace sda by sdc
  d) perhaps a 'balance' is necessary ?

3) Can I use also the above procedure if I am only allowed to mount read-only ?

4) If I want to use my system without RAID1 support (dangerous I
know), after booting in degraded mode with read-write, can I convert
back sdb from RAID1 to RAID0 in a safe way ?
(btrfs balance start -dconvert=raid0 -mconvert=raid0 /)

5) Perhaps a recovery procedure which includes booting on a different
rescue disk would be more appropriate ?

Thanks again,
