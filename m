Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FD5C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 17:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BBC620823
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 17:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YZXv5eJY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfC1RE4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 13:04:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfC1RE4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 13:04:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SGx025009772;
        Thu, 28 Mar 2019 17:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O7TZFKuMpDq7A0dJ3kbY2z50Y8jvLqdDuD+7UTvT8WI=;
 b=YZXv5eJYlXhNuWnGfYHd0J+bM8N4pokFnjpjRcESrk1WRthtRN/xXi9UDdDn64PWv6fU
 sb7ZAFRbX4V6cSENRSETz09HQJQKdLz1ZBpky0uFYHGHgoZYwcRyxuK9rWmp9tFvmsWU
 EDbIW94d0r4vv0uPSb6UyOPFR4csvyWWKYnHdvXcv0IvZLrOJZseH2VpUf0rCYY4n5YU
 AR/r+71Vy/1edUua+w2gtVCpAKLSiLWFM5BQtue/DkbGQzmgf4/+rSNJ8kag4pA1Leqn
 qI7q6gooo83pPHs87wJiPE+dBEcEZMfIt64afXdoWnGDga5oZC3zn4rjtJh3BWe9TVQD TQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2re6djr14j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 17:04:50 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2SH4h5C018006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 17:04:44 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2SH4gFS016219;
        Thu, 28 Mar 2019 17:04:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 10:04:41 -0700
Date:   Thu, 28 Mar 2019 10:04:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 11/15] fs: dedup file range to use a compare function
Message-ID: <20190328170440.GH1172@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-12-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-12-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9209 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280113
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:57PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> With dax we cannot deal with readpage() etc. So, we create a
> funciton callback to perform the file data comparison and pass
> it to generic_remap_file_range_prep() so it can use iomap-based
> functions.

So it occurs to me -- is there an intrinsic requirement that all files
sharing blocks must be in DAX mode or not-DAX mode?  Or in other words,
if I run cp --reflink a b, then it cannot be the case that IS_DAX(a) !=
IS_DAX(b), right?

Will there be calamitous consequences if dax and page cache both point
to the same piece of storage?  I would imagine so...

> This may not be the best way to solve this. Suggestions welcome.

Agree.  There's a fair amount of code duplication between the dax and
pagecache compare functions, considering that the loop structure for
both cases is:

while (len) {
	/* Figure out minimum comparison length */

	/* Map source file range into memory */

	/* Map dest file range into memory */

	/* Compare memory */

	/* Release dest file memory */

	/* Release source file memory */

	/* Update counters or break out */
}

The current vfs_dedupe_file_range_compare could use some improvements,
at least for filesystems where we actually support iomap.  In
particular, if you try to dedupe into or out of a hole, it'll flood the
page cache with zero pages, which is pretty wasteful if we could've
found out that it's actually a hole.

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/ctree.h     |  3 +++
>  fs/btrfs/dax.c       |  7 +++++++
>  fs/btrfs/ioctl.c     | 13 +++++++++++-
>  fs/dax.c             | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/file.c      |  2 +-
>  fs/read_write.c      |  9 +++++---
>  fs/xfs/xfs_reflink.c |  2 +-
>  include/linux/dax.h  |  2 ++
>  include/linux/fs.h   |  4 +++-
>  9 files changed, 93 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0e5060933bde..750f9c70fabe 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3803,6 +3803,9 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
>  ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
>  ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
>  vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
> +int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
> +		struct inode *dest, loff_t destoff, loff_t len,
> +		bool *is_same);
>  #else
>  static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
>  {
> diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
> index 927f962d1e88..9488cae0f8b4 100644
> --- a/fs/btrfs/dax.c
> +++ b/fs/btrfs/dax.c
> @@ -168,4 +168,11 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
>  
>  	return ret;
>  }
> +
> +int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
> +		struct inode *dest, loff_t destoff, loff_t len,
> +		bool *is_same)
> +{
> +	return dax_file_range_compare(src, srcoff, dest, destoff, len, is_same, &btrfs_iomap_ops);
> +}
>  #endif /* CONFIG_FS_DAX */
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e66426e7692d..2e5137b01561 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3990,8 +3990,19 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  	if (ret < 0)
>  		goto out_unlock;
>  
> +#ifdef CONFIG_FS_DAX
> +	if (IS_DAX(file_inode(file_in)) && IS_DAX(file_inode(file_out)))
> +		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
> +				pos_out, len, remap_flags,
> +				btrfs_dax_file_range_compare);
> +	else
> +		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
> +				pos_out, len, remap_flags, NULL);
> +#else
>  	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
> -					    len, remap_flags);
> +						    len, remap_flags, NULL);
> +#endif
> +
>  	if (ret < 0 || *len == 0)
>  		goto out_unlock;
>  
> diff --git a/fs/dax.c b/fs/dax.c
> index 41061da42771..18998c5ee27a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1775,3 +1775,61 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
>  	return dax_insert_pfn_mkwrite(vmf, pfn, order);
>  }
>  EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
> +
> +
> +int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
> +		loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops)

Comments for this function assume this is a vfs generic function, not a
dax specific thing...

