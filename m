Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40328 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728734AbeGPNfc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 09:35:32 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3F0DADC1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 13:08:08 +0000 (UTC)
Date: Mon, 16 Jul 2018 15:08:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: chunk and dev-extent related error handler
 enhancement
Message-ID: <20180716130803.GH3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180709064203.32409-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180709064203.32409-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2018 at 02:42:01PM +0800, Qu Wenruo wrote:
> Can be fetched with all existing tree-checker/bg<->chunk error detector
> from github:
> https://github.com/adam900710/linux/tree/tree_checker_enhance
> 
> Still some fuzzed images reported from Xu Wen.
> This time, 2 can be fixed by chunk <-> dev extent mapping verification.
> One BUG_ON() can be removed.
> 
> The remaining 2 images are all mostly about extent tree corruption,
> which is not as easy to detect, since extent tree has way more complex
> reference relationship.
> 
> At least, fix what we can first.
> 
> And for chunk <-> dev extent mapping verification, it will trigger
> read on the whole device tree, to iterate through all DEV_EXTENT items.
> This will introduce an extra overhead on mount.
> 
> However since device tree is pretty small (the same level as chunk tree),
> and according to previous analyse on mount time, chunk tree iteration is
> only a pretty small fraction of the whole mount time (less than 5%), it
> shouldn't bring obvious impact to users.

Ok, that's acceptable.
