From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: 2.6.37 BUG at inode.c:1616 (was Re: 2.6.37: Bug on btrfs while
	umount)
Date: Mon, 10 Jan 2011 11:34:37 -0800
Message-ID: <20110110193437.GA19021@hexapodia.org>
References: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com> <1294363682-sup-7971@think> <20110110080815.GA7508@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Drunkard Zhang <gongfan193@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110110080815.GA7508@hexapodia.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 10, 2011 at 12:08:15AM -0800, Andy Isaacson wrote:
> On Thu, Jan 06, 2011 at 08:29:12PM -0500, Chris Mason wrote:
> > > [50010.838804] ------------[ cut here ]------------
> > > [50010.838931] kernel BUG at fs/btrfs/inode.c:1616!
> > > [50010.839053] invalid opcode: 0000 [#1] PREEMPT SMP
> [snip]
> > > [50010.839653] Pid: 1681, comm: btrfs-endio-wri Not tainted 2.6.37 #1
> > 
> > Could you please pull from the master branch of the btrfs unstable tree.
> > We had a late fix that is related to this.
> 
> I saw BUG at inode.c:1616 while running 2.6.37-rc6-11882-g55ec86f, I saw

Just got this again, same BUG and same stack trace.  This machine +
fs ran great for several months under approximately the same workload,
but the FS is slowly filling up; is this a regression in .37 or is the
bug a function of the FS load?

-andy
