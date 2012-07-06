Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:43284 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab2GFU7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 16:59:24 -0400
Date: Fri, 6 Jul 2012 16:59:20 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <sensille@gmx.net>
CC: Liu Bo <liubo2009@cn.fujitsu.com>, "Chris L. Mason" <clmason@fusionio.com>,
        Josef Bacik <JBacik@fusionio.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>,
        Daniel J Blueman <daniel@quora.org>, <list.btrfs@jan-o-sch.net>
Subject: Re: Please hammer my for-linus branch
Message-ID: <20120706205920.GE31489@localhost.localdomain>
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

Well that was a huge pain in the ass, you are going to have to tell me how to
fix this Arne or fix it yourself.  The problem was introduced here

00f04b88791ff49dc64ada18819d40a5b0671709

The problem is we no longer merge delayed refs on the fs trees anymore, and
somehow we end up with this sequence of events

alloc block
add backref for some random block
remove implicit backref
add implicit backref back <-- I'm not entirely sure why/how this happens, I just
			assume its some relocate magic
run refs

because we do the sequence thing we go to add the implicit backref and panic
because we find there is one already there, and that's not supposed to happen
with tree blocks.  If we had run the remove first we would have been fine or if
we had just merged the delayed refs they would have cancelled each other out and
we would have been fine.  In order to test this theory I took the seq
comparisons out of comp_entry in delayed-refs.c and the test has been running
for about 20 minutes, before it would die in less than 30 seconds.  So why is
this needed?  I assume you need it for something, but I figure its easier for
you to fix this than for me to go figure out what it's used for.  Thanks,

Josef
