Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38923 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751210AbdGZNZa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 09:25:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20C5DAB1E
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 13:25:29 +0000 (UTC)
Subject: Re: [PATCH 5/7] btrfs-progs: backref: add list_first_pref helper
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-5-jeffm@suse.com>
 <ac5c6a7c-97e9-2230-934b-8e5cb371dc94@suse.com>
 <bf9d2dae-4291-2dad-9101-f5fb18215699@suse.com>
Message-ID: <90a21da3-6c0f-50cc-a95f-d05ed1a9f05e@suse.com>
Date: Wed, 26 Jul 2017 09:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <bf9d2dae-4291-2dad-9101-f5fb18215699@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0s9mVw2E0F971lCIsnN5lw1O7qwNnTfcX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0s9mVw2E0F971lCIsnN5lw1O7qwNnTfcX
Content-Type: multipart/mixed; boundary="Gn32N4WCDWFdkKEDfVFVW3kLGMFI6C4nc";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <90a21da3-6c0f-50cc-a95f-d05ed1a9f05e@suse.com>
Subject: Re: [PATCH 5/7] btrfs-progs: backref: add list_first_pref helper
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-5-jeffm@suse.com>
 <ac5c6a7c-97e9-2230-934b-8e5cb371dc94@suse.com>
 <bf9d2dae-4291-2dad-9101-f5fb18215699@suse.com>
In-Reply-To: <bf9d2dae-4291-2dad-9101-f5fb18215699@suse.com>

--Gn32N4WCDWFdkKEDfVFVW3kLGMFI6C4nc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/26/17 9:22 AM, Jeff Mahoney wrote:
> On 7/26/17 3:08 AM, Nikolay Borisov wrote:
>>
>>
>> On 25.07.2017 23:51, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> ---
>>>  backref.c | 11 +++++++----
>>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/backref.c b/backref.c
>>> index ac1b506..be3376a 100644
>>> --- a/backref.c
>>> +++ b/backref.c
>>> @@ -130,6 +130,11 @@ struct __prelim_ref {
>>>  	u64 wanted_disk_byte;
>>>  };
>>> =20
>>> +static struct __prelim_ref *list_first_pref(struct list_head *head)
>>> +{
>>> +	return list_first_entry(head, struct __prelim_ref, list);
>>> +}
>>> +
>>
>> I think this just adds one more level of abstraction with no real
>> benefit whatsoever. Why not drop the patch entirely.
>=20
> Ack.  I thought it might be more readable but it ends up taking the sam=
e
> number of characters.

Actually, no, it doesn't.  That's only true if using 'head' as the list h=
ead
as in the helper.

It ends up being

	ref =3D list_first_pref(&prefstate->pending_missing_keys);
vs
	ref =3D list_first_entry(&prefstate->pending_missing_keys,
                               struct __prelim_ref, list);

and I have to say I prefer reading the former.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Gn32N4WCDWFdkKEDfVFVW3kLGMFI6C4nc--

--0s9mVw2E0F971lCIsnN5lw1O7qwNnTfcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWXiYRB57S2MheeWyAQg0CQ//XBu8rvveduvxP1mPAXul7rFDGyKajPTC
yegNctc/Q+GY71Apty3+8UDIJdalTlzmzJ1CMFRblGVkpfoJ5sK2FJfSn2Gpbuoq
WFlLokdRgI5wz0Inj+0dD0q7WZw/S/1GTj3h9ERFkWiApE6i6qxlfyZlR9zLTt1D
oQHEDYfLBg6PUY/BHwVTNywxO/fA5ubnCwM6oKIiIn/mQEUrgPClS/O3fCTKaqmD
4bFXg5mkAq3lIPwYfjUnHe170kc7C4bJ2A4KVm9sNnDIgYgUfZ7zYwJSl6rB0YZt
TuwGr970IY9hrw91TEY7uaS7319fd8rpHfhXHiE8KyUlAXebZeTCnDibqHyUlneS
QRpaeAkJ4acStZx3vcRjMMu2jW+ijOS07+0YfSibClnI1LgGn13U5jOAmSem6qD7
1d2jxXZWf50pyoiNivMSUveiB0XEtR+tuY/VdRRj+fv1BtrnpToi3+koJ+n01uPo
ZV3worDScwNiFq6ibBDo94EkzKWINsI8+NPol0/o+ltfFHDiIvvxn4l5eZc6ntt3
W0pzr+e4GZltX2bcofIKyZxZPwCArt7JFv/96jcIPl6yOkxRQnH1fhSkREAncBeb
tXVk+fkq4wO6WIJt6FTKBkd0VR4fSHT639u8SdZ7/GYijvZlfeYTUVc+5wv3V274
3iMNjGC1iaA=
=wV+R
-----END PGP SIGNATURE-----

--0s9mVw2E0F971lCIsnN5lw1O7qwNnTfcX--
