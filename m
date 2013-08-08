Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39227 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3HHDwX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 23:52:23 -0400
Received: by mail-vb0-f46.google.com with SMTP id p13so2772780vbe.33
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Aug 2013 20:52:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130807160027.188b340b@wpkg.org>
References: <20130806003505.7d7feff6@wpkg.org>
	<5200888A.4030109@gmx.net>
	<20130807004227.6b2b688e@wpkg.org>
	<20130807160027.188b340b@wpkg.org>
Date: Wed, 7 Aug 2013 23:52:23 -0400
Message-ID: <CALJXSJq9jYXCt0BZipeg11kWcOp9EKv=tZ-i8GcQcyJGgc-2Sw@mail.gmail.com>
Subject: Re: Heavy memory leak when using quota groups
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm pretty I encountered the same leak over here, 15 days uptime and I
had consistent out of memory problems, I got angry and did go in
single user mode and noticed that with only systemd->screen->bash(2) I
had 2 GB of memory used on 4 GB total. This box mostly has random
reads and just before the out of memory condition had 12 GB written to
a lot of files.

# btrfs qgroup show /mnt/btrfs
0/337 13953818624 9494970368
0/338 0 0
0/353 20934205440 20934205440
0/373 36420952064 36420952064
0/668 0 19161088
0/669 21279420416 16839733248
0/890 -97652736 -97652736
0/907 65536 65536
0/910 0 0

Screenshot of top/processes/memory: http://i39.tinypic.com/2rrrjtl.jpg

On Wed, Aug 7, 2013 at 4:00 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> On Wed, 7 Aug 2013 00:42:27 +0800
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>
>> > What do I have to do to reproduce it here? How do you generate the
>> > load? What is the disk setup, what the qgroups setup?
>>
>> Unfortunately I don't have a way to reproduce, as the issue
>> happened to me only once.
>
> I keep removing the files, and memory usage has grown to 28 GB (out of
> 32 GB).
>
> Is there anything I can debug at this point?
>
> # free
>              total       used       free     shared    buffers     cached
> Mem:      32638512   32476992     161520          0        732 3531152
> -/+ buffers/cache:   28945108    3693404
> Swap:     16776116     173392   16602724
>
>
> # cat /proc/meminfo
> MemTotal:       32638512 kB
> MemFree:          163364 kB
> Buffers:             864 kB
> Cached:          3531940 kB
> SwapCached:        60992 kB
> Active:          3599804 kB
> Inactive:        2422176 kB
> Active(anon):    1860412 kB
> Inactive(anon):   629848 kB
> Active(file):    1739392 kB
> Inactive(file):  1792328 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:      16776116 kB
> SwapFree:       16602916 kB
> Dirty:             85432 kB
> Writeback:         10320 kB
> AnonPages:       2458792 kB
> Mapped:            11068 kB
> Shmem:               796 kB
> Slab:            3168820 kB
> SReclaimable:    3099388 kB
> SUnreclaim:        69432 kB
> KernelStack:        3408 kB
> PageTables:        14764 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    33095372 kB
> Committed_AS:    4301988 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      130036 kB
> VmallocChunk:   34359595900 kB
> HardwareCorrupted:     0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:       12520 kB
> DirectMap2M:    33220608 kB
>
> --
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
