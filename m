Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44032 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751384AbaJWNPz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 09:15:55 -0400
Date: Thu, 23 Oct 2014 09:15:49 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
Message-ID: <20141023131537.GB17395@hungrycats.org>
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com>
 <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net>
 <20141022200812.GA17395@hungrycats.org>
 <01D3E7DE-5420-4C97-98C4-BB0414C4972E@colorremedies.com>
 <54488F91.6070109@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
In-Reply-To: <54488F91.6070109@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 10:18:09PM -0700, Robert White wrote:
> On 10/22/2014 09:30 PM, Chris Murphy wrote:
> >Sure. So if Btrfs is meant to address scalability, then perhaps at the m=
oment it's falling short. As it's easy to add large drives and get very lar=
ge multiple device volumes, the snapshotting needs to scale also.
> >
> >I'd say per user, it's reasonable to have 24 hourly (one snapshot per ho=
ur for a day), 7 daily, 4 weekly, and 12 monthly snapshots, or 47 snapshots=
=2E That's 47,000 snapshots if it's sane for a single Btrfs volume to host =
1000 users. Arguably, such a system is better off with a distributed fs: Gl=
uster FS or GFS2 or Ceph.
>=20
> Is one subvolume per user a rational expectation? Is it even
> particularly smart? Dooable, sure, but as a best practice it doesn't
> seem that useful because it multiplies the maintenace by the user
> base.

For snapshots alone it doesn't make much sense, but there are other
btrfs features that work in subvolume units.  Some people want quota
and send/receive to work on a per-user level too.

If 'btrfs subvolume' had a '-r' recursive option, it would make management
easier.  Even without -r, /home/* can be managed by a simple shell loop
with a wildcard:

makeSnapshot () {
	btrfs sub create "/snapshots/$1"
	for x in /home/*; do
		btrfs sub snap "$x" "/snapshots/$1/$x";
	done
}

makeSnapshot "/home/.snapshots/$(date +%Y-%m-%d-%H-%M-%S)"

> Presuming a linux standard base layout (which is very presumptive)
> having the 47 snapshots of /home instead of the 47,000 snapshots of
> /home/X(1000) is just as workable, if not moreso. A reflink
> recursive copy of /home/X(n) from /home_Backup_date/X(n) is only
> trivially longer than resnapshotting the individual user.

reflink copies are much slower than snapshots.  For that matter, making
a writable snapshot of the entire /home as one subvolume, then using
'rm -rf' to get rid of what we don't need for one particular snapshot
is *also* faster than reflink copies.

More precisely, the bulk of the total life-cycle execution time is at the
beginning with reflink copies (have to create shared extent ref items,
traverse the source directories, and allocate new directory trees, all
while racing against data modifications) and at the end with snapshots
(btrfs-cleaner has to remove unreferenced tree nodes and extents in the
background) or snap-then-trim (replace btrfs-cleaner with rm -rf).

> Again this gets into the question not of what exercises well to
> create the snapshot but what functions well during a restore.
>=20
> People constantly create "backup solutions" without really looking
> at the restore path.

It's not all about backups.

> And if you setup each user on their own snapshot what happens the
> first time two users want to hard-link a file betwixt them?

One of the features of per-user subvolumes is that such things are
completely forbidden.  Security issues, user confusion, and all that.

Deduplication by extent sharing (and reflink copy) doesn't care about
subvolumes as long as you do the clone through a common parent of the
user subvolumes (i.e. /home).  The result isn't a hardlink which keeps
users happy, and shares underlying storage which keeps admins with
storage budget issues happy.

> Excessive segmentation of storage is an evil unto itself.
>=20
> YMMV, of course.
>=20
> An orthoginal example:
>=20
> If you give someone six disks and tell them to make an encrypted
> raid6 via cryptsetup and mdadm, at least eight out of ten will
> encrypt the drives and then raid the result. But it's _massivly_
> more efficent to raid the drives and then encrypt the result. Why?

That seems...implausible.  They would need to enter the passphrases six
times too.

> Because writing a block with the latter involves only one block
> being encrypted/decrypted. The former, if the raid is fine involves
> several encryptions/decryptions and _many_ if the raid is degraded.

It would be the correct answer if you needed to keep the structure of
the storage array secret...or if you wanted to use btrfs to implement
the RAID layer, and needed the encrypted layer to be divided along
the same boundaries as the physical layer.

> The above is a mental constraint, a mistake, that is all to common
> because people expect encrytion to be "better" the closer you get to
> the spinning rust.
>=20
> So too people expect that segmentation is somehow better if it most
> closely matches the abstract groupings (like per user) but in
> practical terms it is better matched to the modality, where, for
> instance, all users are one kind of thing, while all data stores are
> another kind of thing.
>=20
> We were just talking about putting all your VMs and larger NOCOW
> files into a separate subvolume/domain because of their radically
> different write behaviors. Thats a sterling reason to subdivide the
> storage. So is / vs. /var vs. /home as three different domains with
> radically different update profiles.
>=20
> So while the natural impulse is to give each user its own subvolume
> it's not likely to be that great an idea in practice because...
> um... 47,000 snapshots dude, and so on.

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRI/3kACgkQgfmLGlazG5wDaACghuwnC2Z7bSzvXYrCNicikqCD
cbwAni43Eqz8mpdiGfZq8cnKFJjJOWIq
=atMW
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
