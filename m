Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:45755 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753024AbeCFMIV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 07:08:21 -0500
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
To: dsterba@suse.cz, fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
 <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
 <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>
 <8af18593-05ff-e24c-1c39-0492cce2c21b@gmx.com>
 <20180306115827.GQ5942@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9668e83b-5ee2-30ff-0678-8e6ffce1c46d@gmx.com>
Date: Tue, 6 Mar 2018 20:08:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180306115827.GQ5942@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FWmqDVe2M5ISDScoVzL5X4hqToKAYVVV7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FWmqDVe2M5ISDScoVzL5X4hqToKAYVVV7
Content-Type: multipart/mixed; boundary="UQDxvoDPSVSUJ0xMbsv16X0PJTJuukzyy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9668e83b-5ee2-30ff-0678-8e6ffce1c46d@gmx.com>
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
 <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
 <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>
 <8af18593-05ff-e24c-1c39-0492cce2c21b@gmx.com>
 <20180306115827.GQ5942@twin.jikos.cz>
In-Reply-To: <20180306115827.GQ5942@twin.jikos.cz>

--UQDxvoDPSVSUJ0xMbsv16X0PJTJuukzyy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8806=E6=97=A5 19:58, David Sterba wrote:
> On Fri, Mar 02, 2018 at 07:40:14PM +0800, Qu Wenruo wrote:
>> On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 19:00, Filipe Manana wrote:
>>> On Fri, Mar 2, 2018 at 10:54 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>> On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 18:46, Filipe Manana wrote:
>>>>> On Fri, Mar 2, 2018 at 5:22 AM, Qu Wenruo <wqu@suse.com> wrote:
>>>>>> Normally when specifying max_inline, we should normally limit it b=
y
>>>>>> uncompressed extent size, as it's the only thing user can control.=

>>>>>
>>>>> Why does it matter that users can control it? Will they write less =
(or
>>>>> more) data to files because stuff won't get inlined?
>>>>> Why do they care about stuff getting inlined or not? That's an
>>>>> implementation detail of btrfs to speed up access to file data and
>>>>> save some space.
>>>>
>>>> Then why we still have max_inline mount option?
>>>
>>> My comment was about deciding based on which size to make the decisio=
n
>>> (compressed vs uncompressed).
>>
>> The same thing, we have given user options to trigger the behavior, th=
en
>> we should give them *predictable* option to modify the behavior.
>>
>> Not something confusing like current max_inline.
>>
>> Either we give user max_inline and max_inline_compressed, or both foll=
ow
>> max_inline.
>=20
> I agree with Filipe and don't see a reason to limit the inlining
> capabilities. Max inline exists to set the maximum file size that will
> be considered for inlining, the rest is implementation detail.
>=20
> In a similar way the compression can decide if the data will be
> compressed, though the user has specified the mount option.
>=20
> Adding another option (max_inline_compressed) does not necessarily
> improve the situation. This requires the user to understand the values
> it can have and how it interacts with other options.
>=20
> I've been thinking about this patchset for a few days and still don't
> think there's a problem we need to fix. We can certainly improve the
> reporting, so the mount option value will be adjusted to the exact
> inline limit and then printed to syslog. Additionally we can export the=

> value as sysfs file, and udate documentation.

Fine, I will discard this patch and just enhance the prompt.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--UQDxvoDPSVSUJ0xMbsv16X0PJTJuukzyy--

--FWmqDVe2M5ISDScoVzL5X4hqToKAYVVV7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqehKUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiaQwf/TSQCuUG9nDRBDvYW5/vElF3U
ercmBWlsL+ZctiLJ8idJChSTin7bp7NTje9ZfbRyaQfoN8NQlyond/arbiAtLpag
KDlZI7CAvQO+S+rCT2lT+FhyO7WL8opcKgm/1IuIh5WONR8TxiXcVI3wnD5kesia
fp4jR+DOer6zBNVG8Dmz/2hM56ZTdZ0oikYbApRwIyVRio9DbinBqO3LAa0YjUb3
0MSbk4gGp3VcjsV5nsj/IcnUEsii7zyCsJIzCXsa0AHsOHUunEdh4O8Jc+JZprF+
0Rb9a58+ilzGHy8bGKCr8VqQO9FWriUmdEWIpAoXKKStaMuTuNrjAT+Ec8kp/w==
=G1Vk
-----END PGP SIGNATURE-----

--FWmqDVe2M5ISDScoVzL5X4hqToKAYVVV7--
