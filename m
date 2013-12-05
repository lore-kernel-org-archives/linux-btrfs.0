Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35898 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3LEXlD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Dec 2013 18:41:03 -0500
From: Russell Coker <russell@coker.com.au>
To: John Goerzen <jgoerzen@complete.org>
Reply-To: russell@coker.com.au
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Extremely slow metadata performance
Date: Fri, 06 Dec 2013 10:41 +1100
Message-ID: <2489440.lJHvyhQY1H@xev>
In-Reply-To: <52A0BD44.9030509@complete.org>
References: <52A0BD44.9030509@complete.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 5 Dec 2013 11:52:04 John Goerzen wrote:
> I have observed extremely slow metadata performance with btrfs. This may
> be a bit of a nightmare scenario; it involves untarring a backup of
> 1.6TB of backuppc data, which contains millions of hardlinks and much
> data, onto USB 2.0 disks.

How does this compare to using Ext4 on the same hardware and same data?

> I have run disk monitoring tools such as dstat while performing these
> operations to see what's going on.
> 
> The behavior I notice is this:
> 
>    * When unpacking large files, the USB drives sustain activity in the
>      20-40 MB/s range, as expected.
>    * When creating vast numbers of hardlinks instead, the activity is
>      roughly this:
>        o Bursts of output from tar due to -v, sometimes corresponding to
>          reads in the 300KB/s range (I suspect this has
>          to do with caching)
>        o Tar blocked for minutes while writes to the disk occur, in the
>          300-600KB/s range.

Is iostat indicating that the disk is at 100% capacity?

> This occurs even when nobarrier,noatime are specified as mount options.
>   I know the disk is capable of far more, because btrfs gets
> far more from it when writing large files.

Write speeds as low as 600KB/s isn't uncommon when there's lots of seeks.  
I've seen similar performance from RAID arrays.  Is BTRFS doing much worse 
than Ext4 in terms of the number of seeks needed for writing that data?

> There are two USB drives in this btrfs filesystem: a 1TB and a 2TB
> drive.  I have tried the raid1, raid0, and single metadata profiles.
> Anecdotal evidence suggests that raid1 performs the worst, raid0 the
> best, and single somewhere in between.  The data is in single mode.
> 
> Is this behavior known and expected?

Last time I did Postal tests I didn't find a lot of difference between BTRFS 
and Ext4 when using 60K average file size (from memory) on a single partition.  
BTRFS did worse when it was using internal RAID-1 and Ext4 was on a Linux 
software RAID-1.  But 60K file size may be larger than the average file you 
use if you use lots of links.

For backups BTRFS seems to perform a lot better (for both creation and 
removing snapshots) if you use snapshots instead of "cp -rl" or equivalent.  
However I have had ongoing problems of BTRFS hanging on snapshot removal which 
aren't fixed in the latest Debian packaged kernels.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/


