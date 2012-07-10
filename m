Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:54766 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab2GJJDX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 05:03:23 -0400
Message-ID: <4FFBEFD9.2030408@arndnet.de>
Date: Tue, 10 Jul 2012 11:03:21 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 3.5.0-rc6: btrfs and LVM snapshots -> wrong devicename in /proc/mounts
References: <4FFB59BF.1050104@arndnet.de> <CAE5mzvizLBtMbVmGfQc1HYve8BoFk+G93j2B=1759JWLH_4w+w@mail.gmail.com>
In-Reply-To: <CAE5mzvizLBtMbVmGfQc1HYve8BoFk+G93j2B=1759JWLH_4w+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 10.07.2012 00:49, schrieb cwillu:
> On Mon, Jul 9, 2012 at 4:22 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
>> Hi,
>>
>> using btrfs with LVM snapshots seems to be confusing /proc/mounts
>> After mounting a snapshot of an original filesystem, the devicename of the
>> original filesystem is overwritten with that of the snapshot in /proc/mounts.
> 
> If the lvm snapshot is visible to btrfs (i.e., btrfs dev scan), it
> will appear as another device which belongs to the original filesystem
> with a duplicate devid.  This might result in bad things happening, or
> possibly just hilarity.

You are right the same bug seems to get triggered on "btrfs dev scan":

arnd@kallisto:/mnt$ sudo grep /mnt /proc/mounts
/dev/mapper/vg0-original /mnt/original btrfs rw,relatime,ssd,space_cache 0 0
arnd@kallisto:/mnt$ sudo btrfs dev scan
Scanning for Btrfs filesystems
failed to read /dev/sr0
ERROR: unable to scan the device '/dev/dm-4' - Device or resource busy
ERROR: unable to scan the device '/dev/dm-17' - Device or resource busy

arnd@kallisto:/mnt$ sudo grep /mnt /proc/mounts
/dev/dm-16 /mnt/original btrfs rw,relatime,ssd,space_cache 0 0

arnd@kallisto:/mnt$ sudo dmsetup info /dev/dm-16
Name:              vg0-testsnap
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      0
Major, minor:      253, 16
Number of targets: 1
UUID: LVM-pUa0TTDg9Y1dII6a6WwcUanE0ai4AVXqpS7sNnWEGZOnww76lrMaZzIEB38rug9


> You have a backup that isn't just an lvm snapshot, right?

Now I will.

Best regards
Arnd




