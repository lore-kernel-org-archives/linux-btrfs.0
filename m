Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:33459 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2HSQCb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 12:02:31 -0400
Message-ID: <50310E11.1010902@pocock.com.au>
Date: Sun, 19 Aug 2012 18:02:25 +0200
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: fail to mount after first reboot
References: <5030F351.6030807@pocock.com.au> <20120819141513.GE30735@carfax.org.uk> <5030F92A.4030309@pocock.com.au> <20120819145124.GF30735@carfax.org.uk>
In-Reply-To: <20120819145124.GF30735@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19/08/12 16:51, Hugo Mills wrote:
> On Sun, Aug 19, 2012 at 02:33:14PM +0000, Daniel Pocock wrote:
>> On 19/08/12 14:15, Hugo Mills wrote:
>>> On Sun, Aug 19, 2012 at 02:08:17PM +0000, Daniel Pocock wrote:
>>>> I created a 1TB RAID1.  So far it is just for testing, no important data
>>>> on there.
>>>>
>>>> After a reboot, I tried to mount it again
>>>>
>>>> # mount /dev/mapper/vg00-btrfsvol0_0 /mnt/btrfs0
>>>> mount: wrong fs type, bad option, bad superblock on
>>>> /dev/mapper/vg00-btrfsvol0_0,
>>>>        missing codepage or helper program, or other error
>>>>        In some cases useful info is found in syslog - try
>>>>        dmesg | tail  or so
>>>
>>>    With multi-volume btrfs filesystems, you have to run "btrfs dev
>>> scan" before trying to mount it. Usually, the distribution will do
>>> this in the initrd (if you've installed its btrfs-progs package).
>>
>> I'm running Debian, I've just updated the system from squeeze to wheezy
>> (with 3.2 kernel) so I could try btrfs and do other QA testing on wheezy
>> (as it is in the beta phase now)
>>
>> I already had the btrfs-tools package installed, before creating the
>> filesystem.  So it appears Debian doesn't have an init script
>>
>> It does have /lib/udev/rules.d/60-btrfs.rules:
>> SUBSYSTEM!="block", GOTO="btrfs_end"
>> ACTION!="add|change", GOTO="btrfs_end"
>> ENV{ID_FS_TYPE}!="btrfs", GOTO="btrfs_end"
>> RUN+="/sbin/modprobe btrfs"
>> RUN+="/sbin/btrfs device scan $env{DEVNAME}"
>>
>> LABEL="btrfs_end"
>>
>> but I'm guessing that isn't any use to my logical volumes that are
>> activated early in the boot sequence?
>>
>> Could I be having this problem because I put my btrfs on logical volumes?
> 
>    Possibly. You may need the "Device mapper uevents" option in the
> kernel (CONFIG_DM_UEVENT) to trigger that udev rule when you enable
> your VG(s). Not sure if it's available/enabled in your kernel.
> 

I've created a Debian bug report for the issue:

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=685311

Thanks for the quick feedback about this
