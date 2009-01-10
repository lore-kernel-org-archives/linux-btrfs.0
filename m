From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 21:29:43 -0800
Message-ID: <20090109212943.4625abdb@infradead.org>
References: <20090109153508.GA4671@elte.hu>
	<49677CB1.3030701@zytor.com>
	<20090109084620.3c711aad@infradead.org>
	<20090109172011.GD26290@one.firstfloor.org>
	<20090109172801.GC6936@parisc-linux.org>
	<20090109174719.GG26290@one.firstfloor.org>
	<20090109094142.367012b6@infradead.org>
	<20090109180213.GH26290@one.firstfloor.org>
	<alpine.LFD.2.00.0901090954410.6528@localhost.localdomain>
	<20090109185509.GJ26290@one.firstfloor.org>
	<20090109195232.GE23869@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
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
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109195232.GE23869@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 9 Jan 2009 14:52:33 -0500
Theodore Tso <tytso@mit.edu> wrote:

> Kerneloops.org does this, so the code is mostly written; but it does
> this in a blinded fashion, so it only makes sense for oops which are
> very common and for which we don't need to ask the user, "so what were
> you doing at the time".  In cases where the user has already stepped
> up and reported the oops on a mailing list, it would be nice if
> kerneloops.org had a way of decoding the oops via some web page.
> 
> Arjan, would something like this be doable, hopefully without too much
> effort?

thinking about this.. making a "pastebin" like thing for oopses is
relatively trivial for me; all the building blocks I have already.

The hard part is getting the vmlinux files in place. Right now I do
this manually for popular released kernels.. if the fedora/suse guys
would help to at least have the vmlinux for their released updates
easily available that would be a huge help.... without that it's going
to suck.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
