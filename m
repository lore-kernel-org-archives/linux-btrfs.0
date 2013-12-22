Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54844 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3LVBPe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Dec 2013 20:15:34 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so3956927pdj.2
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Dec 2013 17:15:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B2BBE1.8090306@gmail.com>
References: <52B2BBE1.8090306@gmail.com>
Date: Sat, 21 Dec 2013 17:15:33 -0800
Message-ID: <CAN05THTwCnmMGh=A0zpgEHqDvoKmokNStfN6wyfVNaFoLxNxBQ@mail.gmail.com>
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Chris Kastorff <encryptio@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Similar things happened to me. (See my unanswered posts ~1Sep, this fs
is not really ready for production I think)

When you get wrong transid errors and reports that you have checksums
being repaired,
that is all bad news and no one can help you.

Unfortunately there are, I think, no real tools to fix basic fs erros.


I never managed to get the my in a state where it could be mounted at all
but did manage to recover most of my data using
btrfs restore from
https://github.com/FauxFaux/btrfs-progs

This is the argument from that command that I used to recover data :
I got most data back with ith but YMMV.

  commit 2a2a1fb21d375a46f9073e44a7b9d9bb7bfaa1e2
  Author: Peter Stuge <peter@stuge.se>
  Date:   Fri Nov 25 01:03:58 2011 +0100

    restore: Add regex matching of paths and files to be restored

    The option -m is used to specify the regex string. -c is used to
    specify case insensitive matching. -i was already taken.

    In order to restore only a single folder somewhere in the btrfs
    tree, it is unfortunately neccessary to construct a slightly
    nontrivial regex, e.g.:

    restore -m '^/(|home(|/username(|/Desktop(|/.*))))$' /dev/sdb2 /output

    This is needed in order to match each directory along the way to the
    Desktop directory, as well as all contents below the Desktop directory.

    Signed-off-by: Peter Stuge <peter@stuge.se>
    Signed-off-by: Josef Bacik <josef@redhat.com>


I wont give advice for your data.
For my data, I copied as much data as I could recover from the
filesystem over to a different filesystem
using the tools in the repo above.
After that destroy the damaged filesystem and rebuild from scratch.


Then  depending on how important your data is, you start making
backups regularely, or switch to a less fragile and unrepairable fs.


