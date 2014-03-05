Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35502 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754729AbaCEDdD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 22:33:03 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:60762 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WL2Zm-000veO-JD
	for linux-btrfs@vger.kernel.org; Tue, 04 Mar 2014 20:32:58 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
Date: Tue, 4 Mar 2014 20:32:57 -0700
Message-Id: <73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>,<20140303183911.GL13899@carfax.org.uk> <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 4, 2014, at 5:27 PM, Mike Russo <mike@PaperSolve.com> wrote:

> Chris Murphy <lists <at> colorremedies.com> writes:
> 
>>> How can I find out what file is on the block group that 
>>> it's having a problem with?
>> 
>> I think that's btrfs-debug-tree -b ? But don't hold me to that. 
>> I haven't done enough debugging to find files
>> from block numbers. Another that might be relevant is 
>> btrfs inspect-internal logical-resolve.
>> 
> 
> Nah, I don't think they're talking about the same thing. The messages I get in syslog for the 2 blocks are:
> 
> Mar  4 07:59:23 ossy kernel: [124731.175116] BTRFS info (device sdd1): relocating block group 894460493824 flags 1
> Mar  4 07:59:32 ossy kernel: [124739.613467] BTRFS error (device sdd1): allocation failed flags 17, wanted 1368420352
> Mar  4 07:59:32 ossy kernel: [124739.613473] BTRFS: space_info 1 has 105551204352 free, is not full
> Mar  4 07:59:32 ossy kernel: [124739.613476] BTRFS: space_info total=1312112508928, used=1201166741504, pinned=0, reserved=565596160, may_use=1368420352, readonly=4828966912
> 
> Mar  4 10:49:33 ossy kernel: [134932.248146] BTRFS info (device sdd1): relocating block group 846142111744 flags 1
> Mar  4 10:49:39 ossy kernel: [134938.440347] BTRFS error (device sdd1): allocation failed flags 17, wanted 1219825664
> Mar  4 10:49:39 ossy kernel: [134938.440353] BTRFS: space_info 1 has 116232978432 free, is not full
> Mar  4 10:49:39 ossy kernel: [134938.440356] BTRFS: space_info total=1322849927168, used=1201311391744, pinned=0, reserved=476590080, may_use=1224540160, readonly=4828966912
> 
> But if I try to examine either of those block groups I get an error message that makes me think the 2 numbers are not really the same thing. 

You could also try a full defragment by specifying -r on the mount point with a small -t value to effectively cause everything to be subject to defragmenting. If this still doesn't permit soft rebalance, then maybe filefrag can find files that have more than 1 extent and just copy them (make duplicates, delete the original). Any copy will be allocated into chunks with the new profile.


> 
> If anyone knows why that allocation should fail (what is "flags 17"?), or how to force something more to happen, please reply. I'm sure this is due to the ext4 conversion, but that means the utility is making a btrfs filesystem that later can't be converted to another profile for some reason. 

The conversion description sounds like the main thing that's occurring is adding Btrfs metadata. The ext4 data and metadata are left intact. I'm not sure what the ext4 allocation looks like compared to data allocated into chunks by Btrfs directly. That could be a contributing factor, but it's also possible older Btrfs filesystems get fragmented in a similar way that they could have profile conversion problems too. Answering that would help determine if btrfs-convert or the rebalancing code needs to account for this possibility. A reproducer would be useful.


Chris Murphy

