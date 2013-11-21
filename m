Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54814 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3KUXiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 18:38:08 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CFD069A068C
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 16:38:07 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Martin <m_btrfs@ml1.co.uk>, <linux-btrfs@vger.kernel.org>
References: <20131108220135.3802.39092@localhost.localdomain>
 <l5jtgo$6q1$1@ger.gmane.org>
In-Reply-To: <l5jtgo$6q1$1@ger.gmane.org>
Message-ID: <20131121233751.5312.13383@localhost.localdomain>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Thu, 21 Nov 2013 18:37:51 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Martin (2013-11-08 18:53:06)
> On 08/11/13 22:01, Chris Mason wrote:
> > Hi everyone,
> > 
> > This patch is now the tip of the master branch for btrfs-progs, which
> > has been updated to include most of the backlogged progs patches.
> > Please take a look and give it a shake.  This was based on Dave's
> > integration tree (many thanks Dave!) minus the patches for online dedup.
> > I've pulled in the coverity fixes and a few others from the list as
> > well.
> > 
> > The patch below switches our default mkfs leafsize up to 16K.  This
> > should be a better choice in almost every workload, but now is your
> > chance to complain if it causes trouble.
> 
> Thanks for that and nicely timely!
> 
> Compiling on Gentoo (3.11.5-gentoo, sys-fs/btrfs-progs-9999) gives:
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

I'm not seeing these warnings with the current master branch, could you
please rerun?

-chris

