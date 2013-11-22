Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50816 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3KVNky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 08:40:54 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 730887C06A6
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 06:40:54 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Martin <m_btrfs@ml1.co.uk>, <linux-btrfs@vger.kernel.org>
References: <20131108220135.3802.39092@localhost.localdomain>
 <l5jtgo$6q1$1@ger.gmane.org>
 <20131121233751.5312.13383@localhost.localdomain>
 <l6n6l2$ln6$1@ger.gmane.org>
In-Reply-To: <l6n6l2$ln6$1@ger.gmane.org>
Message-ID: <20131122134038.5312.42200@localhost.localdomain>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Fri, 22 Nov 2013 08:40:38 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Martin (2013-11-22 04:03:41)
> On 21/11/13 23:37, Chris Mason wrote:
> > Quoting Martin (2013-11-08 18:53:06)
> >> On 08/11/13 22:01, Chris Mason wrote:
> >>> Hi everyone,
> >>>
> >>> This patch is now the tip of the master branch for btrfs-progs, which
> >>> has been updated to include most of the backlogged progs patches.
> >>> Please take a look and give it a shake.  This was based on Dave's
> >>> integration tree (many thanks Dave!) minus the patches for online dedup.
> >>> I've pulled in the coverity fixes and a few others from the list as
> >>> well.
> >>>
> >>> The patch below switches our default mkfs leafsize up to 16K.  This
> >>> should be a better choice in almost every workload, but now is your
> >>> chance to complain if it causes trouble.
> >>
> >> Thanks for that and nicely timely!
> >>
> >> Compiling on Gentoo (3.11.5-gentoo, sys-fs/btrfs-progs-9999) gives:
> >>
> >>
> >>  * QA Notice: Package triggers severe warnings which indicate that it
> >>  *            may exhibit random runtime failures.
> >>  * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
> >> strict-aliasing rules [-Wstrict-aliasing]
> >>  * volumes.c:1930:5: warning: dereferencing type-punned pointer will
> >> break strict-aliasing rules [-Wstrict-aliasing]
> >>  * volumes.c:1931:6: warning: dereferencing type-punned pointer will
> >> break strict-aliasing rules [-Wstrict-aliasing]
> > 
> > I'm not seeing these warnings with the current master branch, could you
> > please rerun?
> 
> From just now:
> 
> 
>  * QA Notice: Package triggers severe warnings which indicate that it
>  *            may exhibit random runtime failures.
>  * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
> strict-aliasing rules [-Wstrict-aliasing]
>  * volumes.c:1930:5: warning: dereferencing type-punned pointer will
> break strict-aliasing rules [-Wstrict-aliasing]
>  * volumes.c:1931:6: warning: dereferencing type-punned pointer will
> break strict-aliasing rules [-Wstrict-aliasing]

Does gentoo modify the optimizations from the Makefile?  We actually
have many strict-aliasing warnings, but I didn't think they came up
until -O2.

At any rate, I'm adding -fno-strict-aliasing just to be sure.

-chris