> +{
> +	void *saddr, *daddr;
> +	struct iomap s_iomap = {0};
> +	struct iomap d_iomap = {0};
> +	loff_t dstart, sstart;
> +	bool same = true;
> +	loff_t cmp_len, l;
> +	int id, ret = 0;
> +
> +	id = dax_read_lock();
> +	while (len) {
> +		ret = ops->iomap_begin(src, srcoff, len, 0, &s_iomap);
> +		if (ret < 0) {
> +			if (ops->iomap_end)
> +				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
> +			return ret;
> +		}

Shouldn't we be checking that the iomap actually points to written
storage?  As opposed to hole/delalloc/unwritten?

Bonus: not-written extents (hole/unwritten) could be optimized a bit,
though I don't know if it's worth it for something that's probably a
corner case.

> +		cmp_len = len;
> +		if (cmp_len > s_iomap.offset + s_iomap.length - srcoff)
> +			cmp_len = s_iomap.offset + s_iomap.length - srcoff;
> +
> +		ret = ops->iomap_begin(dest, destoff, cmp_len, 0, &d_iomap);
> +		if (ret < 0) {
> +			if (ops->iomap_end) {
> +				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
> +				ops->iomap_end(dest, destoff, len, ret, 0, &d_iomap);
> +			}
> +			return ret;
> +		}
> +		if (cmp_len > d_iomap.offset + d_iomap.length - destoff)
> +			cmp_len = d_iomap.offset + d_iomap.length - destoff;
> +

If you wanted to make this a generic function, it would be kinda nice if
we could switch between grabbing page cache for non-DAX files and
dax_direct_access for DAX files.

(Actually, no, that's kind of ugly too.)

Perhaps iomap.c needs to grow a function to iterate ranges of two files
and call an actor function on both sets?  And we can change the actor to
be the pagecache-grabbing one or the dax-access one depending on the DAX
mode.

Though I guess that leaves poor old ocfs2 in the dust since it doesn't
support iomap.  I guess it wouldn't be too hard to adapt it to have an
iomap ops for reads only.

> +
> +		sstart = (get_start_sect(s_iomap.bdev) << 9) + s_iomap.addr + (srcoff - s_iomap.offset);
> +		l = dax_direct_access(s_iomap.dax_dev, PHYS_PFN(sstart), PHYS_PFN(cmp_len), &saddr, NULL);
> +		dstart = (get_start_sect(d_iomap.bdev) << 9) + d_iomap.addr + (destoff - d_iomap.offset);
> +		l = dax_direct_access(d_iomap.dax_dev, PHYS_PFN(dstart), PHYS_PFN(cmp_len), &daddr, NULL);
> +		same = !memcmp(saddr, daddr, cmp_len);
> +		if (!same)
> +			break;
> +		len -= cmp_len;
> +		srcoff += cmp_len;
> +		destoff += cmp_len;
> +
> +		if (ops->iomap_end) {
> +			ret = ops->iomap_end(src, srcoff, len, 0, 0, &s_iomap);
> +			ret = ops->iomap_end(dest, destoff, len, 0, 0, &d_iomap);
> +		}
> +	}
> +	dax_read_unlock(id);
> +	*is_same = same;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dax_file_range_compare);
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index d640c5f8a85d..6bf3e8fbb016 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2558,7 +2558,7 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
>  		goto out_unlock;
>  
>  	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
> -			&len, remap_flags);
> +			&len, remap_flags, NULL);
>  	if (ret < 0 || len == 0)
>  		goto out_unlock;
>  
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 177ccc3d405a..da521a221213 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1855,7 +1855,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>   */
>  int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  				  struct file *file_out, loff_t pos_out,
> -				  loff_t *len, unsigned int remap_flags)
> +				  loff_t *len, unsigned int remap_flags, compare_range_t compare)

Line wrapping...

>  {
>  	struct inode *inode_in = file_inode(file_in);
>  	struct inode *inode_out = file_inode(file_out);
> @@ -1914,8 +1914,11 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  	 */
>  	if (remap_flags & REMAP_FILE_DEDUP) {
>  		bool		is_same = false;
> -
> -		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
> +		if (compare)
> +			ret = compare(inode_in, pos_in,
> +				inode_out, pos_out, *len, &is_same);
> +		else
> +			ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
>  				inode_out, pos_out, *len, &is_same);

Make the callers pass in vfs_dedupe_file_range_compare instead of NULL,
and avoid this if clause stuff.

--D

>  		if (ret)
>  			return ret;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 680ae7662a78..8907c7aa3f19 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1350,7 +1350,7 @@ xfs_reflink_remap_prep(
>  		goto out_unlock;
>  
>  	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
> -			len, remap_flags);
> +			len, remap_flags, NULL);
>  	if (ret < 0 || *len == 0)
>  		goto out_unlock;
>  
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 0dd316a74a29..a11bc7b1f526 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -157,6 +157,8 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
>  int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
>  int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  				      pgoff_t index);
> +int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
> +                loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
>  
>  #ifdef CONFIG_FS_DAX
>  int __dax_zero_page_range(struct block_device *bdev,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b42df09b04c..22fe4324b22e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1880,10 +1880,12 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
>  		unsigned long, loff_t *, rwf_t);
>  extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
>  				   loff_t, size_t, unsigned int);
> +typedef int (compare_range_t)(struct inode *src, loff_t srcpos, struct inode *dest,
> +		loff_t destpos, loff_t len, bool *is_same);
>  extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  					 struct file *file_out, loff_t pos_out,
>  					 loff_t *count,
> -					 unsigned int remap_flags);
> +					 unsigned int remap_flags, compare_range_t cmp);
>  extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>  				  struct file *file_out, loff_t pos_out,
>  				  loff_t len, unsigned int remap_flags);
> -- 
> 2.16.4
> 
