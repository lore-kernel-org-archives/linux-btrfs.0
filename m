Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46325 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaLSI6y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 03:58:54 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A7B713EE1C1
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 17:58:52 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B52D5AC0958
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 17:58:51 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2AC101DB804D
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 17:58:51 +0900 (JST)
Message-ID: <5493E8B0.1080107@jp.fujitsu.com>
Date: Fri, 19 Dec 2014 17:58:24 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
References: <20141217024228.GA5544@pyropus.ca>
In-Reply-To: <20141217024228.GA5544@pyropus.ca>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Sorry for late reply. Let me ask some questions.

On 2014/12/17 11:42, Charles Cazabon wrote:
> Hi,
>
> I've been running btrfs for various filesystems for a few years now, and have
> recently run into problems with a large filesystem becoming *really* slow for
> basic reading.  None of the debugging/testing suggestions I've come across in
> the wiki or in the mailing list archives seems to have helped.
>
> Background: this particular filesystem holds backups for various other
> machines on the network, a mix of rdiff-backup data (so lots of small files)
> and rsync copies of larger files (everything from ~5MB data files to ~60GB VM
> HD images).  There's roughly 16TB of data in this filesystem (the filesystem
> is ~17TB).  The btrfs filesystem is a simple single volume, no snapshots,
> multiple devices, or anything like that.  It's an LVM logical volume on top of
> dmcrypt on top of an mdadm RAID set (8 disks in RAID 6).

Q1. You mean your Btrfs file system exists on the top of
     the following deep layers?

+---------------+
|Btrfs(single)  |
+---------------+
|LVM(non RAID?) |
+---------------+
|dmcrypt        |
+---------------+
|mdadm RAID set |
+---------------+

# Unfortunately, I don't know how Btrfs works in conjunction
#with such a deep layers.

Q2. If Q1 is true, is it possible to reduce that layers as follows?

+-----------+
|Btrfs(*1)  |
+-----------+
|dmcrypt    |
+-----------+

It's because there are too many layers and these have
the same/similar features and heavy layered file system
tends to cause more trouble than thinner layered ones
regardless of file system type.

*1) Currently I don't recommend you to use RAID56 of Btrfs.
     So, if RAID6 is mandatory, mdadm RAID6 is also necessary.

>
> The performance:  trying to copy the data off this filesystem to another
> (non-btrfs) filesystem with rsync or just cp was taking aaaages - I found one
> suggestion that it could be because updating the atimes required a COW of the
> metadata in btrfs, so I mounted the filesystem noatime, but this doesn't
> appear to have made any difference.  The speeds I'm seeing (with iotop)
> fluctuate a lot.  They spend most of the time in the range of 1-3 MB/s, with
> large periods of time where no IO seems to happen at all, and occasional short
> spikes to ~25-30 MB/s.  System load seems to sit around 10-12 (with only 2
> processes reported as running, everything else sleeping) while this happens.
> The server is doing nothing other than this copy at the time.  The only
> processes using any noticable CPU are rsync (source and destination processes,
> around 3% CPU each, plus an md0:raid6 process around 2-3%), and a handful of
> "kworker" processes, perhaps one per CPU (there are 8 physical cores in the
> server, plus hyperthreading).
>
> Other filesystems on the same physical disks have no trouble exceeding 100MB/s
> reads.  The machine is not swapping (16GB RAM, ~8GB swap with 0 swap used).

Q3. They are also consist of the following layers?

+---------------+
|XFS/ext4       |
+---------------+
|LVM(non RAID?) |
+---------------+
|dmcrypt        |
+---------------+
|mdadm RAID set |
+---------------+

Q4. Are other filesystems also near-full?

Q5. Is there any error/warning message about
     Btrfs/LVM/dmcrypt/mdadm/hardwares?

Thanks,
Satoru

>
> Is there something obvious I'm missing here?  Is there a reason I can only
> average ~3MB/s reads from a btrfs filesystem?
>
> kernel is x86_64 linux-stable 3.17.6.  btrfs-progs is v3.17.3-3-g8cb0438.
> Output of the various info commands is:
>
>    $ sudo btrfs fi df /media/backup/
>    Data, single: total=16.24TiB, used=15.73TiB
>    System, DUP: total=8.00MiB, used=1.75MiB
>    System, single: total=4.00MiB, used=0.00
>    Metadata, DUP: total=35.50GiB, used=34.05GiB
>    Metadata, single: total=8.00MiB, used=0.00
>    unknown, single: total=512.00MiB, used=0.00
>
>    $ btrfs --version
>    Btrfs v3.17.3-3-g8cb0438
>
>    $ sudo btrfs fi show
>
>    Label: 'backup'  uuid: c18dfd04-d931-4269-b999-e94df3b1918c
>      Total devices 1 FS bytes used 15.76TiB
>      devid    1 size 16.37TiB used 16.31TiB path /dev/mapper/vg-backup
>
> Thanks in advance for any suggestions.
>
> Charles
>

