Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752035AbdLEMNo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 07:13:44 -0500
Subject: Re: [PATCH 6/7] btrfs-progs: Add test for super block recovery
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-7-git-send-email-nborisov@suse.com>
 <ea75633b-10e7-28e0-ae47-5502901599de@gmx.com>
 <2bff48d1-09fa-59ae-7f1f-f4a91b9bf143@suse.com>
 <eb446973-c5c8-8d69-c5bc-c84fe136c5d8@gmx.com>
 <666447ad-8bab-2a13-3304-7b477c7cdde6@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <703b16dc-dda1-1492-d75c-7e125c31ae36@gmx.com>
Date: Tue, 5 Dec 2017 20:13:36 +0800
MIME-Version: 1.0
In-Reply-To: <666447ad-8bab-2a13-3304-7b477c7cdde6@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4jR9rASe4xSUPE8Qpo74glwpLf9pbIA5o"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4jR9rASe4xSUPE8Qpo74glwpLf9pbIA5o
Content-Type: multipart/mixed; boundary="Xl1Phq1TORSHCf8b6LIw5meLKP4qqqBwm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <703b16dc-dda1-1492-d75c-7e125c31ae36@gmx.com>
Subject: Re: [PATCH 6/7] btrfs-progs: Add test for super block recovery
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-7-git-send-email-nborisov@suse.com>
 <ea75633b-10e7-28e0-ae47-5502901599de@gmx.com>
 <2bff48d1-09fa-59ae-7f1f-f4a91b9bf143@suse.com>
 <eb446973-c5c8-8d69-c5bc-c84fe136c5d8@gmx.com>
 <666447ad-8bab-2a13-3304-7b477c7cdde6@suse.com>
In-Reply-To: <666447ad-8bab-2a13-3304-7b477c7cdde6@suse.com>

--Xl1Phq1TORSHCf8b6LIw5meLKP4qqqBwm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 19:26, Nikolay Borisov wrote:
>=20
>=20
> On  5.12.2017 13:12, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 18:04, Nikolay Borisov wrote:
>>>
>>>
>>> On  5.12.2017 11:33, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:=

>>>>> This functionality regressed some time ago and it was never caught.=
 Seems no
>>>>> one complained of that, but to be sure add a regression test to pre=
vent future=20
>>>>> regressions.
>>>>>
>>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>>
>>>> One nitpick for the patch sequence, normally we put fix before test
>>>> case, to avoid breaking bisect.
>>>>
>>>>> ---
>>>>>  tests/fsck-tests/029-superblock-recovery/test.sh | 64 ++++++++++++=
++++++++++++
>>>>>  1 file changed, 64 insertions(+)
>>>>>  create mode 100755 tests/fsck-tests/029-superblock-recovery/test.s=
h
>>>>>
>>>>> diff --git a/tests/fsck-tests/029-superblock-recovery/test.sh b/tes=
ts/fsck-tests/029-superblock-recovery/test.sh
>>>>> new file mode 100755
>>>>> index 000000000000..beb78d6ccc22
>>>>> --- /dev/null
>>>>> +++ b/tests/fsck-tests/029-superblock-recovery/test.sh
>>>>> @@ -0,0 +1,64 @@
>>>>> +#!/bin/bash
>>>>> +# Test that any superblock is correctly detected
>>>>> +# and fixed by btrfs rescue
>>>>> +
>>>>> +source "$TOP/tests/common"
>>>>> +
>>>>> +check_prereq btrfs
>>>>> +check_prereq mkfs.btrfs
>>>>> +check_prereq btrfs-select-super
>>>>> +
>>>>> +setup_root_helper
>>>>> +
>>>>> +rm -f dev1
>>>>> +run_check truncate -s 260G dev1
>>>>> +loop=3D$(run_check_stdout $SUDO_HELPER losetup --find --show dev1)=

