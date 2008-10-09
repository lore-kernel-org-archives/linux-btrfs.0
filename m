From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] deny sys_{rename,link} across subvolumes of same disk
Date: Thu, 9 Oct 2008 01:55:10 -0400
Message-ID: <20081009055510.GA24531@infradead.org>
References: <200810090340.50462.trapni@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christian Parpart <trapni@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810090340.50462.trapni@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 09, 2008 at 03:40:50AM +0200, Christian Parpart wrote:
> This patch denies renames and linking of inodes across subvolumes, as it 
> causes disk format corruption.
> 
> I guess a long-term goal *might* be to just handle these special cases with 
> care, to allow them by properly handling this case in the implementation, 
> however, I wasn't unable to do that with my limited knowledge.

I'll post patches in a few days that make sure every subvolume is under
a different vfsmount which also solves this problem.

