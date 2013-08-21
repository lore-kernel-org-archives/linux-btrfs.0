Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:40927 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3HUN7H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 09:59:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 900BD9A041C
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 07:59:07 -0600 (MDT)
Date: Wed, 21 Aug 2013 09:59:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Josef Bacik <jbacik@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel BUG on Snapshot Deletion (3.11.0-rc5)
Message-ID: <20130821135905.GL3990@localhost.localdomain>
References: <CAKcLGm_DXiwJrAMYG66ZiEmXtSKe0z0LUPfxat0Repb0jfDnNA@mail.gmail.com>
 <20130813141542.GF2150@localhost.localdomain>
 <CAKcLGm99PdyuurtmA6_ZW1PQOaH4piQSK-VYQMT-0PJkgDf-Yw@mail.gmail.com>
 <CAKcLGm_c=qimNQiByVA5ko-7K4ojL2mf5yoxLyiVCwKgaLcAZA@mail.gmail.com>
 <CAKcLGm_jFa_2FaaaudRZF8JRymh1t3ASMFN1tFGbs0PGt1vNaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAKcLGm_jFa_2FaaaudRZF8JRymh1t3ASMFN1tFGbs0PGt1vNaQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 21, 2013 at 08:44:55AM -0500, Mitch Harder wrote:
> On Thu, Aug 15, 2013 at 12:29 PM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
> > I'm running into a curious problem.
> >
> > In the process of making my script portable, I am breaking the ability
> > to replicate the error.
> >
> > I'm trying to isolate the aspect of my local script that is triggering
> > the error.  No firm insights yet.
> >
> >
> > On Tue, Aug 13, 2013 at 11:03 AM, Mitch Harder
> > <mitch.harder@sabayonlinux.org> wrote:
> >> Let me work on making that script more portable, and hopefully quicker
> >> to reproduce.
> >>
> >> On Tue, Aug 13, 2013 at 9:15 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> >>> On Mon, Aug 12, 2013 at 11:06:27PM -0500, Mitch Harder wrote:
> >>>> I'm hitting a btrfs Kernel BUG running a snapshot stress script with
> >>>> linux-3.11.0-rc5.
> >>>>
> >>>
> >>> I can haz script?  Thanks,
> >>>
> 
> I've had a hard time assembling a portable reproducer for this issue.
> 
> I discovered that my reproducer was highly dependent on a local
> archive of out-of-date git kernel sources.  My efforts to reproduce
> the error with a portable set of scripts with publicly available
> kernel git sources weren't successful.
> 
> It seems like this issue is related to a corner-case workload that is
> difficult to reproduce.
> 
> So I've bisected the error I was seeing with my local script, and
> identified the following commit as triggering my issue:
> 
> commit:    3c64a1aba7cfcb04f79e76f859b3d66660275d59
> Btrfs: cleanup: don't check the same thing twice
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=for-linus&id=3c64a1aba7cfcb04
> 
> I tested a kernel which reverted this change, and also added WARN_ON
> lines to provide a back trace.
> 

Well that works too :).  I'll look at this when I get back from the doctor in a
few hours and see if I can't figure out why it started happening.  Thanks,

Josef
