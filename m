Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbcGGME6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 08:04:58 -0400
Date: Thu, 7 Jul 2016 14:05:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: fix read_node_slot to return errors
Message-ID: <20160707120517.GW13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1467165348-9931-1-git-send-email-bo.li.liu@oracle.com>
 <1467745814-12889-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467745814-12889-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 05, 2016 at 12:10:14PM -0700, Liu Bo wrote:
> We use read_node_slot() to read btree node and it has two cases,
> a) slot is out of range, which means 'no such entry'
> b) we fail to read the block, due to checksum fails or corrupted
>    content or not with uptodate flag.
> But we're returning NULL in both cases, this makes it return -ENOENT
> in case a) and return -EIO in case b), and this fixes its callers
> as well as btrfs_search_forward() 's caller to catch the new errors.
> 
> The problem is reported by Peter Becker, and I can manage to
> hit the same BUG_ON by mounting my fuzz image.
> 
> Reported-by: Peter Becker <floyd.net@gmail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
