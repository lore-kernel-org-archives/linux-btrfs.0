Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbcDKPFz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 11:05:55 -0400
Date: Mon, 11 Apr 2016 17:02:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, zhaolei@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs: do not create empty block group if we have
 allocated data
Message-ID: <20160411150218.GM3412@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1450146572-22383-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450146572-22383-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2015 at 06:29:32PM -0800, Liu Bo wrote:
> Now we force to create empty block group to keep data profile alive,
> however, in the below example, we eventually get an empty block group
> while we're trying to get more space for other types (metadata/system),
> 
> - Before,
> block group "A": size=2G, used=1.2G
> block group "B": size=2G, used=512M
> 
> - After "btrfs balance start -dusage=50 mount_point",
> block group "A": size=2G, used=(1.2+0.5)G
> block group "C": size=2G, used=0
> 
> Since there is no data in block group C, it won't be deleted
> automatically and we have to get the unused 2G until the next mount.
> 
> Balance itself just moves data and doesn't remove data, so it's safe
> to not create such a empty block group if we already have data
>  allocated in other block groups.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I'm adding the patch to my for-next.
