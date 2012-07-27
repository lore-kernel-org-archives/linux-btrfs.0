Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49727 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2G0Smm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 14:42:42 -0400
Date: Fri, 27 Jul 2012 11:42:39 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120727184238.GA6713@merlins.org>
References: <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120202124241.GW16796@shiny>
 <20120718220446.GB3888@merlins.org>
 <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120722204428.GC3925@merlins.org>
 <20120722224145.GC12951@merlins.org>
 <20120723064202.GB6931@merlins.org>
 <20120727110835.GA6933@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120727110835.GA6933@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 27, 2012 at 07:08:35AM -0400, Chris Mason wrote:
> On Mon, Jul 23, 2012 at 12:42:03AM -0600, Marc MERLIN wrote:
> > 
> > 22 seconds for 15K files on an SSD is super slow and being 5 times
> > slower than a spinning disk with the same data.
> > What's going on?
> 
> Hi Marc,
> 
> The easiest way to figure out is with latencytop.  I'd either run the
> latencytop gui or use the latencytop -c patch which sends a text dump to
> the console.
> 
> This is assuming that you're not pegged at 100% CPU...
> 
> https://oss.oracle.com/~mason/latencytop.patch

Thanks for the patch, and yes I can confirm I'm definitely not pegged on CPU 
(not even close and I get the same problem with unencrypted filesystem, actually
du -sh is exactly the same speed on encrypted and unecrypted).

Here's the result I think you were looking for. I'm not good at reading this,
but hopefully it tells you something useful :)

The full run is here if that helps:
http://marc.merlins.org/tmp/latencytop.txt

Process du (6748) Total: 4280.5 msec
	Reading directory content	 15.2 msec         11.0 %
		sleep_on_page wait_on_page_bit read_extent_buffer_pages 
		btree_read_extent_buffer_pages.constprop.110 read_tree_block 
		read_block_for_search.isra.32 btrfs_next_leaf 
		btrfs_real_readdir vfs_readdir sys_getdents system_call_fastpath 
	[sleep_on_page]	 13.5 msec         88.2 %
		sleep_on_page wait_on_page_bit read_extent_buffer_pages 
		btree_read_extent_buffer_pages.constprop.110 read_tree_block 
		read_block_for_search.isra.32 btrfs_search_slot 
		btrfs_lookup_csum __btrfs_lookup_bio_sums 
		btrfs_lookup_bio_sums btrfs_submit_compressed_read btrfs_submit_bio_hook 
	Page fault	 12.9 msec          0.6 %
		sleep_on_page_killable wait_on_page_bit_killable 
		__lock_page_or_retry filemap_fault __do_fault handle_pte_fault 
		handle_mm_fault do_page_fault page_fault 
	Executing a program	  7.1 msec          0.2 %
		sleep_on_page_killable __lock_page_killable 
		generic_file_aio_read do_sync_read vfs_read kernel_read 
		prepare_binprm do_execve_common.isra.27 do_execve sys_execve 
		stub_execve 

Process du (6748) Total: 9517.4 msec
	[sleep_on_page]	 23.0 msec         82.8 %
		sleep_on_page wait_on_page_bit read_extent_buffer_pages 
		btree_read_extent_buffer_pages.constprop.110 read_tree_block 
		read_block_for_search.isra.32 btrfs_search_slot 
		btrfs_lookup_inode btrfs_iget btrfs_lookup_dentry btrfs_lookup 
		__lookup_hash 
	Reading directory content	 13.2 msec         17.2 %
		sleep_on_page wait_on_page_bit read_extent_buffer_pages 
		btree_read_extent_buffer_pages.constprop.110 read_tree_block 
		read_block_for_search.isra.32 btrfs_search_slot 
		btrfs_real_readdir vfs_readdir sys_getdents system_call_fastpath 

Process du (6748) Total: 9524.0 msec
	[sleep_on_page]	 17.1 msec         88.5 %
		sleep_on_page wait_on_page_bit read_extent_buffer_pages 
		btree_read_extent_buffer_pages.constprop.110 read_tree_block 
		read_block_for_search.isra.32 btrfs_search_slot 
		btrfs_lookup_inode btrfs_iget btrfs_lookup_dentry btrfs_lookup 
		__lookup_hash 
	Reading directory content	 16.0 msec         11.5 %
		sleep_on_page wait_on_page_bit read_extent_buffer_pages 
		btree_read_extent_buffer_pages.constprop.110 read_tree_block 
		read_block_for_search.isra.32 btrfs_search_slot 
		btrfs_real_readdir vfs_readdir sys_getdents system_call_fastpath 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
