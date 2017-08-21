Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754429AbdHURRl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:17:41 -0400
Date: Mon, 21 Aug 2017 19:16:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jared.e.vb@gmail.com
Subject: Re: [PATCH] btrfs-progs: Allow inspect dump-tree to show specified
 tree block even some tree roots are corrupted
Message-ID: <20170821171616.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818093630.9892-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818093630.9892-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 06:36:30PM +0900, Qu Wenruo wrote:
> For btrfs inspect-internal dump-tree, if we use "-b" parameter to show
> specified tree block, then we don't really need extra tree roots.
> 
> Only chunk root is needed to build up the whole chunk mapping so we can
> read tree blocks.
> 
> This patch will add __OPEN_CTREE_RETURN_CHUNK_ROOT flag when show
> speicifed tree block.
> So even root tree is corrupted, we can still use inspect-internal
> dump-tree to do some debugging.

Sounds useful.

> Reported-by: Zirconium Hacker <jared.e.vb@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Applied, thanks.
