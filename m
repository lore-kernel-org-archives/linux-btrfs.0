From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Proper error handling on NULL pointers
Date: Mon, 26 Oct 2009 18:23:55 +0900
Message-ID: <20091026092355.GC5564@think>
References: <200910191236.14046.lists-receive@programmierforen.de>
 <200910211943.51623.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Andi Drebes <lists-receive@programmierforen.de>,
	linux-btrfs@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910211943.51623.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2009 at 07:43:51PM +0200, Diego Calleja wrote:
> On Lunes 19 Octubre 2009 12:36:13 Andi Drebes escribi=F3:
> > However, is there any interest in patches fixing these problems? If=
 yes: what would be the best strategy? Should we start fixing this "lay=
er by layer" -- the low-level functions first and the high-level functi=
ons later on? Or should use come kind of "vertical approach" -- one low=
-level function and all of its callers at once?
>=20
> I don't know what is the developer plan to fix that - apparently it's
> not in the high-priority list (but it must be certainly in the priori=
ty
> list, anyone who gets out of memory using btrfs will have some chance=
s of
> getting an oops - but notice that most of the important paths are rea=
dy
> to handle errors reliably and there aren't many bug reports due to ba=
d
> oom handling, so it doesn't seems to be that critical).

On thing to remember on the allocator is that when you're asking for
one page or less in kmalloc the allocator will generally oom the box be=
fore it
returns null.

So, I'm not suggesting we aren't going to fix these but that's why they
haven't turned into any bug reports yet.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
