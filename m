From: Roman Mamedov <rm@romanrm.ru>
Subject: snapshot ctime // Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 21:13:16 +0600
Message-ID: <20110817211316.0414bb5a@natsu>
References: <4E4B2452.9070407@oracle.com>
	<20110817140433.GA32261@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZbOsHWcpux4pffSti+LqR_n"; protocol="application/pgp-signature"
Cc: Anand Jain <Anand.Jain@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Dave <dave@thekilempire.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817140433.GA32261@hendrix.borisch.local>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/ZbOsHWcpux4pffSti+LqR_n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Aug 2011 10:04:33 -0400
Dave <dave@thekilempire.com> wrote:

> I've already done something similar.  I take hourly, daily, weekly, and m=
onthly
> snapshots of my /home subvolume.  Here's the script I've created for this:

On one machine I make hourly snapshots of my /home and of the root FS as we=
ll.

The tricky part is actually not the snapshotting, but the deletion of outda=
ted snapshots.

That's due to the unfortunate fact (bug?), that snapshot-directories do not=
 have their ctime set correctly at all, they have some totally bogus ctime =
instead.

.........../snaps/$ ls -la --time=3Dctime | tail
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-05@02-31-51
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-06@02-49-29
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-07@00-17-40
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-08@01-53-29
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-10@03-09-32
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-12@00-26-54
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-13@01-40-19
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-14@04-22-07
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-15@02-29-13
dr-xr-xr-x 1 root root  102 2011-06-28 12:29 2011-08-16@10-27-57

As you can see I have to store creation date/time in the snapshot name, and=
 then parse it out to delete snapshots e.g. older than 3 months.

So until someone cares about snapshot ctime enough to fix this, btrfs will =
not be a convenient FS to work with timed snapshotting/cleanup.

--=20
With respect,
Roman

--Sig_/ZbOsHWcpux4pffSti+LqR_n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5L2owACgkQTLKSvz+PZwhAXACfQKvnNPwCwxLyN1kpUrLvk7d7
aNgAn2AW7yQ4Ojn6QwvwBlIevSyj075p
=iA4F
-----END PGP SIGNATURE-----

--Sig_/ZbOsHWcpux4pffSti+LqR_n--
