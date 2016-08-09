Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33734 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbcHIM4u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 08:56:50 -0400
Received: by mail-io0-f179.google.com with SMTP id 38so10457976iol.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 05:56:50 -0700 (PDT)
Subject: Re: Issue: errno:28 (No space left on device)
To: Thomas <c.monty@web.de>, linux-btrfs@vger.kernel.org
References: <e4671ca6-38bc-ce32-0bc9-c1e7bc9873cd@web.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1b31f650-6c29-7b46-eafb-0434a26f15d6@gmail.com>
Date: Tue, 9 Aug 2016 08:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <e4671ca6-38bc-ce32-0bc9-c1e7bc9873cd@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-09 07:50, Thomas wrote:
> Hello!
First things first:
Mailing lists are asynchronous.  You will almost _never_ get an 
immediate response, and will quite often not get a response for a few 
hours at least.  Sending a message more than once when you don't get a 
response does not make it more likely you get a response quickly, and in 
fact is a good way to seriously annoy people and make them less willing 
to help you.
>
> I'm facing a severe issue with Debian installation using BTRFS:
> errno:28 (No space left on device)
>
> After a few minutes of system usage I get this error message for any
> action, means there's really no disk space left.
>
> However, the output of btrfs fi usage / reports that ~10% of disk space
> should be free.
>
> I have 2 questions:
> 1. Why is the OS reporting an error "Issue: errno:28 (No space left on
> device)" whereas "btrfs fi usage" reports free space?
BTRFS allocates disk space in two stages.  In the first stage, it 
allocates large chunks that then get used only for metadata or data. 
Within those chunks, it then allocates blocks for the given type of data 
on-demand.  In your case, the filesystem has no room to allocate new 
chunks, but has some free space in existing chunks.  This shouldn't 
result in allocation failures for new files, but for currently unknown 
reasons it sometimes does, and this is a known issue that we have been 
unable to completely fix so far (we've technically 'fixed' this about 5 
or 6 times already, but there appear to be lots of odd corner cases that 
haven't been found yet).
> 2. How can I solve this issue w/o the possibility of extending the
> partition?
Right now, you have three options:
1. Extend the partition, run a full balance, and then shrink the 
partition again.
2. Temporarily add another device (make sure it's at least 4GB), run a 
full balance, and then remove the device.
3. Recreate the filesystem from scratch and restore from a backup.

Regardless of which option you choose, you either need to free up some 
disk space, or get a bigger storage device, as running within a few GB 
of a full filesystem is a known trigger for this issue.  Depending on 
how frequently you snapshot the system, just deleting some old snapshots 
may help.  Making sure to clean out the package cache after running 
updates will probably help too.
>
>
> THX
>
> ---------------------------------------------------------------------------------------
>
>
> thomas@pc8-nb:~$ uname -a
> Linux pc8-nb 4.6.1-towo.1-siduction-amd64 #1 SMP PREEMPT siduction 4.6-1
> (2016-06-04) x86_64 GNU/Linux
>
>
> thomas@pc8-nb:~$ sudo btrfs --version
> btrfs-progs v4.5.2
>
>
> thomas@pc8-nb:~$ sudo btrfs fi usage /
> Overall:
>       Device size:          20.53GiB
>       Device allocated:          20.53GiB
>       Device unallocated:             0.00B
>       Device missing:             0.00B
>       Used:              18.25GiB
>       Free (estimated):           1.96GiB    (min: 1.96GiB)
>       Data ratio:                  1.00
>       Metadata ratio:              1.00
>       Global reserve:         160.00MiB    (used: 400.00KiB)
>
> Data,single: Size:19.76GiB, Used:17.81GiB
>      /dev/sda8      19.76GiB
>
> Metadata,single: Size:776.00MiB, Used:455.73MiB
>      /dev/sda8     776.00MiB
>
> System,single: Size:4.00MiB, Used:16.00KiB
>      /dev/sda8       4.00MiB
>
> Unallocated:
>      /dev/sda8         0.00B
>
>
> thomas@pc8-nb:~$ sudo btrfs fi show
> Label: 'siduction'  uuid: dbb9433e-a84f-4e84-9200-49350b31a3f6
>     Total devices 1 FS bytes used 18.25GiB
>     devid    1 size 20.53GiB used 20.53GiB path /dev/sda8
>
>
> thomas@pc8-nb:~$ sudo btrfs su li /
> ID 257 gen 5498245 top level 5 path @
> ID 258 gen 5498245 top level 5 path @home
> ID 259 gen 5488356 top level 5 path @tmp
> ID 260 gen 2029641 top level 5 path @var_lib_lxc
> ID 261 gen 5480763 top level 5 path @var_log
> ID 262 gen 5467204 top level 5 path @var_spool
> ID 263 gen 5467205 top level 5 path @var_tmp
> ID 290 gen 5464299 top level 257 path .snapshots
> ID 291 gen 2026169 top level 258 path @home/.snapshots
> ID 293 gen 2029641 top level 260 path @var_lib_lxc/.snapshots
> ID 355 gen 163972 top level 290 path .snapshots/17/snapshot
> ID 356 gen 167205 top level 290 path .snapshots/18/snapshot
> ID 357 gen 5383634 top level 5 path @var_cache_apt_archives
> ID 358 gen 5464163 top level 290 path .snapshots/19/snapshot
>
>
> thomas@pc8-nb:~$ sudo journalctl | grep space
> [...]
> Jun 16 17:52:39 pc8-nb unattended-upgrade-shutdown[13530]: OSError:
> [Errno 28] No space left on device
> Jun 16 17:52:39 pc8-nb unattended-upgrade-shutdown[13530]: OSError:
> [Errno 28] No space left on device
> Jun 16 17:52:39 pc8-nb unattended-upgrade-shutdown[13530]: OSError:
> [Errno 28] No space left on device
> [...]
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://ftp.fau.de/debian/dists/stable/main/Contents-i386  Write error -
> write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://debian.mirror.lrz.de/debian/dists/stable/contrib/binary-i386/Packages.gz
>   Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://debian.mirror.lrz.de/debian/dists/stable/contrib/i18n/Translation-en
>   Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://debian.mirror.lrz.de/debian/dists/stable/contrib/Contents-amd64
> Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://debian.mirror.lrz.de/debian/dists/stable/contrib/Contents-i386
> Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://mirror.unitedcolo.de/debian/dists/stable/non-free/binary-amd64/Packages.gz
>   Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://mirror.unitedcolo.de/debian/dists/stable/non-free/binary-i386/Packages.gz
>   Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://debian.mirror.lrz.de/debian/dists/stable/non-free/i18n/Translation-en
>   Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://mirror.unitedcolo.de/debian/dists/stable/non-free/Contents-amd64
> Write error - write (28: No space left on device)
> Jul 17 04:43:02 pc8-nb cron-apt[2658]: E: Failed to fetch
> http://ftp.fau.de/debian/dists/stable/non-free/Contents-i386  Write
> error - write (28: No space left on device)
> [...]

