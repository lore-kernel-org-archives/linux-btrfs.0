Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:55355 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaFGIVz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Jun 2014 04:21:55 -0400
Message-ID: <5392CC86.3060009@libero.it>
Date: Sat, 07 Jun 2014 10:25:42 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>, kreijack@inwind.it
CC: linux-btrfs@vger.kernel.org
Subject: Re: some project ideas: NFS4 ACLs, resilience on the same device,
 allowing to specify which devices are "distinct" in a RAID
References: <1401731056.4904.9.camel@heisenberg.scientia.net>	 <538DFFEB.105@libero.it> <1402104897.18904.12.camel@heisenberg.scientia.net>
In-Reply-To: <1402104897.18904.12.camel@heisenberg.scientia.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2014 03:34 AM, Christoph Anton Mitterer wrote:
> On Tue, 2014-06-03 at 19:03 +0200, Goffredo Baroncelli wrote:
>> There is (was ?) a project to address that: richacl
>> http://www.bestbits.at/richacl/. This is not a btrfs project, but a
>> linux kernel project because from a filesystem  POV the
>> implementation requires to store some information in a extended
>> attributes: the check is performed at the VFS level.
> 
>>> Now one could create a RAID5 on them, but apparently sda1 and
>>> sda2 are on the same disk... so I'd like a way to tell btrfs that
>>> these are the "same" and not really that redundant.
>> 
>> Hugo Mill worked on something related to that [1]
>> 
>> [1] "Thoughts on RAID nomenclature"
>> http://www.spinics.net/lists/linux-btrfs/msg33782.html
> 
> 
> Thanks for the info... should I put those 3 ideas to the 
> https://btrfs.wiki.kernel.org/index.php/Project_ideas page? Or is
> that just meant to be edited by the developers?
> 

You can add new ideas to the wiki pages, supporting by link and other info were available. This is the real nature of the wiki pages.

However I am still convinced richacl/nfs4 acl are not strictly related to a specific filesystem.

BR

> Cheers, Chris.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
