Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761123859D7;
	Tue, 17 Mar 2026 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773782820; cv=none; b=bQGVpwfLWpA/LHlBXqv74NqorhcyuMzT3nk4xxVBvIFOCVnK/jFz4SlhB0s5MNH3bryrOcp5DsaPR5VszwgM3PILZ3usbc7aZ9i9ZTPs6R4IZn2qSoWVMmriT85N/V34xI2F79XK2N0k2m1a7fY0c46wEbgfW1xZbaxjh3DCAIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773782820; c=relaxed/simple;
	bh=LCAw327GeX32SPS6pBsHNJ6xiqVstVI2j6KTNBf+JyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enzz9O93ucm0RBY48VFO+KQxwJWBAiUVqX+hXId8I1Ibb6xAmfEAnVysOMTZTxoilrPag+QdY/UR6YePtCnuv4X8OHbRpxkxleWHzhhSYB6eOzRM+In4l+Fv53gjFiNEf34Ci0ckSm1asIdUiMlhNb6ELQOHijFEJcY1XdXzRBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Eyh9soFx; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Eyh9soFx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773782814; x=1774387614; i=quwenruo.btrfs@gmx.com;
	bh=826oPLNa2wqAwk9+enUB+Bj+j5ZtLLCl078gMG10Sug=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Eyh9soFxrDTMWenG8lxL0JYJMt5YtXuMRviPjdgam7ArZmPwicpMTcMgbH4JXLK3
	 StXz6hMzfr6x4b+2M+FEif0SNjhRmtLnxZgdRZHOrqpYKixYp/TLQMV5b5EobS+ak
	 qZlPAjm7QLBYAC2m4bBwRtGbFliJfdfsSxrzkjEGA0MN84gXZBUNeH8VEWA3geAg5
	 qG87r7eW7Nc45Mq64HNWlGbdyzEGgRvcWd5NdYsBPvOHMWNUOK+XjKkkQCpxRlZLE
	 jvC2LQ8CTfpSA775gNZqoyQWohYCSnOSQchELefp8NaZP+4ZmXvqGjsyedy98TcGb
	 d6M78AJSRghlAMsn4A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M26vL-1w08xg3TZp-00DBLB; Tue, 17
 Mar 2026 22:26:54 +0100
Message-ID: <b44dfabe-32fc-4ced-a000-cd05893b00e8@gmx.com>
Date: Wed, 18 Mar 2026 07:56:49 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: zlib: handle page aligned compressed size
 correctly
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
 David Sterba <dsterba@suse.com>,
 Jean-Christophe Guillain <jean-christophe@guillain.net>
References: <ab5c12312b275589abd42c47a0c34b7e68375407.1773389056.git.wqu@suse.com>
 <20260317101157.GS5735@twin.jikos.cz>
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
In-Reply-To: <20260317101157.GS5735@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:d8F1TOhxVAczqYkvh01PFDzGyEhmqtB/A39Hbf0+jYF0Pq8rlx1
 roBXkT7FkEVmIp5JJguRjgxYhmodxteOJFt1yMyqCdIKqXndAo/+eaXSlMAQWLiUS0qR51I
 Y9ZTqiqBUygV+gdUQ/EwwfOG9JwqSt1SGJo8u6IFx85GQ1jk9nWcgVTfHMyxhcjuYRDDEMN
 bH7ghQYcbP3EfnvdIVd/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cPguwzXBKbo=;8SyvCtxeoztN8yGoEZcjCWdcbZb
 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



=E5=9C=A8 2026/3/17 20:41, David Sterba =E5=86=99=E9=81=93:
> On Fri, Mar 13, 2026 at 06:35:26PM +1030, Qu Wenruo wrote:
[...]
>> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
>> index 1a5093525e32..147c92a4dd04 100644
>> --- a/fs/btrfs/zlib.c
>> +++ b/fs/btrfs/zlib.c
>> @@ -308,7 +308,9 @@ int zlib_compress_bio(struct list_head *ws, struct =
compressed_bio *cb)
>>   	}
>>   	/* Queue the remaining part of the folio. */
>=20
> Maybe update this comment with brief description of the tricky case.

To be honest, the tricky case is not tricky at all.

It's myself considering large folios and bs > ps cases too much.

The new code is in fact more straightforward, if there are new output,=20
total_out - bi_size is exactly the length of the new output.

And the output length is already limited by folio_size, there is no need=
=20
and shouldn't use offset_in_folio().
The offset_in_folio() looks sane on a quick glance, but if you put all=20
the corner values (0, and folio_size) into it, it only passes the 0 case=
=20
but not the folio_size case.

So there is no tricky case in the first place, it's all my fault making=20
things way too complex and shoot myself in the foot.

Thanks,
Qu


>=20
>>   	if (workspace->strm.total_out > bio->bi_iter.bi_size) {
>> -		u32 cur_len =3D offset_in_folio(out_folio, workspace->strm.total_out=
);
>> +		const u32 cur_len =3D workspace->strm.total_out - bio->bi_iter.bi_si=
ze;
>> +
>> +		ASSERT(cur_len <=3D folio_size(out_folio));
>>  =20
>>   		if (!bio_add_folio(bio, out_folio, cur_len, 0)) {
>>   			ret =3D -E2BIG;
>> --=20
>> 2.53.0
>>
>=20

