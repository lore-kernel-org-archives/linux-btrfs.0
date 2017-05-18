Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933388AbdERO4S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 10:56:18 -0400
Date: Thu, 18 May 2017 16:55:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: dedicated error codes for the block layer
Message-ID: <20170518145508.GR4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170518131812.22956-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170518131812.22956-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 03:17:57PM +0200, Christoph Hellwig wrote:
> This series introduces a new blk_status_t error code type for the block
> layer so that we can have tigher control and explicit semantics for
> block layer errors.
> 
> All but the last three patches are cleanups that lead to the new type.
> 
> The series it mostly limited to the block layer and drivers, and touching
> file systems a little bit.  The only major exception is btrfs, which
> does funny things with bios and thus sees a larger amount of propagation
> of the new blk_status_t.

JFYI, the patches 13 and 15 are missing, not in linux-btrfs mailbox and
patchwork web. Does not look like a delay, maybe vger refused them
completely.
