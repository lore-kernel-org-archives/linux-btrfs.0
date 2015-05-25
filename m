Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbbEYNnd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 09:43:33 -0400
Date: Mon, 25 May 2015 15:43:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: Enhance read_tree_block to avoid memory
 corruption
Message-ID: <20150525134331.GH23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432256483-19347-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432256483-19347-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 22, 2015 at 09:01:23AM +0800, Qu Wenruo wrote:
> Add the following tree block check to avoid memory corruption on hostile
> image:
> 1) Check level.
> Level >= BTRFS_MAX_LEVEL won't be read out.
> 
> 2) Nritems.
> For nr_items > max_nritems, the tree_block won't be read out.
> Max nritems is calculated in a easy method.
> For node, it's straightforward, just (nodesize - header size) /
> (btrfs_key_ptr)
> For leaf, (nodesize - header size) / (btrfs_item), as btrfs support zero
> item size
> 
> This fixes 3 kernel bugs: BZ#97171, BZ#97191, BZ#97271.
> 
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.

I've added image for the first bug, the other two do not pass inside our
testing setup (check/repair/check) and fails to start, but the image
restoration works at least. This would need some enhancements.
