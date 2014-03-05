Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zixgateway01.papersolve.com ([71.125.1.135]:13954 "EHLO
	sw-email.stardatecomputer.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756174AbaCEA1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 19:27:35 -0500
Received: from sw-email.stardatecomputer.com (127.0.0.1) id h2pnne0171sv for <linux-btrfs@vger.kernel.org>; Tue, 4 Mar 2014 19:27:33 -0500 (envelope-from <mike@PaperSolve.com>)
From: Mike Russo <mike@PaperSolve.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: ENOSPC errors during raid1 rebalance
Date: Wed, 5 Mar 2014 00:27:32 +0000
Message-ID: <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>,<20140303183911.GL13899@carfax.org.uk>
In-Reply-To: <20140303183911.GL13899@carfax.org.uk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:

> > How can I find out what file is on the block group that 
> > it's having a problem with?
> 
> I think that's btrfs-debug-tree -b ? But don't hold me to that. 
> I haven't done enough debugging to find files
> from block numbers. Another that might be relevant is 
> btrfs inspect-internal logical-resolve.
> 

Nah, I don't think they're talking about the same thing. The messages I get in syslog for the 2 blocks are:

Mar  4 07:59:23 ossy kernel: [124731.175116] BTRFS info (device sdd1): relocating block group 894460493824 flags 1
Mar  4 07:59:32 ossy kernel: [124739.613467] BTRFS error (device sdd1): allocation failed flags 17, wanted 1368420352
Mar  4 07:59:32 ossy kernel: [124739.613473] BTRFS: space_info 1 has 105551204352 free, is not full
Mar  4 07:59:32 ossy kernel: [124739.613476] BTRFS: space_info total=1312112508928, used=1201166741504, pinned=0, reserved=565596160, may_use=1368420352, readonly=4828966912

Mar  4 10:49:33 ossy kernel: [134932.248146] BTRFS info (device sdd1): relocating block group 846142111744 flags 1
Mar  4 10:49:39 ossy kernel: [134938.440347] BTRFS error (device sdd1): allocation failed flags 17, wanted 1219825664
Mar  4 10:49:39 ossy kernel: [134938.440353] BTRFS: space_info 1 has 116232978432 free, is not full
Mar  4 10:49:39 ossy kernel: [134938.440356] BTRFS: space_info total=1322849927168, used=1201311391744, pinned=0, reserved=476590080, may_use=1224540160, readonly=4828966912

But if I try to examine either of those block groups I get an error message that makes me think the 2 numbers are not really the same thing. 

root@ossy:~# /usr/src/btrfs-progs/btrfs-debug-tree -b 894460493824 /dev/sdc1
Check tree block failed, want=894460493824, have=7159859086769936959
Check tree block failed, want=894460493824, have=7159859086769936959
Check tree block failed, want=894460493824, have=7159859086769936959
read block failed check_tree_block
Check tree block failed, want=894460493824, have=7159859086769936959
Check tree block failed, want=894460493824, have=7159859086769936959
Check tree block failed, want=894460493824, have=7159859086769936959
read block failed check_tree_block
failed to read 894460493824

Sigh. So I'm stuck at 10GB on single, but I don't know which 10GB it is. 

root@ossy:~# /usr/src/btrfs-progs/btrfs fi df /mymedia
Data, RAID1: total=1.21TiB, used=1.09TiB
Data, single: total=10.00GiB, used=5.50GiB
System, RAID1: total=32.00MiB, used=180.00KiB
Metadata, RAID1: total=2.00GiB, used=1.45GiB

If anyone knows why that allocation should fail (what is "flags 17"?), or how to force something more to happen, please reply. I'm sure this is due to the ext4 conversion, but that means the utility is making a btrfs filesystem that later can't be converted to another profile for some reason. 

