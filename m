Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30C3C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73CD020870
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 13:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73CD020870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbeLLNhu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 08:37:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:46320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726245AbeLLNhu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 08:37:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 175D5AD0C;
        Wed, 12 Dec 2018 13:37:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 13E8ADA7E5; Wed, 12 Dec 2018 14:37:24 +0100 (CET)
Date:   Wed, 12 Dec 2018 14:37:24 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: send, fix race with transaction commits that
 create snapshots
Message-ID: <20181212133722.GV23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181210175502.16620-1-fdmanana@kernel.org>
 <20181211101945.28695-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211101945.28695-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 11, 2018 at 10:19:45AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we create a snapshot of a snapshot currently being used by a send
> operation, we can end up with send failing unexpectedly (returning
> -ENOENT error to user space for example). The following diagram shows
> how this happens.
> 
>             CPU 1                                   CPU2                                CPU3
> 
>  btrfs_ioctl_send()
>   (...)
>                                      create_snapshot()
>                                       -> creates snapshot of a
>                                          root used by the send
>                                          task
>                                       btrfs_commit_transaction()
>                                        create_pending_snapshot()
>   __get_inode_info()
>    btrfs_search_slot()
>     btrfs_search_slot_get_root()
>      down_read commit_root_sem
> 
>      get reference on eb of the
>      commit root
>       -> eb with bytenr == X
> 
>      up_read commit_root_sem
> 
>                                         btrfs_cow_block(root node)
>                                          btrfs_free_tree_block()
>                                           -> creates delayed ref to
>                                              free the extent
> 
>                                        btrfs_run_delayed_refs()
>                                         -> runs the delayed ref,
>                                            adds extent to
>                                            fs_info->pinned_extents
> 
>                                        btrfs_finish_extent_commit()
>                                         unpin_extent_range()
>                                          -> marks extent as free
>                                             in the free space cache
> 
>                                       transaction commit finishes
> 
>                                                                        btrfs_start_transaction()
>                                                                         (...)
>                                                                         btrfs_cow_block()
>                                                                          btrfs_alloc_tree_block()
>                                                                           btrfs_reserve_extent()
>                                                                            -> allocates extent at
>                                                                               bytenr == X
>                                                                           btrfs_init_new_buffer(bytenr X)
>                                                                            btrfs_find_create_tree_block()
>                                                                             alloc_extent_buffer(bytenr X)
>                                                                              find_extent_buffer(bytenr X)
>                                                                               -> returns existing eb,
>                                                                                  which the send task got
> 
>                                                                         (...)
>                                                                          -> modifies content of the
>                                                                             eb with bytenr == X
> 
>     -> uses an eb that now
>        belongs to some other
>        tree and no more matches
>        the commit root of the
>        snapshot, resuts will be
>        unpredictable
> 
> The consequences of this race can be various, and can lead to searches in
> the commit root performed by the send task failing unexpectedly (unable to
> find inode items, returning -ENOENT to user space, for example) or not
> failing because an inode item with the same number was added to the tree
> that reused the metadata extent, in which case send can behave incorrectly
> in the worst case or just fail later for some reason.
> 
> Fix this by performing a copy of the commit root's extent buffer when doing
> a search in the context of a send operation.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Nice catch, patch added to misc-next, thanks.
