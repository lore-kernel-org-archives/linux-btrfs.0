Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795647954;
	b=I2XAUBleACwjuTiJuAfAoY25hzcHdiD3WuTdNniCzNaaGmyr61UkoDHOxEgTC0p70oKl
	 jjlquXM0nt1BjMxjxuGk36wBb9H0vD64pyW7qKGGV6aD+wy41XeiNTuNih7ka8kBrOdXO
	 qTMDNwjwsN+0mmh5bF+yntc56+oGMrEaTrUAie0wjWQ0F5E8VUXWUi/9J/sPExX0RtJqG
	 Sij2l79F1MNJGK37Y+7hlVqiNzwjvA97IXP5Cw143H6bbJRIB1nqXpjomVEf+mC8QOm3j
	 hPkRaH6eS6keEVRb4cW+lc33OX/BnhHS5mogZMenG893KbwwGHohc/iZU3tRlb136Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795647954;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=vyG+QP7aVJceCbCL6IsryBR6S53JsWgTGZFEzxwGdhQ=;
	b=mcgnhfSlBW06XMtKBulzZSAo85zbj9XP45G+b27xoNypljUoblzJs7TbijVmCXGqRwBy
	 hTw5JrCnjt8pqIUl6pthIbYXxsXEpqWoC/V6iJiqEC2ymPhVtsYT+Ahnqnq61oxDYsLo/
	 iJUF7wuFrKSgB4kZ17N++XEPrU+JczT0v/6vqNiCkQeIXQEow7Yf6bK3ecGBMCR4CV+G5
	 PyJha4ZUSACdm+EMjESNKpnaz1seMStpwGFjIcletZnF9VHCeqK9Fm+LzHntFYvKrafa5
	 P0ZJjJoZThqRybfS6e45CFiKHjhNzxwFaxYOplwoz47VGmnHc2hvuO6eeiC1jXXkOrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Nk5vWfee;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9D5606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 23:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E9D5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=Nk5vWfee
DKIM2-Signature:  i=1; m=1; t=1795647951;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:cIxEDU307sA4f4VN1MqfsyqZWGlX
   7AufCP37/fxI3DknPAZNhyS3P3VqbRW981df+FHl+JI/U8L+IKA3ohrC7CX5ZTEhgE84Xb8z8EM
   7i3TGWCKZ6zJbH/GldARMSgl6SLytJpQgqD3qLp9sDSiRCupJobkzwLdONBzMWA6ya2qf9TIY63
   /LvDFeG7KCMV60jLvbfdFNUD6TLQP1Bg0il41NRKSm0/sbZEBEDQ5yGlEziy9cFlk745hXoOpIG
   +5sVvV7fxiQKPVW2omgv59FHuM7zeivUmoizrZrOe4bCCY8cR+IVaIdY1XZCq/AGu/ecoRRoCPM
   m4S6vB9uVR2EOw==;
Message-Instance:  m=1;
 h=sha256:
   /P4WST+u9tbK2xNxONOcirDeZCil39khRVx6fxZEqzA=:
   SGFsC0Cfl3xN49iQENFQE0/azrxjJdZ7Hiy9+T2fmyc=,
  sha512:
   GoIi8rRskVPAhzYq3tUmTHq+578k7LYEecxMgriF1oXIAu6H8oRJbJSzSYafvwCXKFo74YlWkOLD/a8Ys3khgQ==:
   7JgAz5A3Fuv7d8UPwcFq4REdGtg/zU3XR6sb1egJQ+CruY/Fk8kl00ukWXEip9b4SU98zbwScyW2hOctKDZy+Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795647940; x=1796252740; i=quwenruo.btrfs@gmx.com;
	bh=vyG+QP7aVJceCbCL6IsryBR6S53JsWgTGZFEzxwGdhQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Nk5vWfee/tGL90H7RjATHuqHWWWT5PEgVIZ1NgilMvSuKP35lpKTuP2wdywOj2Bt
	 g56Pk49AkweqvnkaLst1Fx0/Ql5u+Wc+jaIlQFppXgBbs8P8kLXJllHb+NROTbC87
	 AEZkWyNiRwr5yLZT0iuMgezISwToBI+OyoiPdvb7M48wdkiMIxW/U5Q6EU2lp4Rye
	 fqO3kKPwNz5hLw09Z9tfjfsc13oNd83QbP1BLq4KYLxZ5lw3p/6Vt/26crKZXBe4o
	 SzpGj5ooRWswCipIJ/uHheVWaI15IilRu6MHrNzMZ8tZyOsv8s+IpSD5rq5DliUIp
	 SoJaBIqDxwK7A27ezg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MvsEx-1yLIeK3Ntn-010hqq; Thu, 26
 Nov 2026 00:05:40 +0100
