Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34509 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbcCKPLo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 10:11:44 -0500
Received: by mail-lb0-f178.google.com with SMTP id xr8so154548079lbb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 07:11:43 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Mar 2016 16:11:41 +0100
Message-ID: <CAPmG0jYkQLwVXSP_mTy0pmD1LiTsNLKKRVHqsJ5cZuGp9rusCA@mail.gmail.com>
Subject: RAID10 filesystem and device usage
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

since I use RAID10 (half a year now), I see that Unallocated: numbers
in   btrfs fi/de us  are not what I expect and probably more is not
fully correct.
I once made a simple change to the code (see patch below) but the I
got unsure how people would like to interpret the output of the tools
commands. At least the Unallocated: numbers seemed correct with the
patch.

It is clear that for a filesystem with multiple raid profiles, like
raid5+single+raid1 for example, the size calculations need quite some
changes, but most people just use one profile per datatype I think. So
just some focus on raid10 here.


Questions:
1) via btrfs command 'filesystem usage', you probably want see how
files (or extents) occupy a filesystem, e.g. "How much space do I have
left for storing more files?". Is this correct?
2) via btrfs command 'device usage', you probably want see how chunks
occupy a device, e.g. "When do I need to buy and add a new disk?". Is
this correct?

I created some test raid10 fs, so that one can easily create extreme
situations like emtpy and full fs and then compare output of:

'fi sh'
'fi df'
'fi us'
'de us'

for default btrfs-progs (opensuse tumbleweed) and patched version from git.
The output for 'fi sh' and 'fi df' is the same for both default and
patched btrfs-progs, but might also raise some questions.


# uname -r
4.4.3-1-default

# btrfs --version
btrfs-progs v4.4.1+20160229


Patch against btrfs-progs git tag v4.4.1

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 33bf403..ddc2f2c 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -608,7 +608,7 @@ static u64 calc_chunk_size(struct chunk_info *ci)
        else if (ci->type & BTRFS_BLOCK_GROUP_RAID6)
                return ci->size / (ci->num_stripes -2);
        else if (ci->type & BTRFS_BLOCK_GROUP_RAID10)
-               return ci->size / ci->num_stripes;
+               return ci->size / (ci->num_stripes /2);
        return ci->size;
 }

=> patched binary
/net/src/btrfs-progs/btrfs


# for i in 0 1 2 3 ; do dd if=/dev/zero of=disk$i.img bs=1G count=10 ; done
# losetup -D
# for i in 0 1 2 3 ; do losetup -f disk$i.img ; done
# mkfs.btrfs -L raid10sizes -m raid10 -d raid10 /dev/loop0 /dev/loop1
/dev/loop2 /dev/loop3
# mount -o noatime LABEL=raid10sizes /local/raid10sizes

=> so filesystem is empty

# btrfs fi sh /local/raid10sizes
Label: 'raid10sizes'  uuid: 87e036be-b440-48ec-8c2a-b7c1eeca5036
        Total devices 4 FS bytes used 1.12MiB
        devid    1 size 10.00GiB used 2.01GiB path /dev/loop0
        devid    2 size 10.00GiB used 2.01GiB path /dev/loop1
        devid    3 size 10.00GiB used 2.01GiB path /dev/loop2
        devid    4 size 10.00GiB used 2.01GiB path /dev/loop3

# btrfs fi df /local/raid10sizes
Data, RAID10: total=2.00GiB, used=1.00MiB
System, RAID10: total=16.00MiB, used=16.00KiB
Metadata, RAID10: total=2.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

