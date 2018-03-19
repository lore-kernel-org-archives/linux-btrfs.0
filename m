Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59729 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970068AbeCSSgT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 14:36:19 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89102ACAD
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 18:36:18 +0000 (UTC)
Date: Mon, 19 Mar 2018 19:33:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print-tree: Enhance warning on tree block
 level mismatch and error handling
Message-ID: <20180319183354.GN6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180315044815.18816-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180315044815.18816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 12:48:15PM +0800, Qu Wenruo wrote:
> This patch enhance the tree block level mismatch by the following
> methods:
> 
> 1) Merge same warning branches into one
>    We had two branches showing the same message, and their condition
>    is also the same. Merge them
> 
> 2) Only skip bad slot
>    The old code skipped all the remaining slots, here we just skip one
>    slot to output as many correct tree blocks as possible.
> 
> 3) Enhance warning message
>    Ouput the parent bytenr and expected and wrong level, so we don't
>    need refer to the stdout to get which tree block is corrupted.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
