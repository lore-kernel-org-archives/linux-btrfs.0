Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44042 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbIVNlc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:41:32 -0400
Date: Tue, 22 Sep 2015 13:41:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150922134131.GH5918@carfax.org.uk>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17/8oYur5Y32USnW"
In-Reply-To: <5601596B.1020607@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--17/8oYur5Y32USnW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2015 at 03:36:43PM +0200, Holger Hoffst=E4tte wrote:
> On 09/22/15 14:59, Jeff Mahoney wrote:
> (snip)
> > So if they way we want to prevent the loss of raid type info is by
> > maintaining the last block group allocated with that raid type, fine,
> > but that's a separate discussion.  Personally, I think keeping 1GB
>=20
> At this point I'm much more surprised to learn that the RAID type can
> apparently get "lost" in the first place, and is not persisted
> separately. I mean..wat?

   It's always been like that, unfortunately.

   The code tries to use the RAID type that's already present to work
out what the next allocation should be. If there aren't any chunks in
the FS, the configuration is lost, because it's not stored anywhere
else. It's one of the things that tripped me up badly when I was
failing to rewrite the chunk allocator last year.

> > allocated as a placeholder is a bit much.  Beyond that, I've been
>=20
> Can you explain why keeping at least one data chunk (or the appropriate
> number across devices, depending on RAID level..) is "a bit much"?
> IMHO this would have no real negative impact on end users (who think
> in terms of overall filesystem space, not how much of that has been
> lazily touched), nor for more obscure use cases like sparse images -
> which would still be sparsely reserved. So there would not be any
> actual downside that I can see. From a fs consistency point of view
> it sounds much more sane to assume that at least a basic set of data
> chunks always need to exist. I know I was very surprised recently to
> see all my data chunks cleaned up on an otherwise empty fs.
> I mean..it's good to see that the house cleaning works, but you also
> gotta know when to stop!
>=20
> > thinking casually about ways to direct the allocator to use certain
> > devices for certain things (e.g. in a hybrid system with SSDs and
> > HDDs, always allocate metadata on the SSD) and there's some overlap
> > there.  As it stands, we can fake that in mkfs but it'll get stomped
> > by balance nearly immediately.
>=20
> Please share those casual thoughts with the group. :)

   I had some as well last year (see my other mail). I hope they line
up with Jeff's. :)

   Hugo.

--=20
Hugo Mills             | "Big data" doesn't just mean increasing the font
hugo@... carfax.org.uk | size.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--17/8oYur5Y32USnW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAVqLAAoJEFheFHXiqx3kCtgQALevzJlLuET9FS1kkxCKhXmz
X6NWBjo8PkQrJeOj3vALqj3tEUn79fVaZ69UV4dbDfVDaeW4yCp0oe75w8tDrOg3
BCtQ+exkZH8R7gGmwIiTan2X2n2tB0wrAyaUwq3ifjOpD+C4OewRKallQggd8YD0
f2hCis0vky7IcpYkiPVMNAQwBFEeJT9IP9kKY/5PKa/5gBIEAEnuyz+wBACMtn9W
2G7x0KDoD7IjO8k7EHkIi5dAXlwxVdsNMkqdyqTkrEGjKGslNLNnpWMPwzdy4Pxo
mlUkzofopGzW2xLHIUGqmincZsTioVQfyrddLakoERMCGLPr/FKRAS2/tLsAsd4K
dTRRlJKaE6MP5b+73Rs5bGgHu/7M3yw8tG57sjco5CaiFBtI+zrMlmfA7MRhmil5
Aqc68cmn/UqS6+TjPsOKHy7usFyRvNYY2cdinN6H9CLgu3FkxevR1A+2jN8fGnDy
Cosm/Nh84gN/BDXLr0+FWjN8JmR3s6Sl7oyTJC0cGd+ZM184FCI88IRCmgfLScW1
ErjRSX5C7hXIZ1fAbVOGm5hzWa2ZqC9Brr7lDcPhN3wzul6McQP2CoFuRVRcspZm
yb0dkx0Klolkc5K8LILxE5C1kAxXDLa0U3Jc9VRCAEZ6UG7xy973V2IT+b3Nzl0a
lbjS4eWCXMg+GZmeUohS
=HK6S
-----END PGP SIGNATURE-----

--17/8oYur5Y32USnW--
