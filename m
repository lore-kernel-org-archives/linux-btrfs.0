Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51940 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbbG0Nu5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 09:50:57 -0400
Date: Mon, 27 Jul 2015 09:50:47 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: Filipe Manana <fdmanana@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix order by which delayed references are run
Message-ID: <20150727135047.GG28964@ret.masoncoding.com>
References: <1436453447-27466-1-git-send-email-fdmanana@kernel.org>
 <55B5D55A.8060806@cn.fujitsu.com>
 <CAL3q7H6Ki25cOyV1-Xj716mpiQD3qU5Eq3CLubh80P7wRou57A@mail.gmail.com>
 <55B5F854.10303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55B5F854.10303@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2015 at 05:22:28PM +0800, Qu Wenruo wrote:
> 
> 
> Filipe Manana wrote on 2015/07/27 09:26 +0100:
> >On Mon, Jul 27, 2015 at 7:53 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> >>Hi Filipe,
> >
> >Hi Qu,
> >
> >>
> >>Sorry for the late reply after it is already merged,
> >>but I'm a little concerned about the extra loop to find the first inc
> >>delayed ref.
> >>
> >>It may take some extra time when there are a lot of delayed refs.
> >>
> >>What about allowing deleting the extent item at dec delayed ref time and
> >>then add it back for later inc delayed refs?
> >
> >So, the reason I did it this way is simplicity - it's pretty much what
> >the pre 4.2-rc1 [1] code did, but slightly more efficient because it
> >iterates a linked list rather than a red black tree using rb_next().
> >So it seems somewhat odd that you're worrying about this after a
> >functional fix when we pretty much always had this behavior in
> >place...
> >
> >Given the complexity of what you propose, I would prefer if we have a
> >benchmark that indeed shows this is a performance critical area (I
> >don't think this list can get that huge, but I might be wrong).
> I agree with you that this may not be a performance hotspot.
> 
> And in fact, before the qgroup patchset, we tested the list implement of
> delayed ref for performance regression, and the difference is so little that
> can be easily ignored.
> So I think even we skip the loop, the performance will only change little.
> 
> One of the main purpose to change the delayed ref to list, is to make it a
> little more straightforward, without the hard to understand/review rb tree
> compare.
> So I hope there is another more simple and straightforward one.
> 
> But as you mentioned, your fix is already simple enough, and after a short
> code search, my idea to fix may not be as simple as I thought.
> 
> So sorry for the disturb, and thanks for your fix again.

Thanks for giving this some extra review.  For now I'm happy with the
tradeoff, but if it shows up in profiles we can look harder.

-chris
