Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998AbcATJUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 04:20:04 -0500
Date: Wed, 20 Jan 2016 10:19:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.4
Message-ID: <20160120091956.GN4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160118130626.GK4227@suse.cz>
 <569EFA89.7080600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <569EFA89.7080600@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2016 at 11:10:01AM +0800, Qu Wenruo wrote:
> Not sure if it's intended or just a small miss, in btrfs-progs ctree.h,
> there is BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE, but
> BTRFS_FEATURE_COMPAT_RO_SUPP is still 0, not including FREE_SPACE_TREE.
> 
> Is it intended as current btrfsck doesn't support to modify fs with new 
> free space cache tree?

In progs it's unintended and buggy, the kernel side is buggy as well.
I'm fixing it.
