Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753948AbdLVTEl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 14:04:41 -0500
Date: Fri, 22 Dec 2017 10:58:28 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/10] Btrfs: extent map selftest: buffered write vs dio
 read
Message-ID: <20171222185828.GC21643@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
 <20171221224256.18196-5-bo.li.liu@oracle.com>
 <703352d3-8b80-1df1-e2ad-192e7e738a8d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <703352d3-8b80-1df1-e2ad-192e7e738a8d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 22, 2017 at 09:51:24AM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.12.2017 00:42, Liu Bo wrote:
> > This test case simulates the racy situation of buffered write vs dio
> > read, and see if btrfs_get_extent() would return -EEXIST.
> 
> Isn't mixing dio/buffered IO on the same file (range?) considered
> dangerous in any case?

They are, but it is sometimes the way how applications work.

thanks,
-liubo

> 
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/tests/extent-map-tests.c | 73 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 73 insertions(+)
> > 
> > diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
> > index 0407396..2adf55f 100644
> > --- a/fs/btrfs/tests/extent-map-tests.c
> > +++ b/fs/btrfs/tests/extent-map-tests.c
> > @@ -181,6 +181,78 @@ static void test_case_2(struct extent_map_tree *em_tree)
> >  	free_extent_map_tree(em_tree);
> >  }
> >  
> > +static void __test_case_3(struct extent_map_tree *em_tree, u64 start)
> > +{
> > +	struct extent_map *em;
> > +	u64 len = SZ_4K;
> > +	int ret;
> > +
> > +	em = alloc_extent_map();
> > +	if (!em)
> > +		/* Skip this test on error. */
> > +		return;
> > +
> > +	/* Add [4K, 8K) */
> > +	em->start = SZ_4K;
> > +	em->len = SZ_4K;
> > +	em->block_start = SZ_4K;
> > +	em->block_len = SZ_4K;
> > +	ret = add_extent_mapping(em_tree, em, 0);
> > +	ASSERT(ret == 0);
> > +	free_extent_map(em);
> > +
> > +	em = alloc_extent_map();
> > +	if (!em)
> > +		goto out;
> > +
> > +	/* Add [0, 16K) */
> > +	em->start = 0;
> > +	em->len = SZ_16K;
> > +	em->block_start = 0;
> > +	em->block_len = SZ_16K;
> > +	ret = btrfs_add_extent_mapping(em_tree, &em, start, len);
> > +	if (ret)
> > +		test_msg("case3 [0x%llx 0x%llx): ret %d\n",
> > +			 start, start + len, ret);
> > +	/*
> > +	 * Since bytes within em are contiguous, em->block_start is identical to
> > +	 * em->start.
> > +	 */
> > +	if (em &&
> > +	    (start < em->start || start + len > extent_map_end(em) ||
> > +	     em->start != em->block_start || em->len != em->block_len))
> > +		test_msg("case3 [0x%llx 0x%llx): ret %d em (start 0x%llx len 0x%llx block_start 0x%llx block_len 0x%llx)\n",
> > +			 start, start + len, ret, em->start, em->len,
> > +			 em->block_start, em->block_len);
> > +	free_extent_map(em);
> > +out:
> > +	/* free memory */
> > +	free_extent_map_tree(em_tree);
> > +}
> > +
> > +/*
> > + * Test scenario:
> > + *
> > + * Suppose that no extent map has been loaded into memory yet.
> > + * There is a file extent [0, 16K), two jobs are running concurrently
> > + * against it, t1 is buffered writing to [4K, 8K) and t2 is doing dio
> > + * read from [0, 4K) or [8K, 12K) or [12K, 16K).
> > + *
> > + * t1 goes ahead of t2 and adds em [4K, 8K) into tree.
> > + *
> > + *         t1                       t2
> > + *  cow_file_range()	     btrfs_get_extent()
> > + *                            -> lookup_extent_mapping()
> > + *   -> add_extent_mapping()
> > + *                            -> add_extent_mapping()
> > + */
> > +static void test_case_3(struct extent_map_tree *em_tree)
> > +{
> > +	__test_case_3(em_tree, 0);
> > +	__test_case_3(em_tree, SZ_8K);
> > +	__test_case_3(em_tree, (12 * 1024ULL));
> > +}
> > +
> >  int btrfs_test_extent_map()
> >  {
> >  	struct extent_map_tree *em_tree;
> > @@ -196,6 +268,7 @@ int btrfs_test_extent_map()
> >  
> >  	test_case_1(em_tree);
> >  	test_case_2(em_tree);
> > +	test_case_3(em_tree);
> >  
> >  	kfree(em_tree);
> >  	return 0;
> > 
