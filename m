Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56156 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab3HGIAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 04:00:37 -0400
Date: Wed, 7 Aug 2013 16:00:27 +0800
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Arne Jansen <sensille@gmx.net>
Subject: Re: Heavy memory leak when using quota groups
Message-ID: <20130807160027.188b340b@wpkg.org>
In-Reply-To: <20130807004227.6b2b688e@wpkg.org>
References: <20130806003505.7d7feff6@wpkg.org>
	<5200888A.4030109@gmx.net>
	<20130807004227.6b2b688e@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 7 Aug 2013 00:42:27 +0800
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> > What do I have to do to reproduce it here? How do you generate the
> > load? What is the disk setup, what the qgroups setup?
> 
> Unfortunately I don't have a way to reproduce, as the issue
> happened to me only once.

I keep removing the files, and memory usage has grown to 28 GB (out of
32 GB).

Is there anything I can debug at this point?

# free
             total       used       free     shared    buffers     cached
Mem:      32638512   32476992     161520          0        732    3531152
-/+ buffers/cache:   28945108    3693404
Swap:     16776116     173392   16602724


# cat /proc/meminfo
MemTotal:       32638512 kB
MemFree:          163364 kB
Buffers:             864 kB
Cached:          3531940 kB
SwapCached:        60992 kB
Active:          3599804 kB
Inactive:        2422176 kB
Active(anon):    1860412 kB
Inactive(anon):   629848 kB
Active(file):    1739392 kB
Inactive(file):  1792328 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      16776116 kB
SwapFree:       16602916 kB
Dirty:             85432 kB
Writeback:         10320 kB
AnonPages:       2458792 kB
Mapped:            11068 kB
Shmem:               796 kB
Slab:            3168820 kB
SReclaimable:    3099388 kB
SUnreclaim:        69432 kB
KernelStack:        3408 kB
PageTables:        14764 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    33095372 kB
Committed_AS:    4301988 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      130036 kB
VmallocChunk:   34359595900 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       12520 kB
DirectMap2M:    33220608 kB

-- 
Tomasz Chmielewski
http://wpkg.org
