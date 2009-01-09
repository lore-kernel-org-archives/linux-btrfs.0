From: "Richard Guenther" <richard.guenther@gmail.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 20:09:28 +0100
Message-ID: <84fc9c000901091109t2c2aef2fu596f8807b0962688@mail.gmail.com>
References: <496648C7.5050700@zytor.com> <49675920.4050205@hp.com>
	 <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com>
	 <20090109084620.3c711aad@infradead.org>
	 <20090109172011.GD26290@one.firstfloor.org>
	 <20090109172801.GC6936@parisc-linux.org>
	 <20090109174719.GG26290@one.firstfloor.org>
	 <20090109173914.GD6936@parisc-linux.org>
	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Matthew Wilcox" <matthew@wil.cx>,
	"Andi Kleen" <andi@firstfloor.org>,
	"Dirk Hohndel" <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
	"jim owens" <jowens@hp.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	"Gregory Haskins" <ghaskins@novell.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Thomas Gleixner" <tglx@linutronix.de>,
	"Nick Piggin" <npiggin@suse.de>,
	"Peter Morreale" <pmorreale@novell.com>,
	"Sven Dietrich" <SDietrich@novell.com>, jh@suse.cz
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 9, 2009 at 6:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 9 Jan 2009, Matthew Wilcox wrote:
>>
>> That seems like valuable feedback to give to the GCC developers.
>
> Well, one thing we should remember is that the kernel really _is_ special.

(sorry for not threading properly here)

Linus writes:

"Thirdly, you're just replacing _one_ random gcc choice with _another_
random one.

What happens when you say -fno-inline-functions-called-once? Does it
disable inlining for those functions IN GENERAL, or just for the LARGE
ones? See?"

-fno-inline-functions-called-once disables the heuristic that always inlines
(static!) functions that are called once.  Other heuristics still
apply, like inlining
the static function if it is small.  Everything else would be totally
stupid - which
seems to be the "default mode" you think GCC developers are in.

Richard.
