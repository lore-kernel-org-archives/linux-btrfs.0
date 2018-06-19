Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43575 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937365AbeFSNkz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 09:40:55 -0400
Date: Tue, 19 Jun 2018 15:38:04 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix return value on rename exchange failure
Message-ID: <20180619133804.GP24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180611182416.18051-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180611182416.18051-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 11, 2018 at 07:24:16PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we failed during a rename exchange operation after starting/joining a
> transaction, we would end up replacing the return value, stored in the
> local 'ret' variable, with the return value from btrfs_end_transaction().
> So this could end up returning 0 (success) to user space despite the
> operation having failed and aborted the transaction, because if there are
> multiple tasks having a reference on the transaction at the time
> btrfs_end_transaction() is called by the rename exchange, that function
> returns 0 (otherwise it returns -EIO and not the original error value).
> So fix this by not overwriting the return value on error after getting
> a transaction handle.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

1 and 2 queued for 4.18, thanks.
