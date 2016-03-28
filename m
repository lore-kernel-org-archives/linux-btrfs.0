Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37057 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbcC1Keu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 06:34:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akUVT-0006El-Uo
	for linux-btrfs@vger.kernel.org; Mon, 28 Mar 2016 12:34:48 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 12:34:47 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 12:34:47 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Mon, 28 Mar 2016 12:30:17 +0200
Message-ID: <20160328123017.6044e2ea@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<CAJCQCtSzKT2BZ15JwgR4b6Nk+n2tsHBLizwJXOqJ93Jbuv05rQ@mail.gmail.com>
	<CAJCQCtQYkCDLks0Wvnt2nqTRMAvh6wQ5nsHB4GPD4wFA8geAsw@mail.gmail.com>
	<20160327033032.6dce42e0@jupiter.sol.kaishome.de>
	<CAJCQCtSOURe5Cy-ytB3Tg_s46hgWsGKLn6fXjy8vt+TBQKNucg@mail.gmail.com>
	<20160327193105.0ba5c557@jupiter.sol.kaishome.de>
	<CAJCQCtQZBv=Qrh+oSM4a5CQW3sTBRWVeJmYN_q0Vx0TvGZCtgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 27 Mar 2016 13:04:25 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> As for the csum errors with this one single VDI file, you're going to
> have to come up with a way to reproduce it consistently. You'll need
> to have a good copy on a filesystem that comes up clean with btrfs
> check and scrub. And then reproduce the corruption somehow. One hint
> based on the other two users with similar setups or workload is they
> aren't using the discard mount option and you are. I'd say unless you
> have a newer SSD that supports queued trim, it probably shouldn't be
> used, it's known to cause the kinds of hangs you report with drives
> that only support non-queued trim. Those drives are better off getting
> fstrim e.g. once a week on a timer.

Let's get back to the csum errors later - that's only on the main drive
which has other corruptions, too, as I found out. So the csum errors
may well be a side effect.

I'm currently trying to fix the remaining problems of the backup drive
which uses no discard at all (it's no SSD).

I'd like to help you out of the confusion, here's the output of:

$ lsblk -o NAME,MODEL,FSTYPE,LABEL,MOUNTPOINT
NAME        MODEL            FSTYPE LABEL      MOUNTPOINT
sda         Crucial_CT128MX1
├─sda1                       vfat   ESP        /boot
├─sda2
└─sda3                       bcache
  ├─bcache0                  btrfs  system
  ├─bcache1                  btrfs  system
  └─bcache2                  btrfs  system     /
sdb         SAMSUNG HD103SJ
├─sdb1                       swap   swap0      [SWAP]
└─sdb2                       bcache
  └─bcache2                  btrfs  system     /
sdc         SAMSUNG HD103SJ
├─sdc1                       swap   swap1      [SWAP]
└─sdc2                       bcache
  └─bcache0                  btrfs  system
sdd         SAMSUNG HD103UJ
├─sdd1                       swap   swap2      [SWAP]
└─sdd2                       bcache
  └─bcache1                  btrfs  system
sde         003-9VT166
└─sde1                       btrfs  usb-backup

(the mountpoint is pretty bogus due to multiple subvolumes, so I
corrected it)

BTW: This discard option ran smooth for the last 12 months or so
(apparently, the SSD drive is soon to die - smartctl lifetime counter
is almost used up, bcache + btrfs can be pretty stressful I think). I'm
not even sure if btrfs mount option "discard" has any effect at all if
it is mounted through bcache.

BTW2: Even fstrim will issue queued trim if it is supported by the
drive and will get you in the same trouble. It needs to be disabled in
the kernel, according to [1]. Side note: I have model MX100 with
firmware update applied which is supposed to fix the problem. I never
experienced the libata fault messages in dmesg.

[1]:
http://forums.crucial.com/t5/Crucial-SSDs/M500-M5x0-QUEUED-TRIM-data-corruption-alert-mostly-for-Linux/td-p/151028

-- 
Regards,
Kai

Replies to list-only preferred.


