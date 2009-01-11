From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Date: Sat, 10 Jan 2009 23:52:11 -0500
Message-ID: <170fa0d20901102052s7488ff0bl14507169fd4c03b3@mail.gmail.com>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
	 <20090110153446.GA13976@elte.hu>
	 <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
	 <20090111012811.GG12885@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Nicholas Miell" <nmiell@comcast.net>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"jim owens" <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	"Gregory Haskins" <ghaskins@novell.com>,
	"Matthew Wilcox" <matthew@wil.cx>,
	"Andi Kleen" <andi@firstfloor.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Thomas Gleixner" <tglx@linutronix.de>,
	"Nick Piggin" <npiggin@suse.de>,
	"Peter Morreale" <pmorreale@novell.com>,
	"Sven Dietrich" <SDietrich@novell.com>, sam@ravnborg.org,
	"Dave Anderson" <anderson@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>
To: "Ingo Molnar" <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090111012811.GG12885@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 10, 2009 at 8:28 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Note, back when kdump was added to the kernel many moons ago i strongly
> supported it and helped out with the patches, etc. I still think it might
> have the potential to become big - but it needs a ton of tech and care to
> reach that level of convenience.
>
> 'kdump light' perhaps that dumps the most important data structures like
> registers of all CPUs, task struct and the symbol tables, the current task
> itself including the kernel stack plus the surrounding 4K of all pointers
> that are in current registers and that point into kernel memory - maybe
> straight to kerneloops.org [if the user agrees] - or something like that.

I think 'kdump light' is a good idea.  I'm all for infrastructure that
works better for more people.  Having to deal with multi-gigabyte dump
files can be a chore.

The mechanics of dumping your suggested 'light' amount of data vs. all
memory should be configurable (e.g. /sys/kernel/kexec_crash_light).
And this obviously doesn't change the potentially fragile nature of
kexec'ing to a crash kernel from an arbitrary context; or the fact
that drivers can easily be incompatible with cleanly shutting down and
restarting on kexec.

I worked with Eric Biederman testing in the early days of his kexec
work and the e1000 driver was incompatible with kexec at that time
(IFF it was built into the kernel, workaround was to use a module and
unload it before kexec, *shudder*; I was using kexec in a custom
bootloader for a storage appliance, not for kdump).

But honestly 99+% of my filesystem/storage enduced Linux crashes
kexec/kdump properly (with RHEL5, 2.6.22, 2.6.25, and 2.6.28); so all
the hard work of people like yourself and other kexec/kdump hackers
(upstream and at RedHat) really is paying off for real Linux users!

The fairly recent kvm kdump compatibility work (2340b62f) is a perfect
example of how hard things can be.  But it is encouraging to see such
commendable effort being put to making kdump workable for all.

Now if only I could fix line numbers when debugging crashes in x86_64
modules with the crash utility! :)

Regards,
Mike
