From: David Sterba <dave@jikos.cz>
Subject: Re: [GIT PULL] Btrfs updates
Date: Mon, 5 Dec 2011 15:08:09 +0100
Message-ID: <20111205140809.GA12130@twin.jikos.cz>
References: <20111201153955.GL5587@shiny> <4EDC7C89.6050803@cn.fujitsu.com> <20111205131413.GC26622@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111205131413.GC26622@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 05, 2011 at 08:14:13AM -0500, Chris Mason wrote:
> On Mon, Dec 05, 2011 at 04:10:49PM +0800, Miao Xie wrote:
> > [PATCH 08/20] Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE
> 
> Thanks, I'll push this 08/20 out as well.

Please pick

Li Zefan: Btrfs: check if the to-be-added device is writable
Liu Bo: Btrfs: drop spin lock when memory alloc fails

(collected in branch fixes-20111205 at my repo)

I overlooked them and forgot to include in the fixes branch before the
last pull request, sorry.


david
