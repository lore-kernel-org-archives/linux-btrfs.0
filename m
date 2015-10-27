Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13056 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbbJ0GMS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 02:12:18 -0400
Date: Tue, 27 Oct 2015 02:12:03 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
Message-ID: <20151027061203.GA25844@ret.thefacebook.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
 <562EF9D7.50101@cn.fujitsu.com>
 <20151027051403.GA23134@ret.thefacebook.com>
 <562F1032.7040103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <562F1032.7040103@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2015 at 01:48:34PM +0800, Qu Wenruo wrote:
> >>Are you testing integration-4.4 from Chris repo?
> >>Or 4.3-rc from mainline repo with my qgroup reserve patchset applied?
> >>
> >>Although integration-4.4 already merged qgroup reserve patchset, but it's
> >>causing some strange bug like over decrease data sinfo->bytes_may_use,
> >>mainly in generic/127 testcase.
> >>
> >>But if qgroup reserve patchset is rebased to integration-4.3 (I did all my
> >>old tests based on that), no generic/127 problem at all.
> >
> >Did I mismerge things?
> >
> >-chris
> >
> Not sure yet.
> 
> But at least some patches in 4.3 is not in integration-4.4, like the
> following patch:
> btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode
> size

Have you tried testing integration-4.4 merged with current Linus git?

-chris
