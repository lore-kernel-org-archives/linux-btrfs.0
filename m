Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74993D9028;
	Tue,  7 Jul 2026 09:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418323; cv=none; b=AYvN/L0eTYLobUQgDZ7kJQzfBV2UvbigGpbNh+jNSNOEvw1WkYyZ4N1i2tRtpKoT9q655rmfkSU2cqv4EJs93tMwVfUqlgSeIHIRgL31DCdiZxppXD7nzi4tRv/eDgYQLfqWQW1dM14Z5FVdzKakVvYssLXPiVofbw2Q8/gQneY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418323; c=relaxed/simple;
	bh=ir6PqQ/A21LS83uBhb2SXPb1M14YjwLBKm0+f1yz9V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=isOQ7vOtcc8or1KuXXHchTO8dBTc6qWFKVPmQ4IvlKspLsjtTUQsVMe9hAEcYyF+SUvW0B25hTLrkealRSW1TJoZmiTPRr+Kx/ReTkOJZvBFH9n09g/ZVVaJ76hc5XCQenE9ulMFvYyMmzDFCuT60K7YLgarqwF6hkbDeOZ6yWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=OWMsIE2N; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="OWMsIE2N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783418319; x=1784023119; i=quwenruo.btrfs@gmx.com;
	bh=7uz09DCfgrjVIlfxXI8ivu5U7J74UfA4JTKfgUifnHQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OWMsIE2NbclpDRohi7yuYMFq04AuppAEAaEALLwJ+17tO1ql5JmQnn7nHa9zbN1I
	 a7MYLOTIqzRemlOQeenPm1bIb/xmdII5R8MWFDswUWXgMV6sRbyinyho4Kd/awEGR
	 KRBChnv2fXSLuPT60pUqpgiD8EXJbAGFVbjcjdgNtu20TgbitD7kNDOyo18N+01G7
	 yQGYI6taDDjw23gf+YcSACnwqqmiLwQyd0E0AynmbsidVAOzI3NoH4S0kn1HxXC7F
	 V6yvHzVIDe9ync/z8YJkudF49ds10f3AskmIQuL531dDXKMDGUrKvWt7xcKo+gvrj
	 bMN+uJX5N/dz3CI12g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N63RQ-1x9TUq0GNc-013HVp; Tue, 07
 Jul 2026 11:58:38 +0200
Message-ID: <68710f89-63cb-40b1-b214-39efbe6dd9af@gmx.com>
Date: Tue, 7 Jul 2026 19:28:32 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: btrfs: new test case for leaking
 BTRFS_FS_STATE_REMOUNTING flag
To: Anand Suveer Jain <asj@kernel.org>, Qu Wenruo <wqu@suse.com>,
 fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260704085208.86039-1-wqu@suse.com>
 <8aa304b0-99bb-4940-923a-27abf9bd6b9b@kernel.org>
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
In-Reply-To: <8aa304b0-99bb-4940-923a-27abf9bd6b9b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ngv9WPfs28DN+XmHUBN0a2V05sXIWmBWZhelR/Vv6BUKiIFTNC4
 fu1IH5dpy9ELdS7BwLgwwRgZQN5EA+XpAM5HvhI8Qjbq1KHf3/yv1kC0HnJufOiY/BK+pTp
 Xl6O5rNQngBairCva52INDoIlbTcoy4hgIVBalpWOwutf3y4J24c5EZBvsKvMnpaAkRXk+s
 askN6V0kTnjjHhkwOfY4A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:c2w8UNan5dI=;a02wJQzBJQJFMLL+GST/4mbJd2d
 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



