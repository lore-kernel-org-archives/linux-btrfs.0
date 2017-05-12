Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49944 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756910AbdELS2L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 14:28:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d9FII-0008Ny-Pf
        for linux-btrfs@vger.kernel.org; Fri, 12 May 2017 20:28:02 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs/SSD
Date: Fri, 12 May 2017 20:27:56 +0200
Message-ID: <20170512202756.16bd785f@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 18 Apr 2017 15:02:42 +0200
schrieb Imran Geriskovan <imran.geriskovan@gmail.com>:

> On 4/17/17, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> > Regarding BTRFS specifically:
> > * Given my recently newfound understanding of what the 'ssd' mount
> > option actually does, I'm inclined to recommend that people who are
> > using high-end SSD's _NOT_ use it as it will heavily increase
> > fragmentation and will likely have near zero impact on actual device
> > lifetime (but may _hurt_ performance).  It will still probably help
> > with mid and low-end SSD's.  
> 
> I'm trying to have a proper understanding of what "fragmentation"
> really means for an ssd and interrelation with wear-leveling.
> 
> Before continuing lets remember:
> Pages cannot be erased individually, only whole blocks can be erased.
> The size of a NAND-flash page size can vary, and most drive have pages
> of size 2 KB, 4 KB, 8 KB or 16 KB. Most SSDs have blocks of 128 or 256
> pages, which means that the size of a block can vary between 256 KB
> and 4 MB.
> codecapsule.com/.../coding-for-ssds-part-2-architecture-of-an-ssd-and-benchmarking/
> 
> Lets continue:
> Since block sizes are between 256k-4MB, data smaller than this will
> "probably" will not be fragmented in a reasonably empty and trimmed
> drive. And for a brand new ssd we may speak of contiguous series
> of blocks.
> 
> However, as drive is used more and more and as wear leveling kicking
> in (ie. blocks are remapped) the meaning of "contiguous blocks" will
> erode. So any file bigger than a block size will be written to blocks
> physically apart no matter what their block addresses says. But my
> guess is that accessing device blocks -contiguous or not- are
> constant time operations. So it would not contribute performance
> issues. Right? Comments?
> 
> So your the feeling about fragmentation/performance is probably
> related with if the file is spread into less or more blocks. If # of
> blocks used is higher than necessary (ie. no empty blocks can be
> found. Instead lots of partially empty blocks have to be used
> increasing the total # of blocks involved) then we will notice
> performance loss.
> 
> Additionally if the filesystem will gonna try something to reduce
> the fragmentation for the blocks, it should precisely know where
> those blocks are located. Then how about ssd block informations?
> Are they available and do filesystems use it?
> 
> Anyway if you can provide some more details about your experiences
> on this we can probably have better view on the issue.

What you really want for SSD is not defragmented files but defragmented
free space. That increases life time.

So, defragmentation on SSD makes sense if it cares more about free
space but not file data itself.

But of course, over time, fragmentation of file data (be it meta data
or content data) may introduce overhead - and in btrfs it probably
really makes a difference if I scan through some of the past posts.

I don't think it is important for the file system to know where the SSD
FTL located a data block. It's just important to keep everything nicely
aligned with erase block sizes, reduce rewrite patterns, and free up
complete erase blocks as good as possible.

Maybe such a process should be called "compaction" and not
"defragmentation". In the end, the more continuous blocks of free space
there are, the better the chance for proper wear leveling.


-- 
Regards,
Kai

Replies to list-only preferred.

