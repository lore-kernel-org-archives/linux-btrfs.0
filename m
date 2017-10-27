Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63969 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751489AbdJ0A0y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 20:26:54 -0400
Subject: Re: [PATCH v2 3/3] btrfs-progs: test/mkfs: Test if the minimal device
 size is valid
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171016082258.27815-1-wqu@suse.com>
 <20171016082258.27815-3-wqu@suse.com> <20171026174523.GC3521@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8645a71d-f164-febb-cc39-233879d10c41@gmx.com>
Date: Fri, 27 Oct 2017 08:26:38 +0800
MIME-Version: 1.0
In-Reply-To: <20171026174523.GC3521@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wEHWeBEqioTaAovlV7uDX4xvldaDSQhQ4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wEHWeBEqioTaAovlV7uDX4xvldaDSQhQ4
Content-Type: multipart/mixed; boundary="ecU1CvSEqpb5VCGS6Ml7E9NIeg1pgugRt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8645a71d-f164-febb-cc39-233879d10c41@gmx.com>
Subject: Re: [PATCH v2 3/3] btrfs-progs: test/mkfs: Test if the minimal device
 size is valid
References: <20171016082258.27815-1-wqu@suse.com>
 <20171016082258.27815-3-wqu@suse.com> <20171026174523.GC3521@twin.jikos.cz>
In-Reply-To: <20171026174523.GC3521@twin.jikos.cz>

--ecU1CvSEqpb5VCGS6Ml7E9NIeg1pgugRt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8827=E6=97=A5 01:45, David Sterba wrote:
> On Mon, Oct 16, 2017 at 04:22:58PM +0800, Qu Wenruo wrote:
>> New test case to test if the minimal device size given by "mkfs.btrfs"=

>> failure case is valid.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> v2:
>>   Nothing
>> ---
>>  tests/common                             | 57 +++++++++++++++++++++++=
++++++++-
>=20
> Please split this change from the patch.

I'll split and resend the patches after split.

However, as I mentioned in latest mkfs --rootdir rework patchset set,
all my later patches more or less relies on them.

Since some of the patches are merged into devel, should I rebase the
incoming patches?
Or just leave them as is?

