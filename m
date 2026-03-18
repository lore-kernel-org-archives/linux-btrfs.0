Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850DC230BE9
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 03:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773805383; cv=none; b=SPYZ1fQfWsijwGRdj5Kdi3uj0/z2JzXLBqWpWYIvetklQG/HjSnYYQVA/goH4ZJ1AlH5VfGbiQ74HefOOkECjvmo+3BXeVwgreMd7Ufz6g+X9qga1Zot/KA3w8bDQkZNTmo6/WT8F4IiLqzh/VbrzEo1FfhqGPspoXty5kVwrFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773805383; c=relaxed/simple;
	bh=MRU1N4/sQixV2UFz5SaX7ugYGNxTVReIzWAO/zT75K8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oK0+N/oULP4PcarWi+z6WglNXTUglFTiLRnNZH9e1inOjAf7gMYSDwu3p23scUx0A7kULCGIExPuSY0b7mhu3oYZ+99aqPhk6+4IP5MyaLTACPU2Y25q/3FmB9z7F74Yl0jp5EwlkXFQmb9t/c3Lq1CMS5iCXYXeBZdpsxAdUWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=BdWewMTv; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="BdWewMTv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773805375; x=1774410175; i=quwenruo.btrfs@gmx.com;
	bh=abYQDO78q4117Ag4maptGcwph7cWnKQj49i9HLgizcM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BdWewMTv4JxfZgXErHfLPOU7ll0N1beLOucS+vxP9VoGtLK3pJolOSkraKYc/T28
	 hl2TRhusFtf30hrHYupiRzEHbQ0VGZtveIU9gvfxBKP6jWhSEeYA39HC3/tyEb6LP
	 9AiDLrUNQDRCYlsERYwDY6JPjcacDGg51OCrCLHrmmY5jJEWkcov16ch/lUqPVbW4
	 jyK6d277WHys62W6gvWmMmVUZDZN0t4dh2t5p1uRY7goxuldm4bKL5xLFBN8iddmB
	 Fg0xbauzuE50MOhDlt6kKG+v7nZbRTunDWvf2ad6LKhGrClrvsM8mqNF/Zq5eO7CD
	 9PYV35uDV3r1a5vvhA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MXXuB-1w5nft2KDP-00LshN; Wed, 18
 Mar 2026 04:42:55 +0100
Message-ID: <ec6daf90-7ebc-4468-a0bc-a3c0ef87f300@gmx.com>
Date: Wed, 18 Mar 2026 14:12:51 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: qgroup API cleanups
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1773776354.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1773776354.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2aDM5ATXm3U7c7swUedYP/oA5MCplLJ+5clWQRe+kaBxqLMbF72
 86PW+XEaz4RymdldKbCVwPMf5Em9zkIOE9ftTMtOlQ3QTlcPokxpmfFRMkIVkcDW7w8tTdO
 BJZZYvDMClEqV8BA6omqgzDGYJjxgILzCRaZXWz+ow1dc+P05VOAeB+0IZp5qmhuy7+Y8Nj
 MS0ufDogDy0Gd2I0Amebw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SYmtdl1e+t4=;By515F4aljQdY++ru6iNmouQXfF
 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



=E5=9C=A8 2026/3/18 06:16, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> Remove some unnecessary qgroup functions and exports and make the API
> simpler.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Filipe Manana (4):
>    btrfs: removed unused qgroup functions for pertrans reservation and f=
reeing
>    btrfs: collapse __btrfs_qgroup_free_meta() into btrfs_qgroup_free_met=
a_prealloc()
>    btrfs: collapse __btrfs_qgroup_reserve_meta() into btrfs_qgroup_reser=
ve_meta_prealloc()
>    btrfs: unexport btrfs_qgroup_reserve_meta()
>=20
>   fs/btrfs/delayed-inode.c |  3 +--
>   fs/btrfs/qgroup.c        | 27 ++++++++++++++------------
>   fs/btrfs/qgroup.h        | 42 +++-------------------------------------
>   3 files changed, 19 insertions(+), 53 deletions(-)
>=20

