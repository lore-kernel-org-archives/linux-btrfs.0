Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36819 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751983AbcFUQzc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 12:55:32 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5LGruEu045245
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 12:55:27 -0400
Received: from e28smtp09.in.ibm.com (e28smtp09.in.ibm.com [125.16.236.9])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23q794nd23-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 12:55:27 -0400
Received: from localhost
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 21 Jun 2016 22:25:24 +0530
Received: from d28relay10.in.ibm.com (d28relay10.in.ibm.com [9.184.220.161])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id A7987125805F
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 22:27:58 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay10.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5LGtMaK39846132
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 22:25:22 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5LGtLf5009088
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 22:25:22 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Date: Tue, 21 Jun 2016 22:25:19 +0530
In-Reply-To: <20160621093457.GT4915@suse.cz>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com> <b42450d1-d929-7d8d-bbb7-126314002d92@cn.fujitsu.com> <20160621093457.GT4915@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1580932.8KuVbA1pQp@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, June 21, 2016 11:34:57 AM David Sterba wrote:
> On Tue, Jun 21, 2016 at 05:26:23PM +0800, Qu Wenruo wrote:
> > > Yeah, but I'm now concerned about the way both will be integrated in the
> > > development or preview branches, not really the functionality itself.
> > >
> > > Now the conflicts are not trivial, so this takes extra time on my side
> > > and I can't be sure about the result in the end if I put only minor
> > > efforts to resolve the conflicts ("make it compile"). And I don't want
> > > to do that too often.
> > >
> > > As stated in past discussions, the features of this impact should spend
> > > one development cycle in for-next, even if it's not ready for merge or
> > > there are reviews going on.
> > >
> > > The subpage patchset is now in a relatively good shape to start actual
> > > testing, which already revealed some problems.
> > >
> > >
> > I'm completely OK to do the rebase, but since I don't have 64K page size 
> > machine to test the rebase, we can only test if 4K system is unaffected.
> > 
> > Although not much help, at least it would be better than making it compile.
> > 
> > Also such rebase may help us to expose bad design/unexpected corner case 
> > in dedupe.
> > So if it's OK, please let me try to do the rebase.
> 
> Well, if you base dedupe on subpage, then it could be hard to find the
> patchset that introduces bugs, or combination of both. We should be able
> to test the features independently, and thus I'm proposing to first find
> some common patchset that makes that possible.
>

Hi David,

I am not sure if I understood the above statement correctly. Do you mean to
commit the 'common/simple' patches from both the subpage-blocksize & dedupe
patchset first and then bring in the complicated ones later?

If yes, then we have a problem doing that w.r.t subpage-blocksize
patchset. The first few patches bring in the core changes necessary for the
other remaining patches.

-- 
chandan

