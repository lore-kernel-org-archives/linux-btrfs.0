Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D526282F3A;
	Mon, 25 May 2026 22:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779747050; cv=none; b=JA15WBbEQV6aweqUH8KiaI8YYLDYXCdDubYvoWLo/ZBfjuDd1duYZ0oSsvnHijv19BEqJyJY06cLUfGeP/E3WANsfdo3Nse+AMKvWl9vS/p64KfIVA8VU+a2m4VOhCOBadWLTWRZlqCLsOwFGc4Ew6rX1WZe4Nutut1R0oQPrQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779747050; c=relaxed/simple;
	bh=DTZXQO7G1HmqT/0ZWr0FpsjYHUM/PNptqDOA5p/k0m0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fnlhR0k0tDYDUe6+pVecM1SxDiAqAbZjtHpg97LC/yzvLwRTqv1/d5mmyAA42ooKwoQrWUl8tbGOIhCGVxa1GO6LnskUqhVBqaN4I90/P0B/TbXzbPzq2Ag7xOXvgEpen2je7suloRIwxPAAcnYZxHNTuvDKYHuFBpSGfSTDuNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=IZzA0Ysu; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="IZzA0Ysu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1779747036; x=1780351836; i=quwenruo.btrfs@gmx.com;
	bh=xet+17pgGpr5I3/1N9uo5PGQFKfeCht7q7IA6fzqAfE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=IZzA0Ysuzfo1txJPXLGAKLaN0lOLLuY7io6PorflE7BZI5YCnjRXBYshm2eTIf40
	 Q/+3iyIR3Amr8srlWMeSCsztfLpKAiUePeYaB3Ebwzm6qLClHMRhpnBB6VPzuUIuo
	 ZWGxKUG+NR0iJzXvSMPuvYQsZ1yvsOe09hiJeFHtBijkWWzjAGu/5MLmwerv9HOjN
	 m7TzK4q20QtlQENl/t2gOpYMHAHF9eEbLjZvIOIAMsz0agEuJU9Vvy8SPecpJBaA1
	 xI4EDvYxmvnRoT83AR+jzZ58Lqt5MB/ughUj6TD3JMwUuYvO4Dwui2bD8ljTePdUB
	 scbOQEAdLdJ/s0Lc0A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1ML9yc-1wjiaP1p6A-00PASg; Tue, 26
 May 2026 00:10:36 +0200
Message-ID: <a8e9dc7d-67f8-45f1-9ba2-0ada6a87fe9d@gmx.com>
Date: Tue, 26 May 2026 07:40:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix subpage state mismatch in cow_fixup writeback
 path
To: dsterba@suse.cz, Werner Kasselman <werner@verivus.ai>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 "wqu@suse.com" <wqu@suse.com>, "dsterba@suse.com" <dsterba@suse.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260316105654.710798-1-werner@verivus.com>
 <20260525141351.GE12792@twin.jikos.cz>
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
In-Reply-To: <20260525141351.GE12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Nt0oz5X5JexfYCCMPxbUdJAS2b0L/9Dq+Ee3GT2g7AWy7IsT+rO
 ihhK63SotCH8j6HHQImI6tQDJT0Jqm/nA4bwYbFOa285Lvn/T+idyiLRx5fVjkqxWl9XgBV
 oHuAASB1/o9i/RuY6Q4+yuH2hlG7EFPYdNiDcbhnFSC1QsXmyt21LDkKVmSQxklMjGCmUcl
 bl9mypk7f5aBVQZ82+4rA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0CLFjBWhiH4=;9fA4F6GMWCDFVxODMyxrA79hg5n
 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
 P+BxBVAKAd7wwKiYe1JS54ufeFWyZM3y2YlssQn



=E5=9C=A8 2026/5/25 23:43, David Sterba =E5=86=99=E9=81=93:
> On Mon, Mar 16, 2026 at 10:56:56AM +0000, Werner Kasselman wrote:
>> writepage_delalloc() marks all dirty sectors as locked via
>> btrfs_folio_set_lock(), setting bits in the subpage locked bitmap and
>> incrementing nr_locked.  These are cleaned up by
>> btrfs_folio_end_lock_bitmap() at the end of extent_writepage().
>>
>> However, when btrfs_writepage_cow_fixup() returns -EAGAIN inside
>> extent_writepage_io(), the code calls folio_unlock() directly and
>> returns 1, causing extent_writepage() to skip the bitmap cleanup:
>>
>>      ret =3D btrfs_writepage_cow_fixup(folio);
>>      if (ret =3D=3D -EAGAIN) {
>>          folio_redirty_for_writepage(bio_ctrl->wbc, folio);
>>          folio_unlock(folio);     // doesn't clear locked bitmap
>>          return 1;                // caller skips end_lock_bitmap()
>>      }
>>
>> This leaves the subpage locked bitmap out of sync with the folio lock
>> state: the folio is unlocked but its subpage locked bitmap still has
>> bits set and nr_locked is elevated.  When writeback retries the folio,
>> btrfs_folio_set_lock() hits the ASSERT at subpage.c:746 because the
>> bits are still set from the previous attempt.
>>
>> The cow_fixup path is largely a legacy path -- the GUP dirty-without-
>> informing-fs issue that triggered it has been fixed on the GUP side,
>> and experimental builds already catch this case with -EUCLEAN before
>> reaching the -EAGAIN return.  However the subpage state mismatch is
>> still a correctness issue for non-experimental builds under error
>> injection or memory pressure (kzalloc failure in
>> btrfs_writepage_cow_fixup()).
>>
>> Fix this by replacing folio_unlock() with btrfs_folio_end_lock_bitmap()=
,
>> which properly clears the locked bitmap bits before unlocking.  For
>> non-subpage or when nr_locked is 0 (e.g. called from
>> extent_write_locked_range()), btrfs_folio_end_lock_bitmap() falls
>> through to plain folio_unlock(), so existing behavior is preserved.
>>
>> Fixes: d034cdb4cc8a ("btrfs: lock subpage ranges in one go for writepag=
e_delalloc()")
>> CC: stable@vger.kernel.org
>> Signed-off-by: Werner Kasselman <werner@verivus.com>
>=20
> I'm going through patch backlog, this patch has some relevance. We're
> going to remove the fixup worker code in 7.2 completely so it cannot be
> applied to the development branch anymore.
>=20
> The problems are hard to hit or need error injection, I don't know if
> it's worth to backport to stable.

I think the root fix, btrfs: check and set EXTENT_DELALLOC_NEW before=20
clearing EXTENT_DELALLOC, is more relevant to backport.

And that fix is already CCed to stable, although only for 6.1+.
Older can be harder to backport.

With that fix backported, the cow fixup path will be a dead code, won't=20
make any difference if fix the error path or not.

Thanks,
Qu

> We've provided a long grace period to
> the fixup worker before removal and I'm glad we can delete it and forget
> about it. If somebody wants one last fix then I'm OK with that.
>=20