=E5=9C=A8 2026/7/7 19:14, Anand Suveer Jain =E5=86=99=E9=81=93:
> On 4/7/26 16:52, Qu Wenruo wrote:
>> This is a regression test for the patch "btrfs: fix leaking
>> BTRFS_FS_STATE_REMOUNTING flag", where conflicting mount options can
>> cause btrfs leave BTRFS_FS_STATE_REMOUNTING set.
>>
>> Such set BTRFS_FS_STATE_REMOUNTING will interrupt several features, and
>> the test case will use "btrfs qgroup rescan" to catch the
>> BTRFS_FS_STATE_REMOUNTING flag.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   tests/btrfs/352     | 53 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>   tests/btrfs/352.out |  2 ++
>>   2 files changed, 55 insertions(+)
>>   create mode 100755 tests/btrfs/352
>>   create mode 100644 tests/btrfs/352.out
>>
>> diff --git a/tests/btrfs/352 b/tests/btrfs/352
>> new file mode 100755
>> index 00000000..2ccf7fab
>> --- /dev/null
>> +++ b/tests/btrfs/352
>> @@ -0,0 +1,53 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
>> +#
>> +# FS QA Test 352
>> +#
>> +# A regression test to make sure failed remount won't leave
>> +# BTRFS_FS_STATE_REMOUNTING flag set, which can interrupt several feat=
ures,
>> +# one of them is btrfs qgroup rescan.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick remount
>> +
>> +_fixed_by_kernel_commit XXXXXXXXXXXX \
>> +	"btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag"
>> +
>=20
>=20
>=20
> We can replace this section with the existing helpers or,
> even better, with a new one as shown below. I am not too
> particular about creating a new helper, that is up to you.
> However, the use of existing helpers such as
> _require_btrfs_fs_sysfs and _require_btrfs_fs_feature
> will be better. Thanks
>=20
>=20
>> +rescue_opts=3D"/sys/fs/btrfs/features/supported_rescue_options"
>> +if [ ! -f "$rescue_opts" ]; then
>> +	_notrun "No supported_rescue_options sysfs interface"
>> +fi
>> +
>> +if ! grep -q "ignorebadroots" "$rescue_opts"; then
>> +	_notrun "\"rescue=3Dignorebadroots\" mount option not supported"
>> +fi
>> +
>=20
>=20
> diff --git a/common/btrfs b/common/btrfs
> index 30288f07b61a..57453fb39893 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -100,6 +100,29 @@ _require_btrfs_mkfs_uuid_option()
>   	fi
>   }
>=20
> +# Check for the availability of a specific option within a btrfs
> feature set
> +# Arguments:
> +#   $1 - Feature attribute of /sys/fs/btrfs/features/
> +#   $2 - Option string to verify inside that file
> +_require_btrfs_fs_feature_option()
> +{

I'm fine to use the existing _require_btrfs_fs_feature() to detect that=20
file.

But I'm not fine of a new _require_btrfs_fs_feature_option().

You have already mentioned the second parameter is optional, then why=20
not merge it into the existing _require_btrfs_fs_feature().


Furthermore adding the second option can cause weird situations for the=20
existing features.

E.g. just check /sys/fs/btrfs/features/rmdir_subvol, I believe it will=20
be 0 on your environment too.

So if we use the optional parameter, there will be something like=20
"_require_btrfs_fs_feature_option acl 0", which doesn't looks sane at all.

I'll convert to use _require_btrfs_fs_feature() for=20
supported_rescue_options, but still manually test the content for the=20
ibadroots option.

Thanks,
Qu
> +	local feat=3D$1
> +	local feat_type=3D$2
> +
> +	if [ -z "$feat" ] || [ -z "$feat_type" ]; then
> +		echo "Missing argument(s) for _require_btrfs_fs_feature_type"
> +		_exit 1
> +	fi
> +
> +	modprobe btrfs > /dev/null 2>&1
> +
> +	_require_btrfs_fs_feature "$feat"
> +
> +	if ! grep -qw "$feat_type" "/sys/fs/btrfs/features/$feat"; then
> +		_notrun "Feature type '$feat_type' not supported by the available
> btrfs version"
> +	fi
> +}
> +
>   _require_btrfs_fs_feature()
>   {
>   	if [ -z $1 ]; then
> diff --git a/tests/btrfs/352 b/tests/btrfs/352
> index 2ccf7fabdb71..14e357dbaa37 100755
> --- a/tests/btrfs/352
> +++ b/tests/btrfs/352
> @@ -14,15 +14,8 @@ _begin_fstest auto quick remount
>   _fixed_by_kernel_commit XXXXXXXXXXXX \
>   	"btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag"
>=20
> -rescue_opts=3D"/sys/fs/btrfs/features/supported_rescue_options"
> -if [ ! -f "$rescue_opts" ]; then
> -	_notrun "No supported_rescue_options sysfs interface"
> -fi
> -
> -if ! grep -q "ignorebadroots" "$rescue_opts"; then
> -	_notrun "\"rescue=3Dignorebadroots\" mount option not supported"
> -fi
> -
> +_require_btrfs_fs_sysfs
> +_require_btrfs_fs_feature_option "supported_rescue_options"
> "ignorebadroots"
>   _require_btrfs_command quota rescan -w
>   _require_scratch
>   _scratch_mkfs >> $seqres.full
>=20
>=20
>=20

