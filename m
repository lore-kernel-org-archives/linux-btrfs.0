Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:48123 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaFCRAi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 13:00:38 -0400
Message-ID: <538DFFEB.105@libero.it>
Date: Tue, 03 Jun 2014 19:03:39 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: some project ideas: NFS4 ACLs, resilience on the same device,
 allowing to specify which devices are "distinct" in a RAID
References: <1401731056.4904.9.camel@heisenberg.scientia.net>
In-Reply-To: <1401731056.4904.9.camel@heisenberg.scientia.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/02/2014 07:44 PM, Christoph Anton Mitterer wrote:
> Hi.
> 
> Christian Kujau suggested in the wiki[] to post project ideas to the
> list to give them some possible wider discussion.
> 
> So far I've had these ideas:
> 
> 1) NFS 4 ACLs[1]
> Not sure whether it has been proposed and/or rejected before),... but it
> would be nice if it was a goal for btrfs to support NFS4 ACLs.
> 
> These are much more powerful than POSIX.1e ACLs... and I think it would
> be nice if all the major Linux filesystems would support them in
> addition or as an alternative to the POSIX.1e ACLs. Of course one would
> have to think about a schema what happens when there are ACLs of both
> types in place for a file, whether this is allowed at all or not and how
> rules would be merged.

There is (was ?) a project to address that: richacl http://www.bestbits.at/richacl/.
This is not a btrfs project, but a linux kernel project because from a filesystem  POV the implementation requires to store some information in a extended attributes: the check is performed at the VFS level.

[...]
> 
> 
> 3) allow to tell btrfs which devices are really distinct in a RAID
> For some reasons people may have setups e.g. like this:
> /dev/sda1
> /dev/sda2
> /dev/sdb1
> /dev/sdc1
> Now one could create a RAID5 on them, but apparently sda1 and sda2 are
> on the same disk... so I'd like a way to tell btrfs that these are the
> "same" and not really that redundant.

Hugo Mill worked on something related to that [1]

[1] "Thoughts on RAID nomenclature" http://www.spinics.net/lists/linux-btrfs/msg33782.html

> 
> 
> Cheers,
> Chris.
> 
> [0] https://btrfs.wiki.kernel.org/index.php?title=Talk%3AProject_ideas&action=historysubmit&diff=26841&oldid=26831
> [1] https://btrfs.wiki.kernel.org/index.php/Talk:Project_ideas#NFS4_ACLS
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
