Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630526;
	b=ar27ekEGT3kkOkozUmBty8sz89y0MF4M5miOqcE3B/ylLwDCcGxlBO+3cYYsgl3+OVZJ
	 hBOLITUCAOZJPCrDaEtQJXxtd2Yb3V/X4yI88qfsB4ZE9EcdNmr0x3VZJwNyvfd5XWsQt
	 FXrY7W9t2C7c1sW7r2YKz7FIqjHM1lXTpxGp/mT7P8Im9o+uW3jSr2beeznRqu94LJkp0
	 q4nDAU8SKKsDOxsVOMX5ebEvM836SenukNUFGqpMG2eKxvA/lCTsuhXRmNBk8tL4054KJ
	 nGl+5XfxTd8uAni4Jtw2asZX4Xrvwz4xK2RtrCGPh/XHuRcjIb4tkRhc0BmBeygL0ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630526;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=BAC9Q/o7yg587muzO0br7Dav6MDTniGnOU9JLCHnOSU=;
	b=iJABS3eA9mMq3QwKbRE82bxeBDwmWRhhG8tdt1SC139Nyz6nUsx+hI9+cS6ODVVpLpdA
	 ZuxsV17/LvsiaP4aMCbQY1I6aNUvxnYpQNrMWBDD0ruYgANeRCXvXVRU70Vn6whJF95bS
	 5Fzut/59/WIVXPgvSjmCPj4ZXoFeekkU1jGgXr9lkMtcisCnpkX+HoRORoFgU7vEjSS4Y
	 mlViiJBl/ritTYaEThG23ESc83uDkcf6JUZPYNLbkJA8cLDBfwHAZuMD6DFDS5PYmWznh
	 IqgE3DRsneP6ymab4EbZnINK7Vt9qkbReEu0AVA2tnRdwSYCL05idNe9HnE/Tqy3tfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=SA34Ng4h;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC90606A885
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 04:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FC90606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=SA34Ng4h
DKIM2-Signature:  i=1; m=1; t=1794630523;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:saPv+G0SrnOE9vlTOgbXg2C5838x
   762o5RJl+Av7EXB+JpDrK9U/ei+Wr3UU/mqH07+yel5rDUl55vk2z+y+z5dj/142OzOEHmDedEQ
   ZwoOuWx8GkNODuw/vZoYQG7Kh3gSPEtjAYOFz+0xcuE2Px4SwtghGDfFlFiTdP2ojF2lHvHqu8x
   nUx5U+3YIC84vo++sI+c1E7LefgTDnxcRl/5BY05FdyLvTFdYfgOPDFm0z7XVFq29C1TypfhxsS
   gJ4V4iPGUa6bjrKNwEYE80XOJRrYKasGN1klQFgSOTeAjkyTv/hG02HPHJhaHo4sRejuEV9rxGS
   1WVSl3EuFwZh1Q==;
Message-Instance:  m=1;
 h=sha256:
   XJj82khlOZq46gePWW3pM/UvA5FODsaS8IseN7Idz4I=:
   5I4Adz8K8IgMUfhn669NtsDKn8sOR4gYRYTwphQ5JuQ=,
  sha512:
   ZTph1vHvCvbu/GL3FSLpCaxvNBbt3cWYyt7R8YmbXLp51cmTIvSLQyv3NCkut8+pLxdomL4AZ5ltviB08ExaNg==:
   jcV6r7N8FIis7FElGu3rFG71UrxkGf1riFe7GTPCu5vL/5xf1lcXGK+JuCDjs8AmAcIyXClKYie1NWCr/N2H3A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794630523; x=1795235323; i=quwenruo.btrfs@gmx.com;
	bh=BAC9Q/o7yg587muzO0br7Dav6MDTniGnOU9JLCHnOSU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SA34Ng4h0LVFmsaD8jfPI1DdEbZRwuzYVNy2MF5gIocmKCR8KGnv+C7/Eo3dJ1Qj
	 7n3uFbOdcX42ym/phCNsPwebKE535JDx3ay8/G8w7nperTm2LiYW6sLP6ePTdkpmw
	 nXxldxxOkaxKssoD2GU4J2Ojr3/oSAdEFsh7Pfve8v7Rq/SksASpNotNUTLIV6GDO
	 zrI/TLD128vcv+rbVqFI4O10LNRIU+4C8++JwRpTBN99ZoEmxxoj7QG2jso5WNLv9
	 Um0bLWBi457K1s7LnXIeuwMoZ0OzTwwwNeMW/k8ELxC+FejKi4uToOOZEzw4ft63f
	 ijIyCHQByH8d6xQ0bQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MZTmY-1wvYNw2Nfy-00KgaZ; Sat, 14
 Nov 2026 05:28:43 +0100
