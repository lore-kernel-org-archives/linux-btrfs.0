Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BFE3446C5
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070904; cv=none; b=M7jNJ9fmBt6Ar2VRHpQlncCngdBcQnYcNEB1SwFj3ytzG/DOgxSnltsUuyMEwEBGh7T0YohaKdg4P4zDkKZJsEv4kByZ4De9GBS3Iej6CG7k38zYPS8AKx2mugxpHI9dy5lPidejBSM4lGbtqloxfsTBUE+9VEWeAOrcJ4FyWx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070904; c=relaxed/simple;
	bh=+x2ixnWtfccF7Ls1lrodGv0ePqboeXEEI2bd05flIS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SSy6CKFWk5+xrW2t0PqRdDIzIHSV36yDmGBAsxjmmP53EpKUFTRICcVU5+/qOzFPvPIOp+4Mge8aRnckkLvQC+tWz9K7Kb5whzvq9i2vyF28ct754yYo4hOJoLb7+xWmDsHNwECjv3gw56QafC02oz+uskH+Yrw+Q88sJNLSOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Jbdm/Cwv; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Jbdm/Cwv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783070893; x=1783675693; i=quwenruo.btrfs@gmx.com;
	bh=HdZ/glc+JfSjKh8w1DCq8UhFzDrlCpaFpN7U97YVjNs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Jbdm/Cwv5U+cqZmm/TrBTHWNVjV+76qmNM/F59ISY0675FV7D39cZHg2jUAkX8Wa
	 8V7aRyKX0yle/4QSgiD8zBxyMHiQ2UdOTjH/z5WJqihNkoCBM8dhtUZEptJVBDu1k
	 YQeFV6wYv6vdhNsCHNsqzK15nNPatLKuJyTmOKdNAMVJqM9JE0YYQrtHSYyN6sHLC
	 D45oZNzZ3R27WKG/m/xsa4CUZQWMLp3huKSfidlyCqsCXyrEhFkpee0nnP1zIGGZk
	 mg+AhBj//qDoHANJD7nWLheJa+aVOuIkszN+mlo+bg0TYbml0Pb3NiugSMIUndKQB
	 47zndSn981L57i1eYw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mkpex-1xNlcw1L5j-00lClR; Fri, 03
 Jul 2026 11:28:13 +0200
Message-ID: <0eb18870-88ab-4856-8b6c-78ade992ec4a@gmx.com>
Date: Fri, 3 Jul 2026 18:58:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] btrfs: add "rescue=usebackuproot" into forced
 read-only options
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
References: <cover.1783068013.git.wqu@suse.com>
 <dc5a344a2f4fcb63f78cb3e95beb1efbee9928f4.1783068013.git.wqu@suse.com>
 <c20f62ae-eef2-4eb5-9290-a7bebe6a259d@fnnas.com>
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
In-Reply-To: <c20f62ae-eef2-4eb5-9290-a7bebe6a259d@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hQlZlCTmsdI4J2sIP/GPR37EMJt7OrOYkKZ9xt4QeQbWqZxU1OE
 aL7C91bhCa9zCvPr16AYio4qYgE+TctZQUU3Hx7eihf9YP0oLXsaOfUgmUN6/LdGqz1Gb2X
 Yfjz1YIotZK2W5+Kzw5Mie5TGtkScwhsnh0vj8Vt/rhz+ZnP1fOUUQcG97w+czgT/IGcxgd
 dfi0KJn6LXuKYXFenxOyA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ymcmpKCDNa8=;Q+pZ/TSnbeXs4hepHhfs9FO1oVc
 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



=E5=9C=A8 2026/7/3 18:51, Dongjiang Zhu =E5=86=99=E9=81=93:
> =E5=9C=A8 2026/7/3 16:41, Qu Wenruo =E5=86=99=E9=81=93:
>> According to btrfs(5) man page, all rescue options should require an
>> read-only mount.
>>
>> But that read-only check is only introduced for newer rescue options,
>> not for the pre-existing "usebackuproot" one.
>>
>> Unify the behavior to match the document.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>    fs/btrfs/super.c | 3 ++-
>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 0a6ce6c19d8c..fef9025a2f76 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -692,7 +692,8 @@ bool btrfs_check_options(const struct btrfs_fs_info=
 *info,
>>    	bool ret =3D true;
>>   =20
>>    	if (!(flags & SB_RDONLY) &&
>> -	    (check_ro_option(info, *mount_opt, BTRFS_MOUNT_NOLOGREPLAY, "nolo=
greplay") ||
>> +	    (check_ro_option(info, *mount_opt, BTRFS_MOUNT_USEBACKUPROOT, "us=
ebackuproot") ||
>> +	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_NOLOGREPLAY, "nolo=
greplay") ||
>>    	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREBADROOTS, =
"ignorebadroots") ||
>>    	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREDATACSUMS,=
 "ignoredatacsums") ||
>>    	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREMETACSUMS,=
 "ignoremetacsums") ||
>=20
> Hi Qu,
>=20
> One more thing I noticed: should BTRFS_MOUNT_USEBACKUPROOT also be added
> to BTRFS_MOUNT_FULL_RO_MASK?

Thanks for pointing this out, you're completely right.

>=20
> Thanks,
> Dongjiang
>=20

