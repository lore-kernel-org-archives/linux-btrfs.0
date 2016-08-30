Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59805 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754327AbcH3LdX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 07:33:23 -0400
Date: Tue, 30 Aug 2016 13:32:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: skip shared node or leaf check for
 low_memory mode
Message-ID: <20160830113202.GB16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160819095946.31917-1-wangxg.fnst@cn.fujitsu.com>
 <20160824124431.GQ16983@twin.jikos.cz>
 <57BE8261.4040308@cn.fujitsu.com>
 <20160829152035.GV16983@twin.jikos.cz>
 <0158e565-3bb8-01fb-362f-6d5d8ec4cf35@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0158e565-3bb8-01fb-362f-6d5d8ec4cf35@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 09:50:20AM +0800, Qu Wenruo wrote:
> > Are they not? The low-memory patchset has been released in 4.7.1, the
> > devel branch is always on top of master branch. I see both branches
> > pushed to the public git repos so I don't see what you mean.
> 
> Unfortunately, the low memory mode is not fully merged into devel branch.
> 
> Only the first part (extent and chunk tree) is merged.
> 
> The second part(fs tree) is not merged yet.
> 
> Patches like the following is not in either devel/master branch:
> Lu Fengqi (13):
>    btrfs-progs: move btrfs_extref_hash() to hash.h
>    btrfs-progs: check: introduce function to find dir_item
>    btrfs-progs: check: introduce function to check inode_ref
>    btrfs-progs: check: introduce function to check inode_extref
>    btrfs-progs: check: introduce function to find inode_ref
>    btrfs-progs: check: introduce a function to check dir_item
>    btrfs-progs: check: introduce function to check file extent
>    btrfs-progs: check: introduce function to check inode item
>    btrfs-progs: check: introduce function to check fs root
>    btrfs-progs: check: introduce function to check root ref
>    btrfs-progs: check: introduce low_memory mode fs_tree check
>    btrfs-progs: check: fix the return value bug of cmd_check()
>    btrfs-progs: check: fix false warning for check_extent_item()
> 
> So Wang found it confusing and unable to apply his patch to devel branch.

He could have replied himself, I think the conversation would feel
better when we can talk directly :)

So the situation with the patchset is a bit messed up. I thought there
was only one patchset for the low-memory mode as the subjects are hard
to tell appart "introduce something" 20 times. I should have spotted
that, but you know how many patches float in the mailinglist, mistakes
happen.

Now that I know where the problem is, I'll add the remaining patches to
devel and release in next or next-next round, depending on the review.
