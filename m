Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50230 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbbJHWWZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 18:22:25 -0400
Date: Thu, 8 Oct 2015 22:22:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS RAID1 behavior after one drive temporal disconection
Message-ID: <20151008222223.GD25907@carfax.org.uk>
References: <201510052226.47051.pisa@cmp.felk.cvut.cz>
 <561657D5.1070809@gmail.com>
 <20151008211352.GC25907@carfax.org.uk>
 <201510090016.43759.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgr1mbP1ee4HJQ5m"
In-Reply-To: <201510090016.43759.pisa@cmp.felk.cvut.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zgr1mbP1ee4HJQ5m
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 09, 2015 at 12:16:43AM +0200, Pavel Pisa wrote:
> Hello Hugo,
>=20
> On Thursday 08 of October 2015 23:13:52 Hugo Mills wrote:
> > On Thu, Oct 08, 2015 at 07:47:33AM -0400, Austin S Hemmelgarn wrote:
> > > On 2015-10-08 04:28, Pavel Pisa wrote:
> > > >I go to use "btrfs replace" because there has not been any reply to =
my
> > > > inplace correction question. But I expect that clarification if
> > > > possible/how to resync RAID1 after one drive temporal disappear is
> > > > really important to many of BTRFS users.
> > >
> > > As of right now, there is no way that I know of to safely re-sync a
> > > drive that's been disconnected for a while.  The best bet is
> > > probably to use replace, but for that to work reliably, you would
> > > need to tell it to ignore the now stale drive when trying to read
> > > each chunk.
> >
> >    Scrub is officially what you need there. I can confirm that it
> > works correctly, having used it myself after accidentally unplugging
> > the wrong drive.
> >
>=20
> Thanks for the reply.
>=20
> I have tried to run scrub after reconnect but it counted errors in
> its console output and write errors has been logged by kernel as crazy.
> I have to admit I have not wait to finish it because I have not good
> feeling from it.

   If the scrub works OK, you will still get lots of scary-looking
errors in the logs, but they'll usually say it's repaired the problem.

   Getting write errors at this point indicates that you have hardware
problems of some kind, and (usually) that device needs to be replaced.
(Or the controller, or the cabling).

> May it be it was result of not fully correct reconnect.
> But other partition worked with ext4 has no problems to write.
>=20
> But if mount/unmount (in my case requiring reboot) and then scrub
> worked it would be much simpler than replaces series.
>=20
> I hope I would not need that (at least soon/in years) but I
> give try to scrub again.
>=20
> May it be problem is my btrfs tools old version on the server --
> Wheezy Btrfs v3.17 backport. Kernel is Linux 4.1.2 #1 SMP PREEMPT.

   No, the version of the tools has no effect on any of this. It
really sounds like you have hardware issues.

   Hugo.

--=20
Hugo Mills             | =A91973 Unclear Research Ltd
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--zgr1mbP1ee4HJQ5m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWFuyfAAoJEFheFHXiqx3kQQoQALx9JK5puqEnmkcfwD4175lb
jmocjx6FqQzNj8MFwBQ4/IHyG1szgxguurP/oPxKKiuMmXrGJEH1NFLx2l6ojr35
ozv1542ZQGbrJzvtSWlvcdu4s3/6tbcjiO2Xh78XXO3tDmtHHFQ0cLwIbWPbU/ox
ffCoGqKCw7HPYU7lR4z+1W2Nv6UmeyL/TEzmaGl68x+gpPswoOmD/1SJ9lEcG5Ld
zd6H6SMv7bLp08tvuqp8kpEoe6OtnqAp9fdG5zWawXzX6EWO09oRoFLZyZlqrW1U
GeDIiE/RDVSfwj4kVw5ZRLlol8oXRoBFvStf8jaqrIjwRNGIQvF7aggH0HPa6SMv
G82YhjEUhnYtRcN8nbcjGLkqee22uuX/zueBi/aVNVe9wduH93ax5LDqeWPnbRWK
BXIj/HH6eDu+AZujQq+l6arqmWwIaVK3K7Pc7ljxkGPLZbnyXlDIF4Zbt90+we9Q
TPH/+rdJiEodlLcBrsoRylQnPfEFY1Bs/7NUQaTANgFB/ao+JTTl6LWBBdpsc1Gx
RxLqwOVlqiw5iXPuiOLv1VyozpQ61JNoZpNTRq1KaeYmEonZt4rHaSRzD3ymSJ6B
hdfD5xj9rr1r+hdVG2iApivf9cYXySHleVwDgqsUAbtlwebOjW2JF75HsLkQjFcl
2cf7HNAGbsDES8Ug9oHA
=HPxd
-----END PGP SIGNATURE-----

--zgr1mbP1ee4HJQ5m--
