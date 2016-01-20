Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934728AbcATSEj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 13:04:39 -0500
Date: Wed, 20 Jan 2016 19:04:30 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.4
Message-ID: <20160120180430.GO4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160118130626.GK4227@suse.cz>
 <569EFA89.7080600@cn.fujitsu.com>
 <20160120091956.GN4227@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160120091956.GN4227@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 20, 2016 at 10:19:56AM +0100, David Sterba wrote:
> On Wed, Jan 20, 2016 at 11:10:01AM +0800, Qu Wenruo wrote:
> > Not sure if it's intended or just a small miss, in btrfs-progs ctree.h,
> > there is BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE, but
> > BTRFS_FEATURE_COMPAT_RO_SUPP is still 0, not including FREE_SPACE_TREE.
> > 
> > Is it intended as current btrfsck doesn't support to modify fs with new 
> > free space cache tree?
> 
> In progs it's unintended and buggy, the kernel side is buggy as well.
> I'm fixing it.

So it's just the btrfs-progs side, kernel side is fine.
