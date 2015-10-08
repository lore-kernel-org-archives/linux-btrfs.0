Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fep25.mx.upcmail.net ([62.179.121.45]:54464 "EHLO
	fep25.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbbJHI2G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 04:28:06 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep25-int.chello.at
          (InterMail vM.8.01.05.18 201-2260-151-151-20140610) with ESMTP
          id <20151008082802.WOOQ13925.viefep25-int.chello.at@edge04.upcmail.net>
          for <linux-btrfs@vger.kernel.org>; Thu, 8 Oct 2015 10:28:02 +0200
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS RAID1 behavior after one drive temporal disconection
Date: Thu, 8 Oct 2015 10:28:02 +0200
References: <201510052226.47051.pisa@cmp.felk.cvut.cz>
In-Reply-To: <201510052226.47051.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201510081028.02178.pisa@cmp.felk.cvut.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

On Monday 05 of October 2015 22:26:46 Pavel Pisa wrote:
> Hello everybody,
...
> BTRFS has recognized appearance of its partition (even that hanged
> from sdb5 to sde5 when disk "hotplugged" again).
> But it seems that RAID1 components are not in sync and BTRFS
> continues to report
>
> BTRFS: lost page write due to I/O error on /dev/sde5
> BTRFS: bdev /dev/sde5 errs: wr 11021805, rd 8526080, flush 29099, corrupt
> 0, gen
>
> I have tried to find the best way to resync RAID1 BTRFS partitions.
> But problem is that filesystem is the root one of the system.
> So reboot to some rescue media is required to run btrfsck --repair
> which is intended for unmounted devices.
>
> What is behavior of BTRFS in this situation?
> Is BTRFS able to use data from not up to date partition in these
> cases where data in respective files have not been modified?
> The main reason for question is if such (stable) data can be backuped
> by out of sync partition in the case of some random block is wear
> out on another device. Or is this situation equivalent to running
> with only one disk?
>
> Are there some parameters/solution to run some command
> (scrub balance) which makes devices to be in the sync again
> without unmount or reboot?
>
> I believe than attaching one more drive and running "btrfs replace"
> would solve described situation. But is there some equivalent to
> run operation "inplace".

It seems that SATA controller is not able to activate link which
has not been connected at BIOS POST time. This means that I cannot add new drive
without reboot.

Before reboot, the server bleeds with messages

BTRFS: bdev /dev/sde5 errs: wr 11715459, rd 8526080, flush 29099, corrupt 0, gen 0
BTRFS: lost page write due to I/O error on /dev/sde5
BTRFS: bdev /dev/sde5 errs: wr 11715460, rd 8526080, flush 29099, corrupt 0, gen 0
BTRFS: lost page write due to I/O error on /dev/sde5

that changed to next mesages after reboot

Btrfs loaded
BTRFS: device label riki-pool devid 1 transid 282383 /dev/sda3
BTRFS: device label riki-pool devid 2 transid 249562 /dev/sdb5
BTRFS info (device sda3): disk space caching is enabled
BTRFS (device sda3): parent transid verify failed on 44623216640 wanted 263476 found 212766
BTRFS (device sda3): parent transid verify failed on 45201899520 wanted 282383 found 246891
BTRFS (device sda3): parent transid verify failed on 45202571264 wanted 282383 found 246890
BTRFS (device sda3): parent transid verify failed on 45201965056 wanted 282383 found 246889
BTRFS (device sda3): parent transid verify failed on 45202505728 wanted 282383 found 246890
BTRFS (device sda3): parent transid verify failed on 45202866176 wanted 282383 found 246890
BTRFS (device sda3): parent transid verify failed on 45207126016 wanted 282383 found 246894
BTRFS (device sda3): parent transid verify failed on 45202522112 wanted 282383 found 246890
BTRFS: bdev /dev/disk/by-uuid/1627e557-d063-40b6-9450-3694dd1fd1ba errs: wr 11723314, rd 8526080, flush 2
BTRFS (device sda3): parent transid verify failed on 45206945792 wanted 282383 found 67960
BTRFS (device sda3): parent transid verify failed on 45204471808 wanted 282382 found 67960

which looks really frightening to me. Temporary disconnected drive has old transid
at start (OK). But what means the rest of the lines. If it means that files with
older transaction ID are used from temporary disconnected drive (now /dev/sdb5)
and newer versions from /dev/sda3 are ignored and reported as invalid then this means
severe data lost and may it be mitchmatch because all transactions after disk disconnect
are lost (i.e. FS root has been taken from misbehaving drive at old version).

BTRFS does not fall even to red-only/degraded mode after system restart.

On the other hand, from logs (all stored on the possibly damaged root FS) it seems
that there there are not missing messages from days when discs has been out of sync,
so it looks like all data are OK. So should I expect that BTRFS managed problems
well and all data are consistent?

I go to use "btrfs replace" because there has not been any reply to my inplace correction
question. But I expect that clarification if possible/how to resync RAID1 after one
drive temporal disappear is really important to many of BTRFS users.

I am now at place where all my connection to Internet goes through endangered
server/router/containers server so I hope to not lost connection.

Thanks for BTRFS work,

                        Pavel




