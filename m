Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34997 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcGXBq1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 21:46:27 -0400
Received: by mail-oi0-f53.google.com with SMTP id l72so211046236oig.2
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 18:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6f4623c4-3e4c-7add-aa89-3857b0d48c61@friedels.name>
References: <6f4623c4-3e4c-7add-aa89-3857b0d48c61@friedels.name>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 23 Jul 2016 19:46:25 -0600
Message-ID: <CAJCQCtQ+hVY27j5jOuAfTn4wPE_FV3AheR0+DLL1ui4m6OYCwQ@mail.gmail.com>
Subject: Re: Chances to recover with bad partition table?
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 23, 2016 at 2:37 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> this morning I had to face an unusual prompt on my machine.
>
> I found that the partition table of /dev/sda had vanished.
>
> I restored it with testdisk. It found one partition, but I am quite sure
> there was a /boot partition in front of that which was not found.
>
> Now, running btrfsck fails:
>
> root@homeserver:~# fdisk -l /dev/sda
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk
> doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sda: 120.0 GB, 120034123776 bytes
> 255 heads, 63 sectors/track, 14593 cylinders, total 234441648 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *     1026048   234440703   116707328   83  Linux
> root@homeserver:~# btrfsck /dev/sda1
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> checksum verify failed on 20987904 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=20987904, have=0
> Couldn't read chunk root
> Couldn't open file system
>
> Is there a way to let btrfs search for the start of the partiton?
>
> I do have a backup; thus it is not fatal. But some data on the disk is more
> recent than my back up (of course)


Something like this:
[root@f24s ~]# dd if=/dev/sda | hexdump -C | egrep '5f 42 48 52 66 53 5f'
00110040  5f 42 48 52 66 53 5f 4d  8d 4f 04 00 00 00 00 00  |_BHRfS_M.O......|
04100040  5f 42 48 52 66 53 5f 4d  8d 4f 04 00 00 00 00 00  |_BHRfS_M.O......|

Since the magic appears 0x40 after the start of the super, and there's
a 64KiB, or 0x10000, pad for a bootloader between the start of the
partition and the start of the superblock, subtract 0x10040 to find
the start of the partition in bytes.

0x110040 - 0x10040 = 0x100000 = 1048576

Divide by 512 to find the LBA to start the partition at

1048576 / 512 = 2048

And in fact that's what my partition is set to start at...
[root@f24s ~]# gdisk -l /dev/sda
GPT fdisk (gdisk) version 1.0.1

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 1953525168 sectors, 931.5 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 3D9880B5-D4DF-41F8-9EFF-40155A1D3DD5
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 1953525134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048       377489407   180.0 GiB   8300  fedora-root


Note that Btrfs silently tolerates the end of the partition being
either shorter or longer than the file system claims it is, so to find
the proper ending you'll have to first guess, so that you can point
btrfs-show-super at the newly established partition, and then look for
dev_item.total_bytes.

In my case:
dev_item.total_bytes    193273528320

193273528320 / 512 = 377487360

377487360 + 2048 - 1 = 377489407


-- 
Chris Murphy
