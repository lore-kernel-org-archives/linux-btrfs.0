Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbbCSNVk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 09:21:40 -0400
Date: Thu, 19 Mar 2015 14:21:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Message-ID: <20150319132139.GE20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9389540.MYekrP2a8Q@merkaba>
 <1929370.YSr7hGqtmM@merkaba>
 <20150318135230.GA20767@twin.jikos.cz>
 <7757761.93uGJVH8dW@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <7757761.93uGJVH8dW@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 03:23:50PM +0100, Martin Steigerwald wrote:
> It explains that having a correct hardlink number for directory is not 
> mandatory, but it doesn´t explain why BTRFS always has 1 in there instead 
> of the actual count of hardlinks. Is this an performance optimization for 
> BTRFS or are there any other reasons why BTRFS does it this way?

I believe it's for performance reasons. New inodes do not update the
parent directory metadata wrt link counts, compared to other filesystems
that do that.

The real performance hit could be noticeable. The directory inode is
cached in memory, so first update would be a bit slower, but the
metadata block needs to be cow-ed on each new file. It's stress on
b-tree locking and allocating new buffers for the metadata blocks.
