Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:45430 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaBHUKl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 15:10:41 -0500
Date: Sat, 8 Feb 2014 15:10:37 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [btrfs] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000038
Message-ID: <20140208201037.GC10975@htj.dyndns.org>
References: <20140207023801.GC11051@localhost>
 <alpine.DEB.2.02.1402070213020.22146@chino.kir.corp.google.com>
 <20140207121038.GA1690@localhost>
 <alpine.DEB.2.02.1402071307590.4212@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1402071307590.4212@chino.kir.corp.google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, David, Fengguang, Chris.

On Fri, Feb 07, 2014 at 01:13:06PM -0800, David Rientjes wrote:
> On Fri, 7 Feb 2014, Fengguang Wu wrote:
> 
> > On Fri, Feb 07, 2014 at 02:13:59AM -0800, David Rientjes wrote:
> > > On Fri, 7 Feb 2014, Fengguang Wu wrote:
> > > 
> > > > [    1.625020] BTRFS: selftest: Running btrfs_split_item tests
> > > > [    1.627004] BTRFS: selftest: Running find delalloc tests
> > > > [    2.289182] tsc: Refined TSC clocksource calibration: 2299.967 MHz
> > > > [  292.084537] kthreadd invoked oom-killer: gfp_mask=0x3000d0, order=1, oom_score_adj=0
> > > > [  292.086439] kthreadd cpuset=
> > > > [  292.087072] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> > > > [  292.087372] IP: [<ffffffff812119de>] pr_cont_kernfs_name+0x1b/0x6c
> > > 
> > > This looks like a problem with the cpuset cgroup name, are you sure this 
> > > isn't related to the removal of cgroup->name?
> > 
> > It looks not related to patch "cgroup: remove cgroup->name", because
> > that patch lies in the cgroup tree and not contained in output of "git log BAD_COMMIT".
> > 
> 
> It's dying on pr_cont_kernfs_name which is some tree that has "kernfs: 
> implement kernfs_get_parent(), kernfs_name/path() and friends", which is 
> not in linux-next, and is obviously printing the cpuset cgroup name.
> 
> It doesn't look like it has anything at all to do with btrfs or why they 
> would care about this failure.

Yeah, this is from a patch in cgroup/review-post-kernfs-conversion
branch which updates cgroup to use pr_cont_kernfs_name().  I forget
that cgrp->kn is NULL for the dummy_root's top cgroup and thus it ends
up calling the kernfs functions with NULL kn and thus the oops.  I
posted an updated patch and the git branch has been updated.

 http://lkml.kernel.org/g/20140208200640.GB10975@htj.dyndns.org

So, nothing to do with btrfs and it looks like somehow the test
appratus is mixing up branches?

Thanks!

-- 
tejun
