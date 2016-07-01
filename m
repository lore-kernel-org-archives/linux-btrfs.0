Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35850 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbcGARin (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 13:38:43 -0400
Date: Fri, 1 Jul 2016 12:38:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Nikolay Borisov <kernel@kyup.com>, Jan Kara <jack@suse.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        dvyukov@google.com, linux-btrfs@vger.kernel.org,
        SiteGround Operations <operations@siteground.com>
Subject: Re: GPF in __mark_inode_dirty due to
 locked_inode_to_wb_and_lock_list returning NULL
Message-ID: <20160701173827.GE28719@htj.duckdns.org>
References: <5774FFF6.3030408@kyup.com>
 <20160701100050.GC22922@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160701100050.GC22922@quack2.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 01, 2016 at 12:00:50PM +0200, Jan Kara wrote:
> Hello,
> 
> On Thu 30-06-16 14:18:14, Nikolay Borisov wrote:
> > In light of the discussion in https://patchwork.kernel.org/patch/9187411/ and 
> > the discussion at https://groups.google.com/forum/#!topic/syzkaller/XvxH3cBQ134
> 
> Well, it looks it is also some bdi_writeback lifetime issue but I don't see
> how it would be related to I_DIRTY_TIME issues. There were couple of fixes
> related to bdi_writeback issues from Tejun since 4.4. Maybe Tejun can tell
> you whether he's seen this or not...

Yeah, this could be the same problem from the blkdev detach path.
Nikolay, was there any block device hot unplugging going on?  If not,
do you have a reproducer?

Thanks.

-- 
tejun
