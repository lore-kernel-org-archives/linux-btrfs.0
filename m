Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20550231A3B;
	Thu, 20 Aug 2026 22:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787264095; cv=none; b=gF8Vo2JRH++PC+lqX55DB/gpZgcD6aL5MIlg2Z3ABvgKb8QmVXMh/hQjr2kkvN/92wl2C1CGmPytIyN1dLYCQ0EOj2TBqXX3gg7dYRDcN3jFcSYfqAGh50I+UmoWwKjSbhmz4/asMdW7nW70RvEmcc5iI63HtMzRHS+3zBRhBUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787264095; c=relaxed/simple;
	bh=LFyZzoVMiz4XqGLmoaESpangDvCLD/JHcK3FOKCsxRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQhWfXiNhh10XGZVEqTp/NiUxOLqssYTJacnYsdCfBNSblEk1pDeL8PC0T10VZCdPAgOSbGcW2sq0iZbDEK1wa5u2jfDOVDmEQdqYyKPWfMnivQM3uEPzbcnZrCkO70pzaGT5XA9YRAyaeFO/bD6hMxhqKLG+fcqAH2Gh3BkTqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=jlfguXHj; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="jlfguXHj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787264084; x=1787868884; i=quwenruo.btrfs@gmx.com;
	bh=LFyZzoVMiz4XqGLmoaESpangDvCLD/JHcK3FOKCsxRM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jlfguXHjpSTcTYmY8JPUfuO0U9bBhvHty166khIFBvrI2gcHVNWZBsEU3e01Sc6Y
	 /vMyqGvX2+LSpV+ucP6BzbSxm9txKv2wtP7pv1zGFzJLaY26VT0h7QYqHmJa9HLT1
	 6tmeJPZImZtfCzQVoUtHHYKZ0/ZNY2CPLzfDFQbCt512b/5UoJskNp2ZHjKUtdUYO
	 F5PJ30SckdEfQQGjTOLx0PUNzGveFpo3MDkTFl05bxOe3VPwWZVY32TtnZsIBwdJq
	 FTDr8ueiNn5hUEv103/IEuhe2VTRRh/beXpX7rO7b94RDf+yxoZwqEiJItRkOM2oR
	 60GXDJWU4GKnXXlBWQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mq2nA-1waiWM0x3C-00hc3i; Fri, 21
 Aug 2026 00:14:44 +0200
Message-ID: <4624cca9-6bca-4358-a29f-63f11224350a@gmx.com>
Date: Fri, 21 Aug 2026 07:43:53 +0930
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
In-Reply-To: <20260820120428.GA9053@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ykmkcBYY74IGteaE3qOrsc4YsJ6COIOZRuPjEnS73Mf9KRiiAxQ
 TOht7iVms2+2zK9IGGM8k5UUByLN7qG0PbiYIJchkg5kWvh0nPDlqGxeVYUV7mNLCabVNGu
 3pxp0IGgJTFwF1ay7iFtHY/E498ptgik72vCN/s6zQpAchQTeQyi4DY/7jms8cXdpsoaiDz
 4Ps6cSaOvin00RHfljVQg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lVreVC3EVx0=;bs5ZCoNVl+IejJnTsQB4pqReRK2
 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
 0ucXN0ig==



=E5=9C=A8 2026/8/20 21:34, David Sterba =E5=86=99=E9=81=93:
> On Tue, Aug 11, 2026 at 02:14:54PM -0400, Jeff Layton wrote:
>> btrfs_insert_orphan_item() allocated a btrfs_path with btrfs_alloc_path=
()
>> which returns -ENOMEM on failure. It is called from btrfs_orphan_add(),
>> so a path allocation failure there turns a recoverable error into a
>> transaction abort.
>>
>> btrfs_path is only ~112 bytes, so allocate it on the stack instead.
>=20
> 112 is too much for on-stack, we've avoided that for btrfs_path in
> particular, except some justified cases. This means in general the
> beginning of call stack like ioctl, syscall handler and such. Otherwise
> we assume there are other layers in the IO stack, like block device
> drivers (DM), NFS, encoding layers or networking (iscsi), and obviously
> the lowest level device drivers.

I think you're very inconsistent on on-stack memory usage at least.

You were fine when I was adding 128bytes for several call sites for the=20
support of huge pages, and I'd argue all those call sites have a deeper=20
stack, because it's on the writeback path.

Furthermore, that huge page support is not widely used, but everyone=20
will need to pay that on-stack price.

On the other hand, you are also very hesitant on my recent patches=20
removing those 128 bytes usages.

So your behavior doesn't seem to match what you said here.


Secondly, your deep-in-the-stack argument doesn't sound solid either.

Every block file system can be built upon layer of storage stacks, not=20
only btrfs, but *every* block fs as long as there is a chance to do IO.
This means you're just saying, there can be almost-infinite lower layers=
=20
under us, so we should not use any extra on-stack memory.

I do not think this is the sane nor really validated.

If you want to argue if the extra 112 bytes is good or not, give me some=
=20
data about the on-stack memory usage.
With the proof that with enough stacked dm layer, that extra 112 bytes=20
are going to cause problem.

Not to mention I believe some dm drivers are queuing the real submission=
=20
handling into a workqueue, avoiding further increasing the on-stack=20
memory usage.

>=20
> The trade off with possible allocation failure vs stack consumption
> needs to be argued in the changelog, "is just 112" is not sufficient.

Although I agree that more changelog will help, especially if Jeff has a=
=20
good call trace showing that this is causing a flip RO in meta's fleet.

>=20
> Getting back the consumed stack space is painful, we've been reducing
> unneeded or redundant parameters of functions for years. The gains are
> like -8 bytes here and -8 bytes there, allocation of +112 wipes that out=
.
>=20
> If the place of allocation is critical we can consider that but we have
> too many of them, anywhere during the transaction commit path or
> irreversible metadata changes. Possibly using __GFP_HIGH could work, but
> I haven't explored that.
>=20
> Qu added the patches to for-next but I had no chance to look closely at
> this patchset yet and am hesitant to leave it like that.
>=20

