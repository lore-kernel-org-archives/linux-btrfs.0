Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:40824 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753450AbcL0LXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Dec 2016 06:23:20 -0500
Date: Tue, 27 Dec 2016 12:23:13 +0100
From: Nils Holland <nholland@tisys.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] mm, memcg: fix (Re: OOM: Better, but still there on)
Message-ID: <20161227112313.GA23101@boerne.fritz.box>
References: <20161222191719.GA19898@dhcp22.suse.cz>
 <20161222214611.GA3015@boerne.fritz.box>
 <20161223105157.GB23109@dhcp22.suse.cz>
 <20161223121851.GA27413@ppc-nas.fritz.box>
 <20161223125728.GE23109@dhcp22.suse.cz>
 <20161223144738.GB23117@dhcp22.suse.cz>
 <20161223222559.GA5568@teela.multi.box>
 <20161226124839.GB20715@dhcp22.suse.cz>
 <20161226185701.GA17030@boerne.fritz.box>
 <20161227080837.GA1308@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161227080837.GA1308@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 27, 2016 at 09:08:38AM +0100, Michal Hocko wrote:
> On Mon 26-12-16 19:57:03, Nils Holland wrote:
> > On Mon, Dec 26, 2016 at 01:48:40PM +0100, Michal Hocko wrote:
> > > On Fri 23-12-16 23:26:00, Nils Holland wrote:
> > > > On Fri, Dec 23, 2016 at 03:47:39PM +0100, Michal Hocko wrote:
> > > > > 
> > > > > Nils, even though this is still highly experimental, could you give it a
> > > > > try please?
> > > > 
> > > > Yes, no problem! So I kept the very first patch you sent but had to
> > > > revert the latest version of the debugging patch (the one in
> > > > which you added the "mm_vmscan_inactive_list_is_low" event) because
> > > > otherwise the patch you just sent wouldn't apply. Then I rebooted with
> > > > memory cgroups enabled again, and the first thing that strikes the eye
> > > > is that I get this during boot:
> > > > 
> > > > [    1.568174] ------------[ cut here ]------------
> > > > [    1.568327] WARNING: CPU: 0 PID: 1 at mm/memcontrol.c:1032 mem_cgroup_update_lru_size+0x118/0x130
> > > > [    1.568543] mem_cgroup_update_lru_size(f4406400, 2, 1): lru_size 0 but not empty
> > > 
> > > Ohh, I can see what is wrong! a) there is a bug in the accounting in
> > > my patch (I double account) and b) the detection for the empty list
> > > cannot work after my change because per node zone will not match per
> > > zone statistics. The updated patch is below. So I hope my brain already
> > > works after it's been mostly off last few days...
> > 
> > I tried the updated patch, and I can confirm that the warning during
> > boot is gone. Also, I've tried my ordinary procedure to reproduce my
> > testcase, and I can say that a kernel with this new patch also works
> > fine and doesn't produce OOMs or similar issues.
> > 
> > I had the previous version of the patch in use on a machine non-stop
> > for the last few days during normal day-to-day workloads and didn't
> > notice any issues. Now I'll keep a machine running during the next few
> > days with this patch, and in case I notice something that doesn't look
> > normal, I'll of course report back!
> 
> Thanks for your testing! Can I add your
> Tested-by: Nils Holland <nholland@tisys.org>

Yes, I think so! The patch has now been running for 16 hours on my two
machines, and that's an uptime that was hard to achieve since 4.8 for
me. ;-) So my tests clearly suggest that the patch is good! :-)

Greetings
Nils
