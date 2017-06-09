Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:36472 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751642AbdFIP33 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 11:29:29 -0400
Received: by mail-io0-f171.google.com with SMTP id y77so34569994ioe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jun 2017 08:29:29 -0700 (PDT)
Date: Fri, 9 Jun 2017 09:29:27 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: dedicated error codes for the block layer V3
Message-ID: <20170609152926.GB24734@kernel.dk>
References: <20170603073806.2046-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 03 2017, Christoph Hellwig wrote:
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
> 
> A git tree is also available at:
> 
>     git://git.infradead.org/users/hch/block.git block-errors
> 
> gitweb:
> 
>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors
> 
> Note the the two biggest patches didn't make it to linux-block and
> linux-btrfs last time.  If you didn't get them they are available in
> the git tree above.  Unfortunately there is no easy way to split them
> up.

Added for 4.13, thanks.

-- 
Jens Axboe

