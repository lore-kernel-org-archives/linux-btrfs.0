From: Tore Anderson <tore.anderson@redpill-linpro.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Fri, 07 Aug 2009 00:01:51 +0200
Message-ID: <4A7B52CF.2030105@redpill-linpro.com>
References: <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com> <4A7AE579.1050403@redpill-linpro.com> <20090806142750.GE3655@dhcp231-156.rdu.redhat.com> <4A7B15DD.2010101@redpill-linpro.com> <20090806180432.GG3655@dhcp231-156.rdu.redhat.com> <4A7B1D6D.6090402@redpill-linpro.com> <20090806183712.GH3655@dhcp231-156.rdu.redhat.com> <4A7B25C3.4020206@redpill-linpro.com> <20090806190118.GI3655@dhcp231-156.rdu.redhat.com> <20090806192219.GD17129@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090806192219.GD17129@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

* Josef Bacik

>> Sorry about all of this, hopefully a better solution will be
>> coming down in a few months.

Don't be - the only reason why I'm running btrfs at this point is to
test and hopefully help out improving it by reporting the problems I'm
running into.  :-)

Thanks for the suggestions!

* Chris Mason

> We can code a fix for the balancer problem quickly, but you might
> have a hard time recompiling it and getting it on that box.
> 
> If this data is critical we'll write something up.

There's no critical data on this filesystem, it's only used for my
Fedora installation.  Won't take me long to re-install from scratch if
that's what it takes.  All og my important data (home directory) is on
NFS.  Using NFS I can easily get new versions of btrfs-progs onto the
box with the hosed btrfs, too.

So if you meant to code up the fix as a band-aid only for me, don't
bother (but thanks for the offer)!  On the other hand, if you wanted to
get such a fix into btrfs-progs anyway I'll be happy to test it out for you.

Best regards,
-- 
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
Tel: +47 21 54 41 27