On Thu, Dec 19, 2013 at 1:26 AM, Chris Kastorff <encryptio@gmail.com> wrote:
> I'm using btrfs in data and metadata RAID10 on drives (not on md or any
> other fanciness.)
>
> I was removing a drive (btrfs dev del) and during that operation, a
> different drive in the array failed. Having not had this happen before,
> I shut down the machine immediately due to the extremely loud piezo
> buzzer on the drive controller card. I attempted to do so cleanly, but
> the buzzer cut through my patience and after 4 minutes I cut the power.
>
> Afterwards, I located and removed the failed drive from the system, and
> then got back to linux. The array no longer mounts ("failed to read the
> system array on sdc"), with nearly identical messages when attempted
> with -o recovery and -o recovery,ro.
>
> btrfsck asserts and coredumps, as usual.
>
> The drive that was being removed is devid 9 in the array, and is
> /dev/sdm1 in the btrfs fi show seen below.
>
> Kernel 3.12.4-1-ARCH, btrfs-progs v0.20-rc1-358-g194aa4a-dirty
> (archlinux build.)
>
> Can I recover the array?
>
> == dmesg during failure ==
>
> ...
> sd 0:2:3:0: [sdd] Unhandled error code
> sd 0:2:3:0: [sdd]
> Result: hostbyte=0x04 driverbyte=0x00
> sd 0:2:3:0: [sdd] CDB:
> cdb[0]=0x2a: 2a 00 26 89 5b 00 00 00 80 00
> end_request: I/O error, dev sdd, sector 646535936
> btrfs_dev_stat_print_on_error: 7791 callbacks suppressed
> btrfs: bdev /dev/sdd errs: wr 315858, rd 230194, flush 0, corrupt 0, gen 0
> sd 0:2:3:0: [sdd] Unhandled error code
> sd 0:2:3:0: [sdd]
> Result: hostbyte=0x04 driverbyte=0x00
> sd 0:2:3:0: [sdd] CDB:
> cdb[0]=0x2a: 2a 00 26 89 5b 80 00 00 80 00
> end_request: I/O error, dev sdd, sector 646536064
> ...
>
> == dmesg after new boot, mounting attempt ==
>
> btrfs: device label lake devid 11 transid 4893967 /dev/sda
> btrfs: disk space caching is enabled
> btrfs: failed to read the system array on sdc
> btrfs: open_ctree failed
>
> == dmesg after new boot, mounting attempt with -o recovery,ro ==
>
> btrfs: device label lake devid 11 transid 4893967 /dev/sda
> btrfs: enabling auto recovery
> btrfs: disk space caching is enabled
> btrfs: failed to read the system array on sdc
> btrfs: open_ctree failed
>
> == btrfsck ==
>
> deep# btrfsck /dev/sda
> warning, device 14 is missing
> warning devid 14 not found already
> parent transid verify failed on 87601116364800 wanted 4893969 found 4893913
> parent transid verify failed on 87601116364800 wanted 4893969 found 4893913
> parent transid verify failed on 87601116381184 wanted 4893969 found 4893913
> parent transid verify failed on 87601116381184 wanted 4893969 found 4893913
> parent transid verify failed on 87601115320320 wanted 4893969 found 4893913
> parent transid verify failed on 87601115320320 wanted 4893969 found 4893913
> parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
> parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
> Ignoring transid failure
> Checking filesystem on /dev/sda
> UUID: d5e17c49-d980-4bde-bd96-3c8bc95ea077
> checking extents
> parent transid verify failed on 87601117159424 wanted 4893969 found 4893913
> parent transid verify failed on 87601117159424 wanted 4893969 found 4893913
> parent transid verify failed on 87601116368896 wanted 4893969 found 4893913
> parent transid verify failed on 87601116368896 wanted 4893969 found 4893913
> parent transid verify failed on 87601117163520 wanted 4893969 found 4893913
> parent transid verify failed on 87601117163520 wanted 4893969 found 4893913
> parent transid verify failed on 87601117638656 wanted 4893969 found 4893913
> parent transid verify failed on 87601117638656 wanted 4893969 found 4893913
> Ignoring transid failure
> parent transid verify failed on 87601117171712 wanted 4893969 found 4893913
> parent transid verify failed on 87601117171712 wanted 4893969 found 4893913
> parent transid verify failed on 87601117175808 wanted 4893969 found 4893913
> parent transid verify failed on 87601117175808 wanted 4893969 found 4893913
> parent transid verify failed on 87601117188096 wanted 4893969 found 4893913
> parent transid verify failed on 87601117188096 wanted 4893969 found 4893913
> parent transid verify failed on 87601116807168 wanted 4893969 found 4893913
> parent transid verify failed on 87601116807168 wanted 4893969 found 4893913
> Ignoring transid failure
> parent transid verify failed on 87601117642752 wanted 4893969 found 4893913
> parent transid verify failed on 87601117642752 wanted 4893969 found 4893913
> Ignoring transid failure
> parent transid verify failed on 87601117650944 wanted 4893969 found 4893913
> parent transid verify failed on 87601117650944 wanted 4893969 found 4893913
> Ignoring transid failure
> Couldn't map the block 5764607523034234880
> btrfsck: volumes.c:1019: btrfs_num_copies: Assertion `!(!ce)' failed.
> zsh: abort (core dumped)  btrfsck /dev/sda
>
> == btrfs fi show ==
>
> Label: 'lake'  uuid: d5e17c49-d980-4bde-bd96-3c8bc95ea077
>         Total devices 10 FS bytes used 7.43TB
>         devid    9 size 1.82TB used 1.61TB path /dev/sdm1
>         devid   12 size 1.82TB used 1.47TB path /dev/sdb
>         devid   16 size 1.82TB used 1.47TB path /dev/sde
>         devid   13 size 1.82TB used 1.47TB path /dev/sdc
>         devid   11 size 1.82TB used 1.47TB path /dev/sda
>         devid   19 size 1.82TB used 1.47TB path /dev/sdk
>         devid   17 size 1.82TB used 1.47TB path /dev/sdf
>         devid   18 size 1.82TB used 1.47TB path /dev/sdg
>         devid   15 size 1.82TB used 1.47TB path /dev/sdd
>         *** Some devices missing
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
