Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:48281 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2GBURk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 16:17:40 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id Ek2HOgkLLplVtdx0 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2012 14:17:39 -0600 (MDT)
Date: Mon, 2 Jul 2012 16:17:37 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Please hammer my for-linus branch
Message-ID: <20120702201737.GX17638@shiny>
References: <20120701012259.GM17638@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120701012259.GM17638@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 30, 2012 at 09:22:59PM -0400, Chris Mason wrote:
> Hi everyone,
> 
> I've got a nice set of fixes from Josef, Jan, Ilya and others in my
> for-linus branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> Some of the changes are fixes for the tree logging code, so I ran some
> extra crash runs against them Friday night.
> 
> I ended up with a new crash in the tree log directory deletion replay
> code, so I didn't send out the pull request to Linus.
> 
> It isn't clear yet if the new crash is because I was testing differently
> or if it is a regression.  I'm nailing it down this weekend, but please
> give my for-linus a shot.

Ok, I've just rebased for-linus.  I've dropped Josef's enospc patch,
which should fix the regression Dave hit.  I've also added a fix for my
log replay crash, which was definitely an old bug.  The delayed
directory operations were queuing up the changes made during replay, and
it was confusing the replay code.

Looks like there's a fix pending from Liu Bo, but I'll let Daniel test
that before pulling it in as well.

Thanks everyone.

-chris


