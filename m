Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657B16A956
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633671; cv=none; b=mcwv3FbkjahWif35LxYhbMjsyDIHeRRxSR0dVTuhQ5jQ7WkuCFsQClJAj9sbOXqLMlPd1YUFlI73EeIhZd42GatBtPWvyLXep67w11Xon1Wa4gToYy2n14LZ1jB6nfrtXVFa9GcMXAEHxhHbw4mBKEpbCIjqTK3fNrDnogUvHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633671; c=relaxed/simple;
	bh=h9P+FOyT6D8mlCLF9MDCcuCBMAftfNJ10Uk9gNwOXVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hcKH+BzpgFTRybu/ZiqN05QyBhEsdH1wuKyETQ5XHT1cSnqUGcChXWptgzdZq+5D8QcePJOmbWp6DikBYjwopfqpw2UL6JPRw/K2XDup5E9su1WIDvVuYWyAXAYFzdsO2mxBI3k9XfJJpOv7EoW0gWyU6h4cElYpZGz0BmL57RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ssk/y7wW; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ssk/y7wW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1778633667; x=1779238467; i=quwenruo.btrfs@gmx.com;
	bh=01BYnQ/1UtYcaqNaWQhco4VO1JKA5oXC0CW9m7bwfzk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ssk/y7wWmsdtDIUFs0QfhhKspgRIyafPKmHC5Lulhn1TMZLBvuPr3/8ABQSlVdTv
	 ijJSIfewWcsqcsE94S8eFOJcBcVskTA+dMlVMODv/JJdlTjnEe5o+utHC0ynyTDn0
	 Ixc7V2CAdQVusotxGnj76FkHmgVSqLnt/K7bhUh3Up/Hz9Lo+YrPHg+emL/cETVKs
	 04DNd5FEtqzMkD4t9qlQpnf9xozfb3cqxosCwy5lB0qArkck2SVchnGt7Ri+rD2Wo
	 p8tPKo9IIedCbQF0ZpiNi8Nau87FJ/dwFNKxEskEFD68ZJKXGVFOr2+BijPT95u7u
	 jz06KF2Ak0BqdyZE0Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MdvmY-1wwZnh03AE-00iVts; Wed, 13
 May 2026 02:54:27 +0200
Message-ID: <fcdb6408-a551-4459-a0d6-199be5e523a3@gmx.com>
Date: Wed, 13 May 2026 10:24:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] btrfs: swallow btrfs_record_squota_delta() enoent
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: marc@merlins.org
References: <cover.1778613519.git.boris@bur.io>
 <2d814d975b4bb96a8310d9c941c5457e10db388a.1778613519.git.boris@bur.io>
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
In-Reply-To: <2d814d975b4bb96a8310d9c941c5457e10db388a.1778613519.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LiaqModg5lLTOpDbT9v6VZhr4eqNjlHuZlOLE+0jJNfqM35/esS
 ZodZ+J2Fg9MBDdgD7yqtAsQ2IB6UDPQ3JauI1TjdP4ON2RFLzQAPHSnSeK2K6B9eUoqs84/
 kaCBvx45qrMD4SjT2xRpLlMMbOioPEZmgc9DesE4SAX4/dp5DiQkPkXJNSNzqKNvLDvrglZ
 Oyp4d7STyRnpOjdkZ6EIw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ukx+iUDL4lQ=;ZUgRHp0rXPLzLlmAqucjLog4I2q
 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
 S5EvKRcaRclC3QA==



=E5=9C=A8 2026/5/13 05:04, Boris Burkov =E5=86=99=E9=81=93:
> I thought that it was likely I could harden squota deletion to the point
> that it was impossible to end up with an extent accounted to a qgroup
> outliving its qgroup. Several recent bugs have made me re-consider that
> position.
>=20
> Ultimately, this is a tradeoff between short term stability and long
> term strictness, but I think given that there could be another layer of
> bugs behind the 2-3 I just fixed, I would feel much more confident in
> people using squotas if the risk was "your values can get a bit out of
> whack which you can fix by deleting stuff or
> disabling/re-enabling/repairing" vs "it will abort your filesystem".
>=20
> As the final nail in the coffin, the Meta production kernel was lacking
> earlier fixes from me and Qu regarding subvol qgroup lifetime, so this
> is what we have been testing at scale, so I think at least for now
> upstream should have the same extra layer of protection.
>=20
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   fs/btrfs/qgroup.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a93d49015fc7..f9e5005028dc 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -4959,7 +4959,7 @@ int btrfs_record_squota_delta(struct btrfs_fs_info=
 *fs_info,
>   	spin_lock(&fs_info->qgroup_lock);
>   	qgroup =3D find_qgroup_rb(fs_info, root);
>   	if (!qgroup) {
> -		ret =3D -ENOENT;
> +		ret =3D 0;

I appreciate that end users won't be bothered with transaction abort,=20
but on the other hand, this seems to mask real bugs.

Can we add a WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG))) so that we=20
can catch such problems for debug builds?

Thanks,
Qu>   		goto out;
>   	}
>  =20

