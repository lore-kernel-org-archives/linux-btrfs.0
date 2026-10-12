Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA913CFF6F;
	Mon, 12 Oct 2026 23:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846389; cv=none; b=VUY+FD9CHci7urKfkh/hXjOUxh9xCSSCjNj+RJ2WCYGj0RCo59ASq9QWlwQrOfDJ340SUCJnieaQLVTafu2TT+FRwVvuVIqgVuzwfm1vv1wmJA6C1HOLF8GoNQdgQrFbwI8oTc1tlDw1TDt6bav3TZ7jD1NkdCX9+d/6AKaOpk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846389; c=relaxed/simple;
	bh=eb8JYDwUa7lJs7DtqbIvPP3rCzj8voaBG4NcBEbnrNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H8rDD5ZaWX6UQhw9oAIk4j4Ig/2vdTFFlEhvUpT1wDvoG5333vYz7f4WwohYp/UyAECokkqy19IXHtqELD/dStUZIUOa96ZlMqNtgx3Eupp5SQ82e6LLondmmKCIqaT7+Y1KBwGh4okGGF0qrEOcJ7KtsoRnuEdDSGpwW8E73jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Ov77iAei; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Ov77iAei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791846384; x=1792451184; i=quwenruo.btrfs@gmx.com;
	bh=eOTqrc7MRZmffPm8XKfIC3H0i9iRvi8gdkxwd9oDug4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Ov77iAeiVSbXZugNBKg8gKR0cTa4WWMpJRg41Fx76iDp+hmpx0ST9DyQAakWX3JB
	 tg6n3eyo0Cd3nhqpJ6+rdjuVNGw/CpRKEGpIl042vQ7u5GzeZ3duqX++qrUfW3l3y
	 6A0ah+BR7uin9sz7XN1k8hSgA0BRDZTmjomizrC3pqsGnWjU8e6Qy+OcE8idfpcqO
	 rFe2LQ+qNWTAPwCAwz2bQ97XdTT1RiDMChPsa3WsBuMq6nbF6PFSX+OJ0DeGIHiwQ
	 nwwHunuzgS9mCxwPGBIDDYJF6jqgei8v8Wf/CKtOmwMtVUQz80f27SBZTbZkgxSFx
	 ZILDh8TCW3/6GOzLDg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N9dsb-1wbTcQ3tDB-011J5i; Tue, 13
 Oct 2026 01:06:24 +0200
Message-ID: <8883e07c-97c4-4014-8d40-c69933e9a0d2@gmx.com>
Date: Tue, 13 Oct 2026 09:36:20 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: test setting attribute on nodatasum file that has
 inherited compression
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <0c27162bb8d0b8366afc37411da2ed794d33fc22.1791826238.git.fdmanana@suse.com>
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
In-Reply-To: <0c27162bb8d0b8366afc37411da2ed794d33fc22.1791826238.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+17gYg7Igu2TgBbvso+yATmfY0WLjv/PAB0RS/p2YHZieBsv+zB
 01V7UAfLnFbVHIfo0JGrm0Bk6cQX0oYOIskXt0VXqfwKdlz9dwFH5HcXgdv9yzM1QB3XLJb
 LVs1/gZHS3Z5i6iYq5rie7Vh0K40s5vDpA7kXFEpVOt1XrvkBdt1otzmTthnzRts1goON/n
 8kYvitBqG77xqgTjz2NIw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4/YSNOW1aI4=;WettX5YYJS8VlgTcLdH/MeBs/sj
 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
 ZqtO//zWi3xGuuJnlfP2Dg07CNeos=



=E5=9C=A8 2026/10/13 04:01, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Test that setting an attribute unrelated to compression on a file that h=
as
> inherited compression from its parent directory does not fail when the f=
s
> is mounted with the nodatasum option.
>=20
> This exercises a regression introduced in kernel 7.2 and that is fixed b=
y
> a patch with the following subject:
>=20
>    "btrfs: fix chattr failing on nodatasum files that have the compress =
flag"
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   tests/btrfs/360     | 37 +++++++++++++++++++++++++++++++++++++
>   tests/btrfs/360.out |  2 ++
>   2 files changed, 39 insertions(+)
>   create mode 100755 tests/btrfs/360
>   create mode 100644 tests/btrfs/360.out
>=20
> diff --git a/tests/btrfs/360 b/tests/btrfs/360
> new file mode 100755
> index 00000000..84c4ba38
> --- /dev/null
> +++ b/tests/btrfs/360
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 360
> +#
> +# Test that setting an attribute unrelated to compression on a file tha=
t has
> +# inherited compression from its parent directory does not fail when th=
e fs is
> +# mounted with the nodatasum option.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick compress
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: fix chattr failing on nodatasum files that have the compress f=
lag"
> +
> +_require_scratch
> +_require_btrfs_no_nodatacow
> +_require_chattr c
> +_require_chattr A
> +
> +_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount "-o nodatasum"
> +
> +mkdir $SCRATCH_MNT/dir
> +# Set the compression attribute on the directory so that any file creat=
ed inside
> +# it will inherit compression.
> +$CHATTR_PROG +c $SCRATCH_MNT/dir
> +
> +# File foo inherits compression from its parent directory.
> +touch $SCRATCH_MNT/dir/foo
> +
> +# Now set some other attribute on file foo and check that it succeeds.
> +$CHATTR_PROG +A $SCRATCH_MNT/dir/foo
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/btrfs/360.out b/tests/btrfs/360.out
> new file mode 100644
> index 00000000..aead0f88
> --- /dev/null
> +++ b/tests/btrfs/360.out
> @@ -0,0 +1,2 @@
> +QA output created by 360
> +Silence is golden

