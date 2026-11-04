Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780109;
	b=aCE8+Mrp4AUdv2rvlUvJmVHlSdcgoToQ5SFgIgywlZ41qz59dOkZiVGlhBObh6QCL2bo
	 YhzlRmnBttA7f7oLhdeXBNvsM+Bt1jiXBSaDed+SThmXFsmNAxv9R/pIc8erSFEJdqJdD
	 5EJPd2bwbsjIWPaV+ghrRzIGMJiYkyQh/20x9ReDNY6Wwwqn2iX2vHJxXraN4AOG6Vlxa
	 F0cKaGOxQq/lAlpD1PwyfBV4j76BwCgjbnjPNudsTn4rvz3TupBg+NyBcQryUxtRF/+jW
	 Rw1UI6QkecqofIjfXot0cZFRxvwtq7E7Hnmlw+Y+4biidZoTAzdzJ0kEAl7FqLx9K2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780109;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=Gja9q0IsLz2kzUvfCHRVGuyBSDRo0orVfOlCaaUIPL4=;
	b=VgAHUHm6BD2XlE9TouYSbRKb+4SqhzBGzAYSJxoWP/HjouM+kSIJuQozTROo8vvkUgdi
	 TNaW+B5JO+nUFV9C/IwAHAwJpPqCTFvW/8spzjNjYmlKLM1iwd6/xSMOqFy9Fx5/PAwlB
	 CfkCWYCNTs9mWH8j9FXRIrRoZlWbr1v2RSak+y1TQiWB5oRRQJhB2KXwaE2Kd4vb7rDwN
	 p7HZZqHFKkkfnkcYUQzI+f736WDHNbX1DVL3rOoA1CskduPx2JyiT6xImYGq+0S6aB5vr
	 XDrl2izngzuPg2CIxEzmNX3wHEU2ORYhXw1DjlgJZhyCYhOLstsm3kP2i9m3Otx/qrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=tzkPkvCP;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B863606A32C
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 08:15:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B863606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=tzkPkvCP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793780099; x=1794384899; i=quwenruo.btrfs@gmx.com;
	bh=Gja9q0IsLz2kzUvfCHRVGuyBSDRo0orVfOlCaaUIPL4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=tzkPkvCPCSCYS+rkbaQG2+w65dGehO1k6Ru2ro/3o20uZwbvc0Y2sFwLW34tyqY8
	 oWnNZyaY1gQPdhOo2frlItwkAKkN5XteTSzfilKP9NpU0gZ5YeDN7DZ7bUqA8e/XT
	 nErtx444aCKHq8mgYZ/s9fBX8fCFN3EXpr2yBJVoW/ysXU33gCkhN0Q9MzFF99xu/
	 0GicXWxXxh9XAPfOoKwXJDnJvJ5JhOuPjCs735o6Xo3vvgH/wjHov34inXEX7NJOQ
	 hmRjAW8zSYgZngxpS/VrVTSAy/hNBBVprdPUmUMgMvxO+L9gnC68Wb1u3kxNfDBgG
	 VVt7jVWSqE+77RJM4Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MkHQX-1wePhS0Jgn-00oHky; Wed, 04
 Nov 2026 09:14:59 +0100
Message-ID: <514c3590-27bd-42e0-b248-ec422a58e502@gmx.com>
Date: Wed, 4 Nov 2026 18:44:55 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] btrfs: wait for encoded writes in fast fsync
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
 <aurorIaI3EAocPQE@infradead.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <aurorIaI3EAocPQE@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5M7FZWaOHm3sK55JXWJWcu8xONzqYAlIIHdXxUoK38b/nFpMNTY
 4azNmURHcC5VPCER+kx1yVPlKxnTRlrc0Hya+qaZwWpHLwrANAMSqOJGWkSApBmGglaRAn8
 Sf1hsCGlyKkk2SHPJPQmo9c9zmIlbc9BlEt6uGkeqchh4QL0uvYXqL+Fm2OLUuk+S0be7Vj
 ZNwf8BZI5wOBu6xEWYZlg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:S8rug4eaOU4=;+1nvKfzfltpQBlnxzGdm+KiRGJ4
 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



=E5=9C=A8 2026/11/4 18:41, Christoph Hellwig =E5=86=99=E9=81=93:
> On Wed, Nov 04, 2026 at 05:40:46PM +1030, Qu Wenruo wrote:
>> This is only covering encoded IO, not direct IO.
>>
>> As we should not mix direct and buffered IO in the first place, fsync()
>> definitely counts as a function in the buffered IO family.
>=20
> It absolutely does not.  fsync/fdatasync covers all data and metadata
> changes.  It is a fundamental part of O_DIRECT data integrity
> operations to write back metadata and to flush disk caches.

Even if there is a direct write in the fly? How would you even detect=20
it, there is no dirty page cache in the range.
