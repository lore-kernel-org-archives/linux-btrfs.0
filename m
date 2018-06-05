Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751750AbeFENrz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 09:47:55 -0400
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
Date: Tue, 5 Jun 2018 21:47:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180605134237.GA3539@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tVAKQGCMRCEWp0B0ASN24mPhl7c5zqYvc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tVAKQGCMRCEWp0B0ASN24mPhl7c5zqYvc
Content-Type: multipart/mixed; boundary="7UexUjaot1oshf9wg0tj8jkHW7tCZkYO8";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
In-Reply-To: <20180605134237.GA3539@twin.jikos.cz>

--7UexUjaot1oshf9wg0tj8jkHW7tCZkYO8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8805=E6=97=A5 21:42, David Sterba wrote:
> On Tue, Jun 05, 2018 at 01:34:03PM +0800, Qu Wenruo wrote:
>> Hi David,
>>
>> It would be pretty nice if we could get this fix (or previous RFC patc=
h)
>> to get into current release cycle.
>>
>> As it's a unrecoverable data corruption, it would be better to get it
>> fixed as soon as possible.
>=20
> That we can do, I'm planning to send 2nd pull by the end of the next
> week as there's at least one patch in the queue now.
>=20
> This patch seems to big, can you please prepare a minimal version?

The previous version (a completely different direction though) is much
smaller.
https://patchwork.kernel.org/patch/10440541/

However personally speaking, I still prefer this one, as it's much simple=
r.

Thanks,
Qu

> Thanks.
>=20


--7UexUjaot1oshf9wg0tj8jkHW7tCZkYO8--

--tVAKQGCMRCEWp0B0ASN24mPhl7c5zqYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsWlIIACgkQwj2R86El
/qiopwgAkQ5zmjDCLLubMnqtMva82v/PEaIwqJlIsCqNfumiJ8cB8lvC1bNmhFnE
8tpQhBIqeXNk2Nn5itZUTyc3JaCE3D3aOmLRgCB1dowhPG6+BPIwy1RIiJLAKVkM
MkLl2ldLWy2WnMddcSphB/m5dVE7rowm73/iAalFyyRWaMpe8ivp9ypxXSpjLrK6
BQSCKv72k02UWIWDtZggy3CAhXBDky4UVNbU1GmEjF7x7miIhUtQrJUWpNbZoBWW
Bxz4XkCpxVBRBg68FlSXSdIVeSc2MkMeOu4E4JPuNkfCCeDc19YNIJ5cQ8e3q5nX
q+YjTX7L702MLl/qEci6EcTGfYw7Og==
=CAS5
-----END PGP SIGNATURE-----

--tVAKQGCMRCEWp0B0ASN24mPhl7c5zqYvc--
