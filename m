Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45963C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 19:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 132292085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 19:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfCSTrB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:47:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:55900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726768AbfCSTrB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 15:47:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71CF7B000;
        Tue, 19 Mar 2019 19:46:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E91D6DA9F3; Tue, 19 Mar 2019 20:48:14 +0100 (CET)
Date:   Tue, 19 Mar 2019 20:48:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        Yoon Jungyeon <jungyeon@gatech.edu>
Subject: Re: [PATCH v2] btrfs: Check the first key and level for cached
 extent buffer
Message-ID: <20190319194814.GR3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190312091040.3352-1-wqu@suse.com>
 <a89819cb-bade-3af1-6fbd-a56b40daad0e@suse.com>
 <d3dbe8a5-d561-b9a6-3e27-83c21a4392e1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3dbe8a5-d561-b9a6-3e27-83c21a4392e1@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 12, 2019 at 07:09:50PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/3/12 下午7:07, Nikolay Borisov wrote:
> > 
> > 
> > On 12.03.19 г. 11:10 ч., Qu Wenruo wrote:
> >> [BUG]
> >> When reading a file from a fuzzed image, kernel can panic like:
> >>   BTRFS warning (device loop0): csum failed root 5 ino 270 off 0 csum 0x98f94189 expected csum 0x00000000 mirror 1
> >>   assertion failed: !memcmp_extent_buffer(b, &disk_key, offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: fs/btrfs/ctree.c, line: 2544
> >>   ------------[ cut here ]------------
> >>   kernel BUG at fs/btrfs/ctree.h:3500!
> >>   invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> >>   RIP: 0010:btrfs_search_slot.cold.24+0x61/0x63 [btrfs]
> >>   Call Trace:
> >>    btrfs_lookup_csum+0x52/0x150 [btrfs]
> >>    __btrfs_lookup_bio_sums+0x209/0x640 [btrfs]
> >>    btrfs_submit_bio_hook+0x103/0x170 [btrfs]
> >>    submit_one_bio+0x59/0x80 [btrfs]
> >>    extent_read_full_page+0x58/0x80 [btrfs]
> >>    generic_file_read_iter+0x2f6/0x9d0
> >>    __vfs_read+0x14d/0x1a0
> >>    vfs_read+0x8d/0x140
> >>    ksys_read+0x52/0xc0
> >>    do_syscall_64+0x60/0x210
> >>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >>
> >> [CAUSE]
> >> The fuzzed image has a corrupted leaf whose first key doesn't match with its parent:
> >>   checksum tree key (CSUM_TREE ROOT_ITEM 0)
> >>   node 29741056 level 1 items 14 free 107 generation 19 owner CSUM_TREE
> >>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
> >>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
> >>   	...
> >>           key (EXTENT_CSUM EXTENT_CSUM 79691776) block 29761536 gen 19
> >>
> >>   leaf 29761536 items 1 free space 1726 generation 19 owner CSUM_TREE
> >>   leaf 29761536 flags 0x1(WRITTEN) backref revision 1
> >>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
> >>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
> >>           item 0 key (EXTENT_CSUM EXTENT_CSUM 8798638964736) itemoff 1751 itemsize 2244
> >>                   range start 8798638964736 end 8798641262592 length 2297856
> >>
> >> When reading above tree block, we have extent_buffer->refs = 2 in the
> >> context:
> >> - initial one from __alloc_extent_buffer()
> >>   alloc_extent_buffer()
> >>   |- __alloc_extent_buffer()
> >>      |- atomic_set(&eb->refs, 1)
> >>
> >> - one being added to fs_info->buffer_radix
> >>   alloc_extent_buffer()
> >>   |- check_buffer_tree_ref()
> >>      |- atomic_inc(&eb->refs)
> >>
> >> So even we call free_extent_buffer() in read_tree_block or other similar
> >> situation, we only decrease the refs by 1, it doesn't reach 0 and won't
> >> be freed right now.
> >>
> >> The staled eb and its corrupted content will still be kept cached.
> >>
> >> Further more, we have several extra cases where we either don't do
> >> first key check or the check is not proper for all callers:
> >> - scrub
> >>   We just don't have first key in this context.
> >>
> >> - shared tree block
> >>   One tree block can be shared by several snapshot/subvolume trees.
> >>   In that case, the first key check for one subvolume doesn't apply to
> >>   another.
> >>
> >> So for above reasons, a corrupted extent buffer can sneak into the
> >> buffer cache.
> >>
> >> [FIX]
> >> Export verify_level_key() as btrfs_verify_level_key() and call it in
> >> read_block_for_search() to fill the hole.
> >>
> >> Due to above described reasons, even we can free corrupted extent buffer
> >> from cache, we still need the check in read_block_for_search(), for
> >> scrub and shared tree blocks.
> >>
> >> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202757
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202759
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202761
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202767
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202769
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >> changelog:
> >> v2:
> >> - Commit message update to show the reason why stale ebs are kept in
> >>   cache.
> >> - Commit message update to show extra reasons why we still need the
> >>   check, mainly for scrub and shared tree blocks.
> >> ---
> >>  fs/btrfs/ctree.c   | 10 ++++++++++
> >>  fs/btrfs/disk-io.c | 10 +++++-----
> >>  fs/btrfs/disk-io.h |  3 +++
> >>  3 files changed, 18 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> >> index 5a6c39b44c84..7672932aa5b4 100644
> >> --- a/fs/btrfs/ctree.c
> >> +++ b/fs/btrfs/ctree.c
> >> @@ -2401,6 +2401,16 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
> >>  	if (tmp) {
> >>  		/* first we do an atomic uptodate check */
> >>  		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
> >> +			/*
> >> +			 * Do extra check for first_key, eb can be stale due to
> >> +			 * being cached, read from scrub, or have multiple
> >> +			 * parents (shared tree blocks).
> >> +			 */
> >> +			if (btrfs_verify_level_key(fs_info, tmp,
> >> +					parent_level - 1, &first_key, gen)) {
> >> +				free_extent_buffer(tmp);
> >> +				return -EUCLEAN;
> >> +			}
> > 
> > What about verify_parent_transid? Shouldn't it also be checked here?
> 
> Previous btrfs_buffer_uptodate() call implies verify_parent_transid()
> check, and that's why btrfs_buffer_uptodate() needs transid parameter.

Agreed, though following btrfs_buffer_uptodate is not exactly
straightforward as it can return 3 values depending on the atomic
parameter (the 3rd one).
