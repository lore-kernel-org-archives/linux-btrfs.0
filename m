Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbcGHLz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 07:55:56 -0400
Subject: Re: kdave/for-next commit 26112f7f472
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        David Sterba <DSterba@suse.com>, Josef Bacik <jbacik@fb.com>
References: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
 <577F8C2E.3@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>
Date: Fri, 8 Jul 2016 07:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <577F8C2E.3@applied-asynchrony.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TUMVjE7qTUsv10s5xbFUuE5xPaQDIftRH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TUMVjE7qTUsv10s5xbFUuE5xPaQDIftRH
Content-Type: multipart/mixed; boundary="l2MVfGRu1nuHArFtFrm34dFe37wwg9QVk"
From: Jeff Mahoney <jeffm@suse.com>
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
 David Sterba <DSterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <fd43645d-fac7-faf9-565f-dfbc6a84ecf5@suse.com>
Subject: Re: kdave/for-next commit 26112f7f472
References: <f4d56502-9860-d9b0-2e40-337a8d028e04@suse.com>
 <577F8C2E.3@applied-asynchrony.com>
In-Reply-To: <577F8C2E.3@applied-asynchrony.com>

--l2MVfGRu1nuHArFtFrm34dFe37wwg9QVk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 7/8/16 7:19 AM, Holger Hoffst=C3=A4tte wrote:
> On 07/08/16 06:24, Jeff Mahoney wrote:
>> Hi Dave -
>>
>> This commit introduces a bug.  I ran across it when running xfstests
>> against my own integrated branch.
>=20
> I can't find that commit id anywhere...?

Hi Holger -

This is the for-next branch.  It's not in any mainline branch yet.

>> The problem is that btrfs_calc_reclaim_metadata_size didn't used to be=

>> called from recovery, so it was safe to use fs_info->fs_root.  With
>> commit 7c83c6a09 (Btrfs: don't bother kicking async if there's nothing=

>> to reclaim) we do call it from recovery context and fs_info->fs_root i=
s
>> NULL.
>>
>> The fix is to just not switch btrfs_calc_reclaim_metadata_size to take=

>> an fs_info.  All the other call sites were using fs_info->fs_root
>> anyway, so it's not like we're pinning a root somewhere just for this =
call.
>=20
> I've had this patch from last October in my 4.4.x tree forever:
> http://www.spinics.net/lists/linux-btrfs/msg48457.html
>=20
> Apparently it fell off the table. Shouldn't that fix it?

A different fix went into for-next.  That's where the conflict is.  The
merged version of my root->fs_info patch reverts it.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--l2MVfGRu1nuHArFtFrm34dFe37wwg9QVk--

--TUMVjE7qTUsv10s5xbFUuE5xPaQDIftRH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXf5THAAoJEB57S2MheeWy0yUP/A5jasOIj3idFcvg90Ce8kS/
e/y1h6TXXHxTLLWuqWvAojxP8LIFMKRVmghZlvg5VXfIpoVSaX4ev6ph+5MC1Om4
J4t6SCieHDFFP+vvREYZQBdJV7cfrCANBw0SvuR126Y2eEJhkZHgKgWR61QBQNlY
Hflq1/fe6d0IWDK27KJfm2obPhalyN+WW4Jnj7qYNPWG42RCZuWI8GIKwp6ha60Q
Zill0vD7/WbWgCLQ9AU9NFLckjjPMdlmJ778Sq/UaAuZ3PYKlCGXQhwxUI7GxTDH
KLfKd8JkggJ/8425TBvxQ/yB1Dh8tA1A62gTEhi4ZqPs73AtTvIwc2qZaIUAL6Wi
rD611t0gVdaCFyyBhae6SSAUIlTRUpNt7dpChrY0Kfqx0q8k1oalDs6Y3YHN0El4
hw3aizJl7iPppUBRLDB0wokV05xqHusbsasndRCx8br1B27qkYOMUK3HorwcsqDK
V7id052A7UOfQQAdFNez86LCeXJ73RGTW+nk4QtUPKptS0pnhVFjAbmrghfzXXk4
XRtPPrNM0d65PHSlkCsy/xYEItuBxUdXbrMnA9TJcaojWmcgDphoEaxAMMHD6LPX
iq+jn/oYUhGKtnFiKFEueNHXTPnnuEBHCpc8ffk3vnQEDWgO/eXV7Ek36Eu72tc8
+1KqBekCrIcY3rSdGYtR
=fYBk
-----END PGP SIGNATURE-----

--TUMVjE7qTUsv10s5xbFUuE5xPaQDIftRH--
