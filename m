Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55885 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750855AbeEKC5n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 22:57:43 -0400
Subject: Re: [PATCH v2 0/4] btrfs: Add write time super block validation
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180424044809.29838-1-wqu@suse.com>
 <20180510144313.GL6649@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1585d921-91ad-e162-9ef2-87d64fe7d862@gmx.com>
Date: Fri, 11 May 2018 10:57:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180510144313.GL6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CBsrNxGjjs5F0m5Lh0hDMSspVvHS8ntqI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CBsrNxGjjs5F0m5Lh0hDMSspVvHS8ntqI
Content-Type: multipart/mixed; boundary="ckz2ZzJU8HiejFIDipETLNVBK3PiiGDd0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <1585d921-91ad-e162-9ef2-87d64fe7d862@gmx.com>
Subject: Re: [PATCH v2 0/4] btrfs: Add write time super block validation
References: <20180424044809.29838-1-wqu@suse.com>
 <20180510144313.GL6649@twin.jikos.cz>
In-Reply-To: <20180510144313.GL6649@twin.jikos.cz>

--ckz2ZzJU8HiejFIDipETLNVBK3PiiGDd0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8810=E6=97=A5 22:43, David Sterba wrote:
> On Tue, Apr 24, 2018 at 12:48:05PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/write_time_sb_check
>>
>> We have 2 reports about corrupted btrfs super block, which has some ga=
rbage
>> in its super block, but otherwise it's completely fine and its csum ev=
en
>> matches.
>>
>> This means we develop memory corruption during btrfs mount time.
>> It's not clear whether it's caused by btrfs or some other kernel modul=
e,
>> but at least let's do write time verification to catch such corruption=

>> early.
>>
>> Changelog:
>> v2:
>>   Rename btrfs_check_super_valid() to btrfs_validate_super() suggested=

>>   by Nikolay and David.
>>
>> Qu Wenruo (4):
>>   btrfs: Rename btrfs_check_super_valid() to btrfs_validate_super()
>>   btrfs: Add incompat flags check for btrfs_check_super_valid()
>>   btrfs: Add csum type check for btrfs_check_super_valid()
>>   btrfs: Do super block verification before writing it to disk
>=20
> IIRC there were some comments about the overal structure of the checks,=

> but I can't find V3 of the patchset. Can you please resend it or point
> me to it in case I missed it? Thanks.

Sorry, forgot to update the patchset, would send them out soon.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ckz2ZzJU8HiejFIDipETLNVBK3PiiGDd0--

--CBsrNxGjjs5F0m5Lh0hDMSspVvHS8ntqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr1BpkACgkQwj2R86El
/qgs/gf/UWbRa0M2Ebsr0M4ZjFdjo0KCRyYCqHeLGX8MUoieHqVsZAg5pPPNHz6z
+1BPCrpIHUH2g+pidWdVGLRSw1BNkkuuuW/53gk8uEGyhd2QsGvRtYxOn5FwitOs
VH7xlu0NacOXg5SKHBOkLOpBzZWgr3KJfh4KQpauYCYZ+1NTfjcXSKFVBfbQzQUy
avoDiVexJkvhwvSkWK3ToOjxZOisfO/hBrMZEHiqc1pwEayZnKP7EfxwTcxPjB+I
eVtET26dHm9MkNsb5vpF8D1kqq3Srn/CWeRZ3xTb63lKRs3jPkpD7R+3pWGkNiYk
MXOwwEgaiXlPDbC08cfd224r7P5Isg==
=1zlg
-----END PGP SIGNATURE-----

--CBsrNxGjjs5F0m5Lh0hDMSspVvHS8ntqI--
