Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530892F7EE6;
	Sun, 20 Sep 2026 21:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789940736; cv=none; b=VYT8Ez4EgIkyYE88r+CieJS5dFp14AXZjYXcC7LvO1Gj7RRZ8iI16FS5IbJuLWsNXkOO9wpK3pso+ixBXDlw4ayvYiyfEka9bMiXSRBMdIs/nt/1NElM6n+NOC4Ns2DNta9f6BBH8Vi8sq1mJWpP5Q9SB2eqo42LDNOb+5zg4Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789940736; c=relaxed/simple;
	bh=e+77SU3JtOsN4xZIa8o0x8p58Se0+t8iMmJS4uNFMUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eG/VmVwJSHD5xWo2gdyNQJeSQTLAUt04Pyj17PuzfjZW9Sr3WAxVt2CxFHp6C7VEimOfL7uR6fbicnL9pVqucSqOyfSmEOyBtVL+7UigvjERC1yP2rO28lrwg4guNeto71dBw+BBYeg8lXyIswMM6+ZLAZ2YcxmNoNt1Ggtr14A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=fKlEOpNT; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="fKlEOpNT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789940732; x=1790545532; i=quwenruo.btrfs@gmx.com;
	bh=e+77SU3JtOsN4xZIa8o0x8p58Se0+t8iMmJS4uNFMUs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=fKlEOpNT/sAZgceoqdfqhESSZGtQ9QHH8JtILefAKfcDkUVzv9d5jEvwhZsVPJMl
	 fTg0PKOunIVW+IEZaN+Pd9OsaGj6yNQcJf8ecUppAnJl08FMJI9aoLWluvaO+htjz
	 gjbdbttyhEsDp/2OtnV0WmzyWaET9Z20ih/nQI8N+FT8x80SHX1RwX+t6j0CUyU7r
	 3vGMEecrozsrPCnoNRZOTRYplMDmzvxEWwItI4QD9eI4fDw05bQ0AkQJcVO5KzWuo
	 916Dz9chmksM7rJdsCeRhzAQToHRB94v3h0J/OdvJCfWNhEw1CJjmRCJRHd8azoOs
	 4wR1frze5gJeZXot2A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MK3Rs-1xTnYD1ytK-00KimJ; Sun, 20
 Sep 2026 23:45:32 +0200
Message-ID: <0090e23b-bbc5-45e0-a46e-9a5b2eb2dc72@gmx.com>
Date: Mon, 21 Sep 2026 07:15:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: test defrag --nocomp converts compressed
 extents to uncompressed
To: Dhruva G <goledhruva@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com, fstests@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>, Anand Jain <asj@kernel.org>
References: <d8930005-39c7-405f-96ac-ea0530e9b2c1@gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <d8930005-39c7-405f-96ac-ea0530e9b2c1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FurSKf7o5gwSR6RtyBDy4BHR2I8ZN8BXuxbWGg30kkwmxHLKaa2
 MsjzRUTNwMfMOHXx3642sDXfJe+YtYfQFW7Q5TpmmFc+ZS1wLzh9mbZVCCGiMZ8BO+TSHty
 rNH6FDAEqRsMmuHwJssvCLwrNLPDO4NYBbmnYO2Td7ZPhsvkInepYCK3GSveEqpwisoJhri
 2MjvklQ9KW0nl7mytN7SA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:oTaRSjgUTdY=;nv8pttmO8CfTnWCHrJLUrowk3wf
 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
 PpX5rBGjhnRlu



=E5=9C=A8 2026/9/20 21:41, Dhruva G =E5=86=99=E9=81=93:
> "btrfs filesystem defragment --nocomp" rewrites already compressed file
> data as uncompressed data. The kernel flag was added by commit
> 009b2056cb25 ("btrfs: defrag: add flag to force no-compression") in
> v6.17, and the userspace option shipped in btrfs-progs v6.16. There is
> no test for it.
>=20
> Add a test that writes compressible data in 128K blocks on a filesystem
> mounted with compress=3Dzlib, runs defragment with --nocomp, and uses th=
e
> FIEMAP encoded flag to verify that no extent remains compressed. Also
> verify that the file contents are unchanged after a remount. Keeping
> compression enabled throughout the test confirms that the defrag ioctl
> takes precedence over the mount option.
>=20
> Regular defrag deliberately leaves maximum-sized compressed extents
> alone, as asserted by btrfs/259. Creating maximum-sized compressed
> extents therefore ensures that an implementation which silently treats
> --nocomp as regular defrag fails the test.
>=20
> Check support in two stages: first require btrfs-progs to advertise
> --nocomp, then invoke it on a 10-byte file to verify that the kernel
> accepts the flag. Kernels with the unknown-flag validation from commit
> 173431b274a9 return EOPNOTSUPP when NOCOMPRESS is unavailable. Kernels
> predating that validation may silently ignore the flag and fail the
> semantic checks instead of skipping.
>=20
> Signed-off-by: Dhruva Gole <goledhruva@gmail.com>

Looks good to me overall.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
