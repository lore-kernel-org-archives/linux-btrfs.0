From: "Richard Guenther" <richard.guenther@gmail.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 20:10:20 +0100
Message-ID: <84fc9c000901091110n2f5565b7mecf9acec35cf5a0@mail.gmail.com>
References: <20090109153508.GA4671@elte.hu>
	 <20090109084620.3c711aad@infradead.org>
	 <20090109172011.GD26290@one.firstfloor.org>
	 <20090109172801.GC6936@parisc-linux.org>
	 <20090109174719.GG26290@one.firstfloor.org>
	 <20090109173914.GD6936@parisc-linux.org>
	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
	 <20090109181952.GI26290@one.firstfloor.org>
	 <84fc9c000901091059v65265413wda053d3ce5b0d17a@mail.gmail.com>
	 <20090109192158.GK26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Matthew Wilcox" <matthew@wil.cx>,
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
To: "Andi Kleen" <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109192158.GK26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 9, 2009 at 8:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> GCC 4.3 should be good in compiling the
>> kernel with default -Os settings.
>
> It's unfortunately not. It doesn't inline a lot of simple asm() inlines
> for example.

Reading Ingos posting with the actual numbers states the opposite.

Richard.
