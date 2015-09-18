Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:64703 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbbIRHfC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 03:35:02 -0400
Received: from durkon.lan ([178.201.238.189]) by mrelayeu.kundenserver.de
 (mreue004) with ESMTPSA (Nemesis) id 0MRhLp-1Z9zje3zpp-00SuIf for
 <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 09:34:59 +0200
Received: from g.menke.ac (haley.lan [192.168.2.21])
	by durkon.lan (Postfix) with ESMTPSA id 18ED387CA
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 09:34:59 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 18 Sep 2015 09:34:58 +0200
From: Gert Menke <gert@menke.ac>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
In-Reply-To: <20150917224154.GA23636@wheatley.student.rit.edu>
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
 <20150917224154.GA23636@wheatley.student.rit.edu>
Message-ID: <27fbc341985fb6d11e40b43d10d93a33@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-09-18 00:41, Sean Greenslade wrote:

> MD is emulating hardware RAID. In hardware RAID, you are doing
> work at the block level. Block-level RAID has no understanding of the
> filesystem(s) running on top of it. Therefore it would have to checksum
> groups of blocks, and store those checksums on the physical disks
> somewhere, perhaps by keeping some portion of the drive for itself.

Of course.

> But
> then this is not very efficient, since it is maintaining checksums for
> data that may be useless (blocks the FS is not currently using).

Correct. But when a disk needs to be swapped you have the same problem - 
the whole disk needs to be rewritten, because the RAID controller (or 
software) does not know about the filesystem. TRIM might help in this 
case.

> So then
> you might make the RAID filesystem aware...and you now have BTRFS RAID.

Right. As long as I don't want to turn off COW.

> Simply put, the block level is probably not an appropriate place for
> checksumming to occur. BTRFS can make checksumming work much more
> effectively and efficiently by doing it at the filesystem level.

Well, yes and no. The Block level needs checksums to identify silent 
data corruption - without access to the block layer, the fs can only 
detect a faulty block, but cannot recover it, even in a raid setting. 
And without access to the fs, the block layer is inefficient, as you 
said. So, BTRFS and ZFS are doing the right thing by sacrificing the 
strict boundary between block and fs layer, imo.

Gert
