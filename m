Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35381 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755770AbdESIV3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 04:21:29 -0400
Date: Fri, 19 May 2017 10:21:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: dedicated error codes for the block layer
Message-ID: <20170519082122.GB1411@lst.de>
References: <20170518131812.22956-1-hch@lst.de> <20170518145508.GR4065@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170518145508.GR4065@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 04:55:08PM +0200, David Sterba wrote:
> JFYI, the patches 13 and 15 are missing, not in linux-btrfs mailbox and
> patchwork web. Does not look like a delay, maybe vger refused them
> completely.

They still haven't made it to linux-block and linux-btrfs, but they did
make it to dm-devel, which is not host on vger.

I also have a git tree here:

   git://git.infradead.org/users/hch/block.git block-errors

Gitweb:

   http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors   
