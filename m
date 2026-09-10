Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE263D994;
	Thu, 10 Sep 2026 00:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998555; cv=none; b=LJ9EU/nGhT9yeORMUABwbxQzz6Pa2umtXB8QBLWFAsbMTMBKEE/aU+IzEsqrglgIgubvoikMPCSVQmQ7waM80PaTSMAuz29DUN3yVkdeLkP5Tva+OxiyxQBCb3di8jjOtRuLYK4a78IbaTbZ3UdM2K3txvAupJ002TMhmnzKS7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998555; c=relaxed/simple;
	bh=eJTgmYA++G8fltGHK+h3OY47C6U3jfKniJ7A20zKO74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUqeJus/m2MEZLA5TNOWUPKljTHi00zocPJIMZ8ahvDp9cuvvTwo1oG+Sei2tzbkblJJT3g5ajL+hxuA8Nh2SK/yW5DAP0sbm/u9gVqQCYG/ayKvDilbZfoItLE9IgdbVuG6g6zg2X1lPx3GHpKqYU0tX5DbuX4xfLPWc1TQSmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=dt0nv/Ce; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="dt0nv/Ce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788998549; x=1789603349; i=quwenruo.btrfs@gmx.com;
	bh=eJTgmYA++G8fltGHK+h3OY47C6U3jfKniJ7A20zKO74=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=dt0nv/CeWH3Jt2GqwAiWN0/W4UsptWOqO+02qsNgfQLmoscvJSnFrV4c70sqJqHl
	 GGeFDshHxiK+OSSSIHBYRPQ2ou2HuK7M1zWCfVV4Z8ZFSAz9iveXaVaIbpwohzCzy
	 40XTa5knWqdNF+QDRpbAhimWiMAvIA0Pit0Tbk9nIqTQ8US6RmTbNvp9BZVTz9mdO
	 6b3m99rspoIftBqKSAnZ5Q8wASkwXhRW0CdT+HJtYOz0aFX73fNMC4aRnky+gTiFY
	 ONWAnB8vAgXLS/oLkytWYkNyjT4oiyO/XSCuzj5Bv+Jtv6cZD5hexcTKHaa0FStEz
	 vLSfehlVLe6ZlQQLXw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MulqN-1wmvA60FhT-00ycgx; Thu, 10
 Sep 2026 02:02:29 +0200
Message-ID: <7e0ab4e0-5859-44e0-a697-38eb422b6302@gmx.com>
Date: Thu, 10 Sep 2026 09:32:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>,
 Qu Wenruo <wqu@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
 <7c331e23-d0ea-4611-9bed-d7099dcb41ab@gmail.com>
 <9ca6e653-f89e-4ed2-8f97-783a5663f97c@suse.com>
 <d27ef15e-2b34-4113-8913-93f4387fb48a@gmail.com>
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
In-Reply-To: <d27ef15e-2b34-4113-8913-93f4387fb48a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GpUdd5AsqNw3H7iVU+CS3laj0CHFRu7hRwDOSW87qYkTcZ2lPQ0
 shnGz4F/nfEMJJQMTb7w+baPPZRFe2Mi0B+Jivzd0uvF9y87TaSUGm4WT4wSOMZ22Q4/4pw
 1DDeu4sN5RqJPlKbNBborpP1yiLPQkvYMWIcXXsEd442AFtZAZa29FZq1UXms88+aW7lGtK
 fylkY6QuyggKjv/53ysaw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qJPqrTiIiX8=;2eDvy+AGRZ7GrrPJO0V6KhHZ1Zk
 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
 vMpR18xOUVgKCvVHJrHb+7EPQVO+AQf



=E5=9C=A8 2026/9/10 09:05, Hanabishi =E5=86=99=E9=81=93:
> I think human reporters deserve more attention than bots. But anyway,=20
> thanks for responding.

BTW, I may consider a different flag/cmd for btrfs device scan ioctl.

So that one can force a device rename, and I can finally put all the=20
responsibility to the end user.

But that will not be landed anytime soon.

Meanwhile I would suggest just to use a initramfs to workaround it, so=20
that btrfs can be mounted with proper device name (initialized by=20
initramfs).