# btrfs fi us /local/raid10sizes
Overall:
    Device size:                  40.00GiB
    Device allocated:              8.03GiB
    Device unallocated:           31.97GiB
    Device missing:                  0.00B
    Used:                          2.25MiB
    Free (estimated):             17.98GiB      (min: 17.98GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,RAID10: Size:2.00GiB, Used:1.00MiB
   /dev/loop0    512.00MiB
   /dev/loop1    512.00MiB
   /dev/loop2    512.00MiB
   /dev/loop3    512.00MiB

Metadata,RAID10: Size:2.00GiB, Used:112.00KiB
   /dev/loop0    512.00MiB
   /dev/loop1    512.00MiB
   /dev/loop2    512.00MiB
   /dev/loop3    512.00MiB

System,RAID10: Size:16.00MiB, Used:16.00KiB
   /dev/loop0      4.00MiB
   /dev/loop1      4.00MiB
   /dev/loop2      4.00MiB
   /dev/loop3      4.00MiB

Unallocated:
   /dev/loop0      9.00GiB
   /dev/loop1      9.00GiB
   /dev/loop2      9.00GiB
   /dev/loop3      9.00GiB

# btrfs de us /local/raid10sizes
/dev/loop0, ID: 1
   Device size:            10.00GiB
   Data,RAID10:           512.00MiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             9.00GiB

/dev/loop1, ID: 2
   Device size:            10.00GiB
   Data,RAID10:           512.00MiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             9.00GiB

/dev/loop2, ID: 3
   Device size:            10.00GiB
   Data,RAID10:           512.00MiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             9.00GiB

/dev/loop3, ID: 4
   Device size:            10.00GiB
   Data,RAID10:           512.00MiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             9.00GiB

# /net/src/btrfs-progs/btrfs fi sh /local/raid10sizes
Label: 'raid10sizes'  uuid: 87e036be-b440-48ec-8c2a-b7c1eeca5036
        Total devices 4 FS bytes used 1.12MiB
        devid    1 size 10.00GiB used 2.01GiB path /dev/loop0
        devid    2 size 10.00GiB used 2.01GiB path /dev/loop1
        devid    3 size 10.00GiB used 2.01GiB path /dev/loop2
        devid    4 size 10.00GiB used 2.01GiB path /dev/loop3

# /net/src/btrfs-progs/btrfs fi df /local/raid10sizes
Data, RAID10: total=2.00GiB, used=1.00MiB
System, RAID10: total=16.00MiB, used=16.00KiB
Metadata, RAID10: total=2.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

# /net/src/btrfs-progs/btrfs fi us /local/raid10sizes
Overall:
    Device size:                  40.00GiB
    Device allocated:              8.03GiB
    Device unallocated:           31.97GiB
    Device missing:                  0.00B
    Used:                          2.25MiB
    Free (estimated):             17.98GiB      (min: 17.98GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,RAID10: Size:2.00GiB, Used:1.00MiB
   /dev/loop0      1.00GiB
   /dev/loop1      1.00GiB
   /dev/loop2      1.00GiB
   /dev/loop3      1.00GiB

Metadata,RAID10: Size:2.00GiB, Used:112.00KiB
   /dev/loop0      1.00GiB
   /dev/loop1      1.00GiB
   /dev/loop2      1.00GiB
   /dev/loop3      1.00GiB

System,RAID10: Size:16.00MiB, Used:16.00KiB
   /dev/loop0      8.00MiB
   /dev/loop1      8.00MiB
   /dev/loop2      8.00MiB
   /dev/loop3      8.00MiB

Unallocated:
   /dev/loop0      7.99GiB
   /dev/loop1      7.99GiB
   /dev/loop2      7.99GiB
   /dev/loop3      7.99GiB

# /net/src/btrfs-progs/btrfs de us /local/raid10sizes
/dev/loop0, ID: 1
   Device size:            10.00GiB
   Data,RAID10:             1.00GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             7.99GiB

/dev/loop1, ID: 2
   Device size:            10.00GiB
   Data,RAID10:             1.00GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             7.99GiB

/dev/loop2, ID: 3
   Device size:            10.00GiB
   Data,RAID10:             1.00GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             7.99GiB

/dev/loop3, ID: 4
   Device size:            10.00GiB
   Data,RAID10:             1.00GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             7.99GiB


=> filling filesystem
# dd if=/dev/zero of=/local/raid10sizes/dumpfile
dd: writing to '/local/raid10sizes/dumpfile': No space left on device
37634786+0 records in
37634785+0 records out
19269009920 bytes (19 GB, 18 GiB) copied, 175,848 s, 110 MB/s

# btrfs fi sh /local/raid10sizes
Label: 'raid10sizes'  uuid: 87e036be-b440-48ec-8c2a-b7c1eeca5036
        Total devices 4 FS bytes used 18.01GiB
        devid    1 size 10.00GiB used 10.00GiB path /dev/loop0
        devid    2 size 10.00GiB used 10.00GiB path /dev/loop1
        devid    3 size 10.00GiB used 10.00GiB path /dev/loop2
        devid    4 size 10.00GiB used 10.00GiB path /dev/loop3

# btrfs fi df /local/raid10sizes
Data, RAID10: total=17.98GiB, used=17.98GiB
System, RAID10: total=16.00MiB, used=16.00KiB
Metadata, RAID10: total=2.00GiB, used=27.36MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

# btrfs fi us /local/raid10sizes
Overall:
    Device size:                  40.00GiB
    Device allocated:             40.00GiB
    Device unallocated:            4.00MiB
    Device missing:                  0.00B
    Used:                         36.02GiB
    Free (estimated):              4.00KiB      (min: 4.00KiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,RAID10: Size:17.98GiB, Used:17.98GiB
   /dev/loop0      4.50GiB
   /dev/loop1      4.50GiB
   /dev/loop2      4.50GiB
   /dev/loop3      4.50GiB

Metadata,RAID10: Size:2.00GiB, Used:27.36MiB
   /dev/loop0    512.00MiB
   /dev/loop1    512.00MiB
   /dev/loop2    512.00MiB
   /dev/loop3    512.00MiB

System,RAID10: Size:16.00MiB, Used:16.00KiB
   /dev/loop0      4.00MiB
   /dev/loop1      4.00MiB
   /dev/loop2      4.00MiB
   /dev/loop3      4.00MiB

Unallocated:
   /dev/loop0      5.00GiB
   /dev/loop1      5.00GiB
   /dev/loop2      5.00GiB
   /dev/loop3      5.00GiB

# btrfs de us /local/raid10sizes
/dev/loop0, ID: 1
   Device size:            10.00GiB
   Data,RAID10:             4.50GiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             5.00GiB

/dev/loop1, ID: 2
   Device size:            10.00GiB
   Data,RAID10:             4.50GiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             5.00GiB

/dev/loop2, ID: 3
   Device size:            10.00GiB
   Data,RAID10:             4.50GiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             5.00GiB

/dev/loop3, ID: 4
   Device size:            10.00GiB
   Data,RAID10:             4.50GiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             5.00GiB

# /net/src/btrfs-progs/btrfs fi sh /local/raid10sizes
Label: 'raid10sizes'  uuid: 87e036be-b440-48ec-8c2a-b7c1eeca5036
        Total devices 4 FS bytes used 18.01GiB
        devid    1 size 10.00GiB used 10.00GiB path /dev/loop0
        devid    2 size 10.00GiB used 10.00GiB path /dev/loop1
        devid    3 size 10.00GiB used 10.00GiB path /dev/loop2
        devid    4 size 10.00GiB used 10.00GiB path /dev/loop3

# /net/src/btrfs-progs/btrfs fi df /local/raid10sizes
Data, RAID10: total=17.98GiB, used=17.98GiB
System, RAID10: total=16.00MiB, used=16.00KiB
Metadata, RAID10: total=2.00GiB, used=27.36MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

# /net/src/btrfs-progs/btrfs fi us /local/raid10sizes
Overall:
    Device size:                  40.00GiB
    Device allocated:             40.00GiB
    Device unallocated:            4.00MiB
    Device missing:                  0.00B
    Used:                         36.02GiB
    Free (estimated):              4.00KiB      (min: 4.00KiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               16.00MiB      (used: 0.00B)

Data,RAID10: Size:17.98GiB, Used:17.98GiB
   /dev/loop0      8.99GiB
   /dev/loop1      8.99GiB
   /dev/loop2      8.99GiB
   /dev/loop3      8.99GiB

Metadata,RAID10: Size:2.00GiB, Used:27.36MiB
   /dev/loop0      1.00GiB
   /dev/loop1      1.00GiB
   /dev/loop2      1.00GiB
   /dev/loop3      1.00GiB

System,RAID10: Size:16.00MiB, Used:16.00KiB
   /dev/loop0      8.00MiB
   /dev/loop1      8.00MiB
   /dev/loop2      8.00MiB
   /dev/loop3      8.00MiB

Unallocated:
   /dev/loop0      1.00MiB
   /dev/loop1      1.00MiB
   /dev/loop2      1.00MiB
   /dev/loop3      1.00MiB

# /net/src/btrfs-progs/btrfs de us /local/raid10sizes
/dev/loop0, ID: 1
   Device size:            10.00GiB
   Data,RAID10:             8.99GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             1.00MiB

/dev/loop1, ID: 2
   Device size:            10.00GiB
   Data,RAID10:             8.99GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             1.00MiB

/dev/loop2, ID: 3
   Device size:            10.00GiB
   Data,RAID10:             8.99GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             1.00MiB

/dev/loop3, ID: 4
   Device size:            10.00GiB
   Data,RAID10:             8.99GiB
   Metadata,RAID10:         1.00GiB
   System,RAID10:           8.00MiB
   Unallocated:             1.00MiB
