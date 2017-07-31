Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751610AbdGaRBe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 13:01:34 -0400
Subject: Re: [PATCH 4/5] btrfs-progs: tests: fix typo in
 convert-tests/008-readonly-image
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20170727154723.2208-1-jeffm@suse.com>
 <20170727154723.2208-5-jeffm@suse.com>
 <631583cc-d84e-d1d5-96f0-99ad6b083fb9@gmx.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <daa81609-3a4e-7314-d070-852c27414e06@suse.com>
Date: Mon, 31 Jul 2017 13:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <631583cc-d84e-d1d5-96f0-99ad6b083fb9@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gt7tq4Wn4RAgMtRmCTvbxX8CEDn7Jo6pH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gt7tq4Wn4RAgMtRmCTvbxX8CEDn7Jo6pH
Content-Type: multipart/mixed; boundary="vwJoDwVapIWE0MtpN0lgPP9am1l1N26FI";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <daa81609-3a4e-7314-d070-852c27414e06@suse.com>
Subject: Re: [PATCH 4/5] btrfs-progs: tests: fix typo in
 convert-tests/008-readonly-image
References: <20170727154723.2208-1-jeffm@suse.com>
 <20170727154723.2208-5-jeffm@suse.com>
 <631583cc-d84e-d1d5-96f0-99ad6b083fb9@gmx.com>
In-Reply-To: <631583cc-d84e-d1d5-96f0-99ad6b083fb9@gmx.com>

--vwJoDwVapIWE0MtpN0lgPP9am1l1N26FI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/27/17 9:27 PM, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B407=E6=9C=8827=E6=97=A5 23:47, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> The dd in convert-tests/008-readonly-image is expected to fail, so
>> there being a typo in the file name has gone unnoticed.
>=20
> Thanks for catching this.
> This is very embarrassing.
>=20
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>   tests/convert-tests/008-readonly-image/test.sh | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tests/convert-tests/008-readonly-image/test.sh
>> b/tests/convert-tests/008-readonly-image/test.sh
>> index 27c9373..cc846fa 100755
>> --- a/tests/convert-tests/008-readonly-image/test.sh
>> +++ b/tests/convert-tests/008-readonly-image/test.sh
>> @@ -14,9 +14,10 @@ convert_test_prep_fs $default_mke2fs
>>   run_check_umount_test_dev
>>   convert_test_do_convert
>>   run_check_mount_test_dev
>> +run_check e2fsck -n "$TEST_MNT/ext2_saved/image"
>>     # It's expected to fail
>> -$SUDO_HELPER dd if=3D/dev/zero of=3D"$TEST_MNT/ext2_save/image" bs=3D=
1M
>> count=3D1 \
>> +$SUDO_HELPER dd if=3D/dev/zero of=3D"$TEST_MNT/ext2_saved/image" bs=3D=
1M
>> count=3D1 \
>>       &> /dev/null
>=20
> BTW, now we have run_mustfail() function, so we don't need to manually
> check the return value now.

Ah, right.  I'll incorporate this with Lakshmipathi's feedback.

-Jeff

> Thanks,
> Qu
>=20
>>   if [ $? -ne 1 ]; then
>>       echo "after convert ext2_save/image is not read-only"
>> @@ -24,3 +25,4 @@ if [ $? -ne 1 ]; then
>>   fi
>>   run_check_umount_test_dev
>>   convert_test_post_rollback
>> +
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--vwJoDwVapIWE0MtpN0lgPP9am1l1N26FI--

--gt7tq4Wn4RAgMtRmCTvbxX8CEDn7Jo6pH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWX9iah57S2MheeWyAQiH/hAAjqXK7d3Wd4pj5s/HRsOLlGCwXiluyhzw
usvGt8dAT1bx76d2zLpQthgWbqAJzfyYSz8ZkKMcv2hjKjvjcc6Bpf3ZkrO1ssTJ
2RZtMkFCGWCFipT8lkB0M/ApBPMvFqBwEhR6BGejJiLUWlbwntI2Y2aZqak3SkD1
YPgrE+37qECHwnQ617LUor0w98NOc5X3rNiQfM8rXrSUfLVHMpXt0fFoTwyuxY8w
UrpaVy3jt+SJ+szUjUQzJ6wLOmk5LpbZp8Zq5AoBz6o1SOmQShH3ufydVnysFseR
k7eS8Iy9fA/nHCmHfdaGmGxSXVoqpyaCWtrMsRIuArua0/6EDzsrUDTxURHe3GjL
SgNhuC/seTV9Ogt0+8MA3Vkz1RRs/uNb4/WwHjAQDizL6P6y2EFurkRUHjQZqzeE
IVB2psIYfIlFDM5ND4t1wGyfRc7yahubfowbJQeaENbJbVYaYhwcW64fpd/bvFTR
6E6ewBDVZ0En4VDBzGYe4sku4/BEp1D598O+6Whrr0FNmahKssHYxNerKc089fho
xBh+32D4OPtkRnKG3+tJltkE5SfYX9IkwSqORFA5dlBIr5/sbjcED5RqcTRDBebv
UniHmEGNH+0QqztuttGEHjsSWt90LVZf/0W5uGcyXZBldoP3lZpbKcwn8BFOvk4W
q5EptEZlizU=
=T8KX
-----END PGP SIGNATURE-----

--gt7tq4Wn4RAgMtRmCTvbxX8CEDn7Jo6pH--
