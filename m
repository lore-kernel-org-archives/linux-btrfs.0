Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:22674 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3G3VaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 17:30:21 -0400
Date: Tue, 30 Jul 2013 21:25:27 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
To: Josef Bacik <jbacik@fusionio.com>, Joe Perches <joe@perches.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
In-Reply-To: <1375218347.2075.133.camel@joe-AO722>
Message-ID: <Pine.BSM.4.64L.1307302121050.20305@herc.mirbsd.org>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
 <20130730171329.GF24583@localhost.localdomain>  <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
  <20130730204001.GG24583@localhost.localdomain> <1375218347.2075.133.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik dixit:

>So stripe_len shouldn't be 0, if it is you have bigger problems :).

☺

>Is this a corrupt fs or something? If there was some sort of

I don’t think so, I can access and use that filesystem under 3.2
just fine (it’s what I created it under, too, so it’s possible
that it’s indeed corrupt and Linux 3.2 is just the same corrupt
to happen to make it work, e.g. wrong endianness used for stripe_len
which makes the upper 32 bit of that 64-bit value (usually 0) become
the lower 32 bit, or something like that).

I have access to that system, and it’s currently running as a
Debian/m68k buildd using said filesystem, but I can run commands
you tell me to diagnose/analyse it if it won’t get corrupted by
those.


Joe Perches dixit:

>Maybe use a temporary check in do_div

Mh. If nobody finds anything I’ll try that. (Doing things like
compiling a kernel and testing it takes about two days timeboxed
and some hours of active human effort, though, so I’d like to
avoid guessing. Plus it’ll disrupt running the Debian buildd…)

On second thoughts, this sort of check sounds like a good idea
to add to that file in general, depending on some debugging
CPPFLAG or Kconfig option. But I’m not the authority on that.

bye,
//mirabilos
-- 
<ch> you introduced a merge commit        │<mika> % g rebase -i HEAD^^
<mika> sorry, no idea and rebasing just fscked │<mika> Segmentation
<ch> should have cloned into a clean repo      │  fault (core dumped)
<ch> if I rebase that now, it's really ugh     │<mika:#grml> wuahhhhhh
