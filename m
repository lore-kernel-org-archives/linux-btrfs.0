Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48371 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934619AbcLUOEL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 09:04:11 -0500
Date: Wed, 21 Dec 2016 09:04:14 -0500
From: Chris Mason <clm@fb.com>
To: Michal Hocko <mhocko@kernel.org>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, <nholland@tisys.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: OOM: Better, but still there on
Message-ID: <20161221140413.GA91507@clm-mbp.masoncoding.com>
References: <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
 <20161217210646.GA11358@boerne.fritz.box>
 <20161219134534.GC5164@dhcp22.suse.cz>
 <20161220020829.GA5449@boerne.fritz.box>
 <20161221073658.GC16502@dhcp22.suse.cz>
 <201612212000.EJJ21327.SFHOLQOtVFMOFJ@I-love.SAKURA.ne.jp>
 <20161221111653.GF31118@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <20161221111653.GF31118@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 21, 2016 at 12:16:53PM +0100, Michal Hocko wrote:
>On Wed 21-12-16 20:00:38, Tetsuo Handa wrote:
>
>One thing to note here, when we are talking about 32b kernel, things
>have changed in 4.8 when we moved from the zone based to node based
>reclaim (see b2e18757f2c9 ("mm, vmscan: begin reclaiming pages on a
>per-node basis") and associated patches). It is possible that the
>reporter is hitting some pathological path which needs fixing but it
>might be also related to something else. So I am rather not trying to
>blame 32b yet...

It might be interesting to put tracing on releasepage and see if btrfs 
is pinning pages around.  I can't see how 32bit kernels would be 
different, but maybe we're hitting a weird corner.

-chris