>>>>
>>>> We have function to do it already.
>>>> prepare_test_dev will use loopback device as fallback if $TEST_DEV i=
s
>>>> not specified.
>>>> Tt can handle size well, and it also uses sparse file so no need to
>>>> worry about disk usage.
>>>
>>> Then the test suite is not very consistent, since I copied this loopb=
ack
>>> handling from some other test.
>>
>> The same feeling when I am pointed that something can be replaced by
>> wrappers in fstests.
>>
>> Some of them can be cleaned up later.
>>
>>>
>>>>
>>>>> +
>>>>> +# Create the test file system.
>>>>> +run_check $SUDO_HELPER "$TOP"/mkfs.btrfs -f "$loop"
>>>>> +
>>>>> +function check_corruption {
>>>>> +	local sb_offset=3D$1
>>>>> +	local source_sb=3D$2
>>>>> +
>>>>> +
>>>>> +	# First we ensure we can mount it successfully
>>>>> +	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
>>>>> +	run_check $SUDO_HELPER umount "$TEST_MNT"
>>>>> +
>>>>> +	# Now corrupt 1k of the superblock at sb_offset
>>>>> +	run_check $SUDO_HELPER dd bs=3D1K count=3D1 seek=3D$(($sb_offset =
+ 1)) if=3D/dev/zero of=3D"$loop"
>>>>> +
>>>>> +	#if corrupting one of the sb copies, copy it over the initial sup=
erblock
>>>>> +	if [ ! -z $source_sb ]; then
>>>>> +		local shift_val=3D$((16 << $source_sb * 12 ))
>>>>> +		run_check $SUDO_HELPER dd bs=3D1K count=3D4 seek=3D64 skip=3D$sh=
ift_val if=3D"$loop" of=3D"$loop"
>>>>> +	fi
>>>>
>>>> Personally speaking, corrupt 64K (1st super) then corrupt the desire=
d
>>>> copy could make the function easier.
>>>> Although we need to split the check part from this function, resulti=
ng
>>>> something like:
>>>>
>>>> corrupt_super 64k
>>>> corrupt_super 64m
>>>> check_super_recover
>>> I'm reluctant to change this function any more.  It has comments on a=
ll
>>> logical steps and is self-contained and I'd rather keep it that way.
>>>
>>>>
>>>>> +
>>>>> +	run_mustfail "Mounted fs with corrupted superblock" \
>>>>> +		$SUDO_HELPER mount $loop "$TEST_MNT"
>>>>> +
>>>>> +	# Now run btrfs rescue which should fix the superblock. It uses 2=

>>>>> +	# to signal success of recovery use mayfail to ignore that retval=

>>>>> +	# but still log the output of the command
>>>>> +	run_mayfail $SUDO_HELPER "$TOP"/btrfs rescue super-recover -yv "$=
loop"
>>>>> +	if [ $? !=3D 2 ]; then
>>>>> +		_fail "couldn't rescue super"
>>>>> +	fi
>>>>
>>>> It's understandable to have return value other than 0 to distinguish=

>>>> health fs from repairable fs.
>>>> But at least let's also put this into man page.
>>>
>>> Yeah, tell me about it, super recovery actually has 5 return values:
>>>
>>> 7985fe64e0e2 ("Btrfs-progs: add super-recover to recover bad supers")=

>>>
>>>     There will be five kinds of return values:
>>>
>>>     0: all supers are valid, no need to recover
>>>     1: usage or syntax error
>>>     2: recover all bad superblocks successfully
>>>     3: fail to recover bad superblocks
>>>     4: abort to recover bad superblocks
>>
>> Since we all agree that the return value is a messy,
>> maybe we could just simplify it to 0 (all valid or successful recover)=

>> and 1 (the rest)?
>=20
> I have no objection, but it's out of the scope of the current series.

Yep, could be done as another patchset.

Thanks,
Qu
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> +
>>>>> +	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
>>>>> +	run_check $SUDO_HELPER umount "$TEST_MNT"
>>>>> +}
>>>>> +
>>>>> +_log "Corrupting first superblock"
>>>>> +check_corruption 64
>>>>> +
>>>>> +_log "Corrupting second superblock"
>>>>> +check_corruption 65536 1
>>>>> +
>>>>> +_log "Corrupting third superblock"
>>>>> +check_corruption 268435456 2
>>>>> +
>>>>> +# Cleanup
>>>>> +run_check $SUDO_HELPER losetup -d "$loop"
>>>>> +rm -f dev1
>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Xl1Phq1TORSHCf8b6LIw5meLKP4qqqBwm--

--4jR9rASe4xSUPE8Qpo74glwpLf9pbIA5o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomjXAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj8Fwf/UZV4Aeh8LLVfRqJpyzTDhVU5
KUxL4+pq0uXrTXG1Xz1Vw91igGcW3IfIahAYriVxCcILYA/6L7LmcQ4XvWmGYyC3
ZfvJtf5SZkT5Zze9Ad/aXetpY7S30q+KGcptS74icBiWhnHtJJB73ZWSLSNN8/fX
LBgYBDDu2TOrCOUd9Xo6oC2jqkqAnXZGZ4WTlRRdCoymhR87udrRUwzvdo6oU4RO
UjNmyP5xNh9kQ5lrWSqq3YwK3KMBeOn+oLE+mKuCT3bcDP38yNTvbzihI3mGsmEU
LQIyV1UfE2OCvAopkAUaUDFs1xZZQjLPAk9punVv1wl4V9CFJhfXo5F4Km7qVQ==
=dEJI
-----END PGP SIGNATURE-----

--4jR9rASe4xSUPE8Qpo74glwpLf9pbIA5o--
