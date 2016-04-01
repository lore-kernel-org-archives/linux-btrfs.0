Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbcDALju (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 07:39:50 -0400
Date: Fri, 1 Apr 2016 13:39:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
Message-ID: <20160401113913.GA9918@suse.cz>
Reply-To: dsterba@suse.cz
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz>
 <56FDC0A2.1030909@cn.fujitsu.com>
 <20160401084418.GI6230@suse.cz>
 <56FE363E.5090202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56FE363E.5090202@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:50:06PM +0800, Qu Wenruo wrote:
> > After another look, why don't we use nodesize directly? Or stripesize
> > where applies. With max_size == 0 the test does not make sense, we ought
> > to know the alignment.
> >
> Yes, my first though is also to use nodesize directly, which should be 
> always correct.
> 
> But the problem is, the related function call stack doesn't have any 
> member to reach btrfs_root or btrfs_fs_info.
> 
> In the very beginning version of such crossing stripe check, I used to 
> add a btrfs_root/btrfs_fs_info parameter to the function.
> 
> But the code change are too many, so I use 'max_size'.
> 
> I can try to re-do such modification, but IIRC it didn't cause a good 
> result.

Yes it would require refactoring, which would be good on itself, because
add_extent_rec takes 12(!) parameters. Some of its callers would need to
be updated, but it seems doable.
