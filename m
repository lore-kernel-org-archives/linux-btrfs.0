Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30742 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJVItZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 04:49:25 -0400
Message-ID: <54476F88.4040509@oracle.com>
Date: Wed, 22 Oct 2014 16:49:12 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Petr Janecek <janecek@ucw.cz>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs release 3.17
References: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

  You have mentioned two issues when balance and fi show running
  concurrently
   - stalling and
   - errors.

first of all..
3.17 replaced our own system wide disk scan methods by lblkid scan
methods. lblkid with its feature-rich is slower as reported here.
   https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg37839.html

Next, as of 3.17 it still miss the poor man's optimizations patches
(without seeking for a new kernel interface)

[PATCH 1/1] btrfs-progs: code optimize cmd_scan_dev() use 
btrfs_register_one_device()
[PATCH 1/2] btrfs-progs: introduce btrfs_register_all_device()
[PATCH 2/2] btrfs-progs: optimize btrfs_scan_lblkid() for multiple calls


If you could, pls..
  Now on 3.17 apply above 3 patches and see if you see any better
  performance for the stalling issue.
  can you do same steps on 3.16 and report what you observe


Now about the 2nd issue errors when balance is running.. here is my
initial analysis with some guess work..

 > just before the version information. During that time, it
 > often prints something like

 > parent transid verify failed on 2636556500992 wanted 2264 found 2268
or
 > Check tree block failed, want=2730665181184, have=9727841172931608576

  The default btrfs fi show will scan kernel for mounted FS first and
  then for umounted btrfs disks.

  When we already know about the mounted disks its just unnecessary that
  we would still read the mounted disks and later drop them as seen,
  looks like we need to write a real fix to replace this workaround fix..
    btrfs filesystem show: skip duplicate fsids



-Anand


On 10/22/14 05:28, Petr Janecek wrote:
> Hello,
>
>> the version 3.17 of btrfs-progs has been released.
>
>    on a system with 3-disk raid1 and 4 and 5-disk raid10 fs,
> "btrfs filesystem show" now stalls for approx. half a minute after the
> listing, just before the version information. During that time, it
> often prints something like
>


> [...]
>          devid    4 size 2.73TiB used 806.01GiB path /dev/sdh
>          devid    5 size 3.64TiB used 123.00GiB path /dev/sdp
>
> parent transid verify failed on 2636556500992 wanted 2264 found 2268
> parent transid verify failed on 2636556500992 wanted 2264 found 2268
> parent transid verify failed on 2636556500992 wanted 2264 found 2268
> parent transid verify failed on 2636556500992 wanted 2264 found 2268
> Ignoring transid failure
> extent buffer leak: start 2636556091392 len 16384
> Btrfs v3.17
>
> I've had a balance running that time, but "btrfs fi sh /any/btrfs/mount"
> returned always quickly as in previous versions.
>
>    Now, with the balance paused, the stalls continue to appear, but no
> messages as above. During the stalls, btrfs is reading the disks at rate
> several MB/s, probably seek limited. /proc/<btrfs fi sh pid>/fd shows
> that it scans again the devices it has already written about.

>    Umounted all the btrfs, checked them -- nothing wrong.
>
>    Resumed the balance -- error messages are (sometimes) back:
>
> [...]
> Label: 'BTR3'  uuid: 0bf93650-fd12-4f82-8086-2c7484141e97
>          Total devices 5 FS bytes used 1.63TiB
>          devid    1 size 2.73TiB used 800.00GiB path /dev/sde
>          devid    2 size 2.73TiB used 800.00GiB path /dev/sdf
>          devid    3 size 2.73TiB used 800.03GiB path /dev/sdg
>          devid    4 size 2.73TiB used 801.00GiB path /dev/sdh
>          devid    5 size 3.64TiB used 143.03GiB path /dev/sdp
>
> Check tree block failed, want=2730665181184, have=9727841172931608576
> Check tree block failed, want=2730665181184, have=9727841172931608576
> Check tree block failed, want=2730665181184, have=8388343671073157408
> Check tree block failed, want=2730665181184, have=9727841172931608576
> Check tree block failed, want=2730665181184, have=9727841172931608576
> read block failed check_tree_block
> Label: 'BTR1'  uuid: 2ec4b5a1-a2c4-4687-9015-cf5b519297f3
>          Total devices 3 FS bytes used 2.47TiB
>          devid    1 size 3.64TiB used 1.79TiB path /dev/sdm
>          devid    2 size 3.64TiB used 1.79TiB path /dev/sdn
>          devid    3 size 3.64TiB used 1.79TiB path /dev/sdo
>
> Btrfs v3.17
>
>    (or the "parent transid verify failed..." + "extent buffer leak..." as
> in the first case as well)
>
>    Kernel version 3.18-rc1
>
>
> Regards,
>
> Petr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
