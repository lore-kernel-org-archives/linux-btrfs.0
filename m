Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CBB3CCFAF
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 21:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788471111; cv=none; b=ibprqk+yUGDoMDqwp+4GwKPyZXHjPXc6lHZM+k0QRfphwRJnK8rVs7T6/gyTyiiPjl6vFH9XuE0kxDBSeFVWLApw3izcHc3SxNkHne6Upj/G7bSEOCuM9RPKf3zESOFf1hl8GVgR24fXfVrqoD9rJkdPcVAnmQwEfNjVvefbzX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788471111; c=relaxed/simple;
	bh=jkYMFTPtsV5i56KG7ZSm78mizs/Um9bUB6ymDHj87NI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=txPLG1L7bgIEtJqgRut8GG0VN6PcPjPSS/KHuqz4NoqjS+6XQf2ZJ1+cHzF56EKMVSI6DEeXeED9KhO3+TyJXlZSUw/alOQYoagpJHD+yO3f1zU6p8T4Nfssj/UVqUzCC674ZAywe4vdFfx6BSLv4t1ISL89qB2I3nnGy4evR6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=rdF7WaeW; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="rdF7WaeW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788471102; x=1789075902; i=quwenruo.btrfs@gmx.com;
	bh=jkYMFTPtsV5i56KG7ZSm78mizs/Um9bUB6ymDHj87NI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rdF7WaeWSLsuxRqubM4eLBtrzAof7mHSDJ6vVAay9jiIMk0WotCLgH/9vjYzbAwU
	 TZPO9ZevSSDPCsIAykKJRKMICVppQLtg/y1YKSZgRu3qVjW5Mq/ezwZ1XyzJFNoNg
	 +TvX0xpB+Vmv6RX1+G1M+N0nNPDiT97rt2RC//Y70QlsJ5gs2V8DLnjV/6Ey5Zg1A
	 ITLAjDuGT9uXbH+ddpdDt4RuQQoVYRHSbZpX0R0U7VjT0HUrOJU7q90KS0svRCEEv
	 bOxw2OjMOTSfYuEbUn/59vCUOrdWJDnfsCYKo5sU7jJfoMezyYcH6UWIbRUZ+isnD
	 mH5ITunECFXDBlhUGg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MFKKX-1x49lE1Nn7-00AaUC; Thu, 03
 Sep 2026 23:31:41 +0200
Message-ID: <c104bad0-4e8e-4f7a-b4fb-d2b8a1a88b95@gmx.com>
Date: Fri, 4 Sep 2026 07:01:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: introduce a new experimental feature,
 RAID56_VSL
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1788417288.git.wqu@suse.com>
 <459e721d-cbb1-4646-8f64-d9a28e50613f@wdc.com>
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
In-Reply-To: <459e721d-cbb1-4646-8f64-d9a28e50613f@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KE5iiHLR/j0qhStmtki8ZiCOuRDKr+9HWAZHCBdxyif4LfkHC48
 gbgIJLLSHmtuXCGcPL+S5YOAuu1bLwyaSaq7kegUoeqACET/dpbzlocD2imYEiuO8tblELP
 eMqJ3zud9ulnCVvqKXNInz1LUxrCcwlPVQ0fan6cPHY/5XRM/n/PhUdpahiZphDURRPg89W
 16/JTsJx0By60oPr6cnkA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kSYU21a4GdQ=;KrEBOlEs9Vp5GiOAT4fmTYDrN6A
 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



=E5=9C=A8 2026/9/3 22:03, Johannes Thumshirn =E5=86=99=E9=81=93:
> On 9/3/26 8:49 AM, Qu Wenruo wrote:
>> The new feature stands for RAID56 Variable Stripe Length, however the
>> VSL part is not implemented yet, thus the whole feature is still hidden
>> behind experimental, and there are definitely works left to properly
>> split the 1st patch.
>>
>> But for now, this series can pass most fstests cases.
>> The failing ones are all related to mixed block groups, which can not b=
e
>> created nor mounted with this new feature.
>=20
> Why not make mixed incompatible with it then?

It's already rejected by kernel.

And for progs (and I noticed I forgot to send the patch) it will reject=20
mkfs.

>=20
>>
>> The roadmap for the full RAID56 VSL implementation is split into two
>> parts:
>>
>> - Introduce a new datasize member
>> =C2=A0=C2=A0 This series.
>>
>> =C2=A0=C2=A0 An fs with data_size 8K and sectorsize 4K will act like a =
fs with
>> =C2=A0=C2=A0 sectorsize 8K.
>> =C2=A0=C2=A0 Meaning the minimal write size is 8K for data.
>>
>> =C2=A0=C2=A0 However the checksum is still calculated based sectorsize,=
 meanwhile
>> =C2=A0=C2=A0 we can still recover each corrupted 4K sector inside a 8K =
data block.
>>
>> =C2=A0=C2=A0 The idea and implementation is not that complex, we're jus=
t reusing
>> =C2=A0=C2=A0 the existing bs > ps support to handle it (on 4K page size=
d systems).
>>
>> =C2=A0=C2=A0 But the challenge is the details where some part of the co=
de still
>> =C2=A0=C2=A0 requires sectorsize (checksum related), meanwhile every ot=
her location
>> =C2=A0=C2=A0 goes datasize for data.
>>
>> - Introduce a new RAID56_VSL chunk type
>> =C2=A0=C2=A0 It will have the following requirements:
>>
>> =C2=A0=C2=A0 * Can have up to (datasize / sectorsize) data stripes
>>
>> =C2=A0=C2=A0 * The number of data stripes are always power of 2
>> =C2=A0=C2=A0=C2=A0=C2=A0 This is only for every RAID56_VSL chunk, users=
 can still have
>> =C2=A0=C2=A0=C2=A0=C2=A0 whatever number of devices in the fs.
>>
>> =C2=A0=C2=A0 * The full stripe length is always datasize
>>
>> =C2=A0=C2=A0 This allows every data write to be full stripe aligned.
>> =C2=A0=C2=A0 And for read repair/scrub, we can still locate and recover=
 a single
>> =C2=A0=C2=A0 sector inside a RAID56 stripe.
>>
>> =C2=A0=C2=A0 This is less flex than the traditional RAID56, which has n=
o limit on
>> =C2=A0=C2=A0 the number of data stripes, but has the write-hole problem=
.
>> =C2=A0=C2=A0 And will require users to determine the maximum device num=
bers at mkfs
>> =C2=A0=C2=A0 time, without any way to change to another datasize.
>>
>> =C2=A0=C2=A0 But the second part is pretty easy to implement.
>>
>> As the digest shows, the biggest problem is the first patch, which is
>> touching over 200 sectorsize users, and is definitely the source of all
>> bugs I hit and fixed so far.
>=20
>=20
> But this is still all !zoned RAID56, isn't it? Or did I miss something?

Yes, all for non-zoned RAID56.

