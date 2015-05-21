Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbbEUOwu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 10:52:50 -0400
Date: Thu, 21 May 2015 16:52:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH] btrfs-progs: Enhance read_tree_block to avoid memory
 corruption.
Message-ID: <20150521145249.GS23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431572784-32124-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431572784-32124-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 14, 2015 at 11:06:24AM +0800, Qu Wenruo wrote:
> Add the following tree_block check to avoid memory corruption or hostile
> image:
> 1) Check level.
> Level >= BTRFS_MAX_LEVEL won't be read out.
> 
> 2) Nritems.
> For nritems == 0 or nr_items > max_nritems, the tree_block won't be read
> out.
> Max nritems is calculated in a easy method.
> For node, it's straightforward, just (nodesize - header size) /
> (btrfs_key_ptr)
> For leaf, (nodesize - header size) / (btrfs_item), assume btrfs support
> item size == 0;
> 
> This fixes 3 kernel bugs: BZ#97171, BZ#97191, BZ#97271.
> 
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

The test 001-bad-file-extent-bytenr fails with this patch (and passes
otherwise). Can you please have a look?
