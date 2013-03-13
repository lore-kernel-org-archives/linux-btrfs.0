Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3CMLrG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 07:47:06 -0400
Message-ID: <51406728.5030705@oracle.com>
Date: Wed, 13 Mar 2013 19:46:48 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: use BTRFS_SCAN_BACKUP_SB flag in btrfs_scan_one_device
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com> <1362756300-30212-4-git-send-email-anand.jain@oracle.com> <513DF252.8070109@redhat.com> <20130311181635.GH7229@twin.jikos.cz>
In-Reply-To: <20130311181635.GH7229@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks Eric and David.

  I have sent out V3 patch-set which will disable access
  to backup super-block unless requested by the user.

  here below are some test cases and results before and
  after this fix.. which finds the patch works awesome.


--------
the original problem which all this started..

mkfs.btrfs /dev/sdb -f && yes| mkfs.ext4 /dev/sdb && mount /dev/sdb /ext4
~/before/mkfs.btrfs -f /dev/sdc /dev/sdd (run twice)
~/before/mkfs.btrfs -f /dev/sdc /dev/sdd
::
ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
adding device /dev/sdd id 2
fs created label (null) on /dev/sdc
         nodesize 4096 leafsize 4096 sectorsize 4096 size 3.11GB


after the fix.

# mkfs.btrfs -f /dev/sdc /dev/sdd

WARNING! - Btrfs v0.20-rc1-238-g170881a-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sdd id 2
fs created label (null) on /dev/sdc
	nodesize 4096 leafsize 4096 sectorsize 4096 size 104.98GB
Btrfs v0.20-rc1-238-g170881a-dirty
-------------

# umount /ext4

# mkfs.btrfs /dev/sdb /dev/sdc -f && wipefs /dev/sdb

There is an existing bug..

# ~/before/btrfs check /dev/sdc --repair
enabling repair mode
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
Checking filesystem on /dev/sdc
UUID: e03c477d-b696-46c1-bf79-43b8b8454f11
checking extents
checking fs roots
checking root refs
btrfs: extent-tree.c:2553: btrfs_reserve_extent: Assertion `!(ret)' failed.
Aborted (core dumped)
#

and its still there even after this patch :-)

# btrfs check /dev/sdc --repair
enabling repair mode
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
Checking filesystem on /dev/sdc
UUID: e03c477d-b696-46c1-bf79-43b8b8454f11
checking extents
checking fs roots
checking root refs
btrfs: extent-tree.c:2553: btrfs_reserve_extent: Assertion `!(ret)' failed.
Aborted (core dumped)

-------------------------


# mkfs.btrfs /dev/sdb /dev/sdc -f && yes|mkfs.ext4 /dev/sdb

without the fix
# ~/before/btrfs restore -o /dev/sdb ~/tmp
ERROR: device scan failed '/dev/sdb' - Invalid argument
ERROR: device scan failed '/dev/sdb' - Invalid argument
Root objectid is 5

with the fix

# btrfs restore -o /dev/sdb ~/tmp
No valid Btrfs found on /dev/sdb
Could not open root, trying backup super
Root objectid is 5

now I say to use sb backup 1..

# btrfs restore -u 1 -o /dev/sdb ~/tmp
Root objectid is 5
# echo $?
0

--------------

# mkfs.btrfs /dev/sdb /dev/sdc -f && yes|mkfs.ext4 /dev/sdb

# ~/before/btrfs check /dev/sdc --repair
enabling repair mode
ERROR: device scan failed '/dev/sdb' - Invalid argument
ERROR: device scan failed '/dev/sdb' - Invalid argument
Checking filesystem on /dev/sdc
UUID: 5dc5c663-eeea-4ec2-b8fe-170157f5d68d
checking extents
checking fs roots
checking root refs
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 22420
file data blocks allocated: 0
  referenced 0
Btrfs v0.20-rc1-235-gdd21bc1

# mkfs.btrfs /dev/sdb /dev/sdc -f && yes|mkfs.ext4 /dev/sdb

since now new code doesn't read backup SB of devid1
it hits the earlier known bug.

# btrfs check /dev/sdc --repair
enabling repair mode
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
Checking filesystem on /dev/sdc
UUID: daa0dc6d-35b6-43ab-8333-894710a5b917
checking extents
checking fs roots
checking root refs
btrfs: extent-tree.c:2553: btrfs_reserve_extent: Assertion `!(ret)' failed.
Aborted (core dumped)

So user would need to fix the devid1 first.

# btrfs check /dev/sdb --repair
enabling repair mode
No valid Btrfs found on /dev/sdb

# btrfs check -s 1 /dev/sdb --repair
using SB copy 1, bytenr 67108864
enabling repair mode
Checking filesystem on /dev/sdb
UUID: daa0dc6d-35b6-43ab-8333-894710a5b917
checking extents
checking fs roots
checking root refs
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 22420
file data blocks allocated: 0
  referenced 0
Btrfs v0.20-rc1-238-g170881a-dirty

# btrfs check /dev/sdc --repair
enabling repair mode
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
Checking filesystem on /dev/sdc
UUID: daa0dc6d-35b6-43ab-8333-894710a5b917
checking extents
checking fs roots
checking root refs
btrfs: extent-tree.c:2553: btrfs_reserve_extent: Assertion `!(ret)' failed.
Aborted (core dumped)

