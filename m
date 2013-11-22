Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab3KVXAK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 18:00:10 -0500
Date: Sat, 23 Nov 2013 09:59:53 +1100
From: NeilBrown <neilb@suse.de>
To: stan@hardwarefreak.com
Cc: David Brown <david.brown@hesbynett.no>, James Plank <plank@cs.utk.edu>,
        Ric Wheeler <rwheeler@redhat.com>,
        Andrea Mazzoleni <amadvance@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
Message-ID: <20131123095953.18858e89@notabene.brown>
In-Reply-To: <528F812D.8020105@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<528D61C5.70902@hardwarefreak.com>
	<528DCD36.1060808@hesbynett.no>
	<528F122C.2040202@hardwarefreak.com>
	<528F812D.8020105@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FW_2xjW9xSFtnZIdV5aJW2z"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/FW_2xjW9xSFtnZIdV5aJW2z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Nov 2013 10:07:09 -0600 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 11/22/2013 2:13 AM, Stan Hoeppner wrote:
> > Hi David,
> >=20
> > On 11/21/2013 3:07 AM, David Brown wrote:
> ...
> >> I don't see that there needs to be any changes to the existing md code
> >> to make raid15 work - it is merely a raid 5 made from a set of raid1
> >> pairs. =20
> >=20
> > The sole purpose of the parity layer of the proposed RAID 15 is to
> > replace sectors lost due to UREs during rebuild.  AFAIK the current RAID
> > 5 and RAID 1 drivers have no code to support each other in this manner.
>=20
> Minor self correction here-- obviously this isn't the 'sole' purpose of
> the parity layer.  It also allows us to recover from losing an entire
> mirror, which is a big upshot of the proposed RAID 15.  Thinking this
> through a little further, more code modification would be needed for
> this scenario.
>=20
> In the event of a double drive failure in one mirror, the RAID 1 code
> will need to be modified in such a way as to allow the RAID 5 code to
> rebuild the first replacement disk, because the RAID 1 device is still
> in a failed state.  Once this rebuild is complete, the RAID 1 code will
> need to switch the state to degraded, and then do its standard rebuild
> routine for the 2nd replacement drive.
>=20
> Or, with some (likely major) hacking it should be possible to rebuild
> both drives simultaneously for no loss of throughput or additional
> elapsed time on the RAID 5 rebuild.=20

Nah, that would be minor hacking.  Just recreate the RAID1 in a state that =
is
not-insync, but with automatic-resync disabled.
Then as continuous writes arrive, move the "recovery_cp" variable forward
towards the end of the array.  When it reaches the end we can safely mark t=
he
whole array as 'in-sync' and forget about diabling auto-resync.

NeilBrown



 In the 20TB drive case, this would
> shave 18 hours off the total rebuild operation elapsed time.  With
> current 4TB drives it would still save 6.5 hours.  Losing both drives in
> one mirror set of a striped array is rare, but given the rebuild time
> saved it may be worth investigating during any development of this RAID
> 15 idea.
>=20


--Sig_/FW_2xjW9xSFtnZIdV5aJW2z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUo/h6Tnsnt1WYoG5AQIRURAAvq7iQ8cfSkOgWftsXhliaxsxQhWJPVU9
61Qr9kHdw0/VivZCnG/ExtpdM3JIoq1/7y/J3ckA1wPJM6a0OSGwd7SBWP9DIeeu
rwV5yvcScxRPtec1B9cPK6mTptvx9iunAwV+eXMJi78opTGmfougrNReBRxuf/Su
SZEJdI/zjsYCp3w7oczWtww5rGllIRNrEgJayhrlEwQjgyh3Hriw9I/xCFWDmRAO
DRcldfBDadymcVeTGW4bQUDR6IoV76otAviJKtc5/mulabPrFjwGozYWwlGx+RyD
gQAPaMkNiVDi3ClLITMtOjz7jib1GMIGYmN2o8uS30Sepo7LM6xKXKrpFEmgXfq+
Z/uNFvRDLOFZJ+nDqsAavIdzBHYyPVQ/8o2E3sc3cQovtnAKWF/vugV6t4NqwPwT
LKS9aqTW+G/iF0nkRcZV7/rxM8Did8HfxxfUep/TyAjhUWr6AYRW6Kyno7f3GBz9
xnO+XNn+F+GfEPIWHVYbgGdXK68KlI09eYLRyilQslI7+eOgnTRX8iJ6/3t4Ag/k
4maXjrUgDD7TDVt4K8dceR8Ng7/QcNkIoL0omIwZEoZhQ2NhoygHxPolu6ALvS1V
fPbYPxWCW4Zn7x5M3M0NFGYxkq9YKqoU/4Gp/6BRFVgfkoLaL5tgKi0A2XdK/olU
HnqtETRN+c8=
=E6sm
-----END PGP SIGNATURE-----

--Sig_/FW_2xjW9xSFtnZIdV5aJW2z--
