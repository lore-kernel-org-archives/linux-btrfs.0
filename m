From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 21:58:13 +0100
Message-ID: <20090109205812.GA24837@uranus.ravnborg.org>
References: <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org> <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain> <84fc9c000901091109t2c2aef2fu596f8807b0962688@mail.gmail.com> <alpine.LFD.2.00.0901091128170.6528@localhost.localdomain> <84fc9c000901091214i16fc74b7q349433a5586d5619@mail.gmail.com> <alpine.LFD.2.00.0901091217530.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Guenther <richard.guenther@gmail.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901091217530.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> And you do have to realize that Linux has been using gcc for a _loong_ 
> while. You can talk all you want about how "inline" is just a hint, but 
> the fact is, it didn't use to be. gcc people _made_ it so, and are having 
> a damn hard time admitting that it's causing problems.

The kernel has used:
# define inline         inline          __attribute__((always_inline))

For a looong time.

So anyone in the kernel when they said "inline" actually
said to gcc: if you have any possible way to do so inline this
sucker.

Now we have a config option that changes this so inline is only
a hint. gcc does not pay enough attention to the hint,
especially compared to the days where the hint was actually a command.

	Sam
