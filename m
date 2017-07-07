Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752314AbdGGQQ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Jul 2017 12:16:29 -0400
Date: Fri, 7 Jul 2017 18:15:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        markus@trippelsdorf.de, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        dsterba@suse.com, marc.c.dionne@gmail.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v2] btrfs: Correct assignment of pos
Message-ID: <20170707161510.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170705033307.8213-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170705033307.8213-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 04, 2017 at 10:33:07PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Assigning pos for usage early messes up in append mode, where
> the pos is re-assigned in generic_write_checks(). Assign
> pos later to get the correct position to write from iocb->ki_pos.
> 
> Since check_can_nocow also uses the value of pos, we shift
> generic_write_checks() before check_can_nocow(). Checks with
> IOCB_DIRECT are present in generic_write_checks(), so checking
> for IOCB_NOWAIT is enough.
> 
> Also, put locking sequence in the fast path.
> 
> Changes since v1:
>  - Moved pos higher up to encompass check_can_nocow() call.
> 
> Fixes: edf064e7c6fe ("btrfs: nowait aio support")
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Acked-by: David Sterba <dsterba@suse.com>
