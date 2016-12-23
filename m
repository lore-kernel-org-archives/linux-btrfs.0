Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40609 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938902AbcLWM5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 07:57:39 -0500
Date: Fri, 23 Dec 2016 13:57:28 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Nils Holland <nholland@tisys.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161223125728.GE23109@dhcp22.suse.cz>
References: <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
 <20161217210646.GA11358@boerne.fritz.box>
 <20161219134534.GC5164@dhcp22.suse.cz>
 <20161220020829.GA5449@boerne.fritz.box>
 <20161221073658.GC16502@dhcp22.suse.cz>
 <20161222101028.GA11105@ppc-nas.fritz.box>
 <20161222191719.GA19898@dhcp22.suse.cz>
 <20161222214611.GA3015@boerne.fritz.box>
 <20161223105157.GB23109@dhcp22.suse.cz>
 <20161223121851.GA27413@ppc-nas.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161223121851.GA27413@ppc-nas.fritz.box>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 23-12-16 13:18:51, Nils Holland wrote:
> On Fri, Dec 23, 2016 at 11:51:57AM +0100, Michal Hocko wrote:
> > TL;DR
> > drop the last patch, check whether memory cgroup is enabled and retest
> > with cgroup_disable=memory to see whether this is memcg related and if
> > it is _not_ then try to test with the patch below
> 
> Right, it seems we might be looking in the right direction! So I
> removed the previous patch from my kernel and verified if memory
> cgroup was enabled, and indeed, it was. So I booted with
> cgroup_disable=memory and ran my ordinary test again ... and in fact,
> no ooms!

OK, thanks for confirmation. I could have figured that earlier. The
pagecache differences in such a short time should have raised the red
flag and point towards memcgs...

[...]
> > I would appreciate to stick with your setup to not pull new unknows into
> > the picture.
> 
> No problem! It's just likely that I won't be able to test during the
> following days until Dec 27th, but after that I should be back to
> normal and thus be able to run further tests in a timely fashion. :-)

no problem at all. I will try to cook up a patch in the mean time.
-- 
Michal Hocko
SUSE Labs
