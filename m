Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33410 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752369AbeEGShb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 14:37:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1AE3BABB4
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 18:37:30 +0000 (UTC)
Date: Mon, 7 May 2018 20:34:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/4] btrfs check --check-data-csum enhancement for
Message-ID: <20180507183453.GF6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180227091259.10877-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180227091259.10877-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 27, 2018 at 05:12:55PM +0800, Qu Wenruo wrote:
> Log-writes tool from Josef exposed btrfs data corruption.
> 
> Although still digging, at least enhance --check-data-csum option so
> that log-replay --check can stop exactly at the point where btrfs data
> get corrupted, instead of manually checking the output.
> 
> Qu Wenruo (4):
>   btrfs-progs: check: Check data csum for all copies
>   btrfs-progs: check: Fix data csum check return value
>   btrfs-progs: check: Continue check even csum error is found
>   btrfs-progs: check: Distingusih csum checking output for
>     --check-data-csum

Added to devel, thanks.
