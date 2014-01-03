Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaACSNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 13:13:42 -0500
Date: Fri, 3 Jan 2014 19:13:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Question about ext4 conversion and leaf size
Message-ID: <20140103181340.GT6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <pan.2014.01.03.00.30.03@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.01.03.00.30.03@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 12:29:51AM +0000, Holger Hoffstätte wrote:
> Conversion from ext4 works really well and is an important step for
> adoption. After recently converting a large-ish device I noticed
> dodgy performance, even after defragment & rebalance; noticeably
> different from the quite good performance of a newly-created btrfs
> with 16k leaf size, as is the default since recently.
> 
> So I went spelunking and found that the btrfs-convert logic indeed
> uses the ext4 block size as leaf size (from #2220):
> https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/tree/btrfs-convert.c#n2245
> 
> This is typically 4096 bytes and explains the observed performance.
> 
> So while I'm basically familiar with btrfs's design, I know nothing
> about the details of the conversion (I'm amazed that it works so well,
> including rollback!) but can/should this not be updated to the new default
> of 16k, or is there a strong necessary correlation between the ext4 block
> size and the newly created btrfs?

The sectorsize has to be same for ext4 and btrfs, which is 4k
(PAGE_SIZE) nowadays. The btrfs metadata block is not limited by that.

I've tried to implement the dumb & simple support for larger metadata
block some time ago

http://repo.or.cz/w/btrfs-progs-unstable/devel.git/commitdiff/337ac35f5a6ebeaee375329084b89ea4a868b4be?hp=704a08cb8ae8735f8538e637a1be822e76e69d3c

but the conversion did not work properly, and I haven't debugged that
further.


david
