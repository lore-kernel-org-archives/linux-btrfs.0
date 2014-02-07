Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52039 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaBGAph (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 19:45:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WBZZU-0002uy-II
	for linux-btrfs@vger.kernel.org; Fri, 07 Feb 2014 01:45:32 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 01:45:32 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 01:45:32 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Are nocow files snapshot-aware
Date: Fri, 07 Feb 2014 01:32:27 +0100
Message-ID: <r5mdsa-hng.ln1@hurikhan77.spdns.de>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de> <pan$9252f$8363907a$3eaa17a6$f558018@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

>> Ah okay, that makes it clear. So, actually, in the snapshot the file is
>> still nocow - just for the exception that blocks being written to become
>> unshared and relocated. This may introduce a lot of fragmentation but it
>> won't become worse when rewriting the same blocks over and over again.
> 
> That also explains the report of a NOCOW VM-image still triggering the
> snapshot-aware-defrag-related pathology.  It was a _heavily_ auto-
> snapshotted btrfs (thousands of snapshots, something like every 30
> seconds or more frequent, without thinning them down right away), and the
> continuing VM writes would nearly guarantee that many of those snapshots
> had unique blocks, so the effect was nearly as bad as if it wasn't NOCOW
> at all!

The question here is: Does it really make sense to create such snapshots of 
disk images currently online and running a system. They will probably be 
broken anyway after rollback - or at least I'd not fully trust the contents.

VM images should not be part of a subvolume of which snapshots are taken at 
a regular and short interval. The problem will go away if you follow this 
rule.

The same applies to probably any kind of file which you make nocow - e.g. 
database files. Most of those file implement their own way of transaction 
protection or COW system, e.g. look at InnoDB files. Neither they gain 
anything from using IO schedulers (because InnoDB internally does block 
sorting and prioritizing and knows better, doing otherwise even hurts 
performance), nor they gain from file system semantics like COW (because it 
does its own transactions and atomic updates and probably can do better for 
its use case). Similar applies to disk images (imagine ZFS, NTFS, ReFS, or 
btrfs images on btrfs). Snapshots can only do harm here (the only 
"protection" use case would be to have a backup, but snapshots are no 
backups), and COW will probably hurt performance a lot. The only use case is 
taking _controlled_ snapshots - and doing it all 30 seconds is by all means 
NOT controlled, it's completely undeterministic.

-- 
Replies to list only preferred.

