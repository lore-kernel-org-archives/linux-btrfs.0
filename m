Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60611 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933864AbeCSSqn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 14:46:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EDED5AF05
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 18:46:41 +0000 (UTC)
Date: Mon, 19 Mar 2018 19:44:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: inspect-dump-tree: add '-f|--follow'
 options to print all children tree blocks for '-b'
Message-ID: <20180319184418.GO6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180314010538.29292-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180314010538.29292-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 09:05:38AM +0800, Qu Wenruo wrote:
> When debuging with "btrfs inspect dump-tree", it's not that handy if we
> want to iterate all child tree blocks starting from a specified block.
> 
> -b can only print a single block, while without -b "btrfs inspect dump-tree"
> will need extra tree roots fulfilled to continue, which is not possible
> for some damaged filesystem.
> 
> Add a new option '-f|--follow' to iterate a sub-tree starting from block
> specified by '-b|--block', so we would have less limitation.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I've dropped the shot option for now and updated the changelog. While
'-f' is probably a good choice, I'd postpone adding that if we want to
use it for other purposes.
