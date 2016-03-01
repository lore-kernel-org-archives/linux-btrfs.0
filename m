Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbcCAR7a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 12:59:30 -0500
Date: Tue, 1 Mar 2016 09:59:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <clm@fb.com>, Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] Experimental btrfs encryption
Message-ID: <20160301175927.GA32354@infradead.org>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <20160301162952.GB718307@mother.pipebreaker.pl>
 <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 01, 2016 at 11:46:16AM -0500, Chris Mason wrote:
> We'll definitely move in line with the common API over time.  Thanks
> Anand for starting this!
> 
> I'd prefer that we keep it per-subvolume for now, just because
> subvolumes are so cheap and because it seems like a better collection
> point for general use.  But as the other filesystems add features we'll
> make sure and keep parity with what users expect.

We already have per-file encryption in f2fs and ext4, and both have
a compatible userspace API and ABI.  It would be a pitty to deviate
from that intead of reusing it, and if needed extending it.
