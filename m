Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbcFBU4Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 16:56:16 -0400
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
To: Mark Fasheh <mfasheh@suse.de>, dsterba@suse.cz,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160601211522.GI7633@wotan.suse.de> <20160602170732.GJ29147@twin.jikos.cz>
 <20160602190814.GQ7633@wotan.suse.de>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <75b66bb1-9d20-a1af-2f41-688b9aee73a3@suse.com>
Date: Thu, 2 Jun 2016 16:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <20160602190814.GQ7633@wotan.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="EqsJEBsCFhiwcRqQl9btngMUSoV1nc2HI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EqsJEBsCFhiwcRqQl9btngMUSoV1nc2HI
Content-Type: multipart/mixed; boundary="eJ3lQkd8VgrUopjgk0sUTvV4KWILiArxc"
From: Jeff Mahoney <jeffm@suse.com>
To: Mark Fasheh <mfasheh@suse.de>, dsterba@suse.cz,
 Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <75b66bb1-9d20-a1af-2f41-688b9aee73a3@suse.com>
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
References: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160601211522.GI7633@wotan.suse.de> <20160602170732.GJ29147@twin.jikos.cz>
 <20160602190814.GQ7633@wotan.suse.de>
In-Reply-To: <20160602190814.GQ7633@wotan.suse.de>

--eJ3lQkd8VgrUopjgk0sUTvV4KWILiArxc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/2/16 3:08 PM, Mark Fasheh wrote:
> On Thu, Jun 02, 2016 at 07:07:32PM +0200, David Sterba wrote:
>> On Wed, Jun 01, 2016 at 02:15:22PM -0700, Mark Fasheh wrote:
>>>> +/* dynamically allocate and initialize a ref_root */
>>>> +static struct ref_root *ref_root_alloc(void)
>>>> +{
>>>> +	struct ref_root *ref_tree;
>>>> +
>>>> +	ref_tree =3D kmalloc(sizeof(*ref_tree), GFP_KERNEL);
>>>
>>> I'm pretty sure we want GFP_NOFS here.
>>
>> Then please explain to me why/where the reasoning below is wrong:
>=20
> The general reasoning of when to use GFP_NOFS below is fine, I don't
> disagree with that at all. If there is no way a recursion back into btr=
fs
> can't happen at that allocation site then we can use GFP_KERNEL.
>=20
> That said, have you closely audited this path? Does the allocation happ=
en
> completely outside any locks that might be shared with the writeout pat=
h?
> What happens if we have to do writeout of the inode being fiemapped in =
order
> to allocate space? If the answer to all my questions is "there is no wa=
y
> this can deadlock" then by all means, we should use GFP_KERNEL. Otherwi=
se
> GFP_NOFS is a sensible guard against possible future deadlocks.

This is exactly the situation we discussed at LSF/MM this year.  The MM
folks are pushing back because the fs folks tend to use GFP_NOFS as a
talisman.  The audit needs to happen, otherwise that last sentence is
another talisman.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--eJ3lQkd8VgrUopjgk0sUTvV4KWILiArxc--

--EqsJEBsCFhiwcRqQl9btngMUSoV1nc2HI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXUJ1pAAoJEB57S2MheeWyPu4P/jYv9AjFMZ5gZBm4K6adWkUY
mxqcneTlvhc7jjRyMYyiVMzoRxE//clc6s4VYK+7fvUwGdU+77aqgOLNZFw0D8YK
vEoJroaBmws/XeABRFOTWImjA5/G9N06V3cSXv8nOoV4EaZtCzpJRD2TdQoiiQCQ
dJoWtsPj1JKumvAiAV0Fa2kkaDNa45duGY0lmRru9V16zSnnEQx4W3TpBFuM/bzp
IHl82m9irXJQNyxdZF4jyO1IrEoM1Y2+cDBV0WBt7J1RgEvFSEhKGKFu2DiiktM2
Nq0xXgg/ex3bb8tiDGUK1etC+ldW93shyXBIbPcF/fQbGeLSSMJk0gCc/HYUeiQ6
b9QnR5FiTeUGd/1ILDq0PWcaBWi9/NxXLybmOIOWrHWUGvGM+8ZWEnp7y6xrdZdH
vXFo1imV6HbhvLxnR1FJCKBXcSwfx5NoJm8z3jhrxDex5XXlGL3kcNlGrvxpDOVR
N229ak0Q3m6udcpqgmNYXaID9kSb0PDG4AB5fnhRWRk04iouPOdnJvzkrL6JsXgD
rNqMN9M6UQtd0wCH0gkA53QW/CkzAN2Ox5H/JMp0HdY0H7CxwRLdQf6k7gM9chd5
OCkBclyT7mJ1Dke/FsGCR0+Z6N8xT/yEHqVv7opgrqeqW3tYso6eOLXSRzjsOR6J
758H6DY9h/A3+Xa5EcPa
=ChOT
-----END PGP SIGNATURE-----

--EqsJEBsCFhiwcRqQl9btngMUSoV1nc2HI--
