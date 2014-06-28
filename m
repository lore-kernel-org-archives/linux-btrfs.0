Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.ispfabriek.nl ([37.251.0.169]:36079 "EHLO
	smtp2.ispfabriek.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaF1Hog (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 03:44:36 -0400
Received: from localhost (unknown [10.3.1.68])
	by smtp2.ispfabriek.nl (Postfix) with ESMTP id D103B41AFF
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 07:37:10 +0000 (UTC)
Received: from smtp2.ispfabriek.nl ([10.3.1.141])
	by localhost (mailscan2.ispfabriek.nl [10.3.1.68]) (amavisd-new, port 10026)
	with ESMTP id cT5dSgPuNXOl for <linux-btrfs@vger.kernel.org>;
	Sat, 28 Jun 2014 09:36:56 +0200 (CEST)
Received: from study.mannem.nl (77-175-145-86.FTTH.ispfabriek.nl [77.175.145.86])
	by smtp2.ispfabriek.nl (Postfix) with ESMTP id 21B8541937
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 09:36:56 +0200 (CEST)
From: Sebastiaan Mannem <sebas@mannem.nl>
To: linux-btrfs@vger.kernel.org
Subject: IO stripe size and other optimizations
Date: Sat, 28 Jun 2014 09:36:55 +0200
Message-ID: <14787157.YvXlcYQe2L@study.mannem.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I'm an Oracle DBA for the dutch government.
In private I'm an enthousiastic btrfs user for some (2) years and I'm looking 
forward to introducing it at work as as RedHat will support it (hopely with 
RHEL7).
Last couple of weeks i've been testing different storage options for Oracle 
Database files:
- LVMStriping with ext4
- Software Raid with LVM and ext4
- Software Raid directly with ext4 (without LVM)
- btrfs (directly on partitions)
- ASM

To optimize performance I've been actively looking at some IOstat numbers.
Btrfs did not do really good and I think I know the main reason.
Both with ext4 and ASM Oracle could do large 'multiple block writes' and large 
'multiple block reads' (looking at avgrq-sz). With btrfs I found that the 
latency was actually better, but the avgrq-sz was verry small. 
So, much IO's but small IO's and therefore not so much MBPS. I think that this 
is because the 'The stripe size is fixed to 64KB for now. '...
Please be aware that this is the 'technology preview version of btrfs with 
RH6'. This is not exactly bleeding edge, so some performance enhancements yet 
comitted might not be part of this tests.

However, this got me thinking. 
Thing is that I had to set a stripesize for both Software Raid and LVM 
Striping. ASM is a little optimized in this part, being that it can set a 
stripe size per filetype (datafiles 1MiB and redo 128k, as I recall).
So large IO's can be written with large requests and small IO's can be striped 
accross many disks.
If there is a possibility to let the stripesize be dependent on the request 
size for a write, you might have simmilar to as for ASM optimisation, and 
better, sinds it is not depending on 'the filesystem knowing the filetype'. I 
think that this would be a great enhancement for large files with big IO's. And 
might give btrfs a lead to more conventional filesystems like ext4 and xfs.

Is there an option to bring this in development? Is it allready thought of, 
planned? When could it be available?
And if practical I could get involved somehow. Perhaps testing with workloads.
Please let me know on your thoughts on this matter...
