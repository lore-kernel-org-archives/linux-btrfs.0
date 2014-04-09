Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58546 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaDIHpK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 03:45:10 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id F1BA220B93
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 03:45:09 -0400 (EDT)
Message-ID: <5344FA85.1030802@grosser.es>
Date: Wed, 09 Apr 2014 09:45:09 +0200
From: Tobias Grosser <tobias@grosser.es>
MIME-Version: 1.0
To: aagaande@gmail.com, linux-btrfs@vger.kernel.org
Subject: Re: dm-crypt + btrfs preformance - long lockups during io
In-Reply-To: <CANOdGizDdNvBjFu+LSGpUdpbO+PeuRLE=Qa-3eQRXhzDtpyFDw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 5, 2014 at 10:54 AM, Anders Aagaard <aagaande@xxxxxxxxx> wrote:
 > Hi
 >
 > I just recently repartitioned my harddrive, and in the process
switched from
 > ext4+ecryptfs to dm-crypt and btrfs. I'm on ubuntu 14.04, using kernel
 > 3.14.0-031400-generic. I'm using a intel ssd, which btrfs detects
(ssd mode
 > enabled according to dmesg).

I also saw and still see lockups on linux 3.8 with a similar 
configuration. btrfs on dm-crypt with SSD mode. I use slightly different 
mount options:

/dev/mapper/sda4_crypt on /home type btrfs 
(rw,noatime,flushoncommit,subvol=@home)
/dev/mapper/sda4_crypt on /store type btrfs (rw,subvol=@store)
/dev/mapper/sda4_crypt on /home/grosser type btrfs 
(rw,noatime,flushoncommit,subvol=@grosser)

(I previously also used compression. This is disabled at the moment, but 
compressed files are still around)

latencytop gives the following information:


firefox: 22909.8 ms latency, cause fsync() on a file

The corresponding backtrace is:

btrfs_log_inode_parent
[btrfs]
btrfs_log_dentry_safe
[btrfs]
btrfs_sync_file
[btrfs]
do_fsync
sys_fsync
system_call_fastpath

There are also 6 processes called

btrfs-endio-wri?? with 1050-1391 ms latency due to [sleep_on_page].

The corresponding backtraces are (3x):

sleep_on_page
wait_on_page_bit
read_extent_buffer_pages
[btrfs]
btree_read_extend_buffer_pages.constprop.119
[btrfs]
read_tree_block
[btrfs]
read_node_slot
[btrfs]
push_leaf_right
[btrfs]
split_leaf
[btrfs]
btrfs_search_slot
[btrfs]
btrfs_csum_file_blocks
[btrfs]
add_pending_csums.isra.42
[btrfs]
btrfs_finish_ordered_io
[btrfs]

1x:

sleep_on_page
wait_on_page_bit
read_extent_buffer_pages
[btrfs]
btree_read_extend_buffer_pages.constprop.119
[btrfs]
read_tree_block
[btrfs]
read_block_for_search.isra.51
[btrfs]
btrfs_search_slot
[btrfs]
btrfs_insert_empty_items
[btrfs]
run_clustered_refs
[btrfs]
btrfs_run_delayed_refs
[btrfs]
__btrfs_end_transaction
[btrfs]
btfs_end_transaction
[btrfs]

1x
sleep_on_page
wait_on_page_bit
read_extent_buffer_pages
[btrfs]
btree_read_extend_buffer_pages.constprop.119
[btrfs]
read_tree_block
[btrfs]
read_node_slot
[btrfs]
push_leaf_left
[btrfs]
split_leaf
[btrfs]
btrfs_search_slot
[btrfs]
btrfs_insert_empty_items
[btrfs]
btrfs_csum_file_blocks
[btrfs]
add_pending_csums.isra.42
[btrfs]

1x
sleep_on_page
wait_on_page_bit
read_extent_buffer_pages
[btrfs]
btree_read_extend_buffer_pages.constprop.119
[btrfs]
read_tree_block
[btrfs]
read_node_slot
[btrfs]
push_leaf_right
[btrfs]
split_leaf
[btrfs]
btrfs_search_slot
[btrfs]
btrfs_csum_file_blocks
[btrfs]
add_pending_csums.isra.42
[btrfs]
btrfs_finish_ordered_io
[btrfs]

At the moment of deadlock, I am just running normal desktop applications 
like thunderbird and firefox.

Cheers,
Tobias

Any idea where such long delays may come from.
