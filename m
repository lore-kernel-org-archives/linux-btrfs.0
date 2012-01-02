From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs-tools in Debian squeeze-backports?
Date: Mon, 2 Jan 2012 08:55:14 -0600
Message-ID: <CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>
References: <4F01BF5D.2070801@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F01BF5D.2070801@pocock.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 2, 2012 at 8:29 AM, Daniel Pocock <daniel@pocock.com.au> wr=
ote:
>
>
> These are the btrfs-tools versions on Debian:
>
> squeeze:
> kernel: 2.6.32
> tools: 0.19+20100601-3
>
> squeeze-backports:
> kernel: 2.6.39
> tools: nothing (so user ends up with 0.19+20100601-3)
>
> wheezy/testing/sid:
> kernel: 3.1.6-1
> tools: 0.19+20111105-2
>
> Using the 2.6.39 kernel from squeeze-backports, do I need a newer
> btrfs-tools and is there a particular reason it is not in
> squeeze-backports too?
>
> Or should I not be trying to use the versions in squeeze at all - sho=
uld
> I be on testing/wheezy or unstable?
>
> The Debian btrfs wiki and the regular btrfs wiki don't really suggest=
 a
> good starting point (other than suggesting the btrfs has been in Debi=
an
> since squeeze)
> http://wiki.debian.org/Btrfs
>
> If I try to use the version from testing or unstable, I get this erro=
r
> on a squeeze setup:
>
> =C2=A0btrfs-tools depends on e2fslibs (>=3D 1.41.99); however:
> =C2=A0Version of e2fslibs on system is 1.41.12-4stable1.

0.19+20111105-2 should be sufficiently up to date for most day-to-day
purposes; the particular dependency you're running up against is
probably a quirk of the packaging.

Note that you really want to be running the latest kernel possible if
using btrfs;  since 2.6.39 there have been several major performance
fixes, stability fixes, crash-corruption fixes, which users did hit on
a somewhat regular basis.  Btrfs is not yet stable for the typical
user who just wants things to work, even when things don't.  I don't
know of any major distros that offer support services for btrfs
filesystems, for instance.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
