Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797C3BAD82;
	Wed, 20 May 2026 08:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779266494; cv=none; b=jo2Th0cyw1VLkenF4uTS08BZGx2q9g5HulfTLrDl+hpc5PDIR5oUbFRngB173vbqa5fq8HY48slsAXLsg83hUepuAoOiJWZkxsPzcli6rPg4PfCSfmotQN8BXD4wNFXlvwEpA7cu7VaWgaj/nVdeXmXE3gNIrzq+rT/6hvqppbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779266494; c=relaxed/simple;
	bh=fMqNJlyV039u9ohm5+AApuHgWMYmRF2q9wy82/juDow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YYPHNYDzj3CALn6Sp+tcoyiM24WYg0k9vNT9EoAoVjgdieqMJy8/hjcCQdkBgWn956FpQfA+crQ0lXmBGkuWbZ4Efp0ToKx2AdC2FR03BZnA9Yu01KsJZ9AW7zcBXPVdM/dTeOkQo2bA+KdKe/p2fTQ2go94xLRKNX8grCfD2sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=EvpRYish; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="EvpRYish"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779266490; x=1779871290; i=quwenruo.btrfs@gmx.com;
	bh=KVGbQSGJqboMkQGEaBuh2n5D9Rw1MUG1r1v6327U8ig=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=EvpRYishcdZk67Wh9wQNUukQEGSMTh3LeuhbPSXJ2qlRtFUX0HnzOMz9+4Zr6Qj7
	 gnjQdK9oPj03fT+wBBsNd85hBqjAvkJZyWR0MrSrIJjd89wAoaXK549bm4yU9X8FD
	 1j2Z1ScTWcYRQrDtBB967afu8jjJjTnXJPZ0ts/A39IxKeTXh3U3ONbHA2vybY/Nj
	 AgKhnNiHHdtgn8c0zlPAcXysh2EquxJ8FG4mnF7CK+bwR0akDtPLghlyl70CFX01D
	 VrLq5JnLQ5x0W5aP711DNi8q4HG5ahPNDJ5y3ZNcrzqHLuQsRuXnSpK19p923QYsi
	 dvaXtRVt/ztAg3bKxQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MZTqW-1wtkYJ26tS-00KAV0; Wed, 20
 May 2026 10:41:30 +0200
Message-ID: <f46636c8-80ba-4802-a6a0-74cbc35e7bee@gmx.com>
Date: Wed, 20 May 2026 18:11:09 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/19] btrfs: require at least 4 devices for RAID 6
To: Christoph Hellwig <hch@lst.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kreijack@inwind.it, David Sterba <dsterba@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
 Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
 Li Nan <linan122@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-raid@vger.kernel.org
References: <20260512052230.2947683-1-hch@lst.de>
 <20260512052230.2947683-2-hch@lst.de> <20260512114231.GG2558453@suse.cz>
 <20260513054742.GA1018@lst.de>
 <0a8d1ff4-f5a2-49e9-aa45-d25dbe4ded40@libero.it>
 <20260515043705.GA3855@lst.de>
 <34C16854-1065-4542-8836-DDED58EC1844@zytor.com>
 <20260518051207.GB9374@lst.de>
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
In-Reply-To: <20260518051207.GB9374@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dvYkZM9TiFDCY/a0OvC9eApZvlSwcJd3UwtLDS5MwAZMjs7M4Nd
 LicIaUhdRQfptJSOREFXlXXwIu6efRES75IROjxURvlDWzg8rXGNi60K4CTQXbKTh9THL/c
 wJ3/QeMKkDZW8kmACTTO7VjjFLSoLau+o3l06KjnXZ62BokkLWYoMVcl2p/DM4z+IpoUtZb
 i5VmwtojDyLUB+n1WFCOg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nxybJh+AjPQ=;zxC+YYRPhBUn8mdIUZXysQ0mHvG
 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
 KgyfcA==



=E5=9C=A8 2026/5/18 14:42, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, May 15, 2026 at 12:59:34PM -0700, H. Peter Anvin wrote:
>> I don't think this is a good idea. Error out; it is the btrfs maintaine=
rs' job to ensure user data isn't lost.
>>
>> The RAID-6 code has *never* supported only 3 units, and if it ever work=
ed for *any* of the implementations it was purely by accident. Speaking as=
 the original author I should know; this was deliberate as in some cases t=
he degenerate case (3) would have required extra trays in the code to no u=
ser benefit.
>>
>> I would not be surprised if the kernel crashed or corrupted the page ca=
che in that case.
>=20
> It does, that's why I wanted to exclude it.  Anyway, for the about to be
> resent version I'll drop this btrfs patch over the stated objection and
> will otherwise not change anything.  This means the (IMHO hypothetical)
> users of this configuration will get a WARN_ON_ONCE triggered, but
> otherwise keep working (or rather not working) as before.
>=20

For the btrfs part, I believe I can get the current 2-disk-raid5 and=20
3-disk-raid6 to fallback to raid1 inside btrfs.

I hope the btrfs part can be finished and reach the next merge window,=20
but I'm not 100% sure.

What is the planned cycle to merge this raid5/6 cleanup?

Thanks,
Qu
