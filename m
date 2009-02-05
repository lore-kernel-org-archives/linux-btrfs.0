From: Pavel Machek <pavel@suse.cz>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Thu, 5 Feb 2009 10:02:29 +0100
Message-ID: <20090205090229.GA2011@elf.ucw.cz>
References: <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed> <20090126162711.GA2083@elf.ucw.cz> <20090201014050.GD24173@disturbed> <20090204182951.GC4797@elf.ucw.cz> <20090205085916.GP24173@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>,
	Eric Sesterhenn <snakebyte@gmx.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090205085916.GP24173@disturbed>
List-ID: <linux-btrfs.vger.kernel.org>


> > > CONFIG_*_DEBUG means include *debug* code there to help developers,
> > > including adding additional failure tests into the kernel. Besides,
> > > which bit of "don't turn it on unless you are an XFS developer"
> > > don't you understand?
> > 
> > Yes, but DEBUG code is normally to help debugging, not to crash
> > kernels.
> 
> Crashing the kernel at exactly the point a problem is detected
> is often the simplest way of debugging the problem.
> 
> e.g. CONFIG_VM_DEBUG=y turns on VM_BUG_ON() which crashes the kernel
> whenever it detects something wrong. Do I turn it on? Yes. Do i

That's different. User is not supposed to be able to trigger
VM_BUG_ON().

> complain about it when I hit a VM_BUG_ON()? No, I report the
> bug and move on. If you turn on a DEBUG option, then you are
> asking the system to behave in a way useful to a developer,
> not an end user. That includes panicing when something wrong
> is detected.

Imagine vm going panic() on mkdir("/lost+found")...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
