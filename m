Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:54336
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847Ab2J1S1b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 14:27:31 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201210281216.43983.Martin@lichtvoll.de>
Date: Sun, 28 Oct 2012 12:27:27 -0600
Message-Id: <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com>
References: <50899151.1070503@inwind.it> <201210281133.10571.Martin@lichtvoll.de> <508D0FC5.1020404@inwind.it> (sfid-20121028_115841_603788_B8F3E1BA) <201210281216.43983.Martin@lichtvoll.de>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 28, 2012, at 5:16 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:

> The question whether how these are all related to the question on how much 
> space is free?

This is my main confusion with 'filesystem df' is that it's very circumspect about this. For a way longer time than I think is OK, I'd use 'fi show' expecting to see single, raid0, raid1 information, but of course that's in df. Whereas I find I get more useful, though still circumspect, usage information from which to infer free space from fi show than fi df. Small problem.


> IMHO it would then be good to also fix regular df to provide a free space 
> like in the summary view. Maybe by being conservative and using the 
> smallest estimation. But mabye its just me who never really understood why 
> a 100 GB BTRFS RAID1 shows 200GB of free space and a 100 MB file on it 
> occupies 200MB.

It's a perspective.

I think we're all trained to see file size as absolute, even when the file is in effect duplicated. I think it's possible we need to be retrained to look at this from a storage point of view. The storage "pool" is 200GB in size, and data allocation is 2x in raid1. I find new users intuit this, rather than thinking the file size is no different, there in a sense no second copy, but the file system is half the size. With conventional raid, this logic sorta works because the raid isn't a file system, so the filesystem really wasn't twice the size. But in btrfs it is. Same for ZFS for that matter.

When considering how du will work down the road with per subvolume, and possibly per file (or folder) redundancy levels, I think everything should be treated literally. The volume/pool is the total size of storage. And then the "disk usage" hit is file size times a redundancy factor. For single and raid0, 1x. For raid1, 2x. If mixed raid5/6 is one day possible too, then it can have a variable factor depending on the stripe/parity ratio. In any case, the *allocation* required for each file is really its size in the file system. How many bytes are in the file is a different inquiry anyway due to metadata which is not part of the file contents anyway.


Chris Murphy


