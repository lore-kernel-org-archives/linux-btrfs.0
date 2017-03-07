Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54446 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752573AbdCGQiQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 11:38:16 -0500
Date: Tue, 7 Mar 2017 17:05:17 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: remove unused delalloc_end parameter
Message-ID: <20170307160517.GW4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1488843167-8511-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1488843167-8511-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 06, 2017 at 11:32:47PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The delalloc_end parameter for extent_clear_unlock_delalloc() is never
> used, and only making the code for all callers longer and more complex.
> Just remove it.

It's been added on purpose

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=dda3245eca18c73413a854a834c41fc770feb0dd

"btrfs: expand cow_file_range() to support in-band dedup and
subpage-blocksize"

so we can merge both mentioned patchsets for testing.
