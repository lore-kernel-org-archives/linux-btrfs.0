Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826186;
	b=ytkMIWuLMTWiFPlrWXE0lw8DrMjXKB7K11nxDGvHsl8fvvn3KhQH35KdxxEphkeKAIqB
	 +/htuiqk8u7vRgfvwHP1KYdg7quYCGwOUVXgFbym1+q3Lz0go6qbdx7sAFP/S7xEeVbzg
	 noAODkLLeZZV/VnEBEwOTAH9SI+/5pxmgoV5i7FCWlP23WMsWNypMykyMOWnYTEEgUybR
	 CNzlVSIuMJrDmG3dqlhbWoqPHem/QCksd210Lh4M6L+xIe8VDpGyIwurDiKqLJKRx7TkD
	 NsGwSXB94ue/Ftg0rjIDFR/DUrXhWwJR3kKKUi9V2rs+nCURJG053XbPi+TWznerAkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826186;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=Ikq6ub2aY4RfE6ktfqOQbsu2yE9thKRVpJhcNzAS6Fo=;
	b=iqC8o/uPlUB7hTRnzGsBp7Egq/nMGvivu+tCaz1NWFfq1Fj7MfV32KHUcA3ED0CqqyDN
	 O9bQQ6I1RKUnplgAxwlA6PGokyTH9+jbQRlOCDvnF6XQrEiE+NYU+aKJN6h+uWDKRvOi+
	 azGTEfLYBmbwmjcw1ircBAgZX6q7gcLeAeMNXc8RLbBW39qPuJcdxcjhTx4D9OxfbjWZT
	 viNL6J1vlh4tZL5vvYfcvA4EeE9YckgyYqFB0TP+NTCSykwxiRa+J5Rnq6gDSz/jLjaIB
	 s94LMrnkVGhLI3O+wryCYARZG/wIYZh2Ha4EAR/aqFxSJuWy80JXPIYEpTzMdR5bWUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=NllFUL8l;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34129606E2DF;
	Wed,  4 Nov 2026 21:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34129606E2DF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=NllFUL8l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793826166; x=1794430966; i=quwenruo.btrfs@gmx.com;
	bh=Ikq6ub2aY4RfE6ktfqOQbsu2yE9thKRVpJhcNzAS6Fo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NllFUL8lyzdFWmxty6LJ4GFLsIsDW8QGs62yXG91OpHAbkl3bW656WIphTwElfcz
	 aFk4KYYa5mhF4gJwwjnBT2I5wIlTHe93yldKzOX6ABjwwmwyAktoDQCJRRLiELfhy
	 Quy4CxCHYuHG4F0mbQrF1Kw3aiVjHRoj9ZY0y37okhctKLoeQO+aWcVppeVAP0HZE
	 LEpHyjzyYF/5iKIiCaTDD610TULVYCznVGNXRTnVlr0QBrpUM/dITRTDv9GsAg0Wv
	 IOwMwpWppJVM3C2QgTbO95H233RK7jJp0VpUUepXbrD/Wa97ga9D5sYJdZ+w9a4hh
	 LFsX1fjlABinacZxWA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N8GMq-1wTSlS0r8i-013rV3; Wed, 04
 Nov 2026 22:02:46 +0100
Message-ID: <4b5a5bcc-6a85-418d-974e-de6ee0565459@gmx.com>
Date: Thu, 5 Nov 2026 07:32:41 +1030
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
Subject: Re: btrfs: bug report: reflink racing with async compression forces
 read-only
To: Breno Leitao <leitao@debian.org>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org, boris@bur.io,
 jlayton@kernel.org, linux-arm-kernel@lists.infradead.org
References: <ause7k_HjzUWT3D-@gmail.com>
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
In-Reply-To: <ause7k_HjzUWT3D-@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:N15VY5cbYzoU5m2RrsMMHq0sJOTG5HyI+Wq3+WGOVPtML1eN/k+
 PGWt2s0EODMWVmonwZSXIe5ftNc1jLyt1ZpiACslYOJfupF8BjsqcAzb30wUgSHnlRXwF7u
 RfSQtf8rFSrNWmsA/woHgEbWg9hI8gfhsohqeHPiIUg5lvutqaV1HrfNoo7xHyuPtaVIqUL
 xWJnqK4bkcMQhTyNmuLVQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0OpbHwP3Qd8=;Qt2srkV0dAW6ZMpqNjD29hHAe3e
 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
 28pSvz



=E5=9C=A8 2026/11/4 22:40, Breno Leitao =E5=86=99=E9=81=93:
> Hi,
>=20
> We are seeing btrfs go read-only on arm64 production hosts (64K pages,
> 4K blocks, compress-force=3Dzstd:3), on 6.16-based kernels and up, still
> being reproduced in linux-next as of today:
>=20
>    BTRFS warning (device nvme0n1p2): no extent map found for inode ...
>    when unpinning extent range [20480, 24576), generation ...
>    BTRFS: error (device nvme0n1p2 state A) in btrfs_finish_one_ordered:3=
200:
>    errno=3D-2 No such entry
>    BTRFS info (device nvme0n1p2 state EA): forced readonly
>=20
> A quick bissection seems to point to commit 1d2fbb7f1f9e ("btrfs: allow
> compression even if the range is not page aligned")
>=20
> I've able to come up with a reproducer that hits the issue within
> seconds with 64K pages:
>=20
> 	https://github.com/leitao/btrfs-reflink-async-compress

Thanks for the report.

>=20
> My robot identified this as the root cause, but I am not smart enough to
> understand:
>=20
> A reflink into a range that is still being compressed does not wait
> for it:
>=20
> 1. Another part of the same folio starts writeback first, which clears
>     the folio's dirty tag.

This shouldn't happen, as btrfs has per-block dirty tracking, thus the=20
PAGECACHE_TAG_DIRTY should only be cleared when the last dirty block got=
=20
its dirty flag cleared.

It looks like some part of code doesn't properly handling the folio=20
PAGECACHE_TAG* in a per-block way.

Thankfully you have a reproducer, it should greatly speedup the fix.

And thank you again for doing a proper bug report, instead of creating=20
LLM slop without understanding it.
A lot of guys should really adapt your style of bug reporting.

Thanks,
Qu
> 2. The second filemap_fdatawrite_range() in btrfs_fdatawrite_range()
>     finds folios by that tag, so btrfs_wait_ordered_range() returns
>     before the async extent has an ordered extent.
> 3. btrfs_clone() drops or splits the extent map pinned for that extent,
>     and the transaction aborts when it completes. If the clone wins the
>     race instead, the compressed write lands after it and the cloned dat=
a
>     is silently lost.
>=20
> Thanks,
> --breno

