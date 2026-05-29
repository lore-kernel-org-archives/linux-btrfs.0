Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555202853E9;
	Fri, 29 May 2026 01:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780018003; cv=none; b=W5/QNzbhFjAhOkwCQZ+Rg8cvP22n9sR2O2YniiorE2fQH/RYLD+NFmBalVt5kjtgdZVWwIUzYifmcE9stYkS2J22La26TwLY1XcwIJHRjPon2psXKf8ujssWJ0G3EmoHIkg+HfJ4j5PaHEBXnTeNboNidtXjVXHsnNTPBMNRdUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780018003; c=relaxed/simple;
	bh=HphU8nE3hWRqHpOYDIGtuW7wyU2aeWexc3kwcEIqDaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ent6xHFK7MrrUWmerFvt+StmFiNOGQQoZ3wLZn6XE2fI9j2fPxc9GHWefXt5G+eNuKkBJ2qgK+Ao3uqe5rNddhmvyREnK4UjWnqcyrBX0+PFmZWLZ1LvmwgLzrLfBAIZdX1KjCA6SfXvVBiOVsoIxDMUpFjeettEIImGMO36Gi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=XlDPSpbP; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="XlDPSpbP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780017999; x=1780622799; i=quwenruo.btrfs@gmx.com;
	bh=0G0xBvih8s3KbYbZB1xq2QprsuCQzFITGnpgmhI/Itk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=XlDPSpbPrUjBFw4NhcAdUzY/B3QtXRaTkgsFfi6cgTbfvbXG4Pl1bXYAye9cyrv5
	 P74G68WQBDlkR4pao4i/LuMLF1qlUTPiNlYk2ZCQDOVB59aH/tLcEU1NSFNjmrcam
	 8T+VSiek2sbEa1Y4jo++Scly3VlldV2mfdu3CIisZaVFnCNQehcxgOSW4EMIwJZ6l
	 /jAY+jQOJR1CsVJx6kTBzJZeqwsrcU39Yx5VtXSmnkDep3oVd9yyfv3hzOUoC0zYv
	 2+fuRtzUz3UPGPG6vgIexn0IsqRySTNXdLT4lyrMeF56OCiQ5FbfByaZwekaUeuQT
	 TmrTlSB7wFPYWTtM6Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MWAOQ-1wn1c508UM-00PbQx; Fri, 29
 May 2026 03:26:39 +0200
Message-ID: <cbb78d27-b17b-4995-b08a-a14bebea2af9@gmx.com>
Date: Fri, 29 May 2026 10:56:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic: add a test case for writes with prealloc extents
 beyond i_size
To: asj@kernel.org, Filipe Manana <fdmanana@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Filipe Manana <fdmanana@suse.com>
References: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
 <c4b59c1c-1f2f-4d93-b710-eb44a8c5943f@gmx.com>
 <CAL3q7H4V8mcisQRkxAro1_w0h+WxqAkapnp9AbKed1geGw6gDQ@mail.gmail.com>
 <acf8dd4b-1d00-48d7-9297-bf508c0b0b6f@kernel.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <acf8dd4b-1d00-48d7-9297-bf508c0b0b6f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1RqPBKrNSCRVY36EWxURz3KXatm5goMd1I+icDumgeKleqe3rjG
 h6U/ty5e7hUFgnXDLYExhmPXJkO7mPfE5J65kSlPvgczXULAPceSnBnQ4mEaClptGlP6B1h
 QKgko23tXHErb5LD7jgQkCVonTM4vO+ZbZoSSaeqhxXmf3DBrGXGpOqN1GoZK2GNDtPaSnf
 szOfWMDRscuqv1V25qDSA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:osGxcwMvNDU=;xUyiTJaGMt/de0rurbnZr/k4vY2
 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



=E5=9C=A8 2026/5/29 09:22, Anand Jain =E5=86=99=E9=81=93:
> On 28/5/26 19:30, Filipe Manana wrote:
>> On Thu, May 28, 2026 at 12:23=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.=
com> wrote:
>>>
>>>
>>>
>>> =E5=9C=A8 2026/5/28 19:57, fdmanana@kernel.org =E5=86=99=E9=81=93:
>>>> From: Filipe Manana <fdmanana@suse.com>
>>>>
>>>> Test writing into a file range containing prealloc extents beyond the=
 current
