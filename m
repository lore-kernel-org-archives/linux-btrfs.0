Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbbHYRTX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:19:23 -0400
Date: Tue, 25 Aug 2015 19:18:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, marc@merlins.org
Subject: Re: [PATCH 2/2] btrfs-progs: find-root: Fix a bug that will cause
 wrong result
Message-ID: <20150825171848.GR10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440470697-21177-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1440470697-21177-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440470697-21177-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 10:44:57AM +0800, Qu Wenruo wrote:
> [BUG]
> btrfs-find-root may not output desire result, as due to
> search_extent_cache() may return result which doesn't cover the desired
> range, generation cache can be screwed up if higher generation tree root
> is found before lower generation tree root.
> 
> For example:
> =======
> ./btrfs-find-root  /dev/sda6  -a
> Superblock thinks the generation is 8
> Superblock thinks the level is 0
> adding bytenr: 4194304, gen: 8	<<< Debug output
> adding bytenr: 24715264, gen: 7 <<< gen is 7 at read_tree_block time
> Well block 4194304(gen: 8 level: 0) seems good, and it matches
> superblock
> Well block 24715264(gen: 8 level: 0) seems good, and it matches
> superblock  <<< But its gen is wrong at result output time
> =======
> 
> [Fix]
> Add a new judgment to make sure the search_extent_cache() is returning
> desired result.
> 
> Reported-by: Marc Merlin <marc@merlins.org>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
