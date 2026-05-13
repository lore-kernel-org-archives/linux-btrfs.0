Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1882A31691A
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 01:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634105; cv=none; b=n81ySFPfqJjw/AC2/BxRc9bHvo18rgNCkEkZs1f9tSu/SMJmDAlwkPbAhlLMZ38BT9RGneUeZ2Y3BRSXQevyHD+o6xpFLIyJEKBPA0GlZDUbjse5JDvh+/JBlmhXm+xJJvno2ZuZnAIqj2BshrHy5Zze9VChWwk+8m2iBE6/Bk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634105; c=relaxed/simple;
	bh=tdxiSUy6uka8KEWS1ruchdZwnND3uqrduIg+uiPbRgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OmjZ6PMDRO7+IicacwIJJRYqzF64R12Edp+14AuUi80QNWmolPmAgIeWr5sxpgVcbNdD8J/b4lbZEW4TMHOcguxab3liuF/npJIy9Da8E6KUgP6wXczktE/QGzH7C/aTcdp5NThQSyREYF/UPTnU91jV+3KLecb2iZRD8QtgcWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=XlSSBPVa; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="XlSSBPVa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1778634094; x=1779238894; i=quwenruo.btrfs@gmx.com;
	bh=n8SZfaX3PANw9Yx6FoDfXccxLr9Spnd/cUmD93pjtuc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=XlSSBPVau8fRcMiAkT5Mopi8dAesehcowqxkI0oyKivDoV/l+jtKFRfhXYbDx0ZU
	 QmQIRyec+2cuXAY+Fm0NGP/mpXat25ULjH0DY3JZZF7HIrIUDuWno6TYCFnooWRX/
	 569HlIUeGoLPExsJEnB6qBCqTkgjPfvIJ9WUHwmlbKgFIo3qbNfsD6gdrFjLry2UG
	 HgB/iyBXRATs2mC+jmD8yIN39eV/XgEzxyDNVfMog47jFGZvYbq70E2lbA646jOVt
	 CtBVaEQ1gT1GVTUX3W35nBgT1j5tbrMqIdPvCrnXOxyfYHfUcg44Z1oEZ9IOF9Ju2
	 x+ptLc4Fe8IWeojg0Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mzyuc-1xIWPj2XQM-014SY3; Wed, 13
 May 2026 03:01:34 +0200
Message-ID: <72d1ba70-9f74-4acc-b181-21ea5cc3bb41@gmx.com>
Date: Wed, 13 May 2026 10:31:29 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: squota lifetime fixes
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: marc@merlins.org
References: <cover.1778613519.git.boris@bur.io>
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
In-Reply-To: <cover.1778613519.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Rq+aNe7B3Uibhf6yqV9aclqnOFoGMYDopPC896bRSYF5f/z6dqc
 KGTfUNzIMnz/mqCHBSfcpvptdapG8fmU2jCigzq5bcmC5PKBIWzTs39OsDObdijYDnwSrEa
 QGO9PBAwCcCIrmIHR/t+lJnfAUSYJZ1eR8eXilPUpzS5jZBP2Z2y0/xetbpIw809WhX/Kac
 gj34yJCSU/cD+MZx7Ch7A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3CAphIaCbeE=;dbFvoQotBfthGn9zt3kXbt/7Q9s
 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
 Jcm2WkgAiFdoFgQ==



=E5=9C=A8 2026/5/13 05:04, Boris Burkov =E5=86=99=E9=81=93:
> A recent report of read-only filesystems since enabling squotas:
>=20
> https://lore.kernel.org/linux-btrfs/adnBhWfJQ1n3hZC8@merlins.org/
>=20
> led me to investigate a handful of issues in squotas and find some trivi=
al and
> not so trivial bugs in their lifetime management. The aim of the series =
is to
> strengthen enforcement of the invariant: "a squota qgroup must outlast e=
xtents
> that are accounted to it".
>=20
> This series consists of two fixes to squota lifetime bugs and two patche=
s that
> reduce the consequences of errors in lifetime management from full fs go=
es
> read-only abort to "warning and inaccurate squotas which can be deleted
> eventually"
>=20
> Additional improvements to btrfs check and fstests to follow.

Only minor debug related comments in the last two patches.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Boris Burkov (4):
>    btrfs: check for subvolume before deleting squota qgroup
>    btrfs: fix squota accounting during enable generation
>    btrfs: clamp to avoid squota underflow
>    btrfs: swallow btrfs_record_squota_delta() enoent
>=20
>   fs/btrfs/fs.h     |  1 +
>   fs/btrfs/qgroup.c | 99 ++++++++++++++++++++++++++++++++---------------
>   2 files changed, 68 insertions(+), 32 deletions(-)
>=20

