From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Wed, 07 Sep 2011 16:15:19 +0200
Message-ID: <1411501.d4mgBNBG2i@tethys>
References: <4E64D3D5.7020407@petaramesh.org> <15663472.1RTxtZJx8a@tethys> <CAG1y0sd=fYDT4Z4J=HqYXSsuZGjyMbUgpbLiguqdnibwt9qqOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Fajar A. Nugraha" <list@fajar.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sd=fYDT4Z4J=HqYXSsuZGjyMbUgpbLiguqdnibwt9qqOw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Le Mercredi 7 Septembre 2011 00:11:25 vous avez =E9crit :
> Reading your post, at this point I'd actually recommend you stick wit=
h
> ext4.

I actually shifted back from BTRFS to ext4 and fell like having offered=
 myself=20
a brand new computer,  about 20 times faster, me happy ;-)

> Both btrfs and zfs are great, but IMHO btrfs is not ready for
> daily use by "ordinary" user yet, while zfs is a memory hog
> (especially for laptops, which is part of the reason why I'm using
> btrfs instead of zfs on this one).

True, ZFS is excellent but a memory hog (and strongly advises using a 6=
4-bit=20
OS) but I was surprised to discover that BTRFS was such a memory eater =
itself,=20
with kernel 3.0. My system was swapping like mad !

I use (kernel) ZFS on my 64-bit main machine and I'm plain happy with i=
t, and=20
tried ZFS on my 32-bit laptop in the hope to get more performance for l=
ess=20
memory ; alas I just got a memory-hungry system running damn slow... Fo=
r the=20
time being I will stick to ZFS for 64-bit machines with >=3D 4GB RAM, a=
nd to=20
ext4 for 32-bit systems with less RAM...

I don't feel that BTRFS gives any advantage in its current state of=20
development. Alas.

--=20
Sw=E2mi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 907=
6E32E

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
