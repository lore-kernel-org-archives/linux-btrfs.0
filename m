Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbcDVUrb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 16:47:31 -0400
Date: Fri, 22 Apr 2016 13:47:28 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Test that qgroup counts are valid after snapshot
 creation
Message-ID: <20160422204728.GB2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20160419222530.GU2187@wotan.suse.de>
 <5716D1F6.6010507@jp.fujitsu.com>
 <20160421235348.GW2187@wotan.suse.de>
 <dd1ae558-9214-022f-10e2-5efd68857e2e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dd1ae558-9214-022f-10e2-5efd68857e2e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2016 at 08:26:33AM +0800, Qu Wenruo wrote:
> 
> 
> Mark Fasheh wrote on 2016/04/21 16:53 -0700:
> >Thank you for the review, comments are below.
> >
> >On Wed, Apr 20, 2016 at 09:48:54AM +0900, Satoru Takeuchi wrote:
> >>On 2016/04/20 7:25, Mark Fasheh wrote:
> >>>+# Force a small leaf size to make it easier to blow out our root
> >>>+# subvolume tree
> >>>+_scratch_mkfs "--nodesize 16384"
> >>
> >>nodesize 16384 is the default value. Do you
> >>intend other value, for example 4096?
> >
> >"future proofing" I suppose - if we up the default, the for loop below may
> >not create a level 1 tree.
> >
> >If we force it smaller than 16K I believe that may mean we can't run this
> >test on some kernels with page size larger than the typical 4k.
> >	--Mark
> >
> >
> >--
> >Mark Fasheh
> >
> >
> 
> Sorry for the late reply.
> 
> Unfortunately, for system with 64K page size, it will fail(mount and
> mkfs) if we use 16K nodesize.
> 
> IIRC, like some other btrfs qgroup test case, we use 64K nodesize as
> the safest nodesize.
> 
> And for level 1 tree create, the idea is to use inline file extents
> to rapidly create level 1 tree.
> 
> 16 4K files should create a level 1 tree.
> Although in this case, max_inline=4096 would be added to mount
> option though.

That all sounds good, thanks. The only thing about filling it completely
with inline extents though is that we should be exercising qgroups a little
harder. But maybe we can blow out the tree with inline extents and then add
some actual data extents after that.
	--Mark

--
Mark Fasheh
