Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A04277035;
	Mon, 16 Mar 2026 10:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773655671; cv=none; b=fu0PSG26+mjIQyKmzYaXFJ0tA+cXALMIaQI3StvWR00iwa3NIxqGJVxll1Mw1vnLVoB1QtCKl1byX3wvLQhT54cSQJ0jg4L/dm71Odq4bYBDknRzC5PlkJHKQOYghXBdUS25yozV86b0Nklo6H31FJ7Aur1pVilci1xdCfr9sko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773655671; c=relaxed/simple;
	bh=Gc2zTWaBTqLU3LGhJOjnWnJ3ZidRM15XTpaP2B+owC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZqMRg1JeoQ+Iso96k8ZYSFcjtcamWUdJ0VbxBL63GiaOHXhychWhEpU+lXkxWnZLyUESwBmb3UNSXqNixtX1+Yl41mIKpYXMOTb4iFf7lm42S/gDQmftK980yPkdFIL+UL/hQXxck3o4eEJV/JN+92TXiNVnqplzuQbOBx0QKlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=EfTepgmB; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="EfTepgmB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773655668; x=1774260468; i=quwenruo.btrfs@gmx.com;
	bh=qyEvNl1tKSixCmf67zYgwh80e/tveFiWuVHvjI5wx1I=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=EfTepgmB0DC0cGxZ/bmPGpwksiPhh7HXqrOxzq6f8n0JwHhhLAAtsbALNuOmIN3Y
	 M9Mc7cAJpsoDjva9v9M3s62necJsSAnXll1pLZbUSruSX171C8tA4qtEZ10+aTfF9
	 1bm266AWViSkf9dsCf3AG6SDUyXc1zP7IhFIHmPb4gSL+d46DN8ddh4H8bvXom9Tp
	 2+KMA/kKCTBcyafD5Zfjlwrv8OJasKNVkvVej0v2k3W0P4LZiqX4ZheXWo3CdeB/g
	 TSX42qQyIq9NdYChabeQKncxZEYyfO+pm4ahllERjZ0GyGYGZCLtjS7mhstHjrPvd
	 UUj+GUg+4+DpBmhHaw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MOiDX-1wFT6y1slj-00LRoT; Mon, 16
 Mar 2026 11:07:47 +0100
Message-ID: <ef838960-b0e0-4ad1-bfd1-556167120b5d@gmx.com>
Date: Mon, 16 Mar 2026 20:37:44 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix subpage locked bitmap leak in cow_fixup
 writeback path
To: Werner Kasselman <werner@verivus.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "wqu@suse.com" <wqu@suse.com>, "dsterba@suse.com" <dsterba@suse.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <ME0P300MB0853F6FA6D7872D77E98338CBD40A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
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
In-Reply-To: <ME0P300MB0853F6FA6D7872D77E98338CBD40A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NI81kJPIuey9eRsDeoWKcL5L70Wzm89OOANcyGQYY5EAwSw1nVq
 6RUBcDFiKbnrP68WKhs/iqgSF/QC2s8k4HvyzzkJg6QULCNZ62fLDzgd2+WJgIxon5juzie
 sT4f5gejP9dF9cMZfQ38amVhzRFoeoLB41VDSjyVqOfesux6pwBczUG2nuOKnoMLL0MjRgX
 rAaaEkaj7y9S8oBac3cUw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3dkUxYceW2g=;72M86PZRH77bYxYHGqgW4KaOcAb
 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



=E5=9C=A8 2026/3/16 20:27, Werner Kasselman =E5=86=99=E9=81=93:
> Hi,
>=20
> While auditing the btrfs subpage writeback path in 7.0-rc4, I found a=20
> locked bitmap leak in extent_writepage_io() when=20
> btrfs_writepage_cow_fixup() returns -EAGAIN.
>=20
> Since commit c96d0e392141 ("btrfs: mark all dirty sectors as locked=20
> inside writepage_delalloc()"), writepage_delalloc() calls=20
> btrfs_folio_set_lock() for all dirty sectors, setting bits in the=20
> subpage locked bitmap and incrementing nr_locked. These are normally=20
> cleaned up by btrfs_folio_end_lock_bitmap() at the end of=20
> extent_writepage().
>=20
> However, when cow_fixup returns -EAGAIN, extent_writepage_io() calls=20
> plain folio_unlock() and returns 1.=C2=A0 This causes extent_writepage()=
 to=20
> skip btrfs_folio_end_lock_bitmap() entirely.=C2=A0 The locked bitmap bit=
s and=20
> nr_locked counter are leaked.

You (or the LLM) are right, although I won't call it bitmap leak, but=20
subpage state mismatch against folio status.

The folio is unlocked but its subpage bitmap is not.

However this is already in a very corner case, that cow fixup path can=20
only be triggered when a dirty range is submitted without an ordered exten=
t.

It's possible to trigger but only with certain error injection, and even=
=20
when that is triggered, it will be more likely for the EUCLEAN case=20
other than EAGAIN.

Just check the EXPERIMENTAL feature check inside that function.

>=20
> When writeback retries the folio, btrfs_folio_set_lock() tries to set=20
> the same bits again and hits the ASSERT at subpage.c:746.
>=20
> The fix replaces folio_unlock() with btrfs_folio_end_lock_bitmap(),=20
> which clears the locked bitmap bits before unlocking.=C2=A0 For non-subp=
age=20
> configurations, btrfs_folio_end_lock_bitmap() falls through to plain=20
> folio_unlock(), so behavior is unchanged.
>=20
> This affects subpage configurations (sectorsize < PAGE_SIZE, e.g. 4K=20
> sector on 64K-page ARM64) when the cow_fixup path triggers, which=20
> happens when a page is dirtied via GUP/pin_user_pages without going=20
> through the filesystem.

IIRC it's no longer the case, the dirty but without informing the fs bug=
=20
is already fixed on the GUP side.


Finally, please send a patch properly through git-send-email, not an=20
attachment.

How do you expect one to review an attachment?

Thanks,
Qu

>=20
> I also wrote a standalone bitmap state machine simulation that=20
> reproduces the invariant violation and verifies the fix:
>=20
>  =C2=A0 tools/testing/btrfs/test-subpage-cow-fixup.c
>=20
>  =C2=A0 $ cc -o test tools/testing/btrfs/test-subpage-cow-fixup.c && ./t=
est
>=20
>  =C2=A0 TEST 1: Buggy path (folio_unlock)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ... PASS (bug=
=20
> reproduced)
>=20
>  =C2=A0 TEST 2: Fixed path (end_lock_bitmap)=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ... PASS
>=20
>  =C2=A0 TEST 3: Non-subpage path (both behave)=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ... PASS
>=20
>  =C2=A0 TEST 4: Partial async + cow_fixup (buggy)=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ... PASS (bug=20
> reproduced)
>=20
>  =C2=A0 TEST 5: Partial async + cow_fixup (fixed)=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ... PASS
>=20
> Please review.
>=20
> Thanks,
>=20
> Werner
>=20

