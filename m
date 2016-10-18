Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755623AbcJRVbq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 17:31:46 -0400
Subject: Re: question re: trim in btrfs
To: Tim Walberg <twalberg@comcast.net>, linux-btrfs@vger.kernel.org
References: <20161018174238.GB5559@comcast.net>
 <20161018190659.GC5559@comcast.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <800ab6b8-10a3-9667-5ad6-4ad0e902d5de@suse.com>
Date: Tue, 18 Oct 2016 17:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <20161018190659.GC5559@comcast.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WOXH1KAL3XEVTl3UUnTF5B53kNQF2Ntui"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WOXH1KAL3XEVTl3UUnTF5B53kNQF2Ntui
Content-Type: multipart/mixed; boundary="HxgT2i0sj0ww3Ht2i7RPE58UJl0nwfGdr";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Tim Walberg <twalberg@comcast.net>, linux-btrfs@vger.kernel.org
Message-ID: <800ab6b8-10a3-9667-5ad6-4ad0e902d5de@suse.com>
Subject: Re: question re: trim in btrfs
References: <20161018174238.GB5559@comcast.net>
 <20161018190659.GC5559@comcast.net>
In-Reply-To: <20161018190659.GC5559@comcast.net>

--HxgT2i0sj0ww3Ht2i7RPE58UJl0nwfGdr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/18/16 3:06 PM, Tim Walberg wrote:
> Forgot to mention - this was on a rather crusty 4.2.6 kernel. Just upgr=
aded to 4.8.1
> and the issue appears to have been resolved...

Thanks for following up.  This issue was actually fixed in v4.3.  There
were a bunch of fixes for discard ranging from correct(ish[1]) reporting
of bytes discarded, discarding ranges in freed block groups, and missing
discards when using -odiscard.

-Jeff

[1] We report the range for which we issue discards.  We don't track if
a particular range has been previously discarded.

> On 10/18/2016 12:42 -0500, Walberg, Tim wrote:
>>> 	Unless I'm misinterpreting something it appears that maybe btrfs doe=
sn't pass
>>> 	fstrim commands down to the underlying drives when being used in a R=
AID-1 config.
>>> =09
>>> 	I have this output from a small script I wrote to run at boot time (=
and also via
>>> 	cron.weekly), rather than using continous trim in the boot options:
>>> =09
>>> 	# cat /var/log/trim.log
>>> 	Thu Oct 13 07:40:07 CDT 2016
>>> 	/boot: 454 MiB (476062720 bytes) trimmed
>>> =09
>>> 	Thu Oct 13 07:40:08 CDT 2016
>>> 	/: 8.9 GiB (9585152000 bytes) trimmed
>>> =09
>>> 	Thu Oct 13 07:40:22 CDT 2016
>>> 	/btrfs/0: 0 B (0 bytes) trimmed
>>> =09
>>> 	/boot and / are mdraid RAID 1 on partitions 1 and 3 of two Samsung 8=
50 Pro SSDs.
>>> 	/btrfs/0 is a btrfs-raid RAID 1 of partition 4 on the same two drive=
s. The btrfs
>>> 	case does not seem to accomplish anything. By comparison, I have the=
 same drive
>>> 	in my laptop, but just a single one, and the non-btrfs-raid-1 file s=
ystem on one
>>> 	of its partitions does run fstrim successfully.
>>> =09
>>> 	This is quite possibly a known limitation, but I didn't find anythin=
g about it
>>> 	through some quick searching. Maybe I didn't dive deep enough...
>>> =09
>>> 	--=20
>>> 	twalberg@gmail.com, twalberg@comcast.net
>>> 	--
>>> 	To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>>> 	the body of a message to majordomo@vger.kernel.org
>>> 	More majordomo info at  http://vger.kernel.org/majordomo-info.html
> End of included message
>=20
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--HxgT2i0sj0ww3Ht2i7RPE58UJl0nwfGdr--

--WOXH1KAL3XEVTl3UUnTF5B53kNQF2Ntui
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYBpS9AAoJEB57S2MheeWycO0P/2tGANtuF0PQqYT8oxb81L6v
qd7PX/pb6JbSm5+sbO0Au0ZmczQLU5xDTP/wIaHSCwDSrM6A5FEirQyevmIJvzOq
ObkDTnSCKLpNliVfZk7M0NNNj2DBTHDxnHfk2+hQJ9f9BiH/tNpu9RmtsLnJ/y7g
WJGIHz6BiQ9o+ForhhZIeme/QRhyQp3idMTLI+funTTcVe82jdNiiBZX+3afk5i1
xLCZoilx/cKrAUcZtCI74L8Fpf/zBu+kTPPcVHfcWwbxuoP6wWQMDzkLl2abjMm9
7+cdyyU9C91BTMHWrFCy+0f5EaYLafzWVa2q9KqxPgjc7Nushtqn02KY1le67Rhn
AS+UwdjsVKBqF1TfLjmuwJxg5vZUIHNSMjeWWQvsWgQWEjBX+HBLs1AunkPxR3zY
Un8Wz1xjW7glOvLQMO249vnBXMPMqEqauFeU88UkIjgzIoF+6HnmDsmVjDbDmylw
7GhllLB2ytcX6DIIvS8XNq9dmTTJT4YbYwlOfy1CgXVNUe/pO0dPIlo1qhYJj/mR
+YL+npw2jPumQAx7/aRmGOsOXLzXxWhgSY/S1hhC/or84uRl2lF0W1ZVobPPfOC7
FT/6KDvDMNUW6GHzsIQLrsiBaMo4mGGoRD2VQDb4R6m+cRNsYXbzzYp1gS/t0Bet
cvrzDDqztMMPvEcOCCjX
=4u7M
-----END PGP SIGNATURE-----

--WOXH1KAL3XEVTl3UUnTF5B53kNQF2Ntui--
