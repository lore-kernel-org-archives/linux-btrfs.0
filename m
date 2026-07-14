Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801EE3EDE78
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784065261; cv=none; b=BFDumWhPTQLlwrbumFHbNd5TFJ4Tvhby8r9UM5iLOl5OaK/Nm+w9TYxUCSOjDcd7cEoSZDDvfgcuWhWzTRwk1SpNWEjhMTI6lguFmJ7Gpj6/psB+0ctvtZr3VUj2QJJ7Byxs7YhQXV6GktpUR4pBPm0UI4uu8b0widPk61OlgUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784065261; c=relaxed/simple;
	bh=RG60tiD4YCzNbdTiIdPzBaFzoPlns9hR/o26gVokuoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ql8R09EYCDt/l/vonodt51t0b4o+uCmByEyuNK/qjNa19ApVecuJjF2cgZZQgFU5x3yyaSHbIo8ERgvpXbxMCpA4stFw0xMzsMQBf1mSoe6CBkPE/PZE/4aEMBZBUz2RRwhubM/gHxG51ajmvF+URqfgXr527IjN3zEDxMzBBuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=BgKm+5Rn; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="BgKm+5Rn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784065254; x=1784670054; i=quwenruo.btrfs@gmx.com;
	bh=RG60tiD4YCzNbdTiIdPzBaFzoPlns9hR/o26gVokuoI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BgKm+5Rn3NQ/eBkrPYPNDx9Og+L86bXe+RRMlkiZ9ywZAZwki2T6linXpG5NGqVi
	 UpoGnV5+3hARVVKLsM+/4uLhpxUtDWjtShbNK7JOu6ucRC3CQEgQuA5lBX2NqN2Ba
	 jPTE5UaO5Kjdfo9brqeDSTah6nbEoB2zeGcoeTPfQ34LkUVcqF1MTxuCYWuUz7DAG
	 8X5s84XWH0V8B/87O5McasxBD7S+JRplrvExtprcG63FWnPo5fHjq++F4Rfw+Qfw5
	 1GmqdfPOCiNUPr4P6/0ipKnOuahFmmCkTNwgpk3inxZtQEIYeb65Gwbr+0KAOyTD/
	 KNu9c+eXXa8cQWmdLQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MSbxD-1wdSO42Bkf-00NfUS; Tue, 14
 Jul 2026 23:40:54 +0200
Message-ID: <67cff567-1070-4908-a253-a8907d237734@gmx.com>
Date: Wed, 15 Jul 2026 07:10:50 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Zhang Boyang <zhangboyang.id@gmail.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
 Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
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
In-Reply-To: <20260714161044.7330-1-zhangboyang.id@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:P8ayel6wQ+3FVa3U9tmN5js5kvIuveQMVy71a6fOup3cA6n8Rel
 ESUInBAl1bwvRuo8E/R+qrGfkQ9EXPftCPVgPfM8oMt81Brtow/MPov1EQBd0Yf6sX7QGZI
 S5B4kSd+7Xsy/AoGszKFySR7FUKGWE1XTX+ukELmZrSUtv0xfCPHST9J/o6NDzZHQVMSkuw
 lKE1pLryBksvDyfl8bz+A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nlFh6P/T3W0=;V5hAh0gvDmaptM/HtcH0+CXYaT3
 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
 B5V2NA==



=E5=9C=A8 2026/7/15 01:40, Zhang Boyang =E5=86=99=E9=81=93:
> Hello btrfs devs,
>=20
> I found two raid-related bugs in btrfs. Two test cases are provided.
>=20
>=20
> BUG 1. fstests: btrfs/348: test ambiguous generation handling on raid1 p=
rofile
>=20
> This test simulates a ambiguous generation which can be caused by, for
> example, two successive power failures. Please note this is not related
> to degraded mounts or nodatacow.
>=20
> This bug may affect several raid levels, take raid1 (say disk A and B)
> as an example:
>=20
> At first power failure during transaction N, metadata trees of
> generation N are written to disk A, but super is not committed. Nothing
> is written to disk B.
>=20
> At second power failure during a different transaction N,

If it's a different transaction, why it will still have the same transid N=
?

> nothing is
> written to disk A, but metadata trees and super is committed to disk B.
>=20
> This creates a ambiguous generation N in two disks. Currently btrfs
> can't detect this, and can lead to severe damages.
