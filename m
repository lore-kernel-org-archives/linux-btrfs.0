Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glockenspiel.complete.org ([78.47.53.23]:40189 "EHLO
	glockenspiel.complete.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3LFEsY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Dec 2013 23:48:24 -0500
Message-ID: <52A15710.6010800@complete.org>
Date: Thu, 05 Dec 2013 22:48:16 -0600
From: John Goerzen <jgoerzen@complete.org>
MIME-Version: 1.0
To: russell@coker.com.au
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Extremely slow metadata performance
References: <52A0BD44.9030509@complete.org> <5930575.71jgM0vnzg@xev>
In-Reply-To: <5930575.71jgM0vnzg@xev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2013 05:32 PM, Russell Coker wrote:
> On Thu, 5 Dec 2013 11:52:04 John Goerzen wrote:
>
>  > I have observed extremely slow metadata performance with btrfs. This may
>
>  > be a bit of a nightmare scenario; it involves untarring a backup of
>
>  > 1.6TB of backuppc data, which contains millions of hardlinks and much
>
>  > data, onto USB 2.0 disks.
>
> How does this compare to using Ext4 on the same hardware and same data?

Hi Russell,

I can't perform a direct apples-to-apples comparison here, because the 
capabilities of the filesystems are dissimilar.  We're talking two USB 
drives, one of them 1TB and the other 2TB.  With ext4, I used LVM to 
combine them into a single volume (no striping).

With the best case in btrfs (-m raid0 -d raid0 -- yes I now know that 
wastes space), it is still slower than ext4.  Overall performance with 
backuppc is somewhat slower.  Creation and sometimes deletion of vast 
numbers of hardlinks, or of vast numbers of empty directories, is much 
slower and can lead to processes blocked waiting for I/O to complete for 
so long that they trigger kernel hung task warnings in dmesg with btrfs. 
  Even a simple ls on a directory with <20 files can take minutes to 
complete when tar is creating these directories or links.

one other datapoint: zfs, even zfs-fuse, on the exact same workload as 
btrfs is significantly faster.

> Write speeds as low as 600KB/s isn't uncommon when there's lots of
> seeks. I've seen similar performance from RAID arrays. Is BTRFS doing
> much worse than Ext4 in terms of the number of seeks needed for writing
> that data?

The strange thing is that these writes come in bursts during which 
userland access to the filesystem is apparently paused.  This suggests 
to me that there is some caching going on here (perfectly fine).  But 
given that, it seems some reordering could be taking place here?

usb-storage does not support NCQ, so perhaps also this is an issue of 
higher latency on USB vs. SATA/SCSI.

-- John
