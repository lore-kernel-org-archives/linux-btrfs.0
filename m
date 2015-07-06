Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbbGFWeG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jul 2015 18:34:06 -0400
Date: Mon, 6 Jul 2015 15:34:04 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Mordechay Kaganer <mkaganer@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: running duperemove but no free space gain
Message-ID: <20150706223404.GF7507@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 07, 2015 at 12:54:01AM +0300, Mordechay Kaganer wrote:
> I have a btrfs volume which is used as a backup using rsync from the
> main servers. It contains many duplicate files across different
> subvolumes and i have some read only snapshots of each subvolume,
> which are created every time after the backup completes.
> 
> I'm was trying to gain some free space using duperemove (compiled from
> git master of this repo: https://github.com/markfasheh/duperemove).
> 
> Executed like this:
> 
> duperemove -rdAh <first_dir> <second_dir>
> 
> Both directories point to the most recent read only snapshots of the
> corresponding subvolumes, but not to the subvolumes themselves, so i
> had to add -r option. AFAIK, they should point to exactly the same
> data because nothing was changed since the snapshots were taken.
> 
> It runs successfully for several hours and prints out many files which
> are indeed duplicate like this:
> 
> Showing 4 identical extents with id 5164bb47
> Start           Length          Filename
> 0.0     4.8M    "...."
> 0.0     4.8M    "...."
> 0.0     4.8M    "...."
> 0.0     4.8M    "...."
> ....skip...
> [0x78dee80] Try to dedupe extents with id 5164bb47
> [0x78dee80] Dedupe 3 extents (id: 5164bb47) with target: (0.0, 4.8M), "...."
> 
> But the actual free space reported by "df" or by "btrfs fi df" doesn't
> seem to change. Used space and metadata space even increases slightly.

There were some patches for 4.2 which are both on the list and upstream that
fix an issue where the unligned tail of extents wasn't being deduplicated.
It sounds like you may have hit this. So we can tell, can you run the
'show-shared-extents' program that comes with duperemove (or 'filefrag -e')
against two of the files that should have been deduped together and provide
the output here. If most of the extent is showing deduped but there's a
not-deduped tail extent then that's most likely what you're seeing.


> I thought that doing deduplication on a file in one snapshot would
> affect all snapshots/subvolumes that contain this (exact version of
> the) file because they all actually should point to the same data
> extents, am i wrong?

Well the case you're describing is one where dedupe wouldn't work - the
extent would already be considered deduplicated since there is only one of
them.

If the data has changed from one snapshot to another, we've created new
extents (for the new data) and it can be deduped against any other extent.
For duperemove to discover it though you have to provide it a path which
will eventually resolve to those extents (that is, duperemove has to find it
in the file scan stage).
	--Mark

--
Mark Fasheh
