Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63905 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbbJ0LfH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 07:35:07 -0400
Date: Tue, 27 Oct 2015 07:34:35 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
Message-ID: <20151027113435.GA837@ret.edimax.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
 <562EF9D7.50101@cn.fujitsu.com>
 <20151027051403.GA23134@ret.thefacebook.com>
 <562F1032.7040103@cn.fujitsu.com>
 <20151027061203.GA25844@ret.thefacebook.com>
 <562F3E74.4040205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <562F3E74.4040205@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2015 at 05:05:56PM +0800, Qu Wenruo wrote:
> 
> 
> Chris Mason wrote on 2015/10/27 02:12 -0400:
> >On Tue, Oct 27, 2015 at 01:48:34PM +0800, Qu Wenruo wrote:
> >>>>Are you testing integration-4.4 from Chris repo?
> >>>>Or 4.3-rc from mainline repo with my qgroup reserve patchset applied?
> >>>>
> >>>>Although integration-4.4 already merged qgroup reserve patchset, but it's
> >>>>causing some strange bug like over decrease data sinfo->bytes_may_use,
> >>>>mainly in generic/127 testcase.
> >>>>
> >>>>But if qgroup reserve patchset is rebased to integration-4.3 (I did all my
> >>>>old tests based on that), no generic/127 problem at all.
> >>>
> >>>Did I mismerge things?
> >>>
> >>>-chris
> >>>
> >>Not sure yet.
> >>
> >>But at least some patches in 4.3 is not in integration-4.4, like the
> >>following patch:
> >>btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode
> >>size
> >
> >Have you tried testing integration-4.4 merged with current Linus git?
> >
> >-chris
> >
> Integration-4.4 merged with Linus' master also fails. :(
> 
> Current known working branches are all based on 4.3-integration(4.2-rc5):
> https://github.com/adam900710/linux/tree/qgroup_reserve_good
> 
> Tried 4.3-rc5 and 4.3-rc7, all fails with kernel warning in generic/137.
> 
> And due to the huge difference, I'm afraid it won't take a short time to
> find the root cause...

Ok, this is the top merge commit in integration:

commit a9e6d153563d2ed69c6cd7fb4fa5ce4ca7c712eb
Merge: 56fa9d0 0584f71
Author: Chris Mason <clm@fb.com>
Date:   Wed Oct 21 19:00:38 2015 -0700

    Merge branch 'allocator-fixes' into for-linus-4.4

Please try commit 56fa9d0, which doesn't have Josef's allocator fixes.
It's possible there is a conflict with your changes in there.

-chris

