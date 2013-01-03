Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:54352 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3ACWHm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 17:07:42 -0500
Date: 03 Jan 2013 22:52:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8jf1hPCXB@helmut.hullen.de>
In-Reply-To: <20130103212342.GE19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

>> On my system (a bundle of /dev/sdb, /dev/sdc, /dev/sdd)
>>
>>         btrfs fi label /dev/sdb mylabel
>>
>> only sets the label on the (unmounted) device /dev/sdb. "/dev/sdc"
>> and "/dev/sdd" remain without label.

>    This is a bug.

Hmmm - I'll test it on another system.

>> Strange - in another way.
>>
>> Here "blkid" (without any device) hangs. See the attachment ("strace
>> blkid").

> [snip]

>> stat64("/dev/fd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0),
>> ...}) = 0 open("/dev/fd0", O_RDONLY|O_LARGEFILE)  = 4
>> fadvise64_64(4, 0, 0, POSIX_FADV_RANDOM) = 0
>> fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(2, 0), ...}) = 0
>> uname({sys="Linux", node="izar", ...})  = 0
>> ioctl(4, BLKGETSIZE64, 0x8050d5c)       = 0
>> _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output
>> error) _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output
>> error) _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output
>> error) _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output
>> error) _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output
>> error) _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output
>> error) _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4, 0x80517a4, 1024)                = -1 EIO (Input/output
>> error) _llseek(4, 0, [0], SEEK_SET)            = 0
>> read(4,  <unfinished ...>

>    This is waiting for /dev/fd0 to return some data. I guess it'll
> give up after a few times round (8? 10?) and return some results.

I've waited 10 minutes ...

I know a similar behaviour p.e. when I run

        btrfs-show

Then btrfs seems to test all block devices in "/dev" (no "udev" system)  
and then tells most times

   failed to read /dev/<nonexistent device>: No such device or address

But those (unnecessary) messages come quick, with only some seconds  
delay.

-----------------

The above log file comes from a machine without floppy disk (a laptop).  
Running "blkid" on an elder tower (with installed and usable floppy  
disk) also checks for "/dev/fd0" and then tells "ok".

Tomorrow I'll test this behaviour on another laptop. Could be a "blkid"  
error.

Viele Gruesse!
Helmut
