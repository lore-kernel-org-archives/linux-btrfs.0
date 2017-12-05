Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53076 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbdLELMS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 06:12:18 -0500
Subject: Re: [PATCH 6/7] btrfs-progs: Add test for super block recovery
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-7-git-send-email-nborisov@suse.com>
 <ea75633b-10e7-28e0-ae47-5502901599de@gmx.com>
 <2bff48d1-09fa-59ae-7f1f-f4a91b9bf143@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <eb446973-c5c8-8d69-c5bc-c84fe136c5d8@gmx.com>
Date: Tue, 5 Dec 2017 19:12:09 +0800
MIME-Version: 1.0
In-Reply-To: <2bff48d1-09fa-59ae-7f1f-f4a91b9bf143@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XOVvBG26J5DDGF6r2G7jkFkO2K1QW6di3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XOVvBG26J5DDGF6r2G7jkFkO2K1QW6di3
Content-Type: multipart/mixed; boundary="Wev2lnOawDONko43vlj6SPHoTUnW9Q4Mb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <eb446973-c5c8-8d69-c5bc-c84fe136c5d8@gmx.com>
Subject: Re: [PATCH 6/7] btrfs-progs: Add test for super block recovery
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-7-git-send-email-nborisov@suse.com>
 <ea75633b-10e7-28e0-ae47-5502901599de@gmx.com>
 <2bff48d1-09fa-59ae-7f1f-f4a91b9bf143@suse.com>
In-Reply-To: <2bff48d1-09fa-59ae-7f1f-f4a91b9bf143@suse.com>

--Wev2lnOawDONko43vlj6SPHoTUnW9Q4Mb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 18:04, Nikolay Borisov wrote:
>=20
>=20
> On  5.12.2017 11:33, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
>>> This functionality regressed some time ago and it was never caught. S=
eems no
>>> one complained of that, but to be sure add a regression test to preve=
nt future=20
>>> regressions.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>
>> One nitpick for the patch sequence, normally we put fix before test
>> case, to avoid breaking bisect.
>>
>>> ---
>>>  tests/fsck-tests/029-superblock-recovery/test.sh | 64 ++++++++++++++=
++++++++++
>>>  1 file changed, 64 insertions(+)
>>>  create mode 100755 tests/fsck-tests/029-superblock-recovery/test.sh
>>>
>>> diff --git a/tests/fsck-tests/029-superblock-recovery/test.sh b/tests=
/fsck-tests/029-superblock-recovery/test.sh
>>> new file mode 100755
>>> index 000000000000..beb78d6ccc22
>>> --- /dev/null
>>> +++ b/tests/fsck-tests/029-superblock-recovery/test.sh
>>> @@ -0,0 +1,64 @@
>>> +#!/bin/bash
>>> +# Test that any superblock is correctly detected
>>> +# and fixed by btrfs rescue
>>> +
>>> +source "$TOP/tests/common"
>>> +
>>> +check_prereq btrfs
>>> +check_prereq mkfs.btrfs
>>> +check_prereq btrfs-select-super
>>> +
>>> +setup_root_helper
>>> +
>>> +rm -f dev1
>>> +run_check truncate -s 260G dev1
>>> +loop=3D$(run_check_stdout $SUDO_HELPER losetup --find --show dev1)
>>
>> We have function to do it already.
>> prepare_test_dev will use loopback device as fallback if $TEST_DEV is
>> not specified.
>> Tt can handle size well, and it also uses sparse file so no need to
>> worry about disk usage.
>=20
> Then the test suite is not very consistent, since I copied this loopbac=
k
> handling from some other test.

The same feeling when I am pointed that something can be replaced by
wrappers in fstests.

Some of them can be cleaned up later.

