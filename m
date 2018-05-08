Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60687 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755404AbeEHQcv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 12:32:51 -0400
Date: Tue, 8 May 2018 18:30:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.de>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 00/18] btrfs-progs: lowmem check: avoid extents
 overwrite
Message-ID: <20180508163008.GI6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
 <20180507181737.GE6649@twin.jikos.cz>
 <86ef8426-80b3-be41-2c95-d2d173d973ab@cn.fujitsu.com>
 <f43e2d6d-4800-faae-6b81-99cd12f7ecda@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <f43e2d6d-4800-faae-6b81-99cd12f7ecda@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 10:06:05AM +0800, Qu Wenruo wrote:
> >>>   - Repair functions for lowmem mode call try_avoid_extents_overwrite()
> >>>     and start transactions.
> >>>     Su Yue (18):
> >>>    btrfs-progs: lowmem check: release path in repair_extent_data_item()
> >>>    btrfs-progs: lowmem check: record returned errors after
> >>>      walk_down_tree_v2()
> >>>    btrfs-progs: lowmem check: assign @parent early in
> >>>      repair_extent_data_item()
> >>>    btrfs-progs: lowmem check: exclude extents of metadata blocks
> >>
> >> Patch 1-4 added to devel.
> >>
> >>>    btrfs-progs: lowmem check: introduce mark/clear_block_groups_full()
> >>
> >> There were too many conflicts starting with this patch.
> >>
> >> Can you please refresh teh rest of the series and resend?
> >>
> > OK of cource. An small question below.
> > 
> > Though this patchset is for lowmem mode, it also changes original mode
> > for code reuse.
> > 
> > This patch and remainings base on Qu's unmerged patchset:
> >     [PATCH 0/3] btrfs-progs: Split original mode check to its own
> >         Author: Qu Wenruo <wqu@suse.com>
> > New version is named
> >     [PATCH 0/3] btrfs-progs: Split mode-original code
> >     Author: Qu Wenruo <wqu@suse.com>
> 
> Sorry, that patchset will not be updated until we get a relatively
> stable check code base.
> So I'm afraid you need to base them on current devel branch other than
> my patchset.

Yeah, my plan for the upcoming weeks is to get all the pending patchsets
with fixes merged before any bigger code cleanups, in check/.
