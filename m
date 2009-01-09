From: Eric Whitney <eric.whitney@hp.com>
Subject: PROBLEM:  I/O stalls when running fstress against multi-device fs
Date: Fri, 09 Jan 2009 17:12:12 -0500
Message-ID: <4967CBBC.40909@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris:

I can consistently reproduce I/O stalls when running fstress (as found 
in Autotest) against a six volume btrfs filesystem mounted without 
options.  The volumes are independent disks from RAID controllers, and 
the test systems are eight core Intel and AMD machines running current 
btrfs-unstable.

The stalls occur at variable times into the runs.  The affected system 
ceases to do I/O while the kernel continues to report some percentage of 
iowait, and negligible utilization otherwise.  fstress does not complete.

On one occasion, I also caught a warning early in the run which did not 
appear to affect the progress fstress made, as I/O continued for some 
minutes until the system stalled once more.  This behavior appears to be 
rare (1 in 6 trials).

Please note that the fstress test passes for single device btrfs 
filesystems (many trials).

Particulars follow for both cases, including huge web-accessible 
backtraces - please let me know if you'd like more information, etc.

Thanks,
Eric


commit: 755efdc3c4d3b42d5ffcef0f4d6e5b37ecd3bf21

uname -a: Linux bl465cb.lnx.usa.hp.com 2.6.28-btrfs-unstable #1 SMP Thu 
Jan 8 14:34:46 EST 2009 x86_64 GNU/Linux

mounted as: /dev/cciss/c1d5 on /mnt type btrfs (rw)

btrfs-show:
Label: none  uuid: 6c4ea7e8-1e68-4fb6-aa99-254a67ea81f2
	Total devices 6 FS bytes used 4.09GB
	devid    4 size 68.33GB used 3.00GB path /dev/cciss/c1d3
	devid    1 size 68.33GB used 2.02GB path /dev/cciss/c1d0
	devid    5 size 68.33GB used 2.01GB path /dev/cciss/c1d4
	devid    2 size 68.33GB used 2.00GB path /dev/cciss/c1d1
	devid    6 size 68.33GB used 2.01GB path /dev/cciss/c1d5
	devid    3 size 68.33GB used 3.00GB path /dev/cciss/c1d2

Btrfs v0.16-37-gb8271dc


sysrq-w backtraces:

http://free.linux.hp.com/~enw/fstress-multi-iohang-010809/sysrq-w-backtraces

http://free.linux.hp.com/~enw/fstress-multi-iohang-010809/warn-and-sysrq-w-backtraces
