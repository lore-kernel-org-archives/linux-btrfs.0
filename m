Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbcDEIrI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 04:47:08 -0400
Date: Tue, 5 Apr 2016 10:43:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
Message-ID: <20160405084336.GF3412@suse.cz>
Reply-To: dsterba@suse.cz
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz>
 <56FDC0A2.1030909@cn.fujitsu.com>
 <20160401084418.GI6230@suse.cz>
 <56FE363E.5090202@cn.fujitsu.com>
 <20160404111852.GG9918@twin.jikos.cz>
 <570314BF.209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <570314BF.209@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 05, 2016 at 09:28:31AM +0800, Qu Wenruo wrote:
> 
> 
> David Sterba wrote on 2016/04/04 13:18 +0200:
> > On Fri, Apr 01, 2016 at 04:50:06PM +0800, Qu Wenruo wrote:
> >>> After another look, why don't we use nodesize directly? Or stripesize
> >>> where applies. With max_size == 0 the test does not make sense, we ought
> >>> to know the alignment.
> >>>
> >>>
> >> Yes, my first though is also to use nodesize directly, which should be
> >> always correct.
> >>
> >> But the problem is, the related function call stack doesn't have any
> >> member to reach btrfs_root or btrfs_fs_info.
> >
> > JFYI, there's global_info avalaible, so it's not necessary to pass
> > fs_info down the callstacks.
> >
> >
> Oh, that's a good news.
> 
> Do I need to re-submit the patch to use fs_info->tree_root->nodesize to 
> avoid false alert?
> Or wait for your refactor?

No need to resend, the refactored code is now in devel.
