Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46967 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752606AbaAIGpA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 01:45:00 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: REQ: btrfs list <subvols only> option
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2DD5D524-F505-4CF7-8639-8D1BD10495F0@colorremedies.com>
Date: Wed, 8 Jan 2014 23:44:55 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-Id: <E6F1CF4A-1981-44CA-98C6-024D2C7F5BBC@colorremedies.com>
References: <loom.20140109T020430-693@post.gmane.org> <38A0596B-F366-453C-ABC2-D4FB25637403@colorremedies.com> <loom.20140109T045506-475@post.gmane.org> <2DD5D524-F505-4CF7-8639-8D1BD10495F0@colorremedies.com>
To: Alex <alex@bpmit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 8, 2014, at 11:27 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Jan 8, 2014, at 9:06 PM, Alex <alex@bpmit.com> wrote:
> 
>> Chris Murphy <lists <at> colorremedies.com> writes:
>> 
>>> Specify the mount point for the Btrfs file system and it will list all
>> subvols on that file system.
>>> 
>>> Chris Murphy--
>> 
>> Thank you Chris.
>> 
>> When I do that on my version of the 3.12 userland:
>> # btrfs  sub list / -o
>> returns nothing (with no error), which I wasn't quite expecting because
>> there *are* other snapshots and subvols below '/'
> 
> Not if / is a mounted subvolume that itself contains no subvolumes. / is the OS root, it is not the file system subvol=5 root.

Hmm, actually you might have found a bug.


# btrfs subvol list /
ID 272 gen 4276 top level 5 path boot
ID 273 gen 4770 top level 5 path root
ID 274 gen 4680 top level 5 path home
ID 275 gen 265 top level 5 path boot_ro_installed
ID 276 gen 280 top level 5 path root_ro_installed
ID 277 gen 280 top level 5 path home_ro_installed
ID 283 gen 327 top level 5 path boot_ro_installed+updates
ID 284 gen 329 top level 5 path root_ro_installed+updates
ID 285 gen 329 top level 5 path home_ro_installed+updates
ID 286 gen 399 top level 5 path boot_ro.3
ID 287 gen 400 top level 5 path root_ro.3
ID 288 gen 1603 top level 5 path home_ro.3
ID 473 gen 2105 top level 5 path boot_ro.2
ID 474 gen 2106 top level 5 path root_ro.2
ID 475 gen 2107 top level 5 path home_ro.2
ID 476 gen 4136 top level 5 path home/chris/Downloads/git
ID 485 gen 3144 top level 5 path boot_ro.1
ID 486 gen 3145 top level 5 path root_ro.1
ID 487 gen 3146 top level 5 path home_ro.1
ID 488 gen 3880 top level 5 path home/chris/Downloads/git/kernel


# btrfs subvol list / -o
# btrfs subvol list /home -o
# btrfs subvol list /home/chris/Downloads/ -o
# btrfs subvol list /home/chris/Downloads/git -o

It seems for sure that the last three should have reported ID 476 and 488. And probably the first should also have listed 272 and 274.

273 is mounted at /
272 is mounted at /boot
274 is mounted at /home

man btrfs "              -o   print only subvolumes bellow specified <path>."

Small typo while we're at it, below should have one l.




Chris Murphy

