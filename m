Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05CAC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 12:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B766221871
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 12:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfDEMFC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 08:05:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:50724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbfDEMFC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 08:05:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65D15AF1E
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2019 12:05:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 63553DA847; Fri,  5 Apr 2019 14:06:09 +0200 (CEST)
Date:   Fri, 5 Apr 2019 14:06:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 0/9] btrfs: Refactor delayed ref parameter list
Message-ID: <20190405120609.GV29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404064537.4031-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 02:45:28PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/refactor_delayed_ref_parameter
> 
> Which is based on David's misc-next branch, the base commit is:
> commit 56d46f96de92ec69963acb7b1d9aed83d2a56a7b (david/misc-next-with-write-checks, david/misc-next)
> Author: Nikolay Borisov <nborisov@suse.com>
> Date:   Wed Mar 27 14:24:18 2019 +0200
> 
>     btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit
> 
> 
> Current delayed ref interface has several problems:
> - Longer and longer parameter lists
>   bytenr
>   num_bytes
>   parent
>   ---- So far so good
>   ref_root
>   owner
>   offset
>   ---- I don't feel well now
>   for_reloc
>   ^^^^ This parameter only makes sense for qgroup code, but we need
>        to pass the parameter a long way down.
> 
>   This makes later parameter list add more and more tricky.
> 
> - Different interpretation for the same parameter
>   Above @owner for data ref is inode who owns this extent,
>   while for tree ref, it's level. They are even in different size range.
> 
>   For level we only need 0~8, while for ino it's
>   BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID, so it's still
>   possible to distinguish them, but it's never a straight-forward thing
>   to grasp.
> 
>   And @offset doesn't even makes sense for tree ref.
> 
>   Such parameter reuse may look clever as an hidden union, but it
>   destroys code readability.
> 
> This patchset will change the way how we pass parameters for delayed
> ref.
> Instead of calling delayed ref interface like:
>   ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, parent,
> 			     ref_root, owner, offset);
> Or
>   ret = btrfs_inc_extent_ref(trans, root, bytenr, nodesize, parent,
> 			     level, ref_root, 0);
> 
> We now call like:
>   btrfs_init_generic_ref(&ref, bytenr, num_bytes,
> 			 root->root_key.objectid, parent);
>   btrfs_init_data_ref(&ref, ref_root, owner, offset);
>   ret = btrfs_inc_extent_ref(trans, &ref);
> Or
>   btrfs_init_generic_ref(&ref, bytenr, num_bytes,
> 			 root->root_key.objectid, parent);
>   btrfs_init_tree_ref(&ref, level, ref_root);
>   ret = btrfs_inc_extent_ref(trans, &ref);
> 
> To determine if a ref is tree or data, instead of calling like:
>   if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>   } else {
>   }
> We do it straight-forward:
>   if (ref->type == BTRFS_REF_METADATA) {
>   } else {
>   }
> 
> And for new members determining some minor behavior, we don't need to add
> a new parameter to btrfs_add_delayed_tree|data_ref() or
> btrfs_inc_extent_ref(), we just assign them after generic/data/tree init, like:
> 
>   btrfs_init_generic_ref(&ref, bytenr, num_bytes,
> 			 root->root_key.objectid, parent);
>   ref->real_root = root->root_key.objectid;
>   ref->skip_qgroup = true;
>   btrfs_init_data_ref(&ref, ref_root, owner, offset);
> 
>   ret = btrfs_inc_extent_ref(trans, &ref);
> 
> This should improve the code readability and make later code easier to
> write.
> 
> Furthermore, with the help of btrfs_ref::real_root parameter, qgroup
> can skip quit a lot of delayed tree/data ref for reloc tree, which
> makes qgroup + balance as fast as quota disabled:
> 
> Test VM:
> - vRAM		8G
> - vCPU		8
> - block dev	vitrio-blk, 'unsafe' cache mode
> - host block	850evo
> 
> Test workload
> - Copy 4G data from /usr/ to one subvolume
> - Create 16 snapshots of that subvolume, and modify 3 files in each
>   snapshot
> - Enable quota, rescan
> - Time "btrfs balance start -m"
> 
>               |      base |  w/ patchset |  no qgroups |
> -------------------------------------------------------------
> relocated     |     23765 |        23772 |       23811 |
> qgroup dirty  |    124498 |           70 |           0 |
> time (sec)    |    23.353 |        3.505 |       3.421 |
> 
> 
> Changelog:
> v2:
> - Better documentation for btrfs_ref declaration
> - Rebase to newer delayed subtree rescan patchset
> - Add reviewed-by tags
> - Remove unnecessary ASSERT() for NULL pointer.
> 
> v3:
> - Rebase to misc-next branch as that branch has all prerequisite now.
> - Update benchmark result, compare with qgroups disabled case directly.
> 
> v3.1:
> - Rebase to misc-next branch.

This does not seem to exhibit the problems I recall from previous
testing, so I'll queue it for merge to misc-next unless there are more
review comments.
