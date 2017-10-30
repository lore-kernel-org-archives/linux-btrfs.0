Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751838AbdJ3AxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 20:53:21 -0400
Subject: Re: [PATCH v3 2/2] btrfs-progs: test/mkfs: Test if the minimal device
 size is valid
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171027005324.17950-1-wqu@suse.com>
 <20171027005324.17950-2-wqu@suse.com> <20171027165924.GN3521@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8fb8d6d8-5a52-05b6-0b69-57cd487da730@gmx.com>
Date: Mon, 30 Oct 2017 08:53:07 +0800
MIME-Version: 1.0
In-Reply-To: <20171027165924.GN3521@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uniqL48VqBTcpRMVpOsmfgSBa6PFXUoCe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uniqL48VqBTcpRMVpOsmfgSBa6PFXUoCe
Content-Type: multipart/mixed; boundary="dupo6XpjRSVWTvQSrjbpLJXkMTnt4ONuI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8fb8d6d8-5a52-05b6-0b69-57cd487da730@gmx.com>
Subject: Re: [PATCH v3 2/2] btrfs-progs: test/mkfs: Test if the minimal device
 size is valid
References: <20171027005324.17950-1-wqu@suse.com>
 <20171027005324.17950-2-wqu@suse.com> <20171027165924.GN3521@twin.jikos.cz>
In-Reply-To: <20171027165924.GN3521@twin.jikos.cz>

--dupo6XpjRSVWTvQSrjbpLJXkMTnt4ONuI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8828=E6=97=A5 00:59, David Sterba wrote:
> On Fri, Oct 27, 2017 at 08:53:24AM +0800, Qu Wenruo wrote:
>> New test case to test if the minimal device size given by "mkfs.btrfs"=

>> failure case is valid.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  tests/mkfs-tests/010-small-image/test.sh | 49 +++++++++++++++++++++++=
+++++++++
>>  1 file changed, 49 insertions(+)
>>  create mode 100755 tests/mkfs-tests/010-small-image/test.sh
>>
>> diff --git a/tests/mkfs-tests/010-small-image/test.sh b/tests/mkfs-tes=
ts/010-small-image/test.sh
>> new file mode 100755
>> index 000000000000..f55760df061f
>> --- /dev/null
>> +++ b/tests/mkfs-tests/010-small-image/test.sh
>> @@ -0,0 +1,49 @@
>> +#!/bin/bash
>> +# test if the reported minimal size of mkfs.btrfs is valid
>> +
>> +source "$TOP"/tests/common
>> +
>> +check_prereq mkfs.btrfs
>> +check_prereq btrfs
>> +
>> +setup_root_helper
>> +
>> +do_test()
>> +{
>> +	# Well, 1M small enough to fail, we just use the output
>> +	# to get the minimal device size
>> +	prepare_test_dev 1M
>> +	output=3D$(run_mustfail_stdout "mkfs.btrfs for small image" \
>> +		 "$TOP"/mkfs.btrfs -f $@ "$TEST_DEV")
>> +	good_size=3D$(echo "$output" | grep -oP "(?<=3Dis )\d+")
>> +
>> +	prepare_test_dev "$good_size"
>> +	run_check "$TOP"/mkfs.btrfs -f $@ "$TEST_DEV"
>> +	run_check $SUDO_HELPER mount "$TEST_DEV" "$TEST_MNT"
>> +	run_check $SUDO_HELPER umount "$TEST_MNT"
>=20
> There are helpers for the default mounts, you can use them to save some=

> typing: run_check_mount_test_dev and run_check_umount_test_dev.
>=20
>> +}
>> +
>> +do_test -n 4k	-m single	-d single
>=20
> I don't seem to get this test to work, it fails with this in the log:

Forgot to mention, the test case is for minimal-device-size fix patchset:=

Enhance minimal device size calculation to fix mkfs failure on small file=


Considering I sent too many patchset recently and most of them have
dependency, should I resend a big patchset to address the dependency?

IIRC the dependency should be:
rootdir rework -> rootdir refactor -> minimal device size fix (including
test cases)

And later mkfs qgroup support also depends on rootdir rework (just
conflicts, not code dependency)

Thanks,
Qu
>=20
> =3D=3D=3D Entering btrfs-progs/tests/mkfs-tests/010-small-image
> $TEST_DEV not given, use btrfs-progs/test/test.img as fallback
> ############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d single btr=
fs-progs/tests/test.img
> btrfs-progs v4.13.3-61-g0615ffa351c2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> failed (expected): btrfs-progs/mkfs.btrfs -f -n 4k -m single -d single =
btrfs-progs/tests/test.img
> ############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d single btr=
fs-progs/tests/test.img
> btrfs-progs v4.13.3-61-g0615ffa351c2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Label:              (null)
> UUID:               b9b55b1b-4096-46ee-acd0-15151a8050d6
> Node size:          4096
> Sector size:        4096
> Filesystem size:    16.00MiB
> Block group profiles:
>   Data:             single            1.56MiB
>   Metadata:         single            1.56MiB
>   System:           single            4.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1    16.00MiB  btrfs-progs/tests/test.img
>=20
> ############### root_helper mount btrfs-progs/tests/test.img btrfs-prog=
s/tests/mnt
> ############### root_helper umount btrfs-progs/tests/mnt
> ############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btrfs-=
progs/tests/test.img
> btrfs-progs v4.13.3-61-g0615ffa351c2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> failed (expected): btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btr=
fs-progs/tests/test.img
> ############### btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btrfs-=
progs/tests/test.img
> ERROR: not enough free space to allocate chunk
> btrfs-progs v4.13.3-61-g0615ffa351c2
> See http://btrfs.wiki.kernel.org for more information.
>=20
> failed: btrfs-progs/mkfs.btrfs -f -n 4k -m single -d dup btrfs-progs/te=
sts/test.img
> test failed for case 010-small-image
> ---
>=20
> The output is unexpected and does not contain the minimal size. The tes=
ted
> branch is current devel (7141063af3c9a423dda), your mkfs --rootdir rewo=
rk
> patches are there. Can you please have a look?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--dupo6XpjRSVWTvQSrjbpLJXkMTnt4ONuI--

--uniqL48VqBTcpRMVpOsmfgSBa6PFXUoCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln2d/MXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qilUgf/Z6SamTCr0TJHRLsEeIb8PUqm
1d+LGUcWaeNQExcixfNr9mrKxFS5G2zUUDlbAXlnvy6mhMCbrlgKZNqQDOl0+6xG
kwIgjFSM459BGEjE7BqsVQ8H0L7bZQcXbFcUMpSAQeUIx0Vu4/GO/hk72WUoZeG4
SJpyenOYUQ7XEGroDpe1qMlXFE71Nf9eN1uH9DiDiIJDPShctQuHcpYJkZjsP5T4
FSk44Tooz3prEePhsw96Hv4hsZA8uC5IZCESjhQBYVCCYm868qeXtyHjg37pDbNm
170AQN9pbuvWmybwrprLemTPmnWyEWm7H7OIl9Ve2MEI/tsA93qKGc4qQiIMRw==
=6ZD2
-----END PGP SIGNATURE-----

--uniqL48VqBTcpRMVpOsmfgSBa6PFXUoCe--
