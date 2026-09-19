Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC7034040D;
	Sat, 19 Sep 2026 23:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789860949; cv=none; b=rAcKgpWTF2D6P9St9Fv3Q1t1+c+5tmC/LP/9WpIYwB93CJc2H55uda4fU8swyuyeL0G2OL5TFzXajBLuJiT3d6kBhlNatkLmwOAc+chGHdTGHLJxvQrc7UNWgwZ3cMWU/TpTmQant4fMZpzyqpTlwghbrkwUStCaMdxanPNaexA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789860949; c=relaxed/simple;
	bh=xpRhzOkhiLUzeQelgZ9+oxdaXTEEa0rRhkGN76VB8Cc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tsDWBaT/zr6O2VnfZnzk9+KiALVrGhPqmGMrfi/ikLG9opD7psX+/d8I5t7PUt34ZSL3bY21kaU6WsuhEZ+h7J6859YhokePqNqijFPygxcP2+OtaJX7Fw9+u7lKEYGTtXCCB7JautHCWU6yBcUoUefokNqXRNQtRS+mcs09sCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=pY7kIeOJ; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="pY7kIeOJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789860941; x=1790465741; i=quwenruo.btrfs@gmx.com;
	bh=+uD+kPAwXK65SKexVMCqCGEmYP1K9Xp3Hg1pWLIst/4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=pY7kIeOJfJnrJ05/h71/wEfusKD7H8pRDb30rjRlZiW0xxmtXzDodwA5i/yLSYjV
	 4vCpF5S7/PZUeCozZ627kegcWAFRFiUlNBIf40LCogeG+otgJDAF6I9TDapqztPUl
	 DF0Q4PRsQGsOTqTPbMP4p6Qm3JpVDjqFEHSO8cm6Ka6CXBXKmPNuywq2TNFmq1oqj
	 uacSaYouFfU6sgO8+DB5plcnfCh9+zYZd2pVcxMCgxYBjZMsHEhjkah6JPCo4nNuD
	 L1BLidOWP7IxW9wkeicSGlCkogOhLBy8dhwFtxIOtS60blTfDg4vQFL7RlmpULEvS
	 b3NV5KlSF7MmQMW0Ow==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MdebB-1wYjuP0zEf-00kJcq; Sun, 20
 Sep 2026 01:35:40 +0200
Message-ID: <68f71bf6-cf42-4741-a0dc-1a6bc54e86a2@gmx.com>
Date: Sun, 20 Sep 2026 09:05:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: test defrag --nocomp converts comp extents to
 uncomp
To: Dhruva G <goledhruva@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com, fstests@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>, Anand Jain <asj@kernel.org>
References: <d17a93e6-1613-4113-a75a-8ea89efb2bdb@gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <d17a93e6-1613-4113-a75a-8ea89efb2bdb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3rMHxwzGs2f0QuMzZCOuDnfJK6TACuLKliX6Vao6Ef7bZMauZnq
 2MKfsSA5rklTda2gDXuJLsHl+UUSxfjj6gKLoU29qIUmIiijyBFsBOdb/u9PesJLgLeways
 qoH2yKboZ48RyKxuVj2Oe7j8yjozESy0Pv4uqSDwJJk520VSKEidYaYEVafDyUfy1IUGzAn
 ZcAFi8CdTAr3bO+RFWOyg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Noh5mShnXyA=;z6bIzWQx5nNW50/tciruhiewV+X
 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



=E5=9C=A8 2026/9/20 03:52, Dhruva G =E5=86=99=E9=81=93:
> "btrfs filesystem defragment --nocomp" rewrites already compressed file
> data as uncompressed data. The kernel flag was added by commit
> 009b2056cb25 ("btrfs: defrag: add flag to force no-compression") in
> v6.17, and the userspace option shipped in btrfs-progs v6.16. There is
> no test for it.
>=20
> Add a test that writes compressible data on a filesystem mounted with
> compression enabled, runs defragment with --nocomp, and verifies that no
> extent remains compressed while the file contents are unchanged across a
> remount. The filesystem stays mounted with compress=3Dzlib for the whole
> test, which also covers that the defrag ioctl takes precedence over moun=
t
> options.
>=20
> Regular defrag deliberately leaves maximum-sized compressed extents alon=
e,
> as asserted by btrfs/259. A --nocomp implementation that silently behave=
s
> like regular defrag therefore requires a dedicated test.
>=20
> Check support in two stages: first require btrfs-progs to advertise
> --nocomp, then invoke it on a 10-byte file to verify that the kernel
> accepts the flag. Kernels with the unknown-flag validation from commit
> 173431b274a9 return EOPNOTSUPP when NOCOMPRESS is unavailable. Kernels
> predating that validation may silently ignore the flag and fail the
> semantic checks instead of skipping.
>=20
> Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
> ---
>=20
> Logs/ compatibility matrix:
> https://gist.github.com/DhruvaG2000/62101a37f5e53e41883b4b3181250724
>=20
> ---
>=20
>   tests/btrfs/354     | 92 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/354.out |  2 +
>   2 files changed, 94 insertions(+)
>   create mode 100755 tests/btrfs/354
>   create mode 100644 tests/btrfs/354.out
>=20
> diff --git a/tests/btrfs/354 b/tests/btrfs/354
> new file mode 100755
> index 00000000..fae8f47e
> --- /dev/null
> +++ b/tests/btrfs/354
> @@ -0,0 +1,92 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Meta Platforms, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 354
> +#
> +# Make sure "btrfs filesystem defragment --nocomp" rewrites compressed =
extents
> +# as uncompressed ones, even though the filesystem is mounted with comp=
ression
> +# enabled, and without changing the file contents.
> +#
> +# Note that regular defrag deliberately skips compressed extents that a=
re
> +# already at their maximum size (see btrfs/259), so a broken --nocomp t=
hat
> +# simply does nothing would go unnoticed without this test.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick defrag compress
> +
> +# real QA test starts here
> +
> +_require_scratch
> +_require_btrfs_command inspect-internal dump-tree
> +_require_btrfs_command filesystem defragment --nocomp
> +
> +_wants_kernel_commit 009b2056cb25 \
> +	"btrfs: defrag: add flag to force no-compression"
> +
> +# Same helper as btrfs/260: btrfs specific extent attributes are only
> +# available from dump-tree, not from fiemap.
> +#
> +# NOTE: At the moment this only works if the file is on a filesystem on=
 top of
