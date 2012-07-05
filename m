Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44168 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab2GEN0K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jul 2012 09:26:10 -0400
Date: Thu, 5 Jul 2012 09:26:06 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Daniel J Blueman <daniel@quora.org>
CC: Liu Bo <liubo2009@cn.fujitsu.com>, "Chris L. Mason" <clmason@fusionio.com>,
        Josef Bacik <JBacik@fusionio.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Please hammer my for-linus branch
Message-ID: <20120705132606.GA3289@localhost.localdomain>
References: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
 <CAMVG2st-qr+PpTUQB=wQ-_21h=d86=aDayb7FvFSSZf4ZyRVhQ@mail.gmail.com>
 <4FF3D27F.4070402@cn.fujitsu.com>
 <CAMVG2suP+-1JORm-k1nYx0n7hcE2DHa_fSOhdW=s2pov1NO50Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMVG2suP+-1JORm-k1nYx0n7hcE2DHa_fSOhdW=s2pov1NO50Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2012 at 12:53:54AM -0600, Daniel J Blueman wrote:
> On 4 July 2012 13:19, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> > On 07/04/2012 11:37 AM, Daniel J Blueman wrote:
> >>> Hi everyone,
> >>>
> >>> I've got a nice set of fixes from Josef, Jan, Ilya and others in my
> >>> for-linus branch:
> >>>
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> >>>
> >>> Some of the changes are fixes for the tree logging code, so I ran some
> >>> extra crash runs against them Friday night.
> >>>
> >>> I ended up with a new crash in the tree log directory deletion replay
> >>> code, so I didn't send out the pull request to Linus.
> >>>
> >>> It isn't clear yet if the new crash is because I was testing differently
> >>> or if it is a regression.  I'm nailing it down this weekend, but please
> >>> give my for-linus a shot.
> >>
> >> I consistently run into this assertion [1] while running a fio
> >> workload on a fresh RAID10 filesystem with a balance running.
> >>
> >> Let me know if you need steps to reproduce, debug etc.
> >
> > Seems that additional condition does not catch the bug.
> >
> > Plz show us the steps to reproduce, I'll try to reproduce it locally and nail it down.
> 
> The reproducer auto-generated from my test [1] consistently hits the
> spot here; config @ http://quora.org/2012/kconfig-btrfs . You'll need
> the fio workload file [2] in the same dir.
> 

Wow I hit this straight away, I will look into it, thanks!

Josef
