Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:49574 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3KOHaw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 02:30:52 -0500
Message-ID: <5285CDA9.3020208@libero.it>
Date: Fri, 15 Nov 2013 08:30:49 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: Re: Mixed and raid [was Re: BUG: btrfsRe: Does btrfs "raid1" actually
 provide any resilience?]
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it> <528536F7.6030503@libero.it> <52853ED2.8040606@libero.it> <pan$afa55$861f820e$b8e2b567$4f5d324c@cox.net>
In-Reply-To: <pan$afa55$861f820e$b8e2b567$4f5d324c@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-15 08:12, Duncan wrote:
> Goffredo Baroncelli posted on Thu, 14 Nov 2013 22:21:22 +0100 as
> excerpted:
> 
>> after some tests and looking at the code I discovered that the current
>> mkfs.btrfs doesn't allow any raid profile other than SINGLE for data and
>> meta-data when the mixed metadata/data group is enabled.
> 
> That'd be a big problem for me, here, as I run a separate sub-GiB (640 
> MiB) btrfs filesystem /var/log, in data+metadata raid1 mode.  (The 
> mountpoint is actually /lg, with /var/log a symlink pointing at it.)
> 
[...]
> 
> You're saying data+metadata DUP wouldn't be possible here either, which 
> would make me pretty unhappy too.

The problem should be in mkfs.btrfs not in the btrfs kernel code. So if
the filesystem was created, there should be not problem.

> 
> Fortunately I did those mkfs.btrfs on an earlier btrfs-tools so wasn't 
> affected by this bug, but bug I would indeed call it, for sure!

Anand posted a patch few hours ago (which worked for me). I think that
this bug could be addressed quickly.

BR


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
