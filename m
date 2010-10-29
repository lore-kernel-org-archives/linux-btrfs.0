From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs-progs: add support for mixed data+metadata block
	groups V3
Date: Thu, 28 Oct 2010 21:03:08 -0400
Message-ID: <20101029010308.GC11684@dhcp231-156.rdu.redhat.com>
References: <1288204654-2127-1-git-send-email-josef@redhat.com> <20101029012013.68a18b8a.ctpm@ist.utl.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?Cl=E1udio?= Martins <ctpm@ist.utl.pt>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101029012013.68a18b8a.ctpm@ist.utl.pt>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 29, 2010 at 01:20:13AM +0100, Cl=E1udio Martins wrote:
>=20
> On Wed, 27 Oct 2010 14:37:34 -0400 Josef Bacik <josef@redhat.com> wro=
te:
> > So alot of crazy people (I'm looking at you Meego) want to use btrf=
s on phones
> > and such with small devices.  Unfortunately the way we split out me=
tadata/data
> > chunks it makes space usage inefficient for volumes that are smalle=
r than
> > 1gigabyte.  So add a -M option for mixing metadata+data, and defaul=
t to this
> > mixed mode if the filesystem is less than or equal to 1 gigabyte.  =
I've tested
> > this with xfstests on a 100mb filesystem and everything is a-ok.
> >=20
>=20
>  Hi,
>=20
>  Could you provide some rationale as to why btrfs should support thes=
e
> two modes of data/metadata (mixed and separate) allocation instead of
> just always doing mixed data+metadata?
>

It makes the volume management stuff easier and gives us more flexibili=
ty for
how we lay out data and metadata.  Thanks,

Josef=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
