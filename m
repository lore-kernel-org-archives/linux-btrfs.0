Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51CE3CF699
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 07:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779693386; cv=none; b=JbIM/bYwsOez/g+F4SXtWNIVPKKgA9CI5FMo8Gx8PIGSOb3vvfuuGevxNMTZRE4IVCsoB4Uj9MGA9nOKq42C/41+cfPX9xG9ymkA3eacal66Ii0qyTQ5j0nEtj68mttBsv2c85yHBd+IB0ybCs3h1q93J5ex4oxSAM33X5orzk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779693386; c=relaxed/simple;
	bh=yJSKpCPVynUyCXoTyCleTJgZPwXhmgCEipx/Dc+Wy80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U5/ywbVnPb6oadgSSv2Sb4O8M+sNaYK7qVhQ5LjqHUHs6bcIaO3cjzxwcj6jc/UDMh+GVjTvVkxhJ8OWXJyljISAE2GamiRqVDVv4mXbCSwkQtdklt2IlKK62c0mV+hKzsMiwW0QazidpOYFn+xsLcUDtZDkXxzyX2Rr1fDL5B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=h0vpqTTv; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="h0vpqTTv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779693381; x=1780298181; i=quwenruo.btrfs@gmx.com;
	bh=fiC1AkoqYr76CGoBv8Odbziep24Ia7RLVVxgIqAUmds=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=h0vpqTTvHB5v7y7WxNyowlIVW1qB91i+KaGNXERIEJnDujL/wbkSWOO6wc6+a5Oi
	 IL+ttV645v94DTStA6ccC9Chkn6//b4/c3SMKp6963hi4proySw6eDkVHl37NF2o0
	 bpUP+MaQ+pGSW+MHswinv4rs+AyJOSBz6D/2eWZir2axlNJ+iRaMysNw2bL4SaPAg
	 oHnlaWH/QZutiTT+dWYVuhu6vu54LTEZc2Txd5mmFyAQuhvEc9Kch0KFsmqEIA+pC
	 DAk2R7HeC4spjxxDQqys+vrtpyta5u0ydteiAYJwegKwSwe0M2k41Uny1hNSVSEkb
	 +h+tfozJtdh2OiXQCQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M3lY1-1wQaCV3qLr-00GYHJ; Mon, 25
 May 2026 09:16:21 +0200
Message-ID: <6ff25e6e-ee87-4708-8a86-e4d982edc2df@gmx.com>
Date: Mon, 25 May 2026 16:46:16 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
 <ahP0yXND64FAOsCV@infradead.org>
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
In-Reply-To: <ahP0yXND64FAOsCV@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9aUPIX4CI3Cp3u3ydMsLvPhvrlYpxGAwcPaojWc3kfdS73DXHKu
 giCx3nq3+LuBI3qpLpjf/rYBAZhvXe5eST6u+XYNfm/F0dDshmGJ5FDoe2nkCfsM4ddCA0P
 vglUjEpFvEjnyqWSociIFjPIJ0ud9rMk2LgjfpwNOF++7kVfshWyupTPNa8pi1plo0o9BJe
 o0qHsBYvCBxgKM+eH0IFA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4tyPnMHb0Qg=;Tn8hkIOKPVGQWYJF4AJa1pxgU4t
 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
 qxnynubTPERznqoFko=



=E5=9C=A8 2026/5/25 16:35, Christoph Hellwig =E5=86=99=E9=81=93:
> On Mon, May 25, 2026 at 02:35:33PM +0930, Qu Wenruo wrote:
>> +	struct btrfs_inode *inode =3D BTRFS_I(file_inode(iocb->ki_filp));
>>   	struct btrfs_dio_data data =3D { 0 };
>> +	const u64 data_profile =3D btrfs_data_alloc_profile(inode->root->fs_i=
nfo) &
>> +				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
>> +	unsigned int dio_flags =3D IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIG=
NED;
>> +
>> +	/*
>> +	 * Userspace may modify the buffer while DIO is in flight. With
>> +	 * data checksumming this would produce a checksum that doesn't
>> +	 * match the persisted data; with duplicated profiles the mirrors
>> +	 * would diverge. Bounce in those cases so writeback sees stable
>> +	 * content.
>> +	 */
>> +	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
>> +	    (data_profile !=3D BTRFS_BLOCK_GROUP_RAID0 && data_profile !=3D 0=
))
>=20
> Should the 0 here be BTRFS_RAID_SINGLE for better documentation?

That BTRFS_RAID_SINGLE is a special enum for iterating btrfs_raid_array[].

Meanwhile for bit flags we do not use that enum index, even if the=20
values match.
>=20
> Also the old code only did this for !BTRFS_INODE_NODATASUM and not
> raid, right?

The old code also does the fallback to buffered for raid too.

That's done in commit 7c2830f00c3e ("btrfs: fallback to buffered IO if=20
the data profile has duplication").

>=20
>=20
>> +		dio_flags |=3D IOMAP_DIO_BOUNCE;
>=20
> Splitting the data_profile check into a helper would improve readabilty
> here.

Sure, will go a dedicated helper for that.

>  Maybe even as a prep patch before the actual change, then a
> patch to add IOMAP_DIO_BOUNCE, and the extension to raid as another
> stand-alone well documented patch?
>=20
> Also while you touch this, you should probably also check the
> bdev_stable_writes similar to XFS (probably yet another patch).

For btrfs stable writes =3D=3D data csum so far. But we do not have any bd=
ev=20
stable writes checks, thus it will be a pretty huge change if we want to=
=20
take per-dev stable writes into consideration.

Thanks,
Qu
