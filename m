Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbcGOJoD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 05:44:03 -0400
Date: Fri, 15 Jul 2016 11:44:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allocate exact page array size in extent_buffer
Message-ID: <20160715094406.GR10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1468499372-24687-1-git-send-email-dsterba@suse.com>
 <3567275.PIHfl50pLS@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3567275.PIHfl50pLS@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2016 at 11:47:07AM +0530, Chandan Rajendra wrote:
> On Thursday, July 14, 2016 02:29:32 PM David Sterba wrote:
> > The calculation of extent_buffer::pages size was done for 4k PAGE_SIZE,
> > but this wastes 15 unused pointers on arches with large page size. Eg.
> > on ppc64 this gives 15 * 8 = 120 bytes.
> >
> 
> The non PAGE_SIZE aligned extent buffer usage in page straddling tests in
> test_eb_bitmaps() need atleast one more page. So how about the following ...
> 
> #define INLINE_EXTENT_BUFFER_PAGES    (BTRFS_MAX_METADATA_BLOCKSIZE / PAGE_SIZE + 1)

Could the extra page pointer be normally used? Ie. not just for the sake
of the tests. I'd rather not waste the bytes. As a compromise, we can do +1
only if the tests are compiled in.
