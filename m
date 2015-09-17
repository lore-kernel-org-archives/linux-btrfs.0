Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:53881 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbIQR4Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 13:56:16 -0400
Received: from durkon.lan ([178.201.238.189]) by mrelayeu.kundenserver.de
 (mreue101) with ESMTPSA (Nemesis) id 0MTQ5X-1ZCx9F0QfH-00SNmf for
 <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 19:56:14 +0200
Received: from xykon.lan (xykon.lan [192.168.2.42])
	by durkon.lan (Postfix) with ESMTPSA id 2539A85EA
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 19:56:09 +0200 (CEST)
Subject: Re: BTRFS as image store for KVM?
To: linux-btrfs@vger.kernel.org
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
From: Gert Menke <gert@menke.ac>
Message-ID: <55FAFEB8.6030404@menke.ac>
Date: Thu, 17 Sep 2015 19:56:08 +0200
MIME-Version: 1.0
In-Reply-To: <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thank you for your answers!

So it seems there are several suboptimal alternatives here...

MD+LVM is very close to what I want, but md has no way to cope with 
silent data corruption. So if I'd want to use a guest filesystem that 
has no checksums either, I'm out of luck.
I'm honestly a bit confused here - isn't checksumming one of the most 
obvious things to want in a software RAID setup? Is it a feature that 
might appear in the future? Maybe I should talk to the md guys...

BTRFS looks really nice feature-wise, but is not (yet) optimized for my 
use-case I guess. Disabling COW would certainly help, but I don't want 
to lose the data checksums. Is nodatacowbutkeepdatachecksums a feature 
that might turn up in the future?

Maybe ZFS is the best choice for my scenario. At least, it seems to work 
fine for Joyent - their SmartOS virtualization OS is essentially Illumos 
(Solaris) with ZFS, and KVM ported from Linux.
Since ZFS supports "Volumes" (virtual block devices inside a ZPool), I 
suspect these are probably optimized to be used for VM images (i.e. do 
as little COW as possible). Of course, snapshots will always degrade 
performance to a degree.

However, there are some drawbacks to ZFS:
- It's less flexible, especially when it comes to reconfiguration of 
disk arrays. Add or remove a disk to/from a RaidZ and rebalance, that 
would be just awesome. It's possible in BTRFS, but not ZFS. :-(
- The not-so-good integration of the fs cache, at least on Linux. I 
don't know if this is really an issue, though. Actually, I imagine it's 
more of an issue for guest systems, because it probably breaks memory 
ballooning. (?)

So it seems there are two options for me:
1. Go with ZFS for now, until BTRFS finds a better way to handle disk 
images, or until md gets data checksums.
2. Buy a bunch of SSDs for VM disk images and use spinning disks for 
data storage only. In that case, BTRFS should probably do fine.

Any comments on that? Am I missing something?

Thanks!
Gert
