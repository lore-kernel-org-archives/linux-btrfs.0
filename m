From: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 12:45:21 +0100
Message-ID: <20090115114518.GT23674@vanheusden.com>
References: <20090114190008.GA13203@elte.hu> <20090114113638.c818fcf8.akpm@linux-foundation.org> <20090114201435.GA6519@elte.hu> <20090114123017.9acf42d7.akpm@linux-foundation.org> <20090114205122.GC6519@elte.hu> <20090114130642.cf2b18b2.akpm@linux-foundation.org> <20090114211458.GD6519@elte.hu> <20090114214158.GA9992@elte.hu> <ac3eb2510901141350x16c0f67cp46376e57062eaef9@mail.gmail.com> <20090114223408.GA19173@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com,
	dmitry.adamushko@gmail.com, hannes@cmpxchg.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753063AbZAOLrU@vger.kernel.org>
In-Reply-To: <20090114223408.GA19173@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

> > >> > You just disproved your own case :(
> > >>
> > >> how so? 80% is not enough? I also checked Fedora and it has
> > >> SCHED_DEBUG=y in its kernel rpms.
> > >
> > > Ubuntu has CONFIG_SCHED_DEBUG=y as well in their kernels.

Debian too:

mauer:~/bin# grep CONFIG_SCHED_DEBUG /boot/config-2.6.2*
/boot/config-2.6.24-1-amd64:# CONFIG_SCHED_DEBUG is not set
/boot/config-2.6.25-2-amd64:CONFIG_SCHED_DEBUG=y
/boot/config-2.6.26-1-amd64:CONFIG_SCHED_DEBUG=y

> > $ zgrep DEBUG_MUTEX /proc/config.gz
> > # CONFIG_DEBUG_MUTEXES is not set

mauer:~/bin# grep DEBUG_MUTEX /boot/config-2.6.2*
/boot/config-2.6.22-3-amd64:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.24-1-amd64:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.25-2-amd64:# CONFIG_DEBUG_MUTEXES is not set
/boot/config-2.6.26-1-amd64:# CONFIG_DEBUG_MUTEXES is not set


Folkert van Heusden

-- 
Looking for a cheap but fast webhoster with an excellent helpdesk?
http://keetweej.vanheusden.com/redir.php?id=1001
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
