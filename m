Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751167AbdJ0X7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 19:59:37 -0400
Subject: Re: [PATCH v3 2/2] btrfs-progs: test/mkfs: Test if the minimal device
 size is valid
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20171027005324.17950-1-wqu@suse.com>
 <20171027005324.17950-2-wqu@suse.com> <20171027165924.GN3521@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <40efeff0-a317-b7a6-cb24-78c62e6c8438@gmx.com>
Date: Sat, 28 Oct 2017 07:59:23 +0800
MIME-Version: 1.0
In-Reply-To: <20171027165924.GN3521@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PpffDvUKpWf96sBltgWKS1ntPEG1XW8cv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PpffDvUKpWf96sBltgWKS1ntPEG1XW8cv
Content-Type: multipart/mixed; boundary="9kKeAArshhlwIpnfOFqTRPpi0VEcUtqgU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <40efeff0-a317-b7a6-cb24-78c62e6c8438@gmx.com>
Subject: Re: [PATCH v3 2/2] btrfs-progs: test/mkfs: Test if the minimal device
 size is valid
References: <20171027005324.17950-1-wqu@suse.com>
 <20171027005324.17950-2-wqu@suse.com> <20171027165924.GN3521@twin.jikos.cz>
In-Reply-To: <20171027165924.GN3521@twin.jikos.cz>

--9kKeAArshhlwIpnfOFqTRPpi0VEcUtqgU
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

Strange, it passed without problem on my box.

=3D=3D=3D Entering /home/adam/btrfs/btrfs-progs/tests/mkfs-tests/010-smal=
l-image
$TEST_DEV not given, use /home/adam/btrfs/btrfs-progs/test/test.img as
fallback
############### /home/adam/btrfs/btrfs-progs/mkfs.btrfs -f -n 4k -m
single -d single /home/adam/btrfs/btrfs-progs/tests/test.img
btrfs-progs v4.13.2
See http://btrfs.wiki.kernel.org for more information.

failed (expected): /home/adam/btrfs/btrfs-progs/mkfs.btrfs -f -n 4k -m
single -d single /home/adam/btrfs/btrfs-progs/tests/test.img
############### /home/adam/btrfs/btrfs-progs/mkfs.btrfs -f -n 4k -m
single -d single /home/adam/btrfs/btrfs-progs/tests/test.img
btrfs-progs v4.13.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               04213076-9678-420b-b748-5e5b6394e025
Node size:          4096
Sector size:        4096
Filesystem size:    44.00MiB
Block group profiles:
  Data:             single            4.38MiB
  Metadata:         single            4.38MiB
  System:           single            4.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    44.00MiB  /home/adam/btrfs/btrfs-progs/tests/test.img

############### root_helper mount
/home/adam/btrfs/btrfs-progs/tests/test.img
/home/adam/btrfs/btrfs-progs/tests/mnt
############### root_helper umount /home/adam/btrfs/btrfs-progs/tests/mnt=

############### /home/adam/btrfs/btrfs-progs/mkfs.btrfs -f -n 4k -m
single -d dup /home/adam/btrfs/btrfs-progs/tests/test.img
btrfs-progs v4.13.2
See http://btrfs.wiki.kernel.org for more information.

failed (expected): /home/adam/btrfs/btrfs-progs/mkfs.btrfs -f -n 4k -m
single -d dup /home/adam/btrfs/btrfs-progs/tests/test.img
############### /home/adam/btrfs/btrfs-progs/mkfs.btrfs -f -n 4k -m
single -d dup /home/adam/btrfs/btrfs-progs/tests/test.img
btrfs-progs v4.13.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               f7c3a0db-abf1-4061-99f0-1028ac713ed6
Node size:          4096
Sector size:        4096
Filesystem size:    164.00MiB
Block group profiles:
  Data:             DUP              64.00MiB
  Metadata:         single            8.00MiB
  System:           single            4.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   164.00MiB  /home/adam/btrfs/btrfs-progs/tests/test.img

############### root_helper mount
/home/adam/btrfs/btrfs-progs/tests/test.img
/home/adam/btrfs/btrfs-progs/tests/mnt
############### root_helper umount /home/adam/btrfs/btrfs-progs/tests/mnt=



Maybe it's related to the preparation patch for that?
Like the prepare_test_dev() function modification?

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


--9kKeAArshhlwIpnfOFqTRPpi0VEcUtqgU--

--PpffDvUKpWf96sBltgWKS1ntPEG1XW8cv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnzyFsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi2TQgAgTsqWlKjrcmxfEKjF0w/0eIC
IE5X9kyad5RgURQl3pF1je9kC6FoB0CPMZO10bn6v7B/PMRyNOO7SgJRwoBQVMJa
HxOvP3SVcUFQkyW4pr8uHsRpJWgEX7xzCLsr1kJ6lE6KqE+KECJLIiwDG5oeeNCD
Fe+FQhTxTXYONb5QflbuD7pKkfNeFs/WV8lNAUxWjuLcW5hDY6cVWuGI9tYxBJKr
o+0pZrlq+8wr9LZXbhTjbJcbY+azXKAcXdini8TbhoquCb1aA6dxdUbJkfdiTlJH
hq3QRy2zHF/2T0DU6L1L5K3tMkEEIB/AQalMzH+YX50u3s75e42mI0wBJNJqXA==
=Krgb
-----END PGP SIGNATURE-----

--PpffDvUKpWf96sBltgWKS1ntPEG1XW8cv--
