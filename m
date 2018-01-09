Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53636 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754495AbeAIAVq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 19:21:46 -0500
Subject: Re: [PATCH 2/2] btrfs-progs: misc-test: Add test case to check if fi
 usage and show report consistent unallocated space
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        adambahe@gmail.com
References: <20180102063315.32382-1-wqu@suse.com>
 <20180102063315.32382-2-wqu@suse.com> <20180108193916.GM13726@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <71de1f27-734d-1024-283d-885cb5de3fdd@gmx.com>
Date: Tue, 9 Jan 2018 08:21:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180108193916.GM13726@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xN1lxt7mRAXwkwS3WGEfLEG5gaOKs7j0s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xN1lxt7mRAXwkwS3WGEfLEG5gaOKs7j0s
Content-Type: multipart/mixed; boundary="TutY4Fot9YBEHu1zbKZ9V5Mj2jGtDOl1S";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 adambahe@gmail.com
Message-ID: <71de1f27-734d-1024-283d-885cb5de3fdd@gmx.com>
Subject: Re: [PATCH 2/2] btrfs-progs: misc-test: Add test case to check if fi
 usage and show report consistent unallocated space
References: <20180102063315.32382-1-wqu@suse.com>
 <20180102063315.32382-2-wqu@suse.com> <20180108193916.GM13726@twin.jikos.cz>
In-Reply-To: <20180108193916.GM13726@twin.jikos.cz>

--TutY4Fot9YBEHu1zbKZ9V5Mj2jGtDOl1S
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8809=E6=97=A5 03:39, David Sterba wrote:
> On Tue, Jan 02, 2018 at 02:33:15PM +0800, Qu Wenruo wrote:
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  tests/misc-tests/028-fi-usage-cross-check/test.sh | 46 ++++++++++++++=
+++++++++
>>  1 file changed, 46 insertions(+)
>>  create mode 100755 tests/misc-tests/028-fi-usage-cross-check/test.sh
>>
>> diff --git a/tests/misc-tests/028-fi-usage-cross-check/test.sh b/tests=
/misc-tests/028-fi-usage-cross-check/test.sh
>> new file mode 100755
>> index 000000000000..bf438b60abf1
>> --- /dev/null
>> +++ b/tests/misc-tests/028-fi-usage-cross-check/test.sh
>> @@ -0,0 +1,46 @@
>> +#!/bin/bash
>> +# check fi-usage is output correct unallocated space for RAID10
>> +
>> +source "$TOP/tests/common"
>> +
>> +check_prereq mkfs.btrfs
>> +check_prereq btrfs
>> +
>> +setup_root_helper
>> +
>> +setup_loopdevs 4
>> +prepare_loopdevs
>> +dev1=3D${loopdevs[1]}
>> +
>> +run_check "$TOP/mkfs.btrfs" -d raid10 -m raid10 -f ${loopdevs[@]}
>> +run_check $SUDO_HELPER mount $dev1 "$TEST_MNT"
>=20
> There's a helper macro for that, run_check_mount_test_dev, that expects=

> the TEST_DEV to be set. I suggest to use this variable instead of dev1,=

> and then the umount command can be replaced by
> run_check_umount_test_dev.
>> +
>> +output_dir=3D$(mktemp -d --tmpdir btrfs-progs-misc.XXXXXXXX)
>=20
> This is not IMO necessary, you get only one line from the fi show outpu=
t
> and check if it's not empty. A simple 'if grep ...' . The output is
> reused so you can store it to a variable.
>=20
>> +
>> +run_check_stdout $SUDO_HELPER "$TOP/btrfs" filesystem show --raw "$TE=
ST_MNT" |\
>> +	grep "$dev1" > "$output_dir/fi_show_output"
>> +if [ ! -s "$output_dir/fi_show_output" ]; then
>> +	_fail "failed to get correct fi show output"
>> +fi
>> +
>> +dev1_total=3D$(cat "$output_dir/fi_show_output" | awk '{print $4}')
>> +dev1_used=3D$(cat "$output_dir/fi_show_output" | awk '{print $6}')
>> +dev1_fi_show_unallocated=3D$(( $dev1_total - $dev1_used))
>> +
>> +run_check_stdout $SUDO_HELPER "$TOP/btrfs" filesystem usage --raw "$T=
EST_MNT" |\
>> +	grep "$dev1" | tail -n1 > "$output_dir/fi_usage_output"
>> +if [ ! -s "$output_dir/fi_usage_output" ]; then
>> +	_fail "failed to get correct fi usage output"
>> +fi
>> +
>> +dev1_fi_usage_unallocated=3D$(cat "$output_dir/fi_usage_output" | awk=
 '{print $2}')
>> +echo "fi usage unallocated for devid1 is $dev1_fi_usage_unallocated" =
>> "$RESULTS"
>> +echo "fi show unallocated for devid1 is $dev1_fi_show_unallocated" >>=
 "$RESULTS"
>> +
>> +if [ $dev1_fi_show_unallocated -ne $dev1_fi_usage_unallocated ]; then=

>> +	_fail "fi usage unallocated mismatch with fi show"
>> +fi
>> +
>> +run_check $SUDO_HELPER umount "$TEST_MNT"
>> +cleanup_loopdevs
>> +rm $output_dir -rf
>=20
> Please quote all arguments, namely if it's passed to 'rm', and options
> should go before arugments.

However the $output_dir won't contain any space or any escaping.

It will always be something like "/tmp/btrfs-progs-misc.1234567", do we
still need to quota something we're sure it's safe?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--TutY4Fot9YBEHu1zbKZ9V5Mj2jGtDOl1S--

--xN1lxt7mRAXwkwS3WGEfLEG5gaOKs7j0s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpUCwkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgPDgf/UyWmivmstwJPZ97UZTQBSt0D
o5fr0X9VLAIQiBw9BrIcmsLYfn4ID/2esrYDKtBpBU+seRmrDMd9A7fSPYG8OVIt
Q4N/aOjGkpvFiGiszHm8wmd/5nPdwayA88orZj22O/xBea2xLa2aNSncHp0e/Zkf
+8UwPqxJ5tOij8BAgYYprkLsSayDrtjCuc3rrAPx8n6lTntZmz2xCNeQO7Wo/WJ8
SNRxcZCtVq8roHQ/kyYJ/FIApWYwWF0jV6fZjNF+NylAIUHRaIstP2lSIUg4YoAw
/x7Xc62It5NK5Jk+NyJe+jSt6A5J/hqA655+RTZK8OAl1sRclBlZmzSO82bC2w==
=MHmj
-----END PGP SIGNATURE-----

--xN1lxt7mRAXwkwS3WGEfLEG5gaOKs7j0s--
