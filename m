From: Theodore Tso <tytso@mit.edu>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
	measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Date: Sun, 11 Jan 2009 15:45:29 -0500
Message-ID: <20090111204529.GB29383@mit.edu>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com> <20090110153446.GA13976@elte.hu> <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com> <20090110211531.GD31579@mit.edu> <20090111101135.GA3306@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Nicholas Miell <nmiell@comcast.net>,
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
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753471AbZAKUqY@vger.kernel.org>
In-Reply-To: <20090111101135.GA3306@webber.adilger.int>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 11, 2009 at 06:11:35PM +0800, Andreas Dilger wrote:
> I'm sad that netconsole/netdump never made it big.  It was fairly useful,
> and extending the eth drivers to add the polling mode was trivial to do.
> We were using that for a few years, but it got replaced by kdump and it
> appears to be less usable IMHO.

The netdump I'm familiar with had the misfeature that it didn't do
packet retransmission, so when it was used on a customer network with
any amount of traffic, packets would get dropped and the crash dump
would utterly fail.  I honestly can't remember which enterprise distro
shipped it, but I can't say I was terribly impressed.  :-(

	    	  	      	  	   	       - Ted
