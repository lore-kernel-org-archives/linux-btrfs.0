Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35829 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757135AbcK3OnL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 09:43:11 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5B815AAC8
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 14:43:09 +0000 (UTC)
Date: Wed, 30 Nov 2016 15:43:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Correct value printed by
 assertions/BUG_ON/WARN_ON
Message-ID: <20161130144305.GM12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161129162452.28402-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161129162452.28402-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2016 at 10:24:52AM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> The values passed to BUG_ON/WARN_ON are negated(!) and printed, which
> results in printing the value zero for each bug/warning. For example:
> volumes.c:988: btrfs_alloc_chunk: Assertion `ret` failed, value 0
> 
> This is not useful. Instead changed to print the value of the parameter
> passed to BUG_ON()/WARN_ON(). The value needed to be changed to long
> to accomodate pointers being passed.
> 
> Also, consolidated assert() and BUG() into ifndef.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Applied, thanks.
