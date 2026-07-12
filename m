Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0EC37881F;
	Sun, 12 Jul 2026 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783892544; cv=none; b=LDCrk8IRv59aEvMT3iX4LNY7/93myJXcLT8sDQZ6irpGM+rlQC/emHbhlsfNFXQKJu+U6r/Nk3u+v+O3gODQQm7nqHmghJjw2qGrpjyaZSjVMxEdQYtLV+3KdBPZU1ZzK7CJqoPT0hgrMg56iVNAwnDFmzI9Wa9JJNC9NGEy8G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783892544; c=relaxed/simple;
	bh=JoVtFp18lbvuPcBcQ2nKzW6ijvUJ5KBomGNcyTg8vVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gFEn82gavQ6i0UcCiykRLzPmu+qcMsUjr1h000Ic4CjHUxzVGK7bvnqKIPLxyukxzfoYv32G8c8tTVjLAnGlrAT9VPPf2g6Z+3R7JWjh9xTqHUuOOJM09m8BUSQtKO2n6ezYC3N0SgPGZry6G81dJhQ52xgseXMgAW5XulG939o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Bwqsx7Vs; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Bwqsx7Vs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783892539; x=1784497339; i=quwenruo.btrfs@gmx.com;
	bh=WdXVoO0cxyTReK3wuyvkvsVggEd/3mI3JAAJ9rExJkU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Bwqsx7VsUQc8sxtEqERKKcLZHQWK6K9vj4HVRVjdK61iNKscXwet3jP/SsGEwY8j
	 s/uv5Oav2k+hTP5eAftnuU5NdqOW5toQXIrqC+USlFo7BCij/pDQLL6IMwXQC36JY
	 X/sk/8YLcD87kgoHrCh9fHFVm7Gc7aX+34ZuHuUb+Ux887QgWHHShhC1Y7JBHgVTQ
	 1QGD4b/VPLvVoxRhE3loLmRMVDU4lAtn70nuqi/JgkPk8AFLuMM2MjOHQhPbPqUKF
	 /a8f8vryZ9E4Taetfb2HPmnYHK3DNVUyj0O5axraDZBWYIpSu1NaeZvY4cJ1Yu8bf
	 KUCzrWYOzX9Kkte1Xw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MsYqv-1x3qqH46Fn-015I8D; Sun, 12
 Jul 2026 23:42:19 +0200
Message-ID: <e34d72fd-1217-4d9e-9d7a-2e7339c1946a@gmx.com>
Date: Mon, 13 Jul 2026 07:12:15 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: allow reflinks into NODATASUM files
To: daan@amutable.com, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
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
In-Reply-To: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9i5HIniKd4qavRXS+NiDSfBXBoQIXA/pO0TAwQkMIq5Yw8R7A4L
 wb7rHnymi+04q2IUf4oa2ILdUNmE9B3h8SfggceQDei95OvAfBmObttK9zcVBf45cGdYv1q
 R/dVHgkS32msuQHJ6JSBl4dYik/jM8SR94WsirTVtz/qLGEAOxiIijyQv4m3ivK5/Sc50H1
 CVumuhdN8A0w/RqYPlswg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/z5H7ffog7w=;YX7kY/10nmEUT7Psk3TUOzGrIEU
 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



=E5=9C=A8 2026/7/12 23:55, Daan De Meyer via B4 Relay =E5=86=99=E9=81=93:
> The primary use case for this series is building a NOCOW VM image from
> individual partition images that are COW and checksummed. Today those
> partitions cannot be cloned into the NODATACOW and NODATASUM destination=
,
> so tools fall back to a full copy. This makes provisioning slower and
> duplicates all of the image data up front.
>=20
> Allow cloning and deduplication from a checksummed file into a NODATASUM
> file. The VM image can then share extents with the partition images.
> Existing checksummed extents are COWed once when modified, protecting th=
e
> source checksums, while newly allocated extents use the destination's
> normal NOCOW behavior.

No, the change will easily cause btrfs check errors, in both lowmem and=20
original modes.

And before you do anything weird, I'd prefer you to address the=20
regression caused by your new 32bit compatible ioctl first:

https://lore.kernel.org/linux-btrfs/66470c2e-56b9-49a9-9cd2-aa49fac75bbf@s=
use.com/
>=20
> The reverse direction remains rejected because the destination would
> expect checksums that do not exist.
>=20
> Patch 1 prevents swap activation from bypassing the COW protection when =
a
> NODATASUM file references checksummed extents. Patch 2 relaxes the refli=
nk
> restriction in the safe direction.
>=20
> The xfstests branch is available at:
> https://github.com/kdave/xfstests/pull/6
>=20
> Signed-off-by: Daan De Meyer <daan@amutable.com>
> ---
> Daan De Meyer (2):
>        btrfs: reject swapfile activation if any extent has checksums
>        btrfs: allow reflinking from checksummed files into nodatasum fil=
es
>=20
>   fs/btrfs/inode.c   | 29 +++++++++++++++++++++++++++++
>   fs/btrfs/reflink.c | 18 ++++++++++++++----
>   2 files changed, 43 insertions(+), 4 deletions(-)
> ---
> base-commit: cab9e339cfbc1a4e075e53e281dfb00391e1a6bb
> change-id: 20260712-reflink-into-nodatasum-aff962f3794e
>=20
> Best regards,
> --
> Daan De Meyer <daan@amutable.com>
>=20
>=20
>=20

