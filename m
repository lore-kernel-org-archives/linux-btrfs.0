Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:42791 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbbI1Vzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 17:55:38 -0400
Subject: Re: btrfs fi defrag interfering (maybe) with Ceph OSD operation
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <56080C9A.6030102@bouton.name>
 <pan$be4b9$74318552$9c70286d$e18abb29@cox.net> <56090E83.4030708@bouton.name>
 <pan$a0ad5$3d2cb4dd$ab00a420$4a68e0c6@cox.net>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5609B757.4080802@bouton.name>
Date: Mon, 28 Sep 2015 23:55:35 +0200
MIME-Version: 1.0
In-Reply-To: <pan$a0ad5$3d2cb4dd$ab00a420$4a68e0c6@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/09/2015 22:52, Duncan a écrit :
> Lionel Bouton posted on Mon, 28 Sep 2015 11:55:15 +0200 as excerpted:
>
>> From what I understood, filefrag doesn't known the length of each extent
>> on disk but should have its position. This is enough to have a rough
>> estimation of how badly fragmented the file is : it doesn't change the
>> result much when computing what a rotating disk must do (especially how
>> many head movements) to access the whole file.
> AFAIK, it's the number of extents reported that's the problem with 
> filefrag and btrfs compression.  Multiple 128 KiB compression blocks can 
> be right next to each other, forming one longer extent on-device, but due 
> to the compression, filefrag sees and reports them as one extent per 
> compression block, making the file look like it has perhaps thousands or 
> tens of thousands of extents when in actuality it's only a handful, 
> single or double digits.

Yes but that's not a problem for our defragmentation scheduler: we
compute the time needed to read the file based on a model of the disk
where reading consecutive compressed blocks has no seek cost, only the
same revolution cost as reading the larger block they form. The cost of
fragmentation is defined as the ratio between this time and the time
computed with our model if the blocks were purely sequential.

>
> In that regard, length or position neither one matter, filefrag will 
> simply report a number of extents orders of magnitude higher than what's 
> actually there, on-device.

Yes but filefrag -v reports the length and position and we can then find
out based purely on the positions if extents are sequential or random.

If people are interested by the details I can discuss them in a separate
thread (or a subthread with a different title). One thing in particular
surprised me and could be an interesting separate discussion: according
to the extents positions reported by filefrag -v, defragmentation can
leave extents in several sequences at different positions on the disk
leading to an average fragmentation cost for compressed files of 2.7x to
3x compared to the ideal case (note that this is an approximation: we
consider files compressed if more than half of their extents are
compressed by checking for "encoded" in the extent flags). This is
completely different for uncompressed files: here defragmentation is
completely effective and we get a single extent most of the time. So
there's at least 3 possibilities : an error in positions reported by
filefrag (and the file is really defragmented), a good reason to leave
these files fragmented or an opportunity for optimization.

But let's remember our real problem: I'm still not sure if calling btrfs
fi defrag <file> can interfere with any concurrent operation on <file>
leading to an I/O error. As this has the potential to bring our platform
down in our current setup the answer I really hope this will catch the
attention of someone familiar with the technical details of btrfs fi defrag.

Best regards,

Lionel Bouton