Thanks,
Qu
>=20
>>  tests/mkfs-tests/010-small-image/test.sh | 51 +++++++++++++++++++++++=
+++++
>>  2 files changed, 107 insertions(+), 1 deletion(-)
>>  create mode 100755 tests/mkfs-tests/010-small-image/test.sh
>>
>> diff --git a/tests/common b/tests/common
>> index eb525a4d02c5..e026cc2f4d30 100644
>> --- a/tests/common
>> +++ b/tests/common
>> @@ -236,6 +236,57 @@ run_mustfail()
>>  	fi
>>  }
>> =20
>> +run_mustfail_stdout()
>> +{
>> +	local spec
>> +	local ins
>> +	local cmd
>> +	local msg
>> +	local ret
>> +
>> +	# We don't use pipefail to avoid disturbing other script, so here we=

>> +	# use temporary output file.
>> +	# So it doesn't support pipeline in the @cmd
>=20
> This would be good as the function comment, plus the 1st argument
> requirement, simlar to run_mustfail.
>=20
>> +	local tmp_output
>> +
>> +	tmp_output=3D$(mktemp --tmpdir btrfs-progs-test--mustfail-stdtout.XX=
XXXX)
>> +
>> +	msg=3D"$1"
>> +	shift
>> +
>> +	if _is_file_or_command "$msg"; then
>> +		echo "ASSERTION FAIL: 1st argument of run_mustfail_stdout must be a=
 message"
>> +		exit 1
>> +	fi
>> +
>> +	ins=3D$(_get_spec_ins "$@")
>> +	spec=3D$(($ins-1))
>> +	cmd=3D$(eval echo "\${$spec}")
>> +	spec=3D$(_cmd_spec "${@:$spec}")
>> +	set -- "${@:1:$(($ins-1))}" $spec "${@: $ins}"
>> +	echo "############### $@" >> "$RESULTS" 2>&1
>> +	if [[ $TEST_LOG =3D~ tty ]]; then echo "CMD(mustfail): $@" > /dev/tt=
y; fi
>> +	if [ "$1" =3D 'root_helper' ]; then
>> +		"$@" 2>&1 > "$tmp_output"
>> +	else
>> +		$INSTRUMENT "$@" 2>&1 > "$tmp_output"
>> +	fi
>> +	ret=3D$?
>> +
>> +	cat "$tmp_output" >> "$RESULTS"
>> +	cat "$tmp_output"
>> +	rm "$tmp_output"
>> +
>> +	if [ "$ret" !=3D 0 ]; then
>> +		echo "failed (expected): $@" >> "$RESULTS"
>> +		return 0
>> +	else
>> +		echo "succeeded (unexpected!): $@" >> "$RESULTS"
>> +		_fail "unexpected success: $msg"
>> +		return 1
>> +	fi
>> +}
>> +
>>  check_prereq()
>>  {
>>  	if ! [ -f "$TOP/$1" ]; then
>> @@ -389,7 +440,11 @@ prepare_test_dev()
>>  	# num[K/M/G/T...]
>>  	local size=3D"$1"
>> =20
>> -	[[ "$TEST_DEV" ]] && return
>> +	# Still truncate it to new size
>> +	if [[ "$TEST_DEV" ]]; then
>> +		truncate -s "$size" "$TEST_DEV"
>=20
> You use $size before it gets checked that's not empty a few lines below=
=2E
>=20
>> +		return;
>> +	fi
>>  	[[ "$size" ]] || size=3D'2G'
>> =20
>>  	echo "\$TEST_DEV not given, use $TOP/test/test.img as fallback" >> \=

>> diff --git a/tests/mkfs-tests/010-small-image/test.sh b/tests/mkfs-tes=
ts/010-small-image/test.sh
>> new file mode 100755
>> index 000000000000..2ed379f9b66f
>> --- /dev/null
>> +++ b/tests/mkfs-tests/010-small-image/test.sh
>> @@ -0,0 +1,51 @@
>> +#!/bin/bash
>> +# test if the reported minimal size of mkfs.btrfs is valid
>> +
>> +source $TOP/tests/common
>> +
>> +check_prereq mkfs.btrfs
>> +check_prereq btrfs
>> +
>> +setup_root_helper
>> +
>> +pagesize=3D$(getconf PAGESIZE)
>=20
> Not used?
>=20
>> +
>> +do_test()
>> +{
>> +	# Well, 1M small enough to fail, we just use the output
>> +	# to get the minimal device size
>> +	prepare_test_dev 1M
>> +	output=3D$(run_mustfail_stdout "mkfs.btrfs for small image" \
>> +		 $TOP/mkfs.btrfs -f $@ "$TEST_DEV")
>> +	good_size=3D$(echo $output | grep -oP "(?<=3Dis )\d+")
>> +
>> +	prepare_test_dev "$good_size"
>> +	run_check $TOP/mkfs.btrfs -f $@ "$TEST_DEV"
>> +	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
>> +	run_check $SUDO_HELPER umount $TEST_MNT
>=20
> Please add quotes around all variables that could come from an external=

> source (TEST_MNT, TEST_DEV, TOP).
>=20
>> +}
>> +
>> +do_test -n 4k	-m single	-d single
>> +do_test -n 4k	-m single	-d dup
>> +do_test -n 4k	-m dup		-d single
>> +do_test -n 4k	-m dup		-d dup
>> +
>> +do_test -n 8k	-m single	-d single
>> +do_test -n 8k	-m single	-d dup
>> +do_test -n 8k	-m dup		-d single
>> +do_test -n 8k	-m dup		-d dup
>> +
>> +do_test -n 16k	-m single	-d single
>> +do_test -n 16k	-m single	-d dup
>> +do_test -n 16k	-m dup		-d single
>> +do_test -n 16k	-m dup		-d dup
>> +
>> +do_test -n 32k	-m single	-d single
>> +do_test -n 32k	-m single	-d dup
>> +do_test -n 32k	-m dup		-d single
>> +do_test -n 32k	-m dup		-d dup
>> +
>> +do_test -n 64k	-m single	-d single
>> +do_test -n 64k	-m single	-d dup
>> +do_test -n 64k	-m dup		-d single
>> +do_test -n 64k	-m dup		-d dup
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ecU1CvSEqpb5VCGS6Ml7E9NIeg1pgugRt--

--wEHWeBEqioTaAovlV7uDX4xvldaDSQhQ4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnyfT4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjQ4wgAsL+FSYrHpl4bykE75Dy+RhXG
RR0qPEoFwmtPKwHRUCA7P2KPWJz93uY0/kHxM8lKNM70/zW31ueW2WcpBhsESNfY
Hg8rF0tOvgEairT9aEmcKjZN9eIaLs+9+5L8ZQny+WLa+X5kXqGyyRqM4rNzyoCF
RhYJdpkXctz16eiXScI3nDaNOd9DnRINDxFGNYcNdtXwpaja36ECfgPTWoxs+t/z
/gh3S2uPv/aLl1qJqFqTz7r1tiAqFyo62qMSm7RUbiaTFuBI8430KOl8qeR+4eHt
GPMEbQMnDwvYhlcIUH82mfxo0Wt7qMmDRPQAe0fUnrobjFWVY0Yepcp1ddvrBg==
=8+QF
-----END PGP SIGNATURE-----

--wEHWeBEqioTaAovlV7uDX4xvldaDSQhQ4--