>=20
>>
>>> +
>>> +# Create the test file system.
>>> +run_check $SUDO_HELPER "$TOP"/mkfs.btrfs -f "$loop"
>>> +
>>> +function check_corruption {
>>> +	local sb_offset=3D$1
>>> +	local source_sb=3D$2
>>> +
>>> +
>>> +	# First we ensure we can mount it successfully
>>> +	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
>>> +	run_check $SUDO_HELPER umount "$TEST_MNT"
>>> +
>>> +	# Now corrupt 1k of the superblock at sb_offset
>>> +	run_check $SUDO_HELPER dd bs=3D1K count=3D1 seek=3D$(($sb_offset + =
1)) if=3D/dev/zero of=3D"$loop"
>>> +
>>> +	#if corrupting one of the sb copies, copy it over the initial super=
block
>>> +	if [ ! -z $source_sb ]; then
>>> +		local shift_val=3D$((16 << $source_sb * 12 ))
>>> +		run_check $SUDO_HELPER dd bs=3D1K count=3D4 seek=3D64 skip=3D$shif=
t_val if=3D"$loop" of=3D"$loop"
>>> +	fi
>>
>> Personally speaking, corrupt 64K (1st super) then corrupt the desired
>> copy could make the function easier.
>> Although we need to split the check part from this function, resulting=

>> something like:
>>
>> corrupt_super 64k
>> corrupt_super 64m
>> check_super_recover
> I'm reluctant to change this function any more.  It has comments on all=

> logical steps and is self-contained and I'd rather keep it that way.
>=20
>>
>>> +
>>> +	run_mustfail "Mounted fs with corrupted superblock" \
>>> +		$SUDO_HELPER mount $loop "$TEST_MNT"
>>> +
>>> +	# Now run btrfs rescue which should fix the superblock. It uses 2
>>> +	# to signal success of recovery use mayfail to ignore that retval
>>> +	# but still log the output of the command
>>> +	run_mayfail $SUDO_HELPER "$TOP"/btrfs rescue super-recover -yv "$lo=
op"
>>> +	if [ $? !=3D 2 ]; then
>>> +		_fail "couldn't rescue super"
>>> +	fi
>>
>> It's understandable to have return value other than 0 to distinguish
>> health fs from repairable fs.
>> But at least let's also put this into man page.
>=20
> Yeah, tell me about it, super recovery actually has 5 return values:
>=20
> 7985fe64e0e2 ("Btrfs-progs: add super-recover to recover bad supers")
>=20
>     There will be five kinds of return values:
>=20
>     0: all supers are valid, no need to recover
>     1: usage or syntax error
>     2: recover all bad superblocks successfully
>     3: fail to recover bad superblocks
>     4: abort to recover bad superblocks

Since we all agree that the return value is a messy,
maybe we could just simplify it to 0 (all valid or successful recover)
and 1 (the rest)?

Thanks,
Qu

>=20
>=20
>>
>> Thanks,
>> Qu
>>
>>> +
>>> +	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
>>> +	run_check $SUDO_HELPER umount "$TEST_MNT"
>>> +}
>>> +
>>> +_log "Corrupting first superblock"
>>> +check_corruption 64
>>> +
>>> +_log "Corrupting second superblock"
>>> +check_corruption 65536 1
>>> +
>>> +_log "Corrupting third superblock"
>>> +check_corruption 268435456 2
>>> +
>>> +# Cleanup
>>> +run_check $SUDO_HELPER losetup -d "$loop"
>>> +rm -f dev1
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Wev2lnOawDONko43vlj6SPHoTUnW9Q4Mb--

--XOVvBG26J5DDGF6r2G7jkFkO2K1QW6di3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomfwoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qinXgf/UGzAuEdKLHleugZh7GNhc3s1
yg9rwpmi/QZ4g/qbRBbIR85F6NC0QO+MLbEifS6w6BQOCcybWIgw2EvJ6J+gWM2H
ioq2pGGHejh4bF0zkMzN1nLn1P4H1ipriKz/ioMI0uarz4NST7K0O5CrVzzE1o/Z
vW9HF1M+QD3mCcCoarGGN+ejsg82S8Ek6E+3zLQrPdfq0NOdvpVDfyewpPnZyEze
9Ol0lue6HTcMK0pPe5Q5dsDGI2b42LWdl+2v3ePsKfaTPVQQYSkpeufRT4KtVXEX
STCfNoIegF/1ZsHJ0MgRfsYhwarA9f4/10P6Vwq53z9LLDCc6ke0uXqC69V74w==
=/HpX
-----END PGP SIGNATURE-----

--XOVvBG26J5DDGF6r2G7jkFkO2K1QW6di3--
