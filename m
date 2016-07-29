Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:36231 "EHLO
	mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbcG2Jk7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 05:40:59 -0400
MIME-Version: 1.0
In-Reply-To: <CADxRZqzt8m6j_GktpKYYmDar=hDYy07DhyiuPJ-gMgtGfiGhXQ@mail.gmail.com>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz> <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
 <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
 <20160728180413.GY30795@suse.cz> <CADxRZqzt8m6j_GktpKYYmDar=hDYy07DhyiuPJ-gMgtGfiGhXQ@mail.gmail.com>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Fri, 29 Jul 2016 12:40:57 +0300
Message-ID: <CADxRZqz4hEm41=uncs9fbUa-b04_G3GRdGGPf=s7YybfHZCM-w@mail.gmail.com>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: dsterba@suse.cz
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>, fstests@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 11:34 PM, Anatoly Pugachev <matorola@gmail.com> wrote:
> On Thu, Jul 28, 2016 at 9:04 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Thu, Jul 28, 2016 at 04:28:41PM +0200, John Paul Adrian Glaubitz wrote:
>>> On 07/28/2016 04:25 PM, John Paul Adrian Glaubitz wrote:
>>> > On 07/28/2016 04:01 PM, Anatoly Pugachev wrote:
>>> >> Program received signal SIGBUS, Bus error.
>>> >> 0x0000000000177dfc in raid6_gen_syndrome (disks=4, bytes=65536,
>>> >> ptrs=0x2c4510) at raid6.c:87
>>> >> 87                      wq0 = wp0 = *(unative_t *)&dptr[z0][d+0*NSIZE];
>>> >
>>> > That should be easy to fix. Just make the R values aligned with the
>>> > appropriate get_aligned functions, see David's previous commit [1]:
>>>
>>> Argh, those are called get_UNaligned_*, not get_aligned_*.
>>>
>>> > There are more lines in raid6.c which need the same fix, basically everything
>>> > with * (unative_t *).
>>>
>>> Oh, and you will somehow need to guard this with #if BITS_PER_LONG == 64 ...
>>> #else ... #endif respectively since you need to use different versions
>>> (64 vs. 32) of get_unaligned_* depending on the size of unative_t.
>>
>> And I've fixed it that way, now pushed to devel ("btrfs-progs: fix
>> unaligned access in raid6 calculations" [1]). Would be great if you or
>> Anatoly can test it so I can add it to the 4.7 release (ETA tomorrow).
>
> David,
> well, I think mkfs.btrfs is fixed, since I just tested it with :
> root@nvg5120:/home/mator/xfstests# ./check 'btrfs/06?'
> FSTYP         -- btrfs
> PLATFORM      -- Linux/sparc64 nvg5120 4.7.0+
> MKFS_OPTIONS  -- /dev/loop0
> MOUNT_OPTIONS -- /dev/loop0 /mnt/scratch
>
> btrfs/060        145s
> btrfs/061        158s
> btrfs/062        288s
> btrfs/063        141s
> btrfs/064        129s
> btrfs/065        44s
> btrfs/066        46s
> btrfs/067        - output mismatch (see
> /home/mator/xfstests/results//btrfs/067.out.bad)
>     --- tests/btrfs/067.out     2016-07-20 12:12:21.772228422 +0300
>     +++ /home/mator/xfstests/results//btrfs/067.out.bad 2016-07-28
> 22:54:00.059192629 +0300
>     @@ -1,2 +1,3 @@
>      QA output created by 067
>      Silence is golden
>     +Scrub find errors in "-m single -d single" test
>     ...
>     (Run 'diff -u tests/btrfs/067.out
> /home/mator/xfstests/results//btrfs/067.out.bad'  to see the entire
> diff)
> btrfs/068        57s
> btrfs/069        45s
> Ran: btrfs/060 btrfs/061 btrfs/062 btrfs/063 btrfs/064 btrfs/065
> btrfs/066 btrfs/067 btrfs/068 btrfs/069
> Failures: btrfs/067
> Failed 1 of 10 tests
>
>
> previously (before mkfs.btrfs fix) , all tests from 06? were bad/failed.
>
> Starting from "tests/btrfs/064" kernel started to log TPC (Trap
> Program Counter register) messages, a lot of them.
>
> Results of the this test i put on a webserver [1].
> Output of journalctl -b (from boot) with TPC messages are at [2].
>
> Not sure what we need to do with sparc64 btrfs module TPC messages.
> Probably fill kernel bugzilla report?
>
> Thanks.
>
> [1] http://u163.east.ru/btrfs/xfstests-btrfs-06x-results.tar.gz
> [2] http://u163.east.ru/btrfs/kernel-4.7.0+-logs-xfstests-06x.txt.gz
>
> PS: my xfstests setup is the following:
>
> # mount tmpfs -t tmpfs -o size=13g /ramdisk/
> /ramdisk# for i in 1 2 3 4 5 6; do fallocate -l 1g scratch${i}; done
> /ramdisk# fallocate -l 4g testvol1
>
> /ramdisk# for i in *; do losetup -f $i; done
> /home/mator/xfstests# losetup
> NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE         DIO
> /dev/loop0         0      0         0  0 /ramdisk/scratch1   0
> /dev/loop1         0      0         0  0 /ramdisk/scratch2   0
> /dev/loop2         0      0         0  0 /ramdisk/scratch3   0
> /dev/loop3         0      0         0  0 /ramdisk/scratch4   0
> /dev/loop4         0      0         0  0 /ramdisk/scratch5   0
> /dev/loop5         0      0         0  0 /ramdisk/scratch6   0
> /dev/loop6         0      0         0  0 /ramdisk/testvol1   0
>
> # mkfs.btrfs /dev/loop6
> btrfs-progs v4.6.1-66-g4367e35
> See http://btrfs.wiki.kernel.org for more information.
>
> Performing full device TRIM (4.00GiB) ...
> Label:              (null)
> UUID:               6a4d5918-adfe-469c-8454-9b28545b88bc
> Node size:          16384
> Sector size:        8192
> Filesystem size:    4.00GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP             204.75MiB
>   System:           DUP               8.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1     4.00GiB  /dev/loop6
>
> root@nvg5120:/home/mator/xfstests# cat local.config
> export TEST_DEV=/dev/loop6
> export TEST_DIR=/fst
> export SCRATCH_DEV_POOL="/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> /dev/loop4 /dev/loop5"
> export SCRATCH_MNT=/mnt/scratch









Just to add, I've also run tests from btrfs/000 to btrfs/059, with not
so bad results:

Ran: btrfs/001 btrfs/002 btrfs/005 btrfs/006 btrfs/008 btrfs/009
btrfs/010 btrfs/012 btrfs/013 btrfs/014 btrfs/015 btrfs/016 btrfs/017
btrfs/018 btrfs/019 btrfs/020 btrfs/021 btrfs/022 btrfs/023 btrfs/024
btrfs/025 btrfs/026 btrfs/027 btrfs/028 btrfs/029 btrfs/030 btrfs/031
btrfs/032 btrfs/033 btrfs/034 btrfs/035 btrfs/036 btrfs/037 btrfs/038
btrfs/039 btrfs/040 btrfs/041 btrfs/042 btrfs/043 btrfs/044 btrfs/045
btrfs/046 btrfs/048 btrfs/049 btrfs/050 btrfs/051 btrfs/052 btrfs/053
btrfs/054 btrfs/055 btrfs/056 btrfs/057 btrfs/058 btrfs/059
Not run: btrfs/003 btrfs/004 btrfs/007 btrfs/011 btrfs/047
Failures: btrfs/010 btrfs/012 btrfs/057
Failed 3 of 54 tests

Failures:

btrfs/010 - failed with "number of extents mis-match!"
$ cat /home/mator/xfstests/results//btrfs/010.full
Create subvolume '/mnt/scratch/subvol'
1+0 records in
1+0 records out
1+0 records in
1+0 records out
1+0 records in
1+0 records out
1+0 records in
1+0 records out
1+0 records in
1+0 records out
Create a snapshot of '/mnt/scratch/subvol' in '/mnt/scratch/snap-2'
Create a snapshot of '/mnt/scratch/subvol' in '/mnt/scratch/snap-1'
/mnt/scratch/subvol/foobar:
        0: [0..79]: 24704..24783
/mnt/scratch/snap-1/foobar:
        0: [0..31]: 24672..24703
        1: [32..47]: 24656..24671
        2: [48..63]: 24608..24623
        3: [64..79]: 24592..24607
/mnt/scratch/snap-2/foobar:
        0: [0..31]: 24672..24703
        1: [32..47]: 24656..24671
        2: [48..63]: 24608..24623
        3: [64..79]: 24592..24607
1 4 4


btrfs/012 - failed with "btrfs-convert failed"
$ cat /home/mator/xfstests/results//btrfs/012.full
mke2fs 1.43.1 (08-Jun-2016)
Discarding device blocks: done
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 98d0756e-76b6-4ab1-ac7d-a1fceb4b21b4
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

ERROR: system chunk array too big 1627389952 > 2048
ERROR: superblock checksum matches but it has invalid members
No valid Btrfs found on /dev/loop0
unable to open ctree
conversion aborted
create btrfs filesystem:
        blocksize: 4096
        nodesize:  16384
        features:  extref, skinny-metadata (default)
btrfs-convert failed


btrfs/057 - failed: '_scratch_mkfs -b 1g --nodesize 4096'
$ cat /home/mator/xfstests/results//btrfs/057.full
# _scratch_mkfs -b 1g --nodesize 4096
ERROR: illegal nodesize 4096 (smaller than 8192)
failed: '_scratch_mkfs -b 1g --nodesize 4096'


JFYI,
mator@nvg5120:~$ getconf PAGE_SIZE
8192


this 000-059 tests was done with fresh reboot.

within 027 test, kernel started to show TPC messages, like this one:

Jul 29 12:10:32 nvg5120 unknown: run fstests btrfs/027 at 2016-07-29 12:10:32
...
Jul 29 12:10:58 nvg5120 kernel: BTRFS info (device loop4): allowing
degraded mounts
Jul 29 12:10:58 nvg5120 kernel: BTRFS info (device loop4): disk space
caching is enabled
Jul 29 12:10:58 nvg5120 kernel: BTRFS info (device loop4): has skinny extents
Jul 29 12:10:59 nvg5120 kernel: BTRFS info (device loop4): dev_replace
from <missing disk> (devid 2) to /dev/loop5 started
Jul 29 12:10:59 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:10:59 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:10:59 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:10:59 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:10:59 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:11:00 nvg5120 kernel: BTRFS info (device loop4): dev_replace
from <missing disk> (devid 2) to /dev/loop5 finished
...
Jul 29 12:11:07 nvg5120 kernel: BTRFS info (device loop4): allowing
degraded mounts
Jul 29 12:11:07 nvg5120 kernel: BTRFS info (device loop4): disk space
caching is enabled
Jul 29 12:11:07 nvg5120 kernel: BTRFS info (device loop4): has skinny extents
Jul 29 12:11:08 nvg5120 kernel: BTRFS info (device loop4): dev_replace
from <missing disk> (devid 2) to /dev/loop5 started
Jul 29 12:11:08 nvg5120 kernel: log_unaligned: 10616 callbacks suppressed
Jul 29 12:11:08 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:11:09 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:11:09 nvg5120 kernel: Kernel unaligned access at
TPC[118e002c] __btrfs_map_block+0x36c/0x1180 [btrfs]
Jul 29 12:11:09 nvg5120 kernel: Kernel unaligned access at
TPC[118e0094] __btrfs_map_block+0x3d4/0x1180 [btrfs]
Jul 29 12:11:09 nvg5120 kernel: Kernel unaligned access at
TPC[118e0960] __btrfs_map_block+0xca0/0x1180 [btrfs]
Jul 29 12:11:09 nvg5120 kernel: BTRFS info (device loop4): dev_replace
from <missing disk> (devid 2) to /dev/loop5 finished
Jul 29 12:11:11 nvg5120 mator[34598]: run xfstest btrfs/028

and only with 027 test, next tests were finished without TPC messages.