> +#       the scratch device and the file is in the default subvolume (tr=
ee id 5).
> +check_file_extent()
> +{
> +	local file=3D"$1"
> +	local offset=3D"$2"
> +	local expected=3D"$3"
> +	local ino=3D$(stat -c "%i" "$file")
> +
> +	echo "=3D=3D=3D file extent at file '$file' offset $offset =3D=3D=3D" =
>> $seqres.full
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV |\
> +		grep -A4 "($ino EXTENT_DATA $offset)" > $tmp.output
> +	cat $tmp.output >> $seqres.full
> +	grep -q "$expected" $tmp.output ||\
> +		echo "file \"$file\" offset $offset doesn't have expected string" \
> +		     "\"$expected\""

This is a little overkilled, if your objective is only to check if the=20
file extent is compressed or not, filefrag or xfs_io "fiemap" can both=20
provide a flag (0x8, encoded) showing if an extent is compressed or not.

> +}
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount -o compress=3Dzlib
> +
> +# Probe kernel support separately from the userspace check above. Kerne=
ls
> +# without the flag reject it with EOPNOTSUPP when unknown-flag validati=
on is
> +# available.
> +$XFS_IO_PROG -f -c "pwrite 0 10" "$SCRATCH_MNT/probe" >> $seqres.full
> +$BTRFS_UTIL_PROG filesystem defragment --nocomp "$SCRATCH_MNT/probe" \
> +	>> $seqres.full 2>&1 || _notrun "defrag --nocomp not supported"
> +
> +# Default xfs_io pattern is highly compressible, so every extent of thi=
s file
> +# ends up compressed and at the 128K maximum compressed extent size.
> +$XFS_IO_PROG -f -c "pwrite 0 1m" "$SCRATCH_MNT/foo" >> $seqres.full

Just a small nitpick, the default block size is 4K, meaning under memory=
=20
pressure the writeback can be triggered halfway, resulting extents=20
smaller than 128K, better to use 128K block size just in case.

This should be very rare though.

> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT

You can merge a regular -c "sync" to above command.

> +
> +# Should be zlib compressed
> +check_file_extent "$SCRATCH_MNT/foo" 0 "compression 1"
> +
> +csum_before=3D$(_md5_checksum "$SCRATCH_MNT/foo")
> +
> +$BTRFS_UTIL_PROG filesystem defragment --nocomp "$SCRATCH_MNT/foo" \
> +	>> $seqres.full 2>&1
> +
> +# Need to commit the transaction or dump-tree won't grab the new
> +# metadata on-disk.
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +
> +# Should no longer be compressed, despite the compress mount option
> +check_file_extent "$SCRATCH_MNT/foo" 0 "compression 0"
> +
> +# No extent of this inode may remain compressed
> +ino=3D$(stat -c "%i" "$SCRATCH_MNT/foo")
> +$BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV |
> +	grep -A4 "($ino EXTENT_DATA " | grep -q "compression [^0]" &&
> +	echo "file still has compressed extents after --nocomp defrag"

Again, regular fiemap can tell if the extent is compressed or not.

Otherwise looks good to me.

Thanks,
Qu

> +
> +# Contents must survive the rewrite, read back from disk and not page c=
ache
> +_scratch_cycle_mount "compress=3Dzlib"
> +csum_after=3D$(_md5_checksum "$SCRATCH_MNT/foo")
> +[ "$csum_before" =3D "$csum_after" ] || echo "file content changed"
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
> new file mode 100644
> index 00000000..8bc7ecf6
> --- /dev/null
> +++ b/tests/btrfs/354.out
> @@ -0,0 +1,2 @@
> +QA output created by 354
> +Silence is golden