Message-ID: <911a40e1-001f-49bb-909d-cc068de277ec@gmx.com>
Date: Sat, 14 Nov 2026 14:58:39 +1030
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
Subject: Re: [PATCH] btrfs: speed up steal_from_bitmap_to_front() with a
 backward word scan
To: Elias Jernberg <eliasjernberg@gmail.com>, linux-btrfs@vger.kernel.org
References: <d829648c-3fc2-4f6e-ad07-ffce8be579a8@suse.com>
 <50cfbe7d-e925-447d-9131-bfd019bf97ea@suse.com>
 <20261114024824.710267-1-eliasjernberg@gmail.com>
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
In-Reply-To: <20261114024824.710267-1-eliasjernberg@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Ki4WgSRDw/9rYl8lzfyB5xaY7R4CofPuOFQBJqeChSXKWpJ5it1
 VccjqOAz/tWrjuvncGoVWWPI0nE1w63fZFYHg82+pqwSEBkApLEeqRG7RJc3ZsAnYUCndaf
 myasT3WHyixHzE2NkglvEot9qmB6MRtr2K2xu8zJ+LuPv+gPIXRNOHKS2toVCHTKmEPN4OC
 XC4yb6D7LAzTh+Tyyhudw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2ReJl0nH754=;aSTquXUo2qBWilzs6bVFWaJ6lZn
 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
 U+2Mpc1RR1M1zGc



=E5=9C=A8 2026/11/14 13:17, Elias Jernberg =E5=86=99=E9=81=93:
> (Resent to the list in plain text; my first copy was rejected as
> HTML. Qu, David, Filipe and Chris already have it, sorry for the
> duplicate.)
>=20
> On 2026/11/14 11:11, Qu Wenruo wrote:
>> Would it resolve the latency problem on 16K page sized systems?
>=20
> It helps a lot, but not fully, and on top of my patch it adds nothing
> measurable in this test.
>=20
> I measured on an Apple M5 MacBook Pro (16K pages) running a 7.3 based
> Asahi style tree, btrfs with 4K sectorsize, space_cache=3Dv2,
> compress=3Dzstd:3, discard=3Dasync. The test writes a 4 GiB file into a
> fragmented free space (about 1.05M extents), removes it, then times a
> buffered 4 GiB write plus fsync. Two runs per kernel:
>=20
>    kernel                      time (s)            MB/s
>    neither (older base)        36.1 / 33.6 / 29.3  119 / 128 / 147
>    your diff only              4.47 / 3.20         1106 / 1578
>    my patch only               1.28 / 1.23         5107 / 4881
>    your diff + my patch        1.40 / 1.34         4308 / 4559

Thanks a lot for the test result.

One interesting result is that, smaller bitmap is not always going to=20
help, e.g. your patch + the diff is still slower than your patch only.
> The "neither" numbers are from an earlier measurement on an older base
> of the same tree; I did not build a third kernel on the current base
> without both changes. The other three share the same base and config.
>=20
> A sysrq-l sample on the "your diff only" kernel still lands in
> _find_next_zero_bit() called from steal_from_bitmap(), so the bit by bit
> walk is still the hot spot, now over 32768 bits instead of 131072.
>=20
> So with 4K bitmaps alone it is about 10x better here, but still 3 to
> 4 times slower than the backward word scan. On top of the word scan
> I see no gain from the smaller bitmaps in this test (slightly lower,
> within the noise of two runs). I have not measured other workloads,
> 64K pages, or anything where the extra bitmap count could matter.
>=20
> Two notes on your diff:
>=20
> 1) fs/btrfs/tests/free-space-tests.c has its own
>     #define BITS_PER_BITMAP (PAGE_SIZE * 8UL), which would need the same
>     change. I did not run the sanity tests with your diff.
>=20
> 2) The tree I tested on is 7.3 based and still has the v1 cache
>     load/write path, where io_ctl_add_bitmap() and io_ctl_read_bitmap()
>     use copy_page(). With 4K bitmaps on a 16K page kernel that copies
>     past the 4K slab object, so for the test kernels I replaced it with
>     a memcpy() of BITS_PER_BITMAP / BITS_PER_BYTE (not exercised, the
>     filesystem uses space_cache=3Dv2). for-next has removed that path,
>     so this only matters for a backport.

Yeah, the diff is really a draft only for testing, far from being able=20
to submit.

>=20
> My reading of the numbers is that the word scan is the part that
> fixes the latency on large page systems, and the 4K bitmaps are an
> independent change on top of it.

Now I have no concern about the patch now. I originally thought limiting=
=20
the bitmap size would be enough to address the problem, but it is not=20
the case.

Furthermore smaller bitmap size itself may not always be good for=20
performance.

So the patch looks good to me now.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Thanks,
> Elias

