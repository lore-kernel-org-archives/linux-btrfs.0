Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2FNHE1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 03:04:27 -0400
Date: Thu, 14 Jun 2012 09:04:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Asias He <asias@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v2] block: Drop dead function blk_abort_queue()
Message-ID: <20120614070417.GG8230@kernel.dk>
References: <1339489742-1810-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339489742-1810-1-git-send-email-asias@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12 2012, Asias He wrote:
> This function was only used by btrfs code in btrfs_abort_devices()
> (seems in a wrong way).
> 
> It was removed in commit d07eb9117050c9ed3f78296ebcc06128b52693be,
> So, Let's remove the dead code to avoid any confusion.
> 
> Changes in v2: update commit log, btrfs_abort_devices() was removed
> already.

Thanks Asias, applied.

-- 
Jens Axboe

