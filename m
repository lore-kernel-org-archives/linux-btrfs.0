From: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Fri, 16 Jan 2009 14:57:49 +0100
Message-ID: <20090116135748.GF29002@vanheusden.com>
References: <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain> <20090115180844.GL22472@elte.hu> <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain> <1232047618.8269.93.camel@think.oraclecorp.com> <20090116133203.GE29002@vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090116133203.GE29002@vanheusden.com>
List-ID: <linux-btrfs.vger.kernel.org>

> > I'll kick off some runs of my three benchmarks on ext3 for comparis=
on.
> > If there are things less synthetic people would like to see, please=
 let
> > me know.
>=20
> What about a web-server test? Number of hits per second it can do?

Quick hack: http://vanheusden.com/tortureweb/tortureweb-0.1.tgz
To test multiple requesters, start this program multiple times in
parallel.
There are probably better testers but for a quick test and might be
sufficient.


=46olkert van Heusden

--=20
Multitail es una herramienta flexible que permite visualizar los "log
file" y seguir la ejecuci=F3n de comandos. Permite filtrar, a=F1adir
colores, combinar archivos, la visualizaci=F3n de diferencias (diff-
view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
