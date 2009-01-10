From: Theodore Tso <tytso@mit.edu>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
	measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Date: Sat, 10 Jan 2009 16:15:31 -0500
Message-ID: <20090110211531.GD31579@mit.edu>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>, Nicholas Miell <nmiell@comcast.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	jim owens <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, sam@ravnborg.org,
	Dave Anderson <anderson@redhat.com>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 10, 2009 at 01:21:06PM -0500, Mike Snitzer wrote:
> > In practice i rarely see bugfixes that were debugged via kdump. Normal
> > oops based fixes outnumber kdump based fixes by a ratio of 1:100 or worse
> > - and kdump is readily available these days - just nobody configures it.
> 
> So you're telling me RedHat doesn't rely on kdump at enterprise
> customer installations?  I find that hard to believe.  Few enterprise
> customers allow defects to be debugged on-site, sometimes collecting a
> crash dump is all you can hope for to make progress.  I have to
> believe you know this fairly well; if not with direct experience then
> through your co-workers?  Or am I living in Ingo's version of Linux
> hell where kdump is actually useful?

In my experience, there are very few kernel versions and hardware for
which kdump works.  I've talked to the people who have to make kdump
work, and every 12-18 months, with a new set of enterprise kernels
comes out, they have to go and fix kdump so it works again for the set
of hardware that they care about, and for the kernel version involved.
Part of the problem is one which has infected nearly every single RAS
technology out there, from kdump to Systemtap, which is the people who
architect and fund these RAS technologies delude themselves into
thinking that they only have to worry about making it work for
enterprise kernels and enterprise users, and to hell with everyone
else --- specifically, kernel developers, which don't matter since
they aren't enterprise users.  Heck, until July of last year,
Systemtap wouldn't even ***compile*** out of the box on a
non-enterprise distribution like Ubuntu or Debian.  And I still have
yet to make kdump work on a Thinkpad, although I've tried.

Since pretty much no one uses these RAS technologies except enterprise
users, and no one bothers to make it easy for kernel developers,
kernel developers have developed alternate mechanisms for debugging
the Linux kernel --- and they don't involve using Systemtap or kdump,
because in practice, it doesn't work for them at all, or it's too hard
to make it work for them. 

And this becomes a vicious cycle; since no one is bothered to spend
time making RAS technologies work for everyday use by kernel
developers, bitrot inevitably sets in, and so the RAS developers get
no help from other kernel developers, who are busy fixing their own
problems via different means; and so the RAS developers hunker down,
and spend even more time fixing the bitrot and complaining that no one
helps them or takes them seriously, and the problem gets worse and
worse and worse --- until now there are people who are busily
developing alternatives to Systemtap, just because too many RAS
architects and developers and had their priorities wrong, and forgot
to focus on every day kernel developers instead of just enterprise
users.

It's very sad, and it means a lot of investment gets wasted, and work
is getting duplicated as a result.

Oh, well.

							- Ted
