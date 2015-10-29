Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3950 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbbJ2G3r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 02:29:47 -0400
Date: Thu, 29 Oct 2015 02:29:34 -0400
From: Chris Mason <clm@fb.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>, <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
Message-ID: <20151029062934.GB24280@ret>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
 <562EF9D7.50101@cn.fujitsu.com>
 <20151027051403.GA23134@ret.thefacebook.com>
 <562F1032.7040103@cn.fujitsu.com>
 <20151027061203.GA25844@ret.thefacebook.com>
 <562F3E74.4040205@cn.fujitsu.com>
 <20151027113435.GA837@ret.edimax.com>
 <CAHji150-Drdan5GoF4g7Rp0vka1q7k+aTYJ7iD52ieE36LGLSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAHji150-Drdan5GoF4g7Rp0vka1q7k+aTYJ7iD52ieE36LGLSQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 28, 2015 at 02:36:42PM +0100, Holger Hoffstätte wrote:
> On Tue, Oct 27, 2015 at 12:34 PM, Chris Mason <clm@fb.com> wrote:
> > On Tue, Oct 27, 2015 at 05:05:56PM +0800, Qu Wenruo wrote:
> >>
> >>
> >> Chris Mason wrote on 2015/10/27 02:12 -0400:
> >> >On Tue, Oct 27, 2015 at 01:48:34PM +0800, Qu Wenruo wrote:
> >> >>>>Are you testing integration-4.4 from Chris repo?
> >> >>>>Or 4.3-rc from mainline repo with my qgroup reserve patchset applied?
> >> >>>>
> >> >>>>Although integration-4.4 already merged qgroup reserve patchset, but it's
> >> >>>>causing some strange bug like over decrease data sinfo->bytes_may_use,
> >> >>>>mainly in generic/127 testcase.
> >> >>>>
> >> >>>>But if qgroup reserve patchset is rebased to integration-4.3 (I did all my
> >> >>>>old tests based on that), no generic/127 problem at all.
> >> >>>
> >> >>>Did I mismerge things?
> >> >>>
> >> >>>-chris
> >> >>>
> >> >>Not sure yet.
> >> >>
> >> >>But at least some patches in 4.3 is not in integration-4.4, like the
> >> >>following patch:
> >> >>btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode
> >> >>size
> >> >
> >> >Have you tried testing integration-4.4 merged with current Linus git?
> 
> Chris, something went definitely wrong with the 4.4-integration
> branch, and it's not the point where you merged from Josef. Mainline
> has: 0f6925fa2907df58496cabc33fa4677c635e2223 ("btrfs: Avoid truncate
> tailing page if fallocate range doesn't exceed inode size"), and that
> commit just doesn't exist in 4.4-integration any more. Neither did any
> merges touch file.c, so it
> seems this just got lost for some reason (rebase? forced push?).
> It's difficult to say what else might have gone missing.

Hi Holger,

integration-4.4 is based on 4.3-rc5, and it doesn't include any of the
btrfs commits that went in after rc5.  So if you want the latest commits
from 4.3, you just need to merge integration-4.4 with a more recent
Linus rc.

This isn't completely intuitive ;)  I could merge in 4.3-rc7, but for the
trees that I send to Linus, he prefers I not add extra merges unless it
solves some dependency (like a new API, or highly critical bug).

So when I test integration, I test it merged into Linus' latest rc, but
I apply patches on top of the older base.  It makes the resulting graph
of merges look much nicer when Linus pulls from me, and if you scroll
through the commits with git log or gitweb, its more clear where the
new commits are.

-chris

