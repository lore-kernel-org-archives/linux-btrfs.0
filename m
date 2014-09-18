Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32984 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaIRJBb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 05:01:31 -0400
Date: Thu, 18 Sep 2014 17:01:05 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to insert
 best fitted extent map
Message-ID: <20140918090104.GD15092@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1410926015-26820-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140918042113.GA15092@localhost.localdomain>
 <541A6F6F.4010901@cn.fujitsu.com>
 <20140918073307.GB15092@localhost.localdomain>
 <541A90A2.5050407@cn.fujitsu.com>
 <20140918082023.GC15092@localhost.localdomain>
 <541A96D0.5000903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <541A96D0.5000903@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 18, 2014 at 04:24:48PM +0800, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping()
> to insert best fitted extent map
> From: Liu Bo <bo.li.liu@oracle.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年09月18日 16:20
> >On Thu, Sep 18, 2014 at 03:58:26PM +0800, Qu Wenruo wrote:
> >[...]
> >>>original:   (start >= existing->start && start < extent_map_end(existing))
> >>>this patch: (start < extent_map_end(existing) && start + len > existing->start)
> >>>
> >>>(start + len > existing->start) doesn't equal to start >= existing->start,
> >>>here is a case of (start+len > existing->start) but (start <= existing->start).
> >>>
> >>>        |--------| -->(existing)
> >>>     |--------|    -->[start, start+len)
> >>>
> >>>And calling search_extent_mapping() doesn't make sure that
> >>>(start >= existing->start) is true, either.
> >>All right, that case is right and I'm wrong.
> >>I'll change the if() to use start >= existing->start.
> >>
> >>BTW, Any other problem?
> >Others look good.
> >
> >thanks,
> >-liubo
> Would you mind me adding your reviewed-by?
> 

Sure.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
-liubo

> Thanks
> Qu
> >>Thanks,
> >>Qu
> >>>>>And one of overlapping cases is (existing->start > start), ie. em->start > start, this is
> >>>>>against our rule of btrfs_get_extent,
> >>>>Nope again, this overlapping in fact is quite normal in multithread
> >>>>random read/write.
> >>>>The files's [0~16) is a preallocated one,
> >>>>Thread A:
> >>>>     write [4K, 8K) into the file, but not committed yet.
> >>>>     extent map tree contains [0,16K) only
> >>>>Thread B:
> >>>>btrfs_get_extent()
> >>>>     the map_start is 8K, len is 4K as an example
> >>>>     grab a large em, take [0,16K), since [4K,8K) write is not committed.
> >>>>     comes to insert: btrfs_release_path(path);
> >>>>
> >>>>Thread A:
> >>>>     [4K, 8K) is not committed
> >>>>     the extent map is now [0, 4K) [4K, 8K) [8K, 16K).
> >>>>
> >>>>Thread B:
> >>>>     goes to insert: add_extent_mapping()
> >>>>     the [0,16K) is overlapping, and the returned existing one is [8K, 16K).
> >>>>     which contains the [map_start, map_start +  len).
> >>>So this's an example of existing->start == start (both are 8K), not
> >>>existing->start > start.
> >>>
> >>>See __extent_writepage_io(),
> >>>
> >>>{
> >>>		...
> >>>                 em = epd->get_extent(inode, page, pg_offset, cur,
> >>>                                      end - cur + 1, 1);
> >>>                 if (IS_ERR_OR_NULL(em)) {
> >>>                         SetPageError(page);
> >>>                         ret = PTR_ERR_OR_ZERO(em);
> >>>                         break;
> >>>                 }
> >>>                 extent_offset = cur - em->start;
> >>>		^^^^^^^^^^^^^^^^^^^^^^^^^^^ it needs to be (em->start <= cur)
> >>>
> >>>		...
> >>>}
> >>>
> >>>thanks,
> >>>-liubo
> >>>
> >>>>>struct extent_map *btrfs_get_extent(...)
> >>>>>{
> >>>>>	[...]
> >>>>>	insert:
> >>>>>		btrfs_release_path(path);
> >>>>>		if (em->start > start || extent_map_end(em) <= start) {
> >>>>>			btrfs_err(root->fs_info, "bad extent! em: [%llu %llu] passed
> >>>>>	[%llu %llu]",
> >>>>>				em->start, em->len, start, len);
> >>>>>			err = -EIO;
> >>>>>                 goto out;
> >>>>>         }
> >>>>>         [...]
> >>>>>}
> >>>>>
> >>>>>thanks,
> >>>>>-liubo
> >>>>>
> >>>>>>+			/*
> >>>>>>+			 * The existing extent map is the one nearest to
> >>>>>>+			 * the [start, start + len) range which overlaps
> >>>>>>+			 */
> >>>>>>+			err = merge_extent_mapping(em_tree, existing,
> >>>>>>+						   em, start);
> >>>>>>  			free_extent_map(existing);
> >>>>>>-			existing = NULL;
> >>>>>>-		}
> >>>>>>-		if (!existing) {
> >>>>>>-			existing = lookup_extent_mapping(em_tree, em->start,
> >>>>>>-							 em->len);
> >>>>>>-			if (existing) {
> >>>>>>-				err = merge_extent_mapping(em_tree, existing,
> >>>>>>-							   em, start);
> >>>>>>-				free_extent_map(existing);
> >>>>>>-				if (err) {
> >>>>>>-					free_extent_map(em);
> >>>>>>-					em = NULL;
> >>>>>>-				}
> >>>>>>-			} else {
> >>>>>>-				err = -EIO;
> >>>>>>+			if (err) {
> >>>>>>  				free_extent_map(em);
> >>>>>>  				em = NULL;
> >>>>>>  			}
> >>>>>>-- 
> >>>>>>2.1.0
> >>>>>>
> >>>>>>--
> >>>>>>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >>>>>>the body of a message to majordomo@vger.kernel.org
> >>>>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
