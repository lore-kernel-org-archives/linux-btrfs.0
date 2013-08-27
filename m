Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab3H0VZz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 17:25:55 -0400
Message-ID: <521D1955.8000908@suse.com>
Date: Tue, 27 Aug 2013 17:25:41 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com> <521CFDD8.6030205@suse.com> <20130827205637.GM29654@localhost.localdomain> <521D14FF.9090604@suse.com> <521D184F.5060407@redhat.com>
In-Reply-To: <521D184F.5060407@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Wl2k6rEGWouBPhj5GvacTg8Xvu25n30Km"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Wl2k6rEGWouBPhj5GvacTg8Xvu25n30Km
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/27/13 5:21 PM, Eric Sandeen wrote:
> On 8/27/13 4:07 PM, Jeff Mahoney wrote:
>> On 8/27/13 4:56 PM, Josef Bacik wrote:
>>> On Tue, Aug 27, 2013 at 03:28:24PM -0400, Jeff Mahoney wrote:
>>>> On 8/26/13 4:56 PM, Josef Bacik wrote:
>>>>> One of the complaints we get a lot is how many BUG_ON()'s we have. =
 So to help
>>>>> with this I'm introducing a kconfig option to enable/disable a new =
ASSERT()
>>>>> mechanism much like what XFS does.  This will allow us developers t=
o still get
>>>>> our nice panics but allow users/distros to compile them out.  With =
this we can
>>>>> go through and convert any BUG_ON()'s that we have to catch actual =
programming
>>>>> mistakes to the new ASSERT() and then fix everybody else to return =
errors.  This
>>>>> will also allow developers to leave sanity checks in their new code=
 to make sure
>>>>> we don't trip over problems while testing stuff and vetting new fea=
tures.
>>>>> Thanks,
>>>>
>>>> I don't think the complaint is so much about the number of BUG_ONs, =
but
>>>> that there's no distinction between something that is supposed to be=

>>>> impossible and something that is improbable. The BUG_ONs to keep cod=
e
>>>> correctness are good and are littered all over the kernel with posit=
ive
>>>> results. The BUG_ONs that are there in place of real error handling
>>>> served their purpose and need to be replaced.
>>>>
>>>> So, I don't know if it's a net win to compile the "good" BUG_ONs out=
 of
>>>> the code. Especially if a user runs into something strange yet famil=
iar
>>>> and the first response is "oh, huh, can you rebuild with asserts ena=
bled?"
>>>>
>>>
>>> Either I provide an option for it or distros do it themselves, this c=
uts out the
>>> middle man.  I'd really rather they just be on all the time since the=
y aren't
>>> things we should hit anyway, but at least this way people have a choi=
ce.
>=20
>> Ok. With my distro hat on, I can tell you I'll be leaving them on. :)
>=20
>> -Jeff
>=20
> XFS also has XFS_WARN as a config option, which keeps all the assertion=
s
> in place, but printk's & backtraces w/o the icky BUG().  That might be
> good to add as well, and perhaps best for a shipping distro (vs. a deve=
loper
> debugging who might want to drop a core file when the assert trips).

Isn't that the distinction between BUG_ON and WARN_ON? If it's worth a
BUG_ON, things should be bad enough (or could result in being bad
enough) that we want to bail out.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Wl2k6rEGWouBPhj5GvacTg8Xvu25n30Km
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSHRlcAAoJEB57S2MheeWyFcQP/1RnkugMRMrhHvzFxH+xCO8/
tkIPAaJQembhrlAP1CqkBLAwef8MoQUTqL7NmwrkIcJCtgn9qnV1tG1CO9J79d9O
wfODxw86cIoHueE7T02ZSPUrYKHSBov5IJuUWZJDb7xEC6FLPshuoseCaOOMNGDD
pAcYpsan5XZOVZ53CMgMjRnZUnPe42U65bKxCw8OFqoh8svQIUS9vUygTIPAOXUy
G0apkS28AenSzU/RQlQWzaWJnlycQcZiB8fBfSQAVV3BLIDGov0vcc5ySOBVMrPB
Q4cbJjco8r2aU0NzTo0AogHTMS8RE75PbfpcSLsznlhlOIobCYaThqsOTjKNuJ5c
uiATM2FPKTf9o8Jb4/XIQcZHnhKw8Jwct2CK0JjfwiAGvtpsYyE2jEGIK0GRtjSo
1Z8GCKQMs3fIuci4sq4Sib9c1zMlZRoVEh7l58sdQkS9LFFfYKa37zX5Wlb70MXq
uHC35BOEQwzUSQRFsmrtrzoXt23ron+iTdWNWFCymTQs2nJcqO5OzOmtCS2rH5to
Cdnrja69uDC4XCplgf8aRO7Nkbm6v1tLbA69FHbyD97putDLcpe9EpQXyyxTNiO6
8iBQD+mWiRVgQLEqSEOKPXD5jSqhknQ7/lHM3LaERDBmcSvOoiKr9m6Ur0aIhlqF
PiYSEsLfDtk/jmWCBT9W
=BE0G
-----END PGP SIGNATURE-----

--Wl2k6rEGWouBPhj5GvacTg8Xvu25n30Km--
