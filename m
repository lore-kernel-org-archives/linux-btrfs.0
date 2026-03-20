Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A581C549F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773967828; cv=none; b=J+E1P/7Qxn2ooPeXZzIA+jHALvtC0ZIMYV1+mXZpHeoLSZ5OeDKzmfnx7xzh/IVz7uaArtVnvvENJ+jlgyLaiuD6O0trcJbj+FjGFGUzn9axC+JNxG355kC+SGPlTVA6r+w/IyS5vEWAycO8twRIvHsOTJji8Jbtpt/MUK8Js6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773967828; c=relaxed/simple;
	bh=6DdYF2tcfkalCqgDd5BnDrR1i7UrS9o+Bcp4PiEe9AA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gRJM6xDeBqKcHysOMK0WhoAHzH1xKLrTPUisyRmEYsLtHL9cA0NgO4c1k4flkJpS/exsXn643DClc3umaVs1QFAguahOBTCI60+y/vFV26291oD7Yr7lbz9AB0K+VxBnXBQSX5xcc0hm0F1hkR/DePCN0AagHoOgWGfo5OUxpdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=jbWEBRkZ; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="jbWEBRkZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773967821; x=1774572621; i=quwenruo.btrfs@gmx.com;
	bh=6DdYF2tcfkalCqgDd5BnDrR1i7UrS9o+Bcp4PiEe9AA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jbWEBRkZmfyUrKLIHMKOdaK3xJqize8Whyj8GYrBqtJvpwGDOM23hu86xioYUpjg
	 dyWgDBqKWKATuQXRGnxceAxCyI6RCSc+mzST2iYMVtUVJ2hhcl4D/KDXUI+mP1wjw
	 VGsILvqg0V8m05usJp2K4ZzQ5S1uVasPGExjG+lOaQrA6ZF+EBjAgEfYVa95xHwaV
	 ekqqRevRkTOJ6K+wE8B5DyQm6J2oEyPxcykvI/Whclb9xbBmK2PMURhagtDaZTCJA
	 loq7YR7tCPSk9SnR68UlcuAu+a4rNKE3ZhOueNwPDOaSU3FFbAa+FW6oZJxpJllt0
	 AMs28eLjLFW1dZqUsg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mn2W5-1vL16h3TcN-00bAgz; Fri, 20
 Mar 2026 01:50:21 +0100
Message-ID: <edf6986d-40dc-47a4-81dd-9946d103bbf1@gmx.com>
Date: Fri, 20 Mar 2026 11:20:16 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: avoid GFP_ATOMIC allocations in qgroup free paths
To: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <44a36cda2b9cdc4a600c942c051f9e028239308b.1773941507.git.loemra.dev@gmail.com>
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
In-Reply-To: <44a36cda2b9cdc4a600c942c051f9e028239308b.1773941507.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:d8+8kN0FAEGMiiZuHYFJqimFnkiPbgxDcWR2UwZs9KpUuVkHLUY
 tMZ5r6oEEjEFvDagMZNPCLUaKxynuquKN6vPt4rTVAHDBm/m0RtfyIuv58CdycIJoYG7HiX
 yof2q+N6Z30RIQ31p9FZYkSxlb/ZidxWJgQeF2LXx8m5CObP4ZtDvAGg0dGNCYisIp+9Wq5
 4ksA6NTaYjaQnCwZ4J51Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uzDfb1nFRm4=;NBrcXgNb//+wZjVH/66d7eg55AS
 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
 qFxgxaUzcV0fmRlV3J+y



=E5=9C=A8 2026/3/20 10:19, Leo Martins =E5=86=99=E9=81=93:
> When qgroups are enabled, __btrfs_qgroup_release_data() and
> qgroup_free_reserved_data() pass an extent_changeset to
> btrfs_clear_record_extent_bits() to track how many bytes had their
> EXTENT_QGROUP_RESERVED bits cleared. Inside the extent IO tree spinlock,
> add_extent_changeset() calls ulist_add() with GFP_ATOMIC to record each
> changed range. If this allocation fails, it hits a BUG_ON and panics the
> kernel.
>=20
> However, both of these callers only read changeset.bytes_changed
> afterwards =E2=80=94 the range_changed ulist is populated and immediatel=
y freed
> without ever being iterated. The GFP_ATOMIC allocation is entirely
> unnecessary for these paths.
>=20
> Introduce extent_changeset_init_bytes_only() which uses a sentinel value
> (EXTENT_CHANGESET_BYTES_ONLY) on the ulist's prealloc field to signal
> that only bytes_changed should be tracked. add_extent_changeset() checks
> for this sentinel and returns early after updating bytes_changed,
> skipping the ulist_add() call entirely. This eliminates the GFP_ATOMIC
> allocation and makes the BUG_ON unreachable for these paths.
>=20
> Callers that need range tracking (qgroup_reserve_data,
> qgroup_unreserve_range, btrfs_qgroup_check_reserved_leak) continue to
> use extent_changeset_init() and are unaffected.
>=20
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>

Looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
