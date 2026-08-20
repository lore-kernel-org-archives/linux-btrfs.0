Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF7437EFFE;
	Thu, 20 Aug 2026 23:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787266805; cv=none; b=h5UtSn1YxIOodsxMFA9dChAPlP4kLhPKkdvZw5xXs0BRRdtLVLbRgtDO0c8sahnLBMovibJSn+J1zgSU1QuYe09MvDcgXBx4jhd8WRJ0ivPP2xF7JaR0I4jOrJoqCiICHPLnsErPdWTbQX+KZUx+ypx1Isi2qw6i2IWupwnviyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787266805; c=relaxed/simple;
	bh=sLI16Xfd2435qb9hqm/aVa2X+Xm1L6UkCixwEoJ/s9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=soWUYD07CIddbmX3hUuo6LUCr9ItLeNoweSLVgLAl2M4O2ajQUzX5sl2iEg/Nhk/1yuQZGewKQ2O5SV+B7P1mc3+Ucd+xlGJXgs8R640sKBbeG+8ibahJ95VdeTtmkX8dP+KMaKjsTMSuxBHKLMcPtv6oQ3F5w2Ve5PA8rRrpQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Njg0of8D; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Njg0of8D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787266794; x=1787871594; i=quwenruo.btrfs@gmx.com;
	bh=sLI16Xfd2435qb9hqm/aVa2X+Xm1L6UkCixwEoJ/s9I=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Njg0of8DNF3sdUZUpMilxXubUJZtYL9frIdme/pyisxRt2lGO3u0G+yJMYeObrSv
	 +PTdvLx8y2Ywl3b8vFGD54W4J8v9xfE59OOywhFeH5BNkaQZWPbTf39R6BsXehqNc
	 Kk7ym+jAxAMdMe0VdZS0ILdv/N/9VOcT+gIitCRv9H8Wozo3w2DhgAbk1COWKrjpY
	 So7IOxrFlqr7TFe3FMWj2O9/zQ9OTmnhpLND7mqLSHy3mFLsxbikdKwq6CWFnmJ+b
	 B9XrPpeSJ14y5AosYXUkjOOAAWRDZEDeqIj6feumm61GggBdKVhNDLEUxIAKy93bw
	 410R5FTZ54AwHqpKpg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M1Ycr-1wyZRi1MFP-00AlWW; Fri, 21
 Aug 2026 00:59:53 +0200
Message-ID: <f58e1b6c-e83b-430d-8ef0-fe859e3cd16b@gmx.com>
Date: Fri, 21 Aug 2026 08:29:48 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
To: dsterba@suse.cz, Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
 <20260811-btrfs-enomem-v3-1-46a993fc3fe5@kernel.org>
 <20260820120428.GA9053@suse.cz>
 <4624cca9-6bca-4358-a29f-63f11224350a@gmx.com>
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
In-Reply-To: <4624cca9-6bca-4358-a29f-63f11224350a@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NMKpz7mN9Zpa83LwyRls4CPWqNSNk8rj8CKxMSQQWcLJNa4Dw5z
 NrvZeyI3/rfO7+kiWk4pswC5ZlqogPSE1GfpHImxcvAHtee9XeFK23StXfjnbW4zCDflXCw
 gMJMvruhY83/MjmmVcx9OX/wXFD2am+RRxQh/eQlfvHApuGpjmX8htU3wa+UNMgpWUv0BzO
 nfAhDfS47Zwm+ncupc1QA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fogrWfSuq0Q=;wkWnjI0cJ/mTIe+SFp4wrjNYgnr
 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
 M38UL3QivUnpNRz4tqDNYAB6KvLlI=



=E5=9C=A8 2026/8/21 07:43, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/8/20 21:34, David Sterba =E5=86=99=E9=81=93:
>> On Tue, Aug 11, 2026 at 02:14:54PM -0400, Jeff Layton wrote:
>>> btrfs_insert_orphan_item() allocated a btrfs_path with=20
>>> btrfs_alloc_path()
>>> which returns -ENOMEM on failure. It is called from btrfs_orphan_add()=
,
>>> so a path allocation failure there turns a recoverable error into a
>>> transaction abort.
>>>
>>> btrfs_path is only ~112 bytes, so allocate it on the stack instead.
>>
>> 112 is too much for on-stack, we've avoided that for btrfs_path in
>> particular, except some justified cases. This means in general the
>> beginning of call stack like ioctl, syscall handler and such. Otherwise
>> we assume there are other layers in the IO stack, like block device
>> drivers (DM), NFS, encoding layers or networking (iscsi), and obviously
>> the lowest level device drivers.
>=20
> I think you're very inconsistent on on-stack memory usage at least.
>=20
> You were fine when I was adding 128bytes for several call sites for the=
=20
> support of huge pages, and I'd argue all those call sites have a deeper=
=20
> stack, because it's on the writeback path.
>=20
> Furthermore, that huge page support is not widely used, but everyone=20
> will need to pay that on-stack price.
>=20
> On the other hand, you are also very hesitant on my recent patches=20
> removing those 128 bytes usages.
>=20
> So your behavior doesn't seem to match what you said here.
>=20
>=20
> Secondly, your deep-in-the-stack argument doesn't sound solid either.
>=20
> Every block file system can be built upon layer of storage stacks, not=
=20
> only btrfs, but *every* block fs as long as there is a chance to do IO.
> This means you're just saying, there can be almost-infinite lower layers=
=20
> under us, so we should not use any extra on-stack memory.
>=20
> I do not think this is the sane nor really validated.
>=20
> If you want to argue if the extra 112 bytes is good or not, give me some=
=20
> data about the on-stack memory usage.
> With the proof that with enough stacked dm layer, that extra 112 bytes=
=20
> are going to cause problem.
>=20
> Not to mention I believe some dm drivers are queuing the real submission=
=20
> handling into a workqueue, avoiding further increasing the on-stack=20
> memory usage.
>=20
>>
>> The trade off with possible allocation failure vs stack consumption
>> needs to be argued in the changelog, "is just 112" is not sufficient.
>=20
> Although I agree that more changelog will help, especially if Jeff has a=
=20
> good call trace showing that this is causing a flip RO in meta's fleet.
>=20
>>
>> Getting back the consumed stack space is painful, we've been reducing
>> unneeded or redundant parameters of functions for years. The gains are
>> like -8 bytes here and -8 bytes there, allocation of +112 wipes that ou=
t.
>>
>> If the place of allocation is critical we can consider that but we have
>> too many of them, anywhere during the transaction commit path or
>> irreversible metadata changes. Possibly using __GFP_HIGH could work, bu=
t
>> I haven't explored that.
>>
>> Qu added the patches to for-next but I had no chance to look closely at
>> this patchset yet and am hesitant to leave it like that.
For now I have removed those from for-next, but I really hope you can=20
come up with a consistent behavior on on-stack memory usage.
