Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502C34963A2
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788559072; cv=none; b=kzQeb8HFF5m07QxIMKExIJT0+ugYmJfuHdzZX4ZCeeskaPEh+Za6vBfr6vdPDQ9BDP8L+TzEI3UOhlehkJ2S5AyZtJL+j/GKJ2R19DzD8cRPB1vcTU3idegdXF8d5gSDbr4bRHzRWhS4AquGe+li8K0rfaJQag3PzreufJxF3dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788559072; c=relaxed/simple;
	bh=43RtKNLqk6ql7mbniIuNaicoFZYpVAri5Ig7/alYPVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fESbGi9eLIvvUOUtlD7IOoouxAoEkBg5WXYw/kfCzeqOEh6DSMJG2nYAu2Exh34pnb9nAcYdiJL3jIEobGWGh0uKLfEgsbZ6iyZyCbWqPtrJYDvgG6sYwvzdy2vEDJzvtZL9vwKtZv28w8tbsvtfw28PXedrAQ1fMtSS+D4u+Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=brxjIgNi; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="brxjIgNi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788559062; x=1789163862; i=quwenruo.btrfs@gmx.com;
	bh=21lJk8INhb3ZVV6Oh6l/4xX7+4pGquWeOhI4SF6k4oQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=brxjIgNi36Fs5zJd7mtDK0lqmrYPXccYSlLAoY/wnNtqw+wLjCM9PfeR7gUcrvuC
	 ju9NeqH25YgJbsKnGFmXo5051pgGfFDRBMLWehdQBBGCzdXge9MbVtG1L6HzpTPJR
	 rO4ZqULTxfx34p1ALMrtKSI09Fshgz4vQAPPhgZ86Eg1qvtbISHKCAAUvL919c/Oi
	 M8rHy88q5+DUpzsDB+reeT+Z9WZN16F6Q48P0hasxmYBx/3itbUJg3X9RuYWr2v3P
	 G28QPc3PBgvklp8/lOGLX+5BfICL36m7kSo9aKXyoauDmPFdPNAoEwSuPw7mCVob7
	 pghXkE4G/BnmCgaaWw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MAfYw-1x9AR23uky-008vvg; Fri, 04
 Sep 2026 23:57:42 +0200
Message-ID: <560dd988-c76e-471a-b4a5-c9a343d7e021@gmx.com>
Date: Sat, 5 Sep 2026 07:27:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: tree-checker: add qgroup status item check
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <f8f6232eb92cc8789461c2219915845aae1850ac.1787737993.git.wqu@suse.com>
 <20260904171406.GO9053@twin.jikos.cz>
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
In-Reply-To: <20260904171406.GO9053@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tiuthcA+4W1x1ciu7uryHF8FbmK8RwNacR1W1c6YsCEccWnQzqn
 N0GS7UKSCqVco31QYCBmtQ0Nv6j6EqlHVCDWIwDxl5AI1mI0Dy6Zy627BefDVI0I9cqcfaW
 pY+Zcy992HDBAB73QAnK7ISNtvNQa2PhGIo/xJNzb9HYsM36wsXb+PkRJpO4ANDt/nzdFwc
 kT6znzgSi4bgYsYfAnezA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:C0zKTz+y8nk=;mzbfiw+2FEA6K3CieLIQob+SyN4
 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



=E5=9C=A8 2026/9/5 02:44, David Sterba =E5=86=99=E9=81=93:
> On Wed, Aug 26, 2026 at 07:23:15PM +0930, Qu Wenruo wrote:
>> This adds the following checks:
>>
>> - Key check
>>
>> - Item size check
>>    Here we do not require completely matching the older or newer qgroup
>>    status item size, this is to allow future structure expansion.
>>
>> - Version check
>>    Again it's not a strict requirement for the version to match the
>>    support one, but to catch obvious bitflip.
>>
>>    And the kernel will already reject unknown version by disabling qgro=
up.
>>
>>    So we allow any version that is no larger than U8_MAX, which I belie=
ve
>>    we won't reach in the next few decades.
>>
>> - Flags check
>>    Mostly to catch any unexpected RUNTIME flags.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v2:
>> - Loosen the version check
>> - Loosen the item size check
>>    To allow older kernels to mount future newer qgroup expansions,
>>    other than completely rejecting the qgroup tree and failing the moun=
t.
>=20
> I don't see this patch in for-next but it seems OK for merge.

Mostly because Sashiko still has some complain about the over-strict=20
checks on the flags.
AKA, any newly introduced flag will be rejected by this check, causing=20
mount failure.

>=20
>> +	/*
>> +	 * The version (1) hasn't changed for a long time, but even if we
>> +	 * are going to support a newer version, it won't suddenly jump
>> +	 * over 255 in the foreseeable future.
>> +	 */
>> +	if (unlikely(btrfs_qgroup_status_version(leaf, qsi) > U8_MAX)) {
>=20
> Why is it U8_MAX instead of 255 as said in the comment?

U8_MAX is exactly 255. Although for the consistency I'll change the=20
comment to use the same U8_MAX.

> I understand
> that it is for one byte, although the structure has __le64 for it.
>=20
> I also don't expect the version to reach any high number, the version
> for such item is an outlier in the data structure format, we usually
> guess the version from the raw item size. Keeping the version inside
> without any reserved/unused filelds also make it pointless. The only
> meaningful way I see is to split the u64 to 1+3 bytes with 1st byte to
> be the version.
>=20
> Actually, looking to the history, commit bd7c1ea3a302ab ("btrfs: qgroup:
> check generation when recording simple quota delta") already increased
> the structure size, so we don't even make use of the version.
>=20
> As it is now it's basically wasting the 4 bytes and we won't increase it
> anyway so can think about how to scrap it completely and make the test
> stricter.

I think the version split (1 bytes for version, 3 bytes for future=20
expansion) is the best solution.

Then I'm totally fine to drop this check.

>=20
>> +		generic_err(leaf, slot,
>> +			    "suspicious qgroup status version, has %llu expect %u",
>> +			    btrfs_qgroup_status_version(leaf, qsi),
>> +			    BTRFS_QGROUP_STATUS_VERSION);
>> +		return -EUCLEAN;
>> +	}
>> +	flags =3D btrfs_qgroup_status_flags(leaf, qsi);
>> +	if (unlikely(flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK)) {
>> +		generic_err(leaf, slot,
>> +			    "unknown qgroup status flags, has 0x%llx unknown flags 0x%llx",
>> +			    flags, flags & ~BTRFS_QGROUP_STATUS_FLAGS_MASK);
>> +		return -EUCLEAN;
>> +	}
>> +	if (unlikely(flags & BTRFS_QGROUP_STATUS_FLAG_SIMPLE_MODE &&
>> +		     item_size < sizeof(*qsi))) {
>> +		generic_err(leaf, slot,
>> +			    "invalid qgroup status item size, has %u expect at least %zu",
>> +			    item_size, sizeof(*qsi));
>> +		return -EUCLEAN;
>> +	}
>> +	return 0;
>> +}
>=20

