Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbbDTEuH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 00:50:07 -0400
Date: Mon, 20 Apr 2015 14:49:56 +1000
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
Message-ID: <20150420144956.1f489f67@notabene.brown>
In-Reply-To: <20150410112431.0e9c337d@notabene.brown>
References: <20150409174916.5a2efef5@notabene.brown>
	<29536.1428571388@warthog.procyon.org.uk>
	<20150410112431.0e9c337d@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dVcelSonvmDGq0X=lchLGNa"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/dVcelSonvmDGq0X=lchLGNa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Apr 2015 11:24:31 +1000 NeilBrown <neilb@suse.de> wrote:

> On Thu, 09 Apr 2015 10:23:08 +0100 David Howells <dhowells@redhat.com> wr=
ote:
>=20
> > NeilBrown <neilb@suse.de> wrote:
> >=20
> > >  Is there a better way?  Could a better way be created?  Maybe
> > >  SEEK_DATA_RELIABLE ??
> >=20
> > fiemap() maybe?
> >=20
> > > Also, if you do try to use fscache on btrfs with 3.19, then nothing g=
ets
> > > cached (as expected) and with a heavy load you can lose a race and ge=
t an
> > > asserting fail in fscache_enqueue_operation
> >=20
> > Do you have the patches here applied?
> >=20
> > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/=
?h=3Dfscache-fixes
> >=20
>=20
> Do I don't.  I had looked through them and while they did seem to be
> addressing similar sorts of races, nothing seems like an obvious match.
> I haven't been able to reproduce the BUG_ON myself.  I only have a report
> of it repeatedly affecting someone else:
>=20
>   https://bugzilla.opensuse.org/show_bug.cgi?id=3D908706
>=20
> I'll probably have to be happy with fixing usage on btrfs, and hope the o=
ther
> bug is fixed already or doesn't become a problem.

I managed to reproduce the bug, and when I applied your patches I cannot any
more.  So it looks like you've fixed it - thanks.

That just leave the bmap issue.  I'll post a patch which causes lseek to be
used when the fs says that is OK.

Thanks,
NeilBrown

--Sig_/dVcelSonvmDGq0X=lchLGNa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTSFdDnsnt1WYoG5AQKb9Q//ZDSe96Txtf7d6U5S89kGEclwSZHtCass
5WNCDawzeqMObZHDn4/jw0geTRj4NE6tpY74PcpPGAQdCzzy9sEC75+69mVCKgP/
WvVaH8KBXcWh8X2W1hHzMVsVq8us2J1aP1gS6LvJsBx33ajBZFitCkSIw4QK5jTz
krpIqrYHxtHshIRqHrv/0bZDcUT/uks6MnIIL7q+g92mBBdJC3xFrlQ+LbgJATdO
VT6TLbuneHPBZ2CdfZS7LaLbSv9XhgPHg7P7qZqN50ruEmASKdtay35B1aRee+Pz
00lemeByskVhRTN5zlebRRk187HNm/y073gAcn7ZhfqbMdo0SvJ4n5YEEg17a1bw
RPClMZW7GpMBFyA3IYUhxipJr4hHNN5vpPJuq47oyZMTFMNpu/8VHIpin3Ow7bJE
VMrixSz/G4BGR7g9c80JB2VRNzk9+gJR3rXgtBxgEaJLnGNvpHf3ocHIjW5Y4Bpk
CCjdz8MuNn3fY3b6jjrp87ENRfLjci7bEAAEAIOdgPdLSS7W/E+3qN9Xn+ja7Ubh
/vvQfscwMAHDciJTy2cmfZjARWACKBkbLov+f3q9uH0BNxG8mA1dRqNg3wVwrR2o
PB4j3Rd5dVw7kuncySOkPoUKQwtzoViW5Coeu6fmgD7+wreJuTIalGO2mjRFQUjz
P9+DooGLVfE=
=KOPe
-----END PGP SIGNATURE-----

--Sig_/dVcelSonvmDGq0X=lchLGNa--
