Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaCSSlJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 14:41:09 -0400
Date: Wed, 19 Mar 2014 19:41:07 +0100
From: David Sterba <dsterba@suse.cz>
To: chandan <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [PATCH 0/6 EARLY RFC] Btrfs: Get rid of whole page I/O.
Message-ID: <20140319184107.GJ29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20140317145555.GG29256@twin.jikos.cz>
 <1785327.CGV06aaKrn@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1785327.CGV06aaKrn@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 18, 2014 at 01:48:00PM +0630, chandan wrote:
> The earlier patchset posted by Chandra Seethraman was to get 4k
> blocksize to work with ppc64's 64k PAGE_SIZE.

Are we talking about metadata block sizes or data block sizes?

> The root node of "tree root" tree has 1957 bytes being written by
> make_btrfs() (in btrfs-progs).  Hence I chose to do 2k blocksize for
> the initial subpagesize-blocksize work. So with this patchset the
> supported blocksizes would be in the range 2k-64k.

So it's metadata blocks, and in this case 2k looks like the only
allowed size that's smaller than 4k, and thus can demonstrage sub-page
size allocations. I'm not sure if this is limiting for potential future
extensions of metadata structures that could be larger.

2k is ok for testing purposes, but I think a 4k-page machine will hardly
use a smaller page size. The more that 16k metadata blocks are now
default.
