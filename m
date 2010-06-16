From: Roberto Ragusa <mail@robertoragusa.it>
Subject: Re: Confused by performance
Date: Wed, 16 Jun 2010 21:56:52 +0200
Message-ID: <4C192C84.5090108@robertoragusa.it>
References: <4BFAEABD.2070700@noir.com>	<4BFF2024.3040509@noir.com>	<4C191330.5060905@noir.com>	<4C19243E.9050507@robertoragusa.it>	<AANLkTinM6ab_KEynfgvVT9v5TmcogoLZ0PLAz2oPnsiS@mail.gmail.com> <AANLkTimKGCk7KlD4KQ8oXhnnOf0pj3VzzDmzzBIK0bNn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimKGCk7KlD4KQ8oXhnnOf0pj3VzzDmzzBIK0bNn@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Freddie Cash wrote:
> > <snip a lot of fancy math that missed the point>
> >
> > That's all well and good, but you missed the part where he said ext2
> > on a 5-way LVM stripeset is many times faster than btrfs on a 5-way
> > btrfs stripeset.
> >
> > IOW, same 5-way stripeset, different filesystems and volume managers,
> > and very different performance.
> >
> > And he's wondering why the btrfs method used for striping is so much
> > slower than the lvm method used for striping.

Sorry, I missed the first line where ext2 on 5disk lvm is said to be fast.
I was commenting as the last two results were ext2 on 5disk and btrfs
on 5disk.

I'd say the great variation between successive runs is important and seems
to point to some bigger problem.

-- Roberto Ragusa mail at robertoragusa.it