Need to write back the backup SB to primary SB.
IMO when -s 1 was given it had the chance to fix
primary.. this can be fixed later.

# ./btrfs-select-super -s 1 /dev/sdb
using SB copy 1, bytenr 67108864
ERROR: device scan failed '/dev/sdb' - Invalid argument

# btrfs check /dev/sdc --repair
enabling repair mode
Checking filesystem on /dev/sdc
UUID: daa0dc6d-35b6-43ab-8333-894710a5b917
checking extents
checking fs roots
checking root refs
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 22420
file data blocks allocated: 0
  referenced 0
Btrfs v0.20-rc1-238-g170881a-dirty
---------------------------------------------------------------


I am not sure if I have a wipe -a working for btrfs,
so I would clean using dd.

# dd if=/dev/zero bs=1 count=8 of=/dev/sdb seek=$((64*1024+64))
8+0 records in
8+0 records out
8 bytes (8 B) copied, 0.000324503 s, 24.7 kB/s

# dd if=/dev/zero bs=1 count=8 of=/dev/sdb seek=$((64*1024*1024+64))
8+0 records in
8+0 records out
8 bytes (8 B) copied, 0.000364635 s, 21.9 kB/s

# dd if=/dev/zero bs=1 count=8 of=/dev/sdb seek=$((256*1024*1024*1024+64))
dd: `/dev/sdb': cannot seek: Invalid argument
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000430846 s, 0.0 kB/s

This behavior is same before and after the patch.

# btrfs check /dev/sdb
No valid Btrfs found on /dev/sdb
# btrfs check /dev/sdb -s 1
using SB copy 1, bytenr 67108864
No valid Btrfs found on /dev/sdb
# btrfs check /dev/sdb -s 2
using SB copy 2, bytenr 274877906944
No valid Btrfs found on /dev/sdb
#
------------------------

  # mkfs.btrfs /dev/sdb /dev/sdc -f && mount /dev/sdc /btrfs

  # dd if=/dev/zero bs=1 count=8 of=/dev/sdb seek=$((64*1024+64))
  # dd if=/dev/zero bs=1 count=8 of=/dev/sdb seek=$((64*1024*1024+64))
  # dd if=/dev/zero bs=1 count=8 of=/dev/sdb seek=$((256*1024*1024*1024+64))

# mkfs.btrfs /dev/sdb

WARNING! - Btrfs v0.20-rc1-238-g170881a-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

/dev/sdb is mounted


# umount /btrfs

# mkfs.btrfs /dev/sdb

WARNING! - Btrfs v0.20-rc1-238-g170881a-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

/dev/sdb appears to contain an existing filesystem (btrfs).
Use the -f option to force overwrite.
#

-------------------------


# mkfs.btrfs /dev/sdd /dev/sde -f

WARNING! - Btrfs v0.20-rc1-238-g170881a-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sde id 2
fs created label (null) on /dev/sdd
	nodesize 4096 leafsize 4096 sectorsize 4096 size 93.22GB
Btrfs v0.20-rc1-238-g170881a-dirty
# mount /dev/sde /btrfs
# umount /btrfs
# dd if=/dev/zero bs=1 count=8 of=/dev/sde seek=$((64*1024+64))
8+0 records in
8+0 records out
8 bytes (8 B) copied, 0.0149415 s, 0.5 kB/s

remove /dev/sdd

# x="0 0 3 0"
# echo "scsi remove-single-device $x" > /proc/scsi/scsi
# lsscsi
[0:0:0:0]    disk    Sun      boot1            V1.0  /dev/sda
[0:0:2:0]    disk    Sun      boot3            V1.0  /dev/sdc
[0:0:4:0]    disk    Sun      boot5            V1.0  /dev/sde
[0:1:0:0]    disk    SEAGATE  ST914602SSUN146G 0603  -
[0:1:1:0]    disk    SEAGATE  ST914602SSUN146G 0603  -
[0:3:0:0]    enclosu ADAPTEC  Virtual SGPIO  0 0001  -


# btrfs check /dev/sde
No valid Btrfs found on /dev/sde

# btrfs check /dev/sde -s 1
using SB copy 1, bytenr 67108864
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
Checking filesystem on /dev/sde
UUID: fa08122d-832f-4f32-87ee-58eb9380d5da
checking extents
checking fs roots
checking root refs
found 815104 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 21476
file data blocks allocated: 786432
  referenced 786432
Btrfs v0.20-rc1-238-g170881a-dirty

# ./btrfs-select-super -s 1 /dev/sde
using SB copy 1, bytenr 67108864
ERROR: device scan failed '/dev/sdc' - Invalid argument
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already

# btrfs check /dev/sde
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
Checking filesystem on /dev/sde
UUID: fa08122d-832f-4f32-87ee-58eb9380d5da
checking extents
checking fs roots
checking root refs
found 815104 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 21476
file data blocks allocated: 786432
  referenced 786432
Btrfs v0.20-rc1-238-g170881a-dirty
#
---------------


Thanks, Anand


On 03/12/2013 02:16 AM, David Sterba wrote:
> On Mon, Mar 11, 2013 at 10:03:46AM -0500, Eric Sandeen wrote:
>> IMHO, nothing should be checking the backup superblocks unless explicitly
>> told to.
>
> That's the whole point I believe.
>
> update the infrastructure, every SB access looks to the first copy
> unless told by command line options.
>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
