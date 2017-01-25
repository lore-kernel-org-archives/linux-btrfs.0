Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41681 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751319AbdAYITm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 03:19:42 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0P8JXuK108384
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 03:19:41 -0500
Received: from e28smtp07.in.ibm.com (e28smtp07.in.ibm.com [125.16.236.7])
        by mx0b-001b2d01.pphosted.com with ESMTP id 286mmv86y0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 03:19:40 -0500
Received: from localhost
        by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 25 Jan 2017 13:49:13 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
        by d28dlp01.in.ibm.com (Postfix) with ESMTP id 6AFD1E0060
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 13:50:25 +0530 (IST)
Received: from d28av06.in.ibm.com (d28av06.in.ibm.com [9.184.220.48])
        by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v0P8JBJ040567014
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 13:49:11 +0530
Received: from d28av06.in.ibm.com (localhost [127.0.0.1])
        by d28av06.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v0P8JA7h012603
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 13:49:10 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, cmason@fb.com, Josef Bacik <jbacik@fb.com>,
        dsterba@suse.com
Subject: Re: [PATCH] Btrfs: fix wrong argument for btrfs_lookup_ordered_range
Date: Wed, 25 Jan 2017 13:49:09 +0530
In-Reply-To: <1485302331-20167-1-git-send-email-bo.li.liu@oracle.com>
References: <1485302331-20167-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <10463170.nZChnp8t2y@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, January 24, 2017 03:58:51 PM Liu Bo wrote:
> Commit "d0b7da88 Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units"
> did this, but btrfs_lookup_ordered_range expects a 'length' rather than a
> 'page_end'.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> Is this a candidate for stable?
> 
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4e02426..366cf0b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9023,7 +9023,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	 * we can't set the delalloc bits if there are pending ordered
>  	 * extents.  Drop our locks and wait for them to finish
>  	 */
> -	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
> +	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
>  	if (ordered) {
>  		unlock_extent_cached(io_tree, page_start, page_end,
>  				     &cached_state, GFP_NOFS);
> 

Thanks for fixing this,
Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

As for the question about whether this commit should be merged into the stable
trees ... I am not sure about that since I don't notice any sort of filesystem
corruption that can be caused by the current code i.e. With the existing code,
apart from any ordered extents that map the page in question, we are most
likely to be *unnecessarily* starting i/o on ordered extents that don't map
the file offset range covered by the page. Chris, Josef or David, Please let
us know your thoughts on this.

-- 
chandan

