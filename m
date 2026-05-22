Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AC5221275;
	Fri, 22 May 2026 09:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779442234; cv=none; b=oaJbr8UmiJL0NCBfmWKSEjQhpLxfkCDQ0Iw9rBg5Ab6TOgJQdWBAAxZJonIQp4oZQE35m95CeQ2zoP5fL+9C6AVncIBfd4a2dzo1ru1ypG6xJzbJYVl37J/yKkejxTFj9KOO63H4NsRj7lbyKz4YAwOADAI51z1aQ03Zx+Nt/xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779442234; c=relaxed/simple;
	bh=akFk15oRsgzZszhGfG+/usO2D9kSPbyYL4ZK3eOl01g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owGFqsJDpjZgvN64dyARhSigqYmvGsBVNht8th5mh2krXLKT9/IO45w17e0u+Y4+W/xO6fsIXo0fqTaJC/0G/Am4Rh56rhIk+Q9brHMeWD08GedrMBV9GqSAEI298azJK9UdhoLmk6SjL+JP6Hs3u3U7CsiJvhbudvb+/mxWvT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=bEgiWEFY; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="bEgiWEFY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779442230; x=1780047030; i=quwenruo.btrfs@gmx.com;
	bh=Ci1und1S65U/SqG95dg4M7x5TEHw+z0CfcGoGbJylyU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=bEgiWEFYe4tVllRxCzwDEJeWti/zTRGhli1pKNKd8B41lHMtQp7KgKJ6rCmIvJY4
	 0TNQYnp/yw1hx/scriH+A73sHJnZl7cP7v/mYYnW9Q47QUwM5gujObNBIlR+zadW6
	 Sl7So9/RvDV9wkliJCCXIvYUn7G8qSxrxaAfZPcYP149D538hqsYsgigIO88qN9Hv
	 QpE47sFIoyBtaAdW40sKhhNzXqARGbf6+xvuqJ8Qbxek9KLJ2T2VHJ+lv2M6dyeab
	 g0vuqU++HjgDsIQluNc1mY6Qpct7DXx4xWDfRUHKeZeaSMN/kp+VbRPY1iXTxHPoT
	 qvFJYmY/4yLKfb3fwA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MWRRT-1wpRKY1xZT-00R9qS; Fri, 22
 May 2026 11:30:30 +0200
Message-ID: <a8de8d07-d262-4f91-96eb-473fcded6549@gmx.com>
Date: Fri, 22 May 2026 19:00:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
To: Christoph Hellwig <hch@lst.de>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
References: <a1d63733465229936351804f3760803d5894a962.1779274630.git.wqu@suse.com>
 <20260522085211.GA6702@lst.de>
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
In-Reply-To: <20260522085211.GA6702@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dSQqhJ7gveu+wbk/HVzb3Ft6wHD0GXmWgX4bjJ5TP3OCmpXYaih
 803vrJr+AegVJL7SZsvAFZnzp++IsmA1dKz4lGdis8BE2X9LCOkzhz0tAloi15C8MZaFdiW
 IMyYULnLio64OQzxc/ABCXjVVF4W4UQecwDS7R35ENzQ5d5sdn31KefBZleBwRt13tgqojJ
 GaPhnTp9i3CP4vwDAFArg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+Ksnpzp6V0Q=;kUewY4ER9ocH64upVaNdCOCxjCA
 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
 3aQmqaizzINC7F3ryBESqkm20TA=



=E5=9C=A8 2026/5/22 18:22, Christoph Hellwig =E5=86=99=E9=81=93:
> Hi Qu,
>=20
> this does looks sensible to me.  Maybe add an xfstests case that
> exercises these using loop devices?
Sure, I'll add a test case to verify the single-data-RAID56 behavior for=
=20
btrfs.

Not sure what specific workload you may want to verify, but my planned=20
workload is:

- Create single-data-RAID56 btrfs
- Fsstress it
- Unmount

- Mount with one device missing, readonly
- Do a readonly scrub, should be no error
- Retry with the remaining device(s)

If you have something else to add, I'm pretty happy to add.

Thanks,
Qu
