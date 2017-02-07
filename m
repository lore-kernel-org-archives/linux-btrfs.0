Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44421 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754142AbdBGS1p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 13:27:45 -0500
Subject: Re: BTRFS for OLTP Databases
To: Peter Zaitsev <pz@percona.com>, linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <579c53e4-f993-dd85-b5a4-76a0b201b899@suse.com>
Date: Tue, 7 Feb 2017 13:27:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KCXV8BFvxnk17lK0TDiP1olndOapQQVjC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KCXV8BFvxnk17lK0TDiP1olndOapQQVjC
Content-Type: multipart/mixed; boundary="75hNitFRopJ6p96FVUKXG69bQf4xnXqmA";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Peter Zaitsev <pz@percona.com>, linux-btrfs@vger.kernel.org
Message-ID: <579c53e4-f993-dd85-b5a4-76a0b201b899@suse.com>
Subject: Re: BTRFS for OLTP Databases
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
In-Reply-To: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>

--75hNitFRopJ6p96FVUKXG69bQf4xnXqmA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/7/17 8:53 AM, Peter Zaitsev wrote:
> Hi,
>=20
> I have tried BTRFS from Ubuntu 16.04 LTS   for write intensive OLTP MyS=
QL
> Workload.
>=20
> It did not go very well ranging from multi-seconds stalls where no
> transactions are completed to the finally kernel OOPS with "no space le=
ft
> on device" error message and filesystem going read only.
>=20
> I'm complete newbie in BTRFS so  I assume  I'm doing something wrong.
>=20
> Do you have any advice on how BTRFS should be tuned for OLTP workload
> (large files having a lot of random writes)  ?    Or is this the case w=
here
> one should simply stay away from BTRFS and use something else ?
>=20
> One item recommended in some places is "nodatacow"  this however defeat=
s
> the main purpose I'm looking at BTRFS -  I am interested in "free"
> snapshots which look very attractive to use for database recovery scena=
rios
> allow instant rollback to the previous state.
>=20

Hi Peter -

There seems to be some misunderstanding around how nodatacow works.
Nodatacow doesn't prohibit snapshot use.  Snapshots are still allowed
and, of course, will cause CoW to happen when a write occurs, but only
on the first write.  Subsequent writes will not CoW again.  This does
mean you don't get CRC protection for data, though.  Since most
databases do this internally, that is probably no great loss.  You will
get fragmentation, but that's true of any random-write workload on btrfs.=


Timothy's comment about how extents are accounted is more-or-less
correct.  The file extents in the file system trees reference data
extents in the extent tree.  When portions of the data extent are
unreferenced, they're not necessarily released.  A balance operation
will usually split the data extents so that the unused space is released.=


As for the Oopses with ENOSPC, that's something we'd want to look into
if it can be reproduced with a more recent kernel.  We shouldn't be
getting ENOSPC anywhere sensitive anymore.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--75hNitFRopJ6p96FVUKXG69bQf4xnXqmA--

--KCXV8BFvxnk17lK0TDiP1olndOapQQVjC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWJoRmx57S2MheeWyAQiUrA/9E/VULr+cTTZHXSv5aAUEnR6f3hS0OET7
I91KIcRRmCS8imQs+IUQcPUEcOEDgRd/qlshIZuvI/q6xKzAathypMT+AmEwUZO8
ErEfiB/Vk+CbKKYJioj3C2D0xiaBaPei+e3MqHOI+KnCJ7MdBxXEGCcHgDgvY4oN
B7Ga521ZVbXCddC32Kob7J+a9JS4siCzakh9SmdB7Qedgq60xUjhTMff3YKbYvlZ
vjVA9uIOt2inBhIE59OyP3BfSKffAh6SvWtl7A3IHrrBh7wM5yo6RLlqSOP0ou/4
D6733lsRkeN/15cJYfi1qV9XdIU4Mn3o1UL9bkrs1MraUTyU3E3USGOIQXfgkwN+
IWVu+/7YKPNLoJ9CmRUfTbILHf/xwSdjgZ3IoStVvawvMDD7u5eXWS0Hz1un39ke
dOPE+cH8qMNLt9qeoPwKXEh6DW8/RgJsn+CL50jmAq6E7lWkyob6kQZdPt960dhV
ObFIJoUaR63IOzWqe/Zy/sG+0DD7KymHuOdNnmCFlrro48t2QtlIxjKyn5/z+OQb
ksQUaeIVDA3N43Rnv8FqzYlR8Q7P5bkIm/6QGQaQjXlyJrZHSQY+XRKtu05iZ76F
DgdkpqNP3OXzr832TFR49wiGDpGPED9Rfo27U2emo+KQYE7Bp/52bxB7Ow1zpki8
I/DFtrORU/0=
=eegw
-----END PGP SIGNATURE-----

--KCXV8BFvxnk17lK0TDiP1olndOapQQVjC--
