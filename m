Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34851 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbbHUEQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 00:16:11 -0400
Received: by qkbm65 with SMTP id m65so26285710qkb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 21:16:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOE4rSxMhwqn49fqPz2knzaRPyvkRr3roFD-JYTcm2rvB-LKkA@mail.gmail.com>
References: <CAOE4rSxMhwqn49fqPz2knzaRPyvkRr3roFD-JYTcm2rvB-LKkA@mail.gmail.com>
Date: Fri, 21 Aug 2015 07:16:10 +0300
Message-ID: <CAOE4rSzk8owgod-p9-+1Gb6HxBr-fMkY2eiHtCXP5VT-C8RVcA@mail.gmail.com>
Subject: Re: Disk "failed" while doing scrub
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-07-13 9:26 GMT+03:00 Dāvis Mosāns <davispuh@gmail.com>:
> also are there some easy way to locate those unreadable sectors and
> rewrite them so hdd relocates them?
>

Only now noticed that scrub does tell it :)

> kernel: BTRFS: i/o error at logical 7358423011328 on dev /dev/sdd,
sector 2879471688, root 3034, inode 5619902, offset 4546727936, length
4096, links 1 (path: dir2/damaged_file)

So for each broken sector I did
$ dd if=/dev/zero of=/dev/sdd seek=359933961 count=1 bs=4096

note that for dd seek need to specify block number which is 4096 byte size
in my case, but from scrub sector is 512 bytes size so 2879471688 / 8
= 359933961

Now disk was able to mark those sectors as dead and self-test passes
also it doesn't show any uncorrectable sectors anymore

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
5 Reallocated_Sector_Ct       0x0033   100   100   036    Pre-fail
Always       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable      0x0010   100   100   000    Old_age
Offline        -       0

Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      3173         -
# 2  Short offline           Completed without error       00%
3169         -
# 3  Short offline           Completed: read failure       90%
3139         2879471688

Then I tried to copy that same file

$ cp damaged_file /tmp/damaged_file
cp: error reading damaged_file: Input/output error

$ ddrescue damaged_file /tmp/damaged_file
GNU ddrescue 1.19
Press Ctrl-C to interrupt
rescued:     6554 MB,  errsize:    8192 B,  current rate:   56082 kB/s
  ipos:     4572 MB,   errors:       2,    average rate:   99310 kB/s
  opos:     4572 MB, run time:    1.10 m,  successful read:       0 s ago
Finished

and result is same, cp stops on first error, but ddrescue is able to
get everything
except those 8 KiB only difference is that I get csum error instead of
I/O error :)

kernel: BTRFS warning (device sdh): csum failed ino 5619902 off
4546727936 csum 2566472073 expected csum

when running scrub

scrub device /dev/sdd (id 2) done
       scrub started at Thu Jul 17 13:58:06 2015 and finished after 02:48:05
       data_extents_scrubbed: 26349742
       tree_extents_scrubbed: 316806
       data_bytes_scrubbed: 1574102949888
       tree_bytes_scrubbed: 5190549504
       read_errors: 0
       csum_errors: 2
       verify_errors: 0
       no_csum: 89600
       csum_discards: 656179
       super_errors: 0
       malloc_errors: 0
       uncorrectable_errors: 2
       unverified_errors: 0
       corrected_errors: 0
       last_physical: 1579475271680
ERROR: There are uncorrectable errors.


Now to fix csum errors I could use btrfs check --init-csum-tree  but I
think that's bad
as it will basically force all files to be valid even if they are
corrupted so I just copied
file from backup overwriting this damaged one.

Then after running scrub again can see that there's no errors anymore

scrub status for 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
       scrub started at Fri Jul 17 19:22:45 2015 and finished after 02:47:58
       data_extents_scrubbed: 26347511
       tree_extents_scrubbed: 317192
       data_bytes_scrubbed: 1573973471232
       tree_bytes_scrubbed: 5196873728
       read_errors: 0
       csum_errors: 0
       verify_errors: 0
       no_csum: 89472
       csum_discards: 656152
       super_errors: 0
       malloc_errors: 0
       uncorrectable_errors: 0
       unverified_errors: 0
       corrected_errors: 0
       last_physical: 1580549013504

Next I did
$ btrfs device delete /dev/sdd /mnt/Data

Which successfully completed, only seems there's a bug that it shows incorrect
unallocated space for device when delete is in progress
$ btrfs filesystem usage

Unallocated:
  /dev/sdc       11.49GiB
  /dev/sdd       16.00EiB   // disk isn't that big...
  /dev/sde       12.02GiB
  /dev/sdg       12.02GiB
  /dev/sdh       11.48GiB

Then I tested that disk with badblocks and it didn't find anything so I just
added it back with
$ btrfs device add /dev/sdd /mnt/Data
and balance
$ btrfs balance start /mnt/Data

And just be completely sure everything is ok

$ btrfs check --check-data-csum /dev/sdc
Checking filesystem on /dev/sdc
UUID: 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 7931796849809 bytes used err is 0
total csum bytes: 7731179932
total tree bytes: 15068594176
total fs tree bytes: 5814714368
total extent tree bytes: 860798976
btree space waste bytes: 1691112689
file data blocks allocated: 7918108438528
referenced 8212185219072


That's all, wasn't any need to recreate filesystem from scratch but just recover
1 file from backup and I even verified all files from backup with
rsync --checksum --dry-run
that everything is indeed correct.

PS. Sorry for so delayed follow-up.
