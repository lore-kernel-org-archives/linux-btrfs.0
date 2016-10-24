Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49411 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752030AbcJXR1D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 13:27:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6A410ABFB
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Oct 2016 17:27:01 +0000 (UTC)
Date: Mon, 24 Oct 2016 19:27:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs-progs: check: release path after usage
Message-ID: <20161024172700.GH22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161024151814.15231-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161024151814.15231-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 10:18:14AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> While performing an fsck, an assertion failure occurs because of reusing path in a loop.
> ctree.c:1112: btrfs_search_slot: Warning: assertion `p->nodes[0] != NULL` failed, value 0
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Applied, thanks.
