Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5250 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753188AbcK2HIX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 02:08:23 -0500
Subject: Re: [PATCH 1/3] btrfs: qgroup: Fix qgroup corruption caused by
 inode_cache mount option (fwd)
To: Julia Lawall <julia.lawall@lip6.fr>
References: <alpine.DEB.2.20.1611290744550.2180@hadrien>
CC: <linux-btrfs@vger.kernel.org>, <kbuild-all@01.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a8398161-9c07-c74d-3e85-ea8ac97f08e2@cn.fujitsu.com>
Date: Tue, 29 Nov 2016 15:08:01 +0800
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1611290744550.2180@hadrien>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, thanks, I just forgot that since the 3rd patch just removes the 
related lines.

Anyway, I should fix it.

Thanks,
Qu

At 11/29/2016 02:46 PM, Julia Lawall wrote:
> It looks like the tree_log_mutex needs to be unlocked at lines 2153 and
> 2159.
>
> julia
>
> ---------- Forwarded message ----------
> Date: Tue, 29 Nov 2016 14:16:30 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> To: kbuild@01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: Re: [PATCH 1/3] btrfs: qgroup: Fix qgroup corruption caused by
>     inode_cache mount option
>
> Hi Qu,
>
> [auto build test WARNING on next-20161128]
> [also build test WARNING on v4.9-rc7]
> [cannot apply to btrfs/next v4.9-rc7 v4.9-rc6 v4.9-rc5]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Qu-Wenruo/btrfs-qgroup-Fix-qgroup-corruption-caused-by-inode_cache-mount-option/20161129-133729
> :::::: branch date: 39 minutes ago
> :::::: commit date: 39 minutes ago
>
>>> fs/btrfs/transaction.c:2307:1-7: preceding lock on line 2126
>
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout a10797b831381f092c853c616f2eddd856ace99d
> vim +2307 fs/btrfs/transaction.c
>
> e02119d5a Chris Mason    2008-09-05  2120  	 * At this point in the commit, there can't be any tree-log
> e02119d5a Chris Mason    2008-09-05  2121  	 * writers, but a little lower down we drop the trans mutex
> e02119d5a Chris Mason    2008-09-05  2122  	 * and let new people in.  By holding the tree_log_mutex
> e02119d5a Chris Mason    2008-09-05  2123  	 * from now until after the super is written, we avoid races
> e02119d5a Chris Mason    2008-09-05  2124  	 * with the tree-log code.
> e02119d5a Chris Mason    2008-09-05  2125  	 */
> e02119d5a Chris Mason    2008-09-05 @2126  	mutex_lock(&root->fs_info->tree_log_mutex);
> 1a40e23b9 Zheng Yan      2008-09-26  2127
> 5d4f98a28 Yan Zheng      2009-06-10  2128  	ret = commit_fs_roots(trans, root);
> 49b25e054 Jeff Mahoney   2012-03-01  2129  	if (ret) {
> 49b25e054 Jeff Mahoney   2012-03-01  2130  		mutex_unlock(&root->fs_info->tree_log_mutex);
> 871383be5 David Sterba   2012-04-02  2131  		mutex_unlock(&root->fs_info->reloc_mutex);
> 6cf7f77e6 Wang Shilong   2014-02-19  2132  		goto scrub_continue;
> 49b25e054 Jeff Mahoney   2012-03-01  2133  	}
> 54aa1f4df Chris Mason    2007-06-22  2134
> 3818aea27 Qu Wenruo      2014-01-13  2135  	/*
> 7e1876aca David Sterba   2014-02-05  2136  	 * Since the transaction is done, we can apply the pending changes
> 7e1876aca David Sterba   2014-02-05  2137  	 * before the next transaction.
> 3818aea27 Qu Wenruo      2014-01-13  2138  	 */
> 572d9ab78 David Sterba   2014-02-05  2139  	btrfs_apply_pending_changes(root->fs_info);
> 3818aea27 Qu Wenruo      2014-01-13  2140
> 5d4f98a28 Yan Zheng      2009-06-10  2141  	/* commit_fs_roots gets rid of all the tree log roots, it is now
> e02119d5a Chris Mason    2008-09-05  2142  	 * safe to free the root of tree log roots
> e02119d5a Chris Mason    2008-09-05  2143  	 */
> e02119d5a Chris Mason    2008-09-05  2144  	btrfs_free_log_root_tree(trans, root->fs_info);
> e02119d5a Chris Mason    2008-09-05  2145
> 0ed4792af Qu Wenruo      2015-04-16  2146  	/*
> a10797b83 Qu Wenruo      2016-11-29  2147  	 * commit_fs_roots() can call btrfs_save_ino_cache(), which generates
> a10797b83 Qu Wenruo      2016-11-29  2148  	 * new delayed refs. Must handle them or qgroup can be wrong.
> a10797b83 Qu Wenruo      2016-11-29  2149  	 */
> a10797b83 Qu Wenruo      2016-11-29  2150  	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
> a10797b83 Qu Wenruo      2016-11-29  2151  	if (ret) {
> a10797b83 Qu Wenruo      2016-11-29  2152  		mutex_unlock(&root->fs_info->reloc_mutex);
> a10797b83 Qu Wenruo      2016-11-29  2153  		goto scrub_continue;
> a10797b83 Qu Wenruo      2016-11-29  2154  	}
> a10797b83 Qu Wenruo      2016-11-29  2155
> a10797b83 Qu Wenruo      2016-11-29  2156  	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
> a10797b83 Qu Wenruo      2016-11-29  2157  	if (ret) {
> a10797b83 Qu Wenruo      2016-11-29  2158  		mutex_unlock(&root->fs_info->reloc_mutex);
> a10797b83 Qu Wenruo      2016-11-29  2159  		goto scrub_continue;
> a10797b83 Qu Wenruo      2016-11-29  2160  	}
> a10797b83 Qu Wenruo      2016-11-29  2161
> a10797b83 Qu Wenruo      2016-11-29  2162  	/*
> 0ed4792af Qu Wenruo      2015-04-16  2163  	 * Since fs roots are all committed, we can get a quite accurate
> 0ed4792af Qu Wenruo      2015-04-16  2164  	 * new_roots. So let's do quota accounting.
> 0ed4792af Qu Wenruo      2015-04-16  2165  	 */
> 0ed4792af Qu Wenruo      2015-04-16  2166  	ret = btrfs_qgroup_account_extents(trans, root->fs_info);
> 0ed4792af Qu Wenruo      2015-04-16  2167  	if (ret < 0) {
> 0ed4792af Qu Wenruo      2015-04-16  2168  		mutex_unlock(&root->fs_info->tree_log_mutex);
> 0ed4792af Qu Wenruo      2015-04-16  2169  		mutex_unlock(&root->fs_info->reloc_mutex);
> 0ed4792af Qu Wenruo      2015-04-16  2170  		goto scrub_continue;
> 0ed4792af Qu Wenruo      2015-04-16  2171  	}
> 0ed4792af Qu Wenruo      2015-04-16  2172
> 5d4f98a28 Yan Zheng      2009-06-10  2173  	ret = commit_cowonly_roots(trans, root);
> 49b25e054 Jeff Mahoney   2012-03-01  2174  	if (ret) {
> 49b25e054 Jeff Mahoney   2012-03-01  2175  		mutex_unlock(&root->fs_info->tree_log_mutex);
> 871383be5 David Sterba   2012-04-02  2176  		mutex_unlock(&root->fs_info->reloc_mutex);
> 6cf7f77e6 Wang Shilong   2014-02-19  2177  		goto scrub_continue;
> 49b25e054 Jeff Mahoney   2012-03-01  2178  	}
> 54aa1f4df Chris Mason    2007-06-22  2179
> 2cba30f17 Miao Xie       2013-01-15  2180  	/*
> 2cba30f17 Miao Xie       2013-01-15  2181  	 * The tasks which save the space cache and inode cache may also
> 2cba30f17 Miao Xie       2013-01-15  2182  	 * update ->aborted, check it.
> 2cba30f17 Miao Xie       2013-01-15  2183  	 */
> 2cba30f17 Miao Xie       2013-01-15  2184  	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
> 2cba30f17 Miao Xie       2013-01-15  2185  		ret = cur_trans->aborted;
> 2cba30f17 Miao Xie       2013-01-15  2186  		mutex_unlock(&root->fs_info->tree_log_mutex);
> 2cba30f17 Miao Xie       2013-01-15  2187  		mutex_unlock(&root->fs_info->reloc_mutex);
> 6cf7f77e6 Wang Shilong   2014-02-19  2188  		goto scrub_continue;
> 2cba30f17 Miao Xie       2013-01-15  2189  	}
> 2cba30f17 Miao Xie       2013-01-15  2190
> 11833d66b Yan Zheng      2009-09-11  2191  	btrfs_prepare_extent_commit(trans, root);
> 11833d66b Yan Zheng      2009-09-11  2192
> 78fae27eb Chris Mason    2007-03-25  2193  	cur_trans = root->fs_info->running_transaction;
> 5d4f98a28 Yan Zheng      2009-06-10  2194
> 5d4f98a28 Yan Zheng      2009-06-10  2195  	btrfs_set_root_node(&root->fs_info->tree_root->root_item,
> 5d4f98a28 Yan Zheng      2009-06-10  2196  			    root->fs_info->tree_root->node);
> 9e351cc86 Josef Bacik    2014-03-13  2197  	list_add_tail(&root->fs_info->tree_root->dirty_list,
> 9e351cc86 Josef Bacik    2014-03-13  2198  		      &cur_trans->switch_commits);
> 5d4f98a28 Yan Zheng      2009-06-10  2199
> 5d4f98a28 Yan Zheng      2009-06-10  2200  	btrfs_set_root_node(&root->fs_info->chunk_root->root_item,
> 5d4f98a28 Yan Zheng      2009-06-10  2201  			    root->fs_info->chunk_root->node);
> 9e351cc86 Josef Bacik    2014-03-13  2202  	list_add_tail(&root->fs_info->chunk_root->dirty_list,
> 9e351cc86 Josef Bacik    2014-03-13  2203  		      &cur_trans->switch_commits);
> 9e351cc86 Josef Bacik    2014-03-13  2204
> 9e351cc86 Josef Bacik    2014-03-13  2205  	switch_commit_roots(cur_trans, root->fs_info);
> 5d4f98a28 Yan Zheng      2009-06-10  2206
> edf39272d Jan Schmidt    2012-06-28  2207  	assert_qgroups_uptodate(trans);
> ce93ec548 Josef Bacik    2014-11-17  2208  	ASSERT(list_empty(&cur_trans->dirty_bgs));
> 1bbc621ef Chris Mason    2015-04-06  2209  	ASSERT(list_empty(&cur_trans->io_bgs));
> 5d4f98a28 Yan Zheng      2009-06-10  2210  	update_super_roots(root);
> e02119d5a Chris Mason    2008-09-05  2211
> 6c41761fc David Sterba   2011-04-13  2212  	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
> 6c41761fc David Sterba   2011-04-13  2213  	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
> 6c41761fc David Sterba   2011-04-13  2214  	memcpy(root->fs_info->super_for_commit, root->fs_info->super_copy,
> 6c41761fc David Sterba   2011-04-13  2215  	       sizeof(*root->fs_info->super_copy));
> ccd467d60 Chris Mason    2007-06-28  2216
> 935e5cc93 Miao Xie       2014-09-03  2217  	btrfs_update_commit_device_size(root->fs_info);
> ce7213c70 Miao Xie       2014-09-03  2218  	btrfs_update_commit_device_bytes_used(root, cur_trans);
> 935e5cc93 Miao Xie       2014-09-03  2219
> afcdd129e Josef Bacik    2016-09-02  2220  	clear_bit(BTRFS_FS_LOG1_ERR, &root->fs_info->flags);
> afcdd129e Josef Bacik    2016-09-02  2221  	clear_bit(BTRFS_FS_LOG2_ERR, &root->fs_info->flags);
> 656f30dba Filipe Manana  2014-09-26  2222
> 4fbcdf669 Filipe Manana  2015-05-20  2223  	btrfs_trans_release_chunk_metadata(trans);
> 4fbcdf669 Filipe Manana  2015-05-20  2224
> a4abeea41 Josef Bacik    2011-04-11  2225  	spin_lock(&root->fs_info->trans_lock);
> 4a9d8bdee Miao Xie       2013-05-17  2226  	cur_trans->state = TRANS_STATE_UNBLOCKED;
> a4abeea41 Josef Bacik    2011-04-11  2227  	root->fs_info->running_transaction = NULL;
> a4abeea41 Josef Bacik    2011-04-11  2228  	spin_unlock(&root->fs_info->trans_lock);
> 7585717f3 Chris Mason    2011-06-13  2229  	mutex_unlock(&root->fs_info->reloc_mutex);
> b7ec40d78 Chris Mason    2009-03-12  2230
> f92957493 Chris Mason    2008-07-17  2231  	wake_up(&root->fs_info->transaction_wait);
> e6dcd2dc9 Chris Mason    2008-07-17  2232
> 79154b1b5 Chris Mason    2007-03-22  2233  	ret = btrfs_write_and_wait_transaction(trans, root);
> 49b25e054 Jeff Mahoney   2012-03-01  2234  	if (ret) {
> 34d970070 Anand Jain     2016-03-16  2235  		btrfs_handle_fs_error(root->fs_info, ret,
> 087488109 David Sterba   2013-03-12  2236  			    "Error while writing out transaction");
> 49b25e054 Jeff Mahoney   2012-03-01  2237  		mutex_unlock(&root->fs_info->tree_log_mutex);
> 6cf7f77e6 Wang Shilong   2014-02-19  2238  		goto scrub_continue;
> 49b25e054 Jeff Mahoney   2012-03-01  2239  	}
> 49b25e054 Jeff Mahoney   2012-03-01  2240
> 49b25e054 Jeff Mahoney   2012-03-01  2241  	ret = write_ctree_super(trans, root, 0);
> 49b25e054 Jeff Mahoney   2012-03-01  2242  	if (ret) {
> 49b25e054 Jeff Mahoney   2012-03-01  2243  		mutex_unlock(&root->fs_info->tree_log_mutex);
> 6cf7f77e6 Wang Shilong   2014-02-19  2244  		goto scrub_continue;
> 49b25e054 Jeff Mahoney   2012-03-01  2245  	}
> 4313b3994 Chris Mason    2008-01-03  2246
> e02119d5a Chris Mason    2008-09-05  2247  	/*
> e02119d5a Chris Mason    2008-09-05  2248  	 * the super is written, we can safely allow the tree-loggers
> e02119d5a Chris Mason    2008-09-05  2249  	 * to go about their business
> e02119d5a Chris Mason    2008-09-05  2250  	 */
> e02119d5a Chris Mason    2008-09-05  2251  	mutex_unlock(&root->fs_info->tree_log_mutex);
> e02119d5a Chris Mason    2008-09-05  2252
> 11833d66b Yan Zheng      2009-09-11  2253  	btrfs_finish_extent_commit(trans, root);
> 4313b3994 Chris Mason    2008-01-03  2254
> 3204d33cd Josef Bacik    2015-09-24  2255  	if (test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &cur_trans->flags))
> 13212b54d Zhao Lei       2015-02-12  2256  		btrfs_clear_space_info_full(root->fs_info);
> 13212b54d Zhao Lei       2015-02-12  2257
> 15ee9bc7e Josef Bacik    2007-08-10  2258  	root->fs_info->last_trans_committed = cur_trans->transid;
> 4a9d8bdee Miao Xie       2013-05-17  2259  	/*
> 4a9d8bdee Miao Xie       2013-05-17  2260  	 * We needn't acquire the lock here because there is no other task
> 4a9d8bdee Miao Xie       2013-05-17  2261  	 * which can change it.
> 4a9d8bdee Miao Xie       2013-05-17  2262  	 */
> 4a9d8bdee Miao Xie       2013-05-17  2263  	cur_trans->state = TRANS_STATE_COMPLETED;
> 2c90e5d65 Chris Mason    2007-04-02  2264  	wake_up(&cur_trans->commit_wait);
> 3de4586c5 Chris Mason    2008-11-17  2265
> a4abeea41 Josef Bacik    2011-04-11  2266  	spin_lock(&root->fs_info->trans_lock);
> 13c5a93e7 Josef Bacik    2011-04-11  2267  	list_del_init(&cur_trans->list);
> a4abeea41 Josef Bacik    2011-04-11  2268  	spin_unlock(&root->fs_info->trans_lock);
> a4abeea41 Josef Bacik    2011-04-11  2269
> 724e2315d Josef Bacik    2013-09-30  2270  	btrfs_put_transaction(cur_trans);
> 724e2315d Josef Bacik    2013-09-30  2271  	btrfs_put_transaction(cur_trans);
> 58176a960 Josef Bacik    2007-08-29  2272
> 0860adfdb Miao Xie       2013-05-15  2273  	if (trans->type & __TRANS_FREEZABLE)
> b2b5ef5c8 Jan Kara       2012-06-12  2274  		sb_end_intwrite(root->fs_info->sb);
> b2b5ef5c8 Jan Kara       2012-06-12  2275
> 1abe9b8a1 liubo          2011-03-24  2276  	trace_btrfs_transaction_commit(root);
> 1abe9b8a1 liubo          2011-03-24  2277
> a2de733c7 Arne Jansen    2011-03-08  2278  	btrfs_scrub_continue(root);
> a2de733c7 Arne Jansen    2011-03-08  2279
> 9ed74f2db Josef Bacik    2009-09-11  2280  	if (current->journal_info == trans)
> 9ed74f2db Josef Bacik    2009-09-11  2281  		current->journal_info = NULL;
> 9ed74f2db Josef Bacik    2009-09-11  2282
> 2c90e5d65 Chris Mason    2007-04-02  2283  	kmem_cache_free(btrfs_trans_handle_cachep, trans);
> 24bbcf044 Yan, Zheng     2009-11-12  2284
> 9e7cc91a6 Wang Xiaoguang 2016-08-01  2285  	/*
> 9e7cc91a6 Wang Xiaoguang 2016-08-01  2286  	 * If fs has been frozen, we can not handle delayed iputs, otherwise
> 9e7cc91a6 Wang Xiaoguang 2016-08-01  2287  	 * it'll result in deadlock about SB_FREEZE_FS.
> 9e7cc91a6 Wang Xiaoguang 2016-08-01  2288  	 */
> 8a7330130 Zhao Lei       2015-07-15  2289  	if (current != root->fs_info->transaction_kthread &&
> 9e7cc91a6 Wang Xiaoguang 2016-08-01  2290  	    current != root->fs_info->cleaner_kthread &&
> 9e7cc91a6 Wang Xiaoguang 2016-08-01  2291  	    !root->fs_info->fs_frozen)
> 24bbcf044 Yan, Zheng     2009-11-12  2292  		btrfs_run_delayed_iputs(root);
> 24bbcf044 Yan, Zheng     2009-11-12  2293
> 79154b1b5 Chris Mason    2007-03-22  2294  	return ret;
> 49b25e054 Jeff Mahoney   2012-03-01  2295
> 6cf7f77e6 Wang Shilong   2014-02-19  2296  scrub_continue:
> 6cf7f77e6 Wang Shilong   2014-02-19  2297  	btrfs_scrub_continue(root);
> 49b25e054 Jeff Mahoney   2012-03-01  2298  cleanup_transaction:
> 0e7211069 Josef Bacik    2012-06-26  2299  	btrfs_trans_release_metadata(trans, root);
> 4fbcdf669 Filipe Manana  2015-05-20  2300  	btrfs_trans_release_chunk_metadata(trans);
> 0e7211069 Josef Bacik    2012-06-26  2301  	trans->block_rsv = NULL;
> c2cf52eb7 Simon Kirby    2013-03-19  2302  	btrfs_warn(root->fs_info, "Skipping commit of aborted transaction.");
> 49b25e054 Jeff Mahoney   2012-03-01  2303  	if (current->journal_info == trans)
> 49b25e054 Jeff Mahoney   2012-03-01  2304  		current->journal_info = NULL;
> 7b8b92af5 Josef Bacik    2012-05-31  2305  	cleanup_transaction(trans, root, ret);
> 49b25e054 Jeff Mahoney   2012-03-01  2306
> 49b25e054 Jeff Mahoney   2012-03-01 @2307  	return ret;
> 79154b1b5 Chris Mason    2007-03-22  2308  }
> 79154b1b5 Chris Mason    2007-03-22  2309
> d352ac681 Chris Mason    2008-09-29  2310  /*
>
> :::::: The code at line 2307 was first introduced by commit
> :::::: 49b25e0540904be0bf558b84475c69d72e4de66e btrfs: enhance transaction abort infrastructure
>
> :::::: TO: Jeff Mahoney <jeffm@suse.com>
> :::::: CC: David Sterba <dsterba@suse.cz>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
>


