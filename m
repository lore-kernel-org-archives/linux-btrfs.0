Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbaDCRBg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Apr 2014 13:01:36 -0400
Date: Thu, 3 Apr 2014 19:01:34 +0200
From: David Sterba <dsterba@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: chandan <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6 EARLY RFC] Btrfs: Get rid of whole page I/O.
Message-ID: <20140403170134.GN29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20140317145555.GG29256@twin.jikos.cz>
 <1785327.CGV06aaKrn@localhost.localdomain>
 <20140319184107.GJ29256@suse.cz>
 <87a9climis.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a9climis.fsf@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 20, 2014 at 08:50:27AM +0530, Aneesh Kumar K.V wrote:
> > On Tue, Mar 18, 2014 at 01:48:00PM +0630, chandan wrote:
> >> The earlier patchset posted by Chandra Seethraman was to get 4k
> >> blocksize to work with ppc64's 64k PAGE_SIZE.
> >
> > Are we talking about metadata block sizes or data block sizes?
> >
> >> The root node of "tree root" tree has 1957 bytes being written by
> >> make_btrfs() (in btrfs-progs).  Hence I chose to do 2k blocksize for
> >> the initial subpagesize-blocksize work. So with this patchset the
> >> supported blocksizes would be in the range 2k-64k.
> >
> > So it's metadata blocks, and in this case 2k looks like the only
> > allowed size that's smaller than 4k, and thus can demonstrage sub-page
> > size allocations. I'm not sure if this is limiting for potential future
> > extensions of metadata structures that could be larger.
> >
> > 2k is ok for testing purposes, but I think a 4k-page machine will hardly
> > use a smaller page size. The more that 16k metadata blocks are now
> > default.
> 
> The goal is to remove the assumption that supported blocks size is >= page
> size. The primary reason to do that is to support migration of disk
> devices across different architectures. If we have a btrfs disk created
> on x86 box with data blocksize 4K and meta data block size 16K we should
> make sure that, the disk can be read/written from ppc64 box (which have a page
> size of 64K). To enable easy testing and community development we are
> now focusing on achieving 2K data blocksize and 2K meata data block size
> on x86. As you said this will never be used in production.
> 
> To achieve that we did the below
> *) Add offset and len to btrfs_io_bio. These are file offsets and
> len. This is later used to unlock extent io tree.
> 
> *) Now we also need to make sure that submit_extent_page only submit
>  contiguous range in the file offset range. ie if we have holes in
>  between we split them into two submit_extent_page.  This ensures that
>  btrfs_io_bio offset and len represent a contiguous range.
> 
> Please let us know whether the above approach is acceptable.

I don't see any apparent problem with this approach.