>>>> i_size, with an unmount and mount after fallocate and the write, to v=
erify
>>>> that the file data, size and extent layout were not lost.
>>>>
>>>> This used to fail on btrfs when not using the no-holes feature (which=
 is
>>>> a default since btrfs-progs 5.15) before this recent kernel fix:
>>>>
>>>>      080ecbd05432 ("btrfs: mark file extent range dirty after convert=
ing prealloc extents")
>>>>
>>>> So in order to reproduce the failure when using an unpatched kernel a=
nd
>>>> a btrfs-progs >=3D 5.15, one must run the test with:
>>>>
>>>>      MKFS_OPTIONS=3D"-O ^no-holes"
>>>>
>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>
>>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>>
>>>
>>> Just one question related to the specified mkfs option.
>>>
>>> As you mentioned, this bug is only affecting ^no-holes, thus default
>>> mount option runs won't trigger it.
>>>
>>> This makes me wondering, should we have a dedicated btrfs test case ju=
st
>>> exercising the ^no-holes path.
>>>
>>> I know this will cause duplication, thus will not be a good idea to
>>> maintain, but we also have dedicated test cases utilizing specified
>>> mount option/mkfs options already.
>>>
>>> So what is the prefer method here?
>>
>=20
> There will be many testcase and option combinations,
> which makes this harder to scale and increases the
> chances of missing a testcase + option combination
> across federated teams.
>=20
> I think it makes sense to maintain a standard testing config
> (not sure what to call it, maybe a Test-Profile?).
>=20
> V2 was sent here:
>=20
> https://lore.kernel.org/fstests/cfb8c19533ac3c764edc1fe62b7fde75e76579a4=
.1743137470.git.anand.jain@oracle.com/
>=20
> Any thoughts? I'm ok to revisit to send v3 if needed.

There is no "nodatasum" mount option to verify the behavior of zero-copy=
=20
direct writes.
Although I hope the incoming IOMAP_DIO_BOUNCE flag usage will get rid of=
=20
the special nodatasum requirement for dio.

Nor "flushoncommit" mount option which recently exposed a deadlock.

And I'm not sure if you should put "rst" mkfs option as default, it's=20
still very experimental.

Not to mention there will be more and more sectorsize/nodesize=20
combination to come with bs > ps support, or on 64K page sizes systems.
Meanwhile the coverage itself may not be improved that much with extra=20
sectorsizes...

Finally you're pushing for a lot of compression runs (3 out of 8), but=20
IIRC there are some known failures and some ENOSPC runs will take way=20
too longer than regular runs.

Even with a 24x7 VM running tests, the generated false alerts still will=
=20
take a lot of human time to review and fix.

>=20
> Thanks, Anand
>=20
>=20
>> So in the past I attempted tests like that, making them btrfs specific
>> and forcing a mount option.
>> Some people (non-btrfs people, I don't recall exactly who, to be
>> honest) disagreed with the claims that the test was actually generic,
>> and that exercising the bug should be done by setting MKFS_OPTIONS in
>> the command line.
>>
>> I'm assuming people and our automations run tests with -O ^no-holes. I
>> do it frequently in my test vms.
>>
>>>
>>> Thanks,
>>> Qu
>>>> ---
>>>>    tests/generic/796     | 54 +++++++++++++++++++++++++++++++++++++++=
++++
>>>>    tests/generic/796.out | 10 ++++++++
>>>>    2 files changed, 64 insertions(+)
>>>>    create mode 100755 tests/generic/796
>>>>    create mode 100644 tests/generic/796.out
>>>>
>>>> diff --git a/tests/generic/796 b/tests/generic/796
>>>> new file mode 100755
>>>> index 00000000..c42a4722
>>>> --- /dev/null
>>>> +++ b/tests/generic/796
>>>> @@ -0,0 +1,54 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
>>>> +#
>>>> +# FS QA Test 796
>>>> +#
>>>> +# Test writing into a file range containing prealloc extents beyond =
the current
>>>> +# i_size, with an unmount and mount after fallocate and the write, t=
o verify
>>>> +# that the file data, size and extent layout were not lost.
>>>> +#
>>>> +. ./common/preamble
>>>> +_begin_fstest auto quick prealloc preallocrw fiemap
>>>> +
>>>> +. ./common/filter
>>>> +. ./common/punch # for _filter_fiemap
>>>> +
>>>> +_require_scratch
>>>> +_require_xfs_io_command "falloc" "-k"
>>>> +_require_xfs_io_command "fiemap"
>>>> +
>>>> +_fixed_by_fs_commit btrfs 080ecbd05432 \
>>>> +     "btrfs: mark file extent range dirty after converting prealloc =
extents"
>>>> +
>>>> +_scratch_mkfs >>$seqres.full 2>&1
>>>> +_scratch_mount
>>>> +
>>>> +# The fiemap results in the golden output requires file allocations =
to align to
>>>> +# 1M boundaries.
>>>> +_require_congruent_file_oplen $SCRATCH_MNT 1048576
>>>> +
>>>> +# Create our file with a size of 0 and a prealloc extent in the rang=
e [0, 2M].
>>>> +$XFS_IO_PROG -f -c "falloc -k 0 2M" $SCRATCH_MNT/foo
>>>> +
>>>> +# Unmount and mount again to remove any in memory state of the inode=
. We will
>>>> +# verify later that neither metadata nor extents were lost during un=
mount.
>>>> +_scratch_cycle_mount
>>>> +
>>>> +# Write into the [0, 1M] range, which increases the inode's i_size.
>>>> +$XFS_IO_PROG -c "pwrite -S 0xab -b 1M 0 1M" $SCRATCH_MNT/foo | _filt=
er_xfs_io
>>>> +
>>>> +# Unmount and mount again to remove any in memory state of the inode=
. We will
>>>> +# verify later that neither metadata nor extents were lost during un=
mount.
>>>> +_scratch_cycle_mount
>>>> +
>>>> +# Check file data (and size).
>>>> +echo "File data:"
>>>> +_hexdump $SCRATCH_MNT/foo
>>>> +
>>>> +# Check we have unwritten extents in range [1M, 2M].
>>>> +echo "Fiemap output:"
>>>> +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
>>>> +
>>>> +# Success, all done.
>>>> +_exit 0
>>>> diff --git a/tests/generic/796.out b/tests/generic/796.out
>>>> new file mode 100644
>>>> index 00000000..c6c6e6a8
>>>> --- /dev/null
>>>> +++ b/tests/generic/796.out
>>>> @@ -0,0 +1,10 @@
>>>> +QA output created by 796
>>>> +wrote 1048576/1048576 bytes at offset 0
>>>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>>>> +File data:
>>>> +000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  >...........=
.....<
>>>> +*
>>>> +100000
>>>> +Fiemap output:
>>>> +0: [0..2047]: data
>>>> +1: [2048..4095]: unwritten
>>>
>=20
>=20

