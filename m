Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2264345753
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 23:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428412; cv=none; b=r8n2Vkuxpk9gwhMr4/5TP4kQKH2BaLDhzKdCpDrd/dNKnPbKRs/ZmlgxQgdzPEsCloFVSRFzni68X6UpAuUh/7tgzLUWnuam3XzeaPJPEN5rW+l5uAF//yUA9yaZh1UE9VnhNq7z/HQINPBwlnSUZgP13Sc4Fztnv5C69T1XGB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428412; c=relaxed/simple;
	bh=RQJVo0JcZ4ugUhR7sSDAQcqD0v4yX+dJwa92KriHVzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oLEeE5A1z06EmJONSwR0Hg75UDOWEOOUxGTCiUuOhSyr5S8VwxVQZ7VTVV3oUKxQw1qmii7b4/hPDi9U37zO4KNiIpkOM0b+i1sCGu7dVVATAb79hyt6fEE9UNZwjyUrO7+KF+yOE7tJwA62EI6HYak95DZMeZ3/oOnBQ3XUdHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Ff+aVeJQ; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Ff+aVeJQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782428405; x=1783033205; i=quwenruo.btrfs@gmx.com;
	bh=942aTXuEwZDOzB6hmxrJgIgGwLKlubOmKMD1cRM+9Js=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Ff+aVeJQHkBAz9ol7aB2OHWOnvLXRgcunrZO45QXmM4aPzWRC6QP0EgmEGco2wmI
	 9CsBy2WWyoZItoFogvFno+KwxcwRZqZte0MVKcCfTWnHPMItzJR9d6mYtn97UqdtM
	 IzkZBXQlCjcWnT4zjAEWj+MFSYJ9BmUQAlXlANe0C97K2spbatqyH2WjG1PZKWjpX
	 2efrfkULOYjmY35CToCQA0auOFfXFtOr0u5yZRA9ZS2qEIngCStbJGUdlJufPJx5n
	 9BxKzvxG9878JrlkhVHQT4F4gEZ30bqZIV0zHCzy7Pw1WecS9z9EALkW556oYr/rO
	 Nb1eqFq8Y5amrLftyg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N2E1G-1xI2bS1vP4-010jbx; Fri, 26
 Jun 2026 01:00:05 +0200
Message-ID: <ecc8a032-a60d-4914-be19-84e902007997@gmx.com>
Date: Fri, 26 Jun 2026 08:30:01 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] btrfs: defrag/autodefrag fixes and cleanups
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1782321584.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1782321584.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MKV5zaUrdey1J5yp+TUR7cbySIhnwtF90k2LaQ8i+Hd4veLaEhQ
 qytvS6tCe83JPAUm2t+wvUqaje8a/OvoScVp4axTrkJttE5jZDlP3bzDa1kpDMN/jMzJhmN
 4CG8wSNCJzqNSUgmiPoJh0Z2MXxHdgWmUSdp6qCvL+A7WnCZ8eUjgttrLukUePC0qXgzCFA
 1Q1fVNnCG4xo5YRmQUPhw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:t0869ZJtChE=;pivRnukcqRYl8kwwiWrTVZv/NmO
 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



=E5=9C=A8 2026/6/26 04:50, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> There are a couple bugs related to defrag and autodefrag, one of them
> reported by syzbot and the other can often be triggered by fsstress with
> the mount option "-o autodefrag" (or fstests on random tests that use
> fsstress with multiple processes). Details in the change logs.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Filipe Manana (6):
>    btrfs: defrag: fix deadlock between defrag and delalloc space reserva=
tion
>    btrfs: fix pending delayed iputs when using autodefrag
>    btrfs: defrag: use a single list for each loop in defrag_one_range()
>    btrfs: defrag: use auto kfree in defrag_one_range() for folios array
>    btrfs: defrag: use simple list_del() in defrag_collect_targets()
>    btrfs: defrag: remove pointless list_del_init() in defrag_one_cluster=
()
>=20
>   fs/btrfs/defrag.c  | 61 ++++++++++++++++++++++++++--------------------
>   fs/btrfs/disk-io.c | 15 ++++++++++++
>   2 files changed, 49 insertions(+), 27 deletions(-)
>=20

