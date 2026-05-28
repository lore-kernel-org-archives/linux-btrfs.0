Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DB53A6B9A;
	Thu, 28 May 2026 11:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779967423; cv=none; b=DV6T9ob4z54rErTY5J1Puta1/BZv0/7G2aq7boWMGJ55lyQ4QnH3PzcVwkVGSy67V/OPvZmRBaw0xUn2ggKjoIMCbZceIY4nZ1GQHUf37OEHOT0MFy5IMyLtlghiFPIQF0EKNZC0gQjNd43IV1jDunWSuxghSjZ6BxhFO76/opw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779967423; c=relaxed/simple;
	bh=x5xjDMaPqdIORwCq3z3i2QfNeHuJKWyM+IYwn9YpsY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LXMaob0Sz8lKrbLdlM0srt0WCWn7kxwoPbeVYxjcdsbDjkMqb9TP//gIYoNv7smAXLFuYArWCTH6VprYi6mZS8u4N58X8gnBZqZIH1u2zJCAtY93RSTn6j7qmSMwExxJ17yh0bA+ssmEJEVRHIK0Kt6bedAyaMHVOXy1K8XIi7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=EBGOFxit; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="EBGOFxit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779967419; x=1780572219; i=quwenruo.btrfs@gmx.com;
	bh=c3+hLrlNRZeetR2guXUOJAXmoVai98S8V5TWVWZrN3g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=EBGOFxitJDsrZyQfbgbNgyIIubxhp2GonWD8ySENnAfU06JBuYiS4rGkl4Ml/emU
	 Wvk7VqhFPMPxvUqRQmZom3X28wqlnlyi1Emo1yJXrLZ5CS/+RYJuUCpqkLEEngHgZ
	 cTV7Mb+ODsZADQRTk9NsOojxMrXJuMaOG5PxM8B8tZ5PSSoZnvxZMGen3s5oPAvoK
	 x8pxiA+cvh/i5XP+rB6ISGe5xodiU1XtJRLYcol89+7lYauskJP9XpoiVik4w2OAy
	 h/f2YjXNm+WlS8nTWlt9qdWkOfL7vku6+w8Lm9cyAHqlEE4XNK+kZXeFtRPcmMsK8
	 6RQfxae88ICmjIpIQg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N3siA-1xSKQE20f2-00zYD7; Thu, 28
 May 2026 13:23:39 +0200
Message-ID: <c4b59c1c-1f2f-4d93-b710-eb44a8c5943f@gmx.com>
Date: Thu, 28 May 2026 20:53:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] generic: add a test case for writes with prealloc extents
 beyond i_size
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
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
In-Reply-To: <4b84813ed94332ccf8bb46848ed91f699d75794a.1779964012.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tWKv9KGoa7k/jBAcLHVVu8sQXgvzGS080zPumwuTGvyJmB8REIc
 0xZZptC6k2Ejjt0A2a3tPWCSE4oPXMrpvQVwmVRFB2aG9XVkK6MphmejqmdoBSUT8ZrSM7j
 FORtwS/q3e4foxyy8P4h+go1VCtJJzQkPidYfp/lE7T36KIOXkkN0ypnF17RQpword1MfvP
 GDYq/FYnqF/SuZR4aT5UA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/8rqfeAH2ag=;0F5VGvb2+iXJf7cABYr/yxRgdJq
 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
 xi1CKN+o7kXWxFHP/Y=



=E5=9C=A8 2026/5/28 19:57, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Test writing into a file range containing prealloc extents beyond the cu=
rrent
> i_size, with an unmount and mount after fallocate and the write, to veri=
fy
> that the file data, size and extent layout were not lost.
>=20
> This used to fail on btrfs when not using the no-holes feature (which is
> a default since btrfs-progs 5.15) before this recent kernel fix:
>=20
>     080ecbd05432 ("btrfs: mark file extent range dirty after converting =
prealloc extents")
>=20
> So in order to reproduce the failure when using an unpatched kernel and
> a btrfs-progs >=3D 5.15, one must run the test with:
>=20
>     MKFS_OPTIONS=3D"-O ^no-holes"
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>


Just one question related to the specified mkfs option.

As you mentioned, this bug is only affecting ^no-holes, thus default=20
mount option runs won't trigger it.

This makes me wondering, should we have a dedicated btrfs test case just=
=20
exercising the ^no-holes path.

I know this will cause duplication, thus will not be a good idea to=20
maintain, but we also have dedicated test cases utilizing specified=20
mount option/mkfs options already.

So what is the prefer method here?

Thanks,
Qu
> ---
>   tests/generic/796     | 54 +++++++++++++++++++++++++++++++++++++++++++
>   tests/generic/796.out | 10 ++++++++
>   2 files changed, 64 insertions(+)
>   create mode 100755 tests/generic/796
>   create mode 100644 tests/generic/796.out
>=20
> diff --git a/tests/generic/796 b/tests/generic/796
> new file mode 100755
> index 00000000..c42a4722
> --- /dev/null
> +++ b/tests/generic/796
> @@ -0,0 +1,54 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 796
> +#
> +# Test writing into a file range containing prealloc extents beyond the=
 current
> +# i_size, with an unmount and mount after fallocate and the write, to v=
erify
> +# that the file data, size and extent layout were not lost.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick prealloc preallocrw fiemap
> +
> +. ./common/filter
> +. ./common/punch # for _filter_fiemap
> +
> +_require_scratch
> +_require_xfs_io_command "falloc" "-k"
> +_require_xfs_io_command "fiemap"
> +
> +_fixed_by_fs_commit btrfs 080ecbd05432 \
> +	"btrfs: mark file extent range dirty after converting prealloc extents=
"
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +# The fiemap results in the golden output requires file allocations to =
align to
> +# 1M boundaries.
> +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> +
> +# Create our file with a size of 0 and a prealloc extent in the range [=
0, 2M].
> +$XFS_IO_PROG -f -c "falloc -k 0 2M" $SCRATCH_MNT/foo
> +
> +# Unmount and mount again to remove any in memory state of the inode. W=
e will
> +# verify later that neither metadata nor extents were lost during unmou=
nt.
> +_scratch_cycle_mount
> +
> +# Write into the [0, 1M] range, which increases the inode's i_size.
> +$XFS_IO_PROG -c "pwrite -S 0xab -b 1M 0 1M" $SCRATCH_MNT/foo | _filter_=
xfs_io
> +
> +# Unmount and mount again to remove any in memory state of the inode. W=
e will
> +# verify later that neither metadata nor extents were lost during unmou=
nt.
> +_scratch_cycle_mount
> +
> +# Check file data (and size).
> +echo "File data:"
> +_hexdump $SCRATCH_MNT/foo
> +
> +# Check we have unwritten extents in range [1M, 2M].
> +echo "Fiemap output:"
> +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap
> +
> +# Success, all done.
> +_exit 0
> diff --git a/tests/generic/796.out b/tests/generic/796.out
> new file mode 100644
> index 00000000..c6c6e6a8
> --- /dev/null
> +++ b/tests/generic/796.out
> @@ -0,0 +1,10 @@
> +QA output created by 796
> +wrote 1048576/1048576 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +File data:
> +000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  >..............=
..<
> +*
> +100000
> +Fiemap output:
> +0: [0..2047]: data
> +1: [2048..4095]: unwritten

