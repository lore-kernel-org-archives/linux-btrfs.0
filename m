Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55689 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbbFKIIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 04:08:37 -0400
Date: Thu, 11 Jun 2015 10:08:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [RFC] add a bi_error field
Message-ID: <20150611080835.GA2655@lst.de>
References: <1433338959-24808-1-git-send-email-hch@lst.de> <20150611075921.GC9634@localhost.localdomain> <20150611080528.GD9634@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150611080528.GD9634@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 04:05:30PM +0800, Liu Bo wrote:
> > Reviewed-by: Liu Bo <bo.li.liu@oracle.com> (btrfs part)
> 
> Also there're some conflicts in btrfs_end_empty_barrier():

Hi Liu,

BIO_EOPNOTSUPP has been removed in the block tree:

http://git.kernel.dk/?p=linux-block.git;a=commitdiff;h=b25de9d6da49b1a8760a89672283128aa8c78345

