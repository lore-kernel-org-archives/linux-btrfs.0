Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4623EAC61;
	Thu,  6 Aug 2026 09:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008730; cv=none; b=SQuAijJmtXGHEeOmn8WWznzpmgVJblW2AggVruh3riLrtN+2CNDinWzdlJKA+kmg7eyH1eOGKRec34q7kp1ZYxcB16ZJ54UcMGOWSE0u64iEjzAiHJMVhE+0V+IelLmDmSEHlcsBh5sYR4vpaFn55UgEbAIvXPwRJ1H4WwKwgTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008730; c=relaxed/simple;
	bh=5ENSej7GGFhGovpS+kWQFawBXt4V9kberM6z8r3VtbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ln9eeb9pfDeEbkDgMtAFKKF4J97kOudzmx3YJd0BntTi0WmCPsVOoPsLVVyj/V+zTNGaxnofvXK5POeuSFNXN4IlJxSlKE9nk16dI0Jig7hWRMWIEGoeCHN/3k/I7q0GQd1JhHIoiLiefMEQHiur1bzpNaK6ckn9FacjASKeiMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=UD+GHERo; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="UD+GHERo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786008713; x=1786613513; i=quwenruo.btrfs@gmx.com;
	bh=5ENSej7GGFhGovpS+kWQFawBXt4V9kberM6z8r3VtbQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UD+GHERoOHSZT49rw3IC3B64MYUTXWR7iqVtAGq7RPscsMVuAtixqXc0+0bOdRL8
	 jM6MWXJ+yCIAISwEv1RN+GvryzcOymtdozmpp3ouUwkiMYJCj775XZcYNgESUptha
	 MyZst3L/ZJ1KoUOtj4KLxYvnbz1J1wT4NRk6Hk6pfAL2v3S0EYgHZL6K6bNYvZn6S
	 LYcwfbQhR/FiTYZ1c9lNgW55Vc0JoOUjoKkySbvuR7m2Fnv/GRZqNmdn90D/95/o+
	 R6GZaFEQuQStWgJRv01+CnQ9IhVJGEZS4H/z79j6r0sVSUKhv6u40oTVZE4q4s5qF
	 JjKa7JjzHTgxPnm4Ww==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MI5UD-1weS4N2VNv-00B7Ny; Thu, 06
 Aug 2026 11:31:53 +0200
Message-ID: <adf19dd3-23d9-43cf-bb52-67da37ae31b3@gmx.com>
Date: Thu, 6 Aug 2026 19:01:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] btrfs: unlock inode and extent in caller when
 uring read extent fails
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Mark Harmstone
 <maharmstone@fb.com>, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org
References: <20260806085041.1410576-1-yangxiuwei@kylinos.cn>
 <20260806085041.1410576-6-yangxiuwei@kylinos.cn>
 <2f43370d-0319-479d-998e-8cf09c84675f@suse.com>
 <20260806093047.1491231-1-yangxiuwei@kylinos.cn>
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
In-Reply-To: <20260806093047.1491231-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3qZT7SvX2LnPidLlsd8uVeK17+aL21reNYxuQkY1CSGxwdOnpm/
 HdAvMACL9MvZXcSbcC2R+4zMMoZtlz38J/9+u0k184lUoGOd9gUUj/nIxt18RMJO6KyKsJv
 RRbLN1VhgVws354PFOliB5PVM/4QFTmu++BW1JwXfSmnbL9zbisEX+KUK79WTmGktYZyIfs
 fVTdEGsi6fbyBFiO5xitg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:K+9Mhr80OPE=;GxP2oJ4nTb6hyZF6ckzjDX6Esrr
 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



=E5=9C=A8 2026/8/6 19:00, Yang Xiuwei =E5=86=99=E9=81=93:
> Hi Wenruo,
>=20
> On 2026/8/6 18:40, Qu Wenruo wrote:
>> Why go to that label? We have nothing to release, the old return -ENOME=
M
>> works completely fine now.
>=20
> Right, I overlooked that and kept the v1 goto. Will use return -ENOMEM
> in v3.

In that case, feel free to add my reviewed-by:

Reviewed-by: Qu Wenruo <wqu@suse.com>

>=20
> Thanks,
> Yang Xiuwei
>=20

