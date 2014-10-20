Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaJTRuV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 13:50:21 -0400
Date: Mon, 20 Oct 2014 19:50:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [REGRESSION?] Used+avail gives more than size of device
Message-ID: <20141020175019.GZ22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <10721429.ggFParDapp@merkaba>
 <pan$10714$bcab7b52$f88ec3cf$1547168d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$10714$bcab7b52$f88ec3cf$1547168d@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 12, 2014 at 10:55:54PM +0000, Duncan wrote:
[...]
> It's the raid-factor.  =:^)
> 
> Btrfs in the kernel is apparently accounting for raid-factor in used 
> space in whatever function standard df is using, but not in available 
> space, even where that available space is already chunk-allocated (btrfs 
> fi show, individual devices, size vs. used, where "used" simply means 
> chunk-allocated for show) and thus the raid-factor known.

Nice analysis. There must be a bug then. The raid factor is taken into account
when calculating the usable space:

super.c:btrfs_statfs():
1827         buf->f_bavail = total_free_data;
1828         ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
1829         if (ret) {
1830                 mutex_unlock(&fs_info->chunk_mutex);
1831                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
1832                 return ret;
1833         }
1834         buf->f_bavail += div_u64(total_free_data, factor);

but it looks like the free space is counted twice, lines 1827 and 1834. The
function btrfs_calc_avail_data_space does the guesswork "how much space could
be still allocated" in the logical units, basically simulating the allocator
logic. I'll have a look as I've touched btrfs_statfs last.
