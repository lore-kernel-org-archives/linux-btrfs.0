From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
 measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Date: Sat, 10 Jan 2009 14:58:16 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901101454090.6528@localhost.localdomain>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com> <20090110211531.GD31579@mit.edu> <20090110222142.GI26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, Mike Snitzer <snitzer@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Nicholas Miell <nmiell@comcast.net>, jim owens <jowens@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
	Dave Anderson <anderson@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090110222142.GI26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Sat, 10 Jan 2009, Andi Kleen wrote:
> 
> I think that's mostly because kexec from arbitary context is a 
> somewhat unstable concept.

I think that's the understatement of the year.

We have tons of problems with standard suspend-to-ram, and that's when the 
suspend sequence has done its best to make everything quiescent. Expecting 
that we can reinitialize all the hardware at some random point when things 
are going haywire is "optimistic" at best.

So of course it will work on some hardware and not others.

I think we've been fairly successful at keeping a running system for 
_most_ of our bugs. Even when things go bad with X running, it's quite 
often possible to ssh in over the network (although it's often better if 
you were already connected) and see the dump.

Not always, obviously. Many dumps really are painful. I'm hoping that 
kernel-mode-setting will at least give us the oops message _more_ of the 
time.

As far as I'm concerned, digital cameras have been more useful than kernel 
dumps to kernel debugging. 

			Linus
