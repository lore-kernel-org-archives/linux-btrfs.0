From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 22:00:40 +0100
Message-ID: <201002182200.40446.kreijack@libero.it>
References: <201002172102.17816.kreijack@libero.it> <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com> <20100218165841.GO10559@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100218165841.GO10559@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 18 February 2010, Chris Mason wrote:
> I do like the subcommand method, more details below.
>=20
> On Wed, Feb 17, 2010 at 03:35:26PM -0800, Mike Fedyk wrote:
> > I think he need some command hierarchy here.
> >=20
> > On Wed, Feb 17, 2010 at 12:02 PM, Goffredo Baroncelli
> > <kreijack@gmail.com> wrote:
> > > OPTIONS
> > >       snapshot|-s <source> [<dest>/]<name>
> > >              Create a writeble snapshot of the subvolume  <source=
>  with=20
 the
> > >              name  <name>  in the <dest> directory. If <source> i=
s not a=20
sub=E2=80=90
> > >              volume, btrfs returns an error.
> >=20
> > This should be "btrfs subvolume snapshot <source> [<dest>/]<name>".
> > It only works on subvolumes.
>=20
> If we can type subvol instead of subvolume I like it.  Basically the
> perl/python arg parsing system where any short form of the command th=
at
> uniquely matches it is allowed.

So for you

$ btrfs s s <source> <dest>

is OK ?

('btrfs s s' means btrfs subvolume snapshot)



> We keep the long forms but allow the user to pick a shorter form if i=
t
> isn't ambiguous.

--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwi=
nd.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