Message-ID: <271c5680-958f-48d0-ba17-f07e8a41f262@gmx.com>
Date: Thu, 26 Nov 2026 09:35:34 +1030
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
Subject: Re: [PATCH] btrfs: tree-checker: verify tree_block_info bounds in
 check_extent_item()
To: Elkin Cruz <elkin@google.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com,
 stable@vger.kernel.org
References: <20261125221849.1424464-1-elkin@google.com>
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
In-Reply-To: <20261125221849.1424464-1-elkin@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wylhbFNh9luowl9gkTJ0PFI3Eo3M3jaZo9XOytK1y7HL2r0aMar
 7BVw8NKgo68sLPw2PMFiOPgYG3wWZhEqRVePbZdYDq6pjsBPGrA6qxbENN42hSSYe5mp0R8
 mH8jHT0MgmeKdNDQWJ4e/PPVDreoiAGHfy3J/UP1+ik0DT/o96Q6lfS2QyWEJ99Yf+OVEdG
 +jfFRCgMIsaEsGH6+HBGw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:G6s6J3dLnzg=;vgb1aM140e78KM8b6VJgZpDsEWk
 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



=E5=9C=A8 2026/11/26 08:48, Elkin Cruz =E5=86=99=E9=81=93:
> check_extent_item() only verifies item_size >=3D sizeof(*ei) before
> reading struct btrfs_tree_block_info on non-skinny tree block extent
> items (BTRFS_EXTENT_ITEM_KEY with BTRFS_EXTENT_FLAG_TREE_BLOCK). A
> crafted filesystem image with 24 <=3D item_size < 42 causes
> btrfs_tree_block_level() to read past the item and potentially past the
> extent buffer's populated folios.
>=20
> Verify item_size >=3D sizeof(*ei) + sizeof(*info) before accessing
> btrfs_tree_block_info.
>=20
> Fixes: f82d1c7ca8ae ("btrfs: tree-checker: Add EXTENT_ITEM and METADATA_=
ITEM check")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elkin Cruz <elkin@google.com>

The check overall looks good to me, but still a minor nitpick inliend belo=
w.

> ---
>=20
> I am trying out new Clang static analysis checks for kernel bug
> classes, and they flagged this code as possibly buggy. The findings
> were triaged/fixed and commit descriptions were drafted with help of AI,
> then checked against linux-next (not runtime-tested on hardware).
>=20
> Thanks,
> Elkin
>=20
>   fs/btrfs/tree-checker.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index d2bf21c7b848..a38eeef7b859 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1665,6 +1665,13 @@ static int check_extent_item(struct extent_buffer=
 *leaf,
>   	if (is_tree_block && key->type !=3D BTRFS_METADATA_ITEM_KEY) {
>   		struct btrfs_tree_block_info *info;
>  =20
> +		if (unlikely(item_size < sizeof(*ei) + sizeof(*info))) {

I won't call this easy to read, nor following the common pattern used late=
r.

I'd prefer the more common (ptr + sizeof() > end) check instead.

Thanks,
Qu

> +			extent_err(leaf, slot,
> +				   "invalid item size, have %u expect [%zu, %u)",
> +				   item_size, sizeof(*ei) + sizeof(*info),
> +				   BTRFS_LEAF_DATA_SIZE(fs_info));
> +			return -EUCLEAN;
> +		}
>   		info =3D (struct btrfs_tree_block_info *)ptr;
>   		if (unlikely(btrfs_tree_block_level(leaf, info) >=3D BTRFS_MAX_LEVEL=
)) {
>   			extent_err(leaf, slot,

