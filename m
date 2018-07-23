Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387801AbeGWNXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 09:23:10 -0400
Date: Mon, 23 Jul 2018 14:22:04 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unused key assignment when doing a full
 send
Message-ID: <20180723122203.GI26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180723081009.4884-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180723081009.4884-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2018 at 09:10:09AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> At send.c:full_send_tree() we were setting the 'key' variable in the loop
> while never using it later. We were also using two btrfs_key variables
> to store the initial key for search and the key found in every iteration
> of the loop. So remove this useless key assignment and use the same
> btrfs_key variable to store the initial search key and the key found in
> each iteration. This was introduced in the initial send commit but was
> never used (commit 31db9f7c23fb ("Btrfs: introduce BTRFS_IOC_SEND for
> btrfs send/receive").
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
