Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbbFRRGe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 13:06:34 -0400
Date: Thu, 18 Jun 2015 19:06:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Facebook <clm@fb.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
Message-ID: <20150618170632.GI6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
 <557B076B.7050500@fb.com>
 <557E86A9.8040207@cn.fujitsu.com>
 <20150615131507.GL6761@twin.jikos.cz>
 <557F7A5F.5010206@cn.fujitsu.com>
 <557F8C78.7080304@cn.fujitsu.com>
 <55822008.1090305@cn.fujitsu.com>
 <1434643066.28534.0@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434643066.28534.0@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 11:57:46AM -0400, Facebook wrote:
> > New new comments?
> 
> As our block sizes get bigger, it makes sense to think about more fine 
> grained checksums.  We're using crcs for:
> 
> 1) memory corruption on the way down to the storage.  We could be very 
> small (bitflips) or smaller chunks (dma corrupting the whole bio).  The 
> places I've seen this in production, the partial crcs might help save a 
> percentage of the blocks, but overall the corruptions were just too 
> pervasive to get back the data.
> 
> 2) incomplete writes.  We're sending down up to 64K btree blocks, the 
> storage might only write some of them.
> 
> 3) IO errors from the drive.  These are likely to fail in much bigger 
> chunks and the partial csums probably won't help at all.
> 
> I think the best way to repair all of these is with replication, either 
> RAID5/6 or some number of mirrored copies.  It's more reliable than 
> trying to stitch together streams from multiple copies, and the code 
> complexity is much lower.

I agree with that. I'm still not convinced that adding all the kernel
code to repair the data is justified, compared to the block-level
redundancy alternatives.

> But, where I do find the partial crcs interesting is the ability to 
> more accurately detect those three failure modes with our larger block 
> sizes.  That's pure statistics based on the crc we've chosen and the 
> size of the block.  The right answer might just be a different crc, but 
> I'm more than open to data here.

Good point, the detection aspect costs only the increased checksumming
and reporting. My assumption is that this will happen infrequently and
can point out serious hardware problems. In that case taking the
filesytem offline is a workable option and improving the userspace tools
to actually attempt the targeted block repair seems easier. Note that
this would come after redundant raid would not be able to fix it.
