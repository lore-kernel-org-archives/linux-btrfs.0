Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45225 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752788AbaGXBNM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 21:13:12 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51813 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XA7ap-001bAY-Ps
	for linux-btrfs@vger.kernel.org; Wed, 23 Jul 2014 19:13:12 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [BUG] bogus out of space reported when mounted raid1 degraded
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$83a22$939c719d$63069ee2$976101e3@cox.net>
Date: Wed, 23 Jul 2014 19:13:10 -0600
Message-Id: <48B1705A-635D-4E03-8005-7E7930D970A8@colorremedies.com>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com> <BEB1C719-6B2A-46DC-9CBA-A22F53C6407C@colorremedies.com> <pan$83a22$939c719d$63069ee2$976101e3@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 22, 2014, at 11:24 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Chris Murphy posted on Tue, 22 Jul 2014 20:36:55 -0600 as excerpted:
>> 
>> Used strace on df, think I found the problem so I put it all into a bug.
>> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=80951
> 
> Suggestion for improved bug summary/title:

So as it turns out this is not a bug, but ultimately a bigger problem.

When a btrfs volume is mounted degraded, df's "Available" appears to be showing free blocks in already allocated chunks, multiplied by 2 in the case of raid1.

> ** ON BTRFS RAID1, TWO DEVICES MUST BE PRESENT IN ORDERED TO ALLOCATE NEW 
> CHUNKS.  MOUNTING DEGRADED WITH A SINGLE DEVICE MEANS NO NEW CHUNK 
> ALLOCATION, WHICH MEANS YOU'RE LIMITED TO FILLING UP EXISTING CHUNKS **

I can confirm this behavior (see below).

## mounted degraded, a 13GB btrfs raid1 volume

# df -h
/dev/sdb                  26G   11G  6.1M 100% /mnt/braid
# btrfs fi df /mnt/braid
Data, RAID1: total=5.00GiB, used=5.00GiB
System, RAID1: total=8.00MiB, used=64.00KiB
Metadata, RAID1: total=1.00GiB, used=7.00MiB
unknown, single: total=64.00MiB, used=0.00

cp a 3.0M file to /mnt/braid
cp: error writing ‘/mnt/braid/four/cmurp_120916_124629.jpg’: No space left on device
cp: failed to extend ‘/mnt/braid/four/cmurp_120916_124629.jpg’: No space left on device

Next steps are:
- reconnect missing device and reboot
- mount btrfs volume normally
- retry the 3MB file copy, which works
- umount, disconnect device and reboot
- mount -o degraded

# df
/dev/sdb                 26382984 10519488   2077888  84% /mnt/braid

# df -h
/dev/sdb                  26G   11G  2.0G  84% /mnt/braid

# btrfs fi df /mnt/braid
Data, RAID1: total=6.00GiB, used=5.01GiB
System, RAID1: total=8.00MiB, used=64.00KiB
Metadata, RAID1: total=1.00GiB, used=7.00MiB
unknown, single: total=64.00MiB, used=0.00

Another 1GB chunk has been allocated, and is now possible to write degraded again, up to a GiB of data.



Chris Murphy