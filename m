From: Ingo Molnar <mingo@elte.hu>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
	measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Date: Sun, 11 Jan 2009 00:22:45 +0100
Message-ID: <20090110232245.GA25872@elte.hu>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com> <20090110211531.GD31579@mit.edu> <20090110222142.GI26290@one.firstfloor.org> <alpine.LFD.2.00.0901101454090.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Mike Snitzer <snitzer@gmail.com>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901101454090.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> As far as I'm concerned, digital cameras have been more useful than 
> kernel dumps to kernel debugging.

Yes, especially ones with VGA video capture. (I caught a 
"oops+triple-fault" crash via that trick once, which was not 
serial-console capture-able and which was just a single frame in the 25 
fps video of the incident.)

	Ingo
