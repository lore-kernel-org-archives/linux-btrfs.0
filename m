Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:32773 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdHQBs7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 21:48:59 -0400
Received: by mail-vk0-f44.google.com with SMTP id j189so18017510vka.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 18:48:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2c543$d5ad45a3$4b673920$5f7cee9a@cox.net>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
 <20170727151038.GT7140@carfax.org.uk> <pan$2c543$d5ad45a3$4b673920$5f7cee9a@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 16 Aug 2017 19:48:58 -0600
Message-ID: <CAJCQCtR-WhXKKM27J2WKVwdMT589eBo+R9Ay0h9WG1EKZ6=oGg@mail.gmail.com>
Subject: Re: Raid0 rescue
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm testing explicitly for this case:


# lvs
  LV         VG Attr       LSize   Pool       Origin Data%  Meta%
Move Log Cpy%Sync Convert
  1          vg Vwi-a-tz--  10.00g thintastic        0.00
  2          vg Vwi-a-tz--  10.00g thintastic        0.00
  thintastic vg twi-aotz-- 100.00g                   0.00   0.38
# mkfs.btrfs -f -mraid1 -draid0 /dev/mapper/vg-1 /dev/mapper/vg-2

...
mount and copy some variable data to the volume, most files are less
than 64KiB, and even some are less than 2KiB. So there will be a mix
of files that will definitely get nerfed by damaged strips, and many
that will live from the drive not accidentally formatted, as well as
inline. But for sure the file system *ought* to survive.

umount and then format NTFS

# mkfs.ntfs -f /dev/mapper/vg-2

Now get this bit of curiousness:

# wipefs /dev/mapper/vg-2
offset               type
----------------------------------------------------------------
0x1fe                dos   [partition table]

0x10040              btrfs   [filesystem]
                     UUID:  bebaedc5-96a1-4163-9527-8254ecae817e

0x3                  ntfs   [filesystem]
                     UUID:  67AD98CF36096C70


So the two supers can co-exist. That invariably is going to cause
kernel code confusion. blkid will neither consider it NTFS nor Btrfs.
So it's sortof in a zombie situation. Get this:

# btrfs rescue super -v /dev/mapper/vg-1
All Devices:
    Device: id = 1, name = /dev/mapper/vg-1

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 65536

        device name = /dev/mapper/vg-1
        superblock bytenr = 67108864

    [All bad supers]:

All supers are valid, no need to recover

# btrfs rescue super -v /dev/mapper/vg-2
All Devices:
    Device: id = 1, name = /dev/mapper/vg-1
    Device: id = 2, name = /dev/mapper/vg-2

Before Recovering:
    [All good supers]:
        device name = /dev/mapper/vg-1
        superblock bytenr = 65536

        device name = /dev/mapper/vg-1
        superblock bytenr = 67108864

        device name = /dev/mapper/vg-2
        superblock bytenr = 65536

        device name = /dev/mapper/vg-2
        superblock bytenr = 67108864

    [All bad supers]:

All supers are valid, no need to recover
#


So the first command sees the supers only on vg-1, it doesn't go
looking at vg-2 at all presumably because kernel code is ignoring that
device due to two different file system supers (?). But the second
command forces it to look at vg-2, and it says the Btrfs supers are
fine, and then also auto discovers the vg-1 device too.

OK so I'm just going to cheat at this point and wipefs just the NTFS
magic so this device is now seen as Btrfs.

# wipefs -n -o 0x3 /dev/mapper/vg-2
/dev/mapper/vg-2: 8 bytes were erased at offset 0x00000003 (ntfs): 4e
54 46 53 20 20 20 20
# wipefs -o 0x3 /dev/mapper/vg-2
/dev/mapper/vg-2: 8 bytes were erased at offset 0x00000003 (ntfs): 4e
54 46 53 20 20 20 20
# partprobe
# blkid
...
/dev/mapper/vg-1: UUID="bebaedc5-96a1-4163-9527-8254ecae817e"
UUID_SUB="ef9dbcf0-bb0b-4faf-a7b4-02f1c92631e4" TYPE="btrfs"
/dev/mapper/vg-2: UUID="bebaedc5-96a1-4163-9527-8254ecae817e"
UUID_SUB="490504ea-4ee4-47ad-91a7-58b6ccf4be8e" TYPE="btrfs"
PTTYPE="dos"
...

OK good. Except, what is PTTYPE? Ohh, that's the first entry in the
wipefs command way at the top I bet.


[root@f26wnuc ~]# wipefs -o 0x1fe /dev/mapper/vg-2
/dev/mapper/vg-2: 2 bytes were erased at offset 0x000001fe (dos): 55 aa
# blkid
...
/dev/mapper/vg-1: UUID="bebaedc5-96a1-4163-9527-8254ecae817e"
UUID_SUB="ef9dbcf0-bb0b-4faf-a7b4-02f1c92631e4" TYPE="btrfs"
/dev/mapper/vg-2: UUID="bebaedc5-96a1-4163-9527-8254ecae817e"
UUID_SUB="490504ea-4ee4-47ad-91a7-58b6ccf4be8e" TYPE="btrfs"
...

Yep!

OK let's just try a normal mount.

It mounts! No errors at all. list all the files on the file system
(about 700). No errors.

Let's cat a few to /dev/null manually.... no errors. OK I'm bored.
Let's just scrub it.


[root@f26wnuc yo]# btrfs scrub status /mnt/yo/
scrub status for bebaedc5-96a1-4163-9527-8254ecae817e
    scrub started at Wed Aug 16 19:40:26 2017, running for 00:00:10
    total bytes scrubbed: 529.62MiB with 181 errors
    error details: csum=181
    corrected errors: 0, uncorrectable errors: 181, unverified errors: 0

One file is affected, the large ~1+GiB file.

[77898.116429] BTRFS warning (device dm-6): checksum error at logical
1621229568 on dev /dev/mapper/vg-2, sector 2621568, root 5, inode 257,
offset 517341184, length 4096, links 1 (path:
Fedora-Workstation-Live-x86_64-Rawhide-20170814.n.0.iso)
[77898.116463] BTRFS error (device dm-6): bdev /dev/mapper/vg-2 errs:
wr 0, rd 0, flush 0, corrupt 1, gen 0
[77898.116478] BTRFS error (device dm-6): unable to fixup (regular)
error at logical 1621229568 on dev /dev/mapper/vg-2

There's about 9 more of those kinds of messages. Anyway that looks to
me like that file itself is nerfed by the NTFS format, but the file
system itself wasn't hit. There's no fixups which would happen if
metadata on vg-2 were overwritten.


I'm gonna take a guess. I *think* originally because the NTFS
signature was there, therefore a normal mount won't work which might
compel the user to try an -o degraded mount which doesn't really help
because that means for sure 1/2 the data strips are lost. I think the
trick here is to make sure both the dos/mbr signature and ntfs
signatures are wiped first. Confirme the supers on both devices are
still OK and if not fix them with 'btrfs rescue super' and then just
mount normally, and start copying files off.


-------
Chris Murphy
