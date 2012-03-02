From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: filesystem full when it's not? out of inodes? huh?
Date: Fri, 2 Mar 2012 19:23:38 +0700
Message-ID: <CAG1y0se9mtjUGGiVPmaw0VPme=7scsf78SxbdZYR=fCmR1SWUA@mail.gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org>
	<4F499498.1040006@gmail.com>
	<20120226110044.GA18898@carfax.org.uk>
	<jiqc6i$e2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jiqc6i$e2$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 2, 2012 at 6:50 PM, Brian J. Murrell <brian@interlinx.bc.ca=
> wrote:
> Is =A02010-06-01 really the last time the tools were considered
> stable or are Ubuntu just being conservative and/or lazy about updati=
ng?

The last one :)

Or probably no one has bugged them enough and point out they're
already using a git snapshot anyway and there are many new features in
the "current" git version of btrfs-tools.

I have been compiling my own kernel (just recently switched to
Precise's kernel though) and btrfs-progs for quite some time, so even
if Ubuntu doesn't provide updated package it wouldn't matter much to
me. If it's important for you, you could file a bug report in
launchpad asking for an update. Even debian testing has an updated
version (which you might be able to use:
http://packages.debian.org/btrfs-tools)

Or create your own ppa with an updated version (or at least rebuilt of
Debian's version).

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
