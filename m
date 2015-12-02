Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53716 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbLBSxp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 13:53:45 -0500
Date: Wed, 2 Dec 2015 18:53:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Russell Coker <russell@coker.com.au>, Chris Mason <clm@fb.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Bug/regression: Read-only mount not read-only
Message-ID: <20151202185331.GJ8775@carfax.org.uk>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com>
 <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au>
 <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com>
 <565F2260.1080004@redhat.com>
 <565F2EF7.5000109@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6b3yLyRKT1M6kiA0"
In-Reply-To: <565F2EF7.5000109@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6b3yLyRKT1M6kiA0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 02, 2015 at 12:48:39PM -0500, Austin S Hemmelgarn wrote:
> On 2015-12-02 11:54, Eric Sandeen wrote:
> >On 12/2/15 3:23 AM, Qu Wenruo wrote:
> >>Qu Wenruo wrote on 2015/12/02 17:06 +0800:
> >>>Russell Coker wrote on 2015/12/02 17:25 +1100:
> >>>>On Wed, 2 Dec 2015 06:05:09 AM Eric Sandeen wrote:
> >>>>>yes, xfs does; we have "-o norecovery" if you don't want that, or need
> >>>>>to mount a filesystem with a dirty log on a readonly device.
> >>>>
> >>>>That option also works with Ext3/4 so it seems to be a standard way of
> >>>>dealing
> >>>>with this.  I think that BTRFS should do what Ext3/4 and XFS do in this
> >>>>regard.
[snip]
> >so if you'd like btrfs to be consistent with these, I would not make
> >norecovery imply ro; rather, make I would make it require an explicit ro, i.e.
> >
> >mount -o ro,norecovery
> Agreed, with something like that, it should as blatantly obvious as
> possible that you can't write to the FS.
> 
> On a side note, do either XFS or ext4 support removing the
> norecovery option from the mount flags through mount -o remount?
> Even if they don't, that might be a nice feature to have in BTRFS if
> we can safely support it.

   One minor awkwardness with "norecovery", I've just realised: we
already have a "recovery" mount option. That's going to make things
really confusing if we stick to that name.

   Hugo.

-- 
Hugo Mills             | Reintarnation: Coming back from the dead as a
hugo@... carfax.org.uk | hillbilly
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--6b3yLyRKT1M6kiA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWXz4rAAoJEFheFHXiqx3kakgP/R1GaRgjPbG4z2j8SnPKs1zQ
uH5GlqlI29x/2EP3XbdaSDnmRGTPfigVYCyDHQGyiehWVBtUp8D+ChZQAQU64pen
oKRlN15P2TKKLZnZNmYPhiXVJP3YTCkh4imdb/ceik468W/g3z+v/zPVJxhVU94H
Ul7V09Bp60SNpWbkJuhD1vzqxxvDUOqqmzl33ZbHVXrHGlCF6LsIBWMVvuw2UbO6
eskk9C4TN47XQltRiUXx8N97MssFYC6kdzyf7mB1MQfoOKB5eQa/IeEX8wxfNQYt
lbYIoJwKcIRrtLeqDdzbMnNIMhbOUesh/KD+HEeVckOWxxK+7IFDsEyEMRKuLEK6
3xGMcVEr3UAZ+Fw4aq8VZiy5UZZmKidX2kHKyOHx0MUDwXAx4AZSgVCuJB7PIJhK
9I/zdvU5v/0lmIH7fYT9ip3tJVTUkYsjY0iYGGvpe/IMDCPO7au2mQ8Mi1lPcG7G
+lnLwBX1hHklPIaz4qLPyXE52hqQt22G0WweGpvrjytU9GHi62I6TqWjgoE9qovJ
h8QekmXmvtW0xePRCel3vfqRUI28BqWb1liorwErKkAWB9qkgerdeKv3eGsLNMhP
SYK5ug+b8TY/X8nKKc22fGnS+nTyXCW5W6sSY0vLhOC5N4B7N1YIpEdGsFvIbbbL
F+Wnzar/dWl+YfhRo/OB
=xdbB
-----END PGP SIGNATURE-----

--6b3yLyRKT1M6kiA0--
