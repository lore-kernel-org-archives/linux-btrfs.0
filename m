From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] btrfs-progs: autotoolized and splitup into
	{libbtrfs,tools,tests}
Date: Thu, 9 Oct 2008 01:55:58 -0400
Message-ID: <20081009055558.GB24531@infradead.org>
References: <200810090420.49767.trapni@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christian Parpart <trapni@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810090420.49767.trapni@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 09, 2008 at 04:20:49AM +0200, Christian Parpart wrote:
> Hi,
> 
> this now makes use of autoconf/automake/libtool suite,
> thus, enabling a wider range of platforms etc.
> Although, I've split up the build into tools, lib, and tests,
> making it possible for 3rd-parties to link against libbtrfs now.

I don't think allowing 3rd parties to link against it is a good idea.
It's basically the kernel code with a few wrappers around it, and will
change a lot over time.

