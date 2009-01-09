From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 14:55:29 -0800
Message-ID: <20090109145529.3264ac26@infradead.org>
References: <49677CB1.3030701@zytor.com>
	<20090109084620.3c711aad@infradead.org>
	<20090109172011.GD26290@one.firstfloor.org>
	<20090109172801.GC6936@parisc-linux.org>
	<20090109174719.GG26290@one.firstfloor.org>
	<20090109094142.367012b6@infradead.org>
	<20090109180213.GH26290@one.firstfloor.org>
	<alpine.LFD.2.00.0901090954410.6528@localhost.localdomain>
	<20090109185509.GJ26290@one.firstfloor.org>
	<20090109195232.GE23869@mit.edu>
	<20090109224410.GQ26290@one.firstfloor.org>
	<4967D131.3010801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
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
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4967D131.3010801@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 09 Jan 2009 14:35:29 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Andi Kleen wrote:
> >> Fetch a gigabyte's worth of data for the debuginfo RPM? 
> > 
> > The suse 11.0 kernel debuginfo is ~120M.
> 
> Still, though, hardly worth doing client-side when it can be done 
> server-side for all the common distro kernels.  For custom kernels,
> not so, but there you should already have the debuginfo locally.h

and if you have the debug info local, all you need is

dmesg | scripts/markup_oops.pl vmlinux

and it nicely decodes it for you



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
