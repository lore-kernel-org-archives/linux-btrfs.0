Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:43106 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbbIDI2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 04:28:25 -0400
Subject: Re: How to properly and efficiently balance RAID6 after more drives
 are added?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <55E6CF72.5070005@netcologne.de>
 <20150902113021.GD11358@carfax.org.uk> <55E6F51B.3000007@netcologne.de>
 <pan$45a25$fd021e31$91d1cbe2$220454a1@cox.net>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <55E95625.2030406@netcologne.de>
Date: Fri, 4 Sep 2015 10:28:21 +0200
MIME-Version: 1.0
In-Reply-To: <pan$45a25$fd021e31$91d1cbe2$220454a1@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Ducan,

thanks a million for taking the time an effort to explain all that.
I understand that all the devices must have been chunk-allocated for
btrfs to tell me all available "space" was used (read "allocated to data
chunks").

The filesystem is quite old already with kernels starting at 3.12 (I
believe) and now 4.2 with always the most current version of btrfs-progs
debian has available.


On 09/03/2015 04:22 AM, Duncan wrote:
> But what we /do/ know from what you posted (from after the add), the 
> previously existing devices are "100% chunk-allocated", size 3.64 TiB, 
> used 3.64 TiB, on each of the first eight devices.
> 
> I don't know how much of (the user docs on) the wiki you've read, and/or 
> understood, but for many people, it takes awhile to really understand a 
> few major differences between btrfs and most other filesystems.
> 
> 1) Btrfs separates data and metadata into separate allocations, 
> allocating, tracking and reporting them separately.  While some 
> filesystems do allocate separately, few expose the separate data and 
> metadata allocation detail to the user.
> 
> 2) Btrfs allocates and uses space in two steps, first allocating/
> reserving relatively large "chunks" from free-space into separate data 
> and metadata chunks, then using space from these chunk allocations as 
> needed, until they're full and more must be allocated.  Nominal[1] chunk 
> size is 1 GiB for data, 256 MiB for metadata.

> 3) Up until a few kernel cycles ago, btrfs could and would automatically 
> allocate chunks as needed, but wouldn't deallocate them when they 
> emptied.  Once they were allocated for data or metadata, that's how they 
> stayed allocated, unless/until the user did a balance manually, at which 
> point the chunk rewrite would consolidate the used space and free any 
> unused chunk-space back to the unallocated space pool.

> The result was that given normal usage writing and deleting data, over 
> time, all unallocated space would typically end up allocated as data 
> chunks, such that at some point the filesystem would run out of metadata 
> space and need to allocate more metadata chunks, but couldn't, because of 
> all those extra partially to entirely empty data chunks that were 
> allocated and never freed.
> 
> Since IIRC 3.17 or so (kernel cycle from unverified memory, but that 
> should be close), btrfs will automatically deallocate chunks if they're 
> left entirely empty, so the problem has disappeared to a large extent, 
> tho it's still possible to eventually end up with a bunch of not-quite-
> empty data chunks, that require a manual balance to consolidate and clean 
> up.


I am running a full balance now, it's at 94% remaining (running for 48
hrs already ;-) ).

Is there any way I should / could "scan" for empty data chunks or almost
empty data chunks which could be freed in order to have more chunks
available for the actual balancing or new chunks that should be used
with a 10 drive RAID6? I understand that btrfs NOW does that somewhat
automagically, but my FS is quite old and used already and there is new
data coming in all the time, so I wand that properly spread across all
the drives.


Regards

Christian
