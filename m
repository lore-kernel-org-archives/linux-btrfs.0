Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbeCZNRQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 09:17:16 -0400
Date: Mon, 26 Mar 2018 15:14:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH] btrfs-progs: remove BTRFS_CRC32_SIZE definition
Message-ID: <20180326131448.GK6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
 <a41c7961-fd69-ddbf-e831-769446868a5c@gmx.com>
 <e3a82fc6-2649-4d47-1893-9277130e6a1c@jp.fujitsu.com>
 <a90d3f5c-835d-d610-d819-9e33f4d3d874@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <a90d3f5c-835d-d610-d819-9e33f4d3d874@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2018 at 03:57:09PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年03月26日 08:54, Misono Tomohiro wrote:
> > On 2018/03/23 18:14, Qu Wenruo wrote:
> >>
> >>
> >> On 2018年03月23日 16:20, Misono Tomohiro wrote:
> >>> The kernel code no longer has BTRFS_CRC32_SIZE and only uses
> >>> btrfs_csum_sizes[]. So, update the progs code as well.
> >>>
> >>> Suggested-by: Qu Wenruo <wqu@suse.com>
> >>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> >>> ---
> >>>  convert/common.c |  2 +-
> >>>  convert/main.c   |  2 +-
> >>>  ctree.h          |  3 +--
> >>>  image/main.c     |  4 ++--
> >>>  mkfs/common.c    | 14 +++++++-------
> >>>  5 files changed, 12 insertions(+), 13 deletions(-)
> >>>
> >>> diff --git a/convert/common.c b/convert/common.c
> >>> index 3860f3b9..2b944fd8 100644
> >>> --- a/convert/common.c
> >>> +++ b/convert/common.c
> >>> @@ -219,7 +219,7 @@ static inline int write_temp_extent_buffer(int fd, struct extent_buffer *buf,
> >>>  {
> >>>  	int ret;
> >>>  
> >>> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> >>> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
> >>
> >> I'd say the normal kernel way to do this is like this, other than using
> >> BTRFS_CSUM_TYPE_CRC32:
> >> 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
> >>
> >> Thanks,
> >> Qu
> > 
> > 
> > Thanks, but we cannot access fs_info or struct btrfs_super_block here (and others in this diff).
> > Should we pass the csum type parameter as an argument? Since currently the only
> > supported type is crc32, I'm not sure if we should write the code so generic at this time.
> 
> Fair enough.

Yeah, at this point I'm ok with replacing it with just the reference to
the array. It's obvious that this could be generalized once there are
more csum algorithms.
