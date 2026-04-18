Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613A329E10B
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 04:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776487589; cv=none; b=R/bqcHtHaVvCAhA9B0eZYSTaAhtGDnxScx71wOZoZ8oKe+ccGQaQ9Js9W+EF9/ZvD1913/efSkNvbkWIYq5yWwyF78gYv93L9isqxtqI8+F53cs2rDSxpz8r9S+yroaQArARBNbLW1+J0DFA7hsZUYQ741CzJRtLeCCR1XOcmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776487589; c=relaxed/simple;
	bh=DxciYcE+2ZF3qV4z78ohRwONadZXRmFPK7md+ZAAkQ0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nZpR3RLtWxWJBVqbTkaapV+pYkP+JTevL46ZGmekrVnm/Ax0YUBe34I9BPKuZ3vn+36dftocOStY4FCsA6JJT5lQN0ndSMwpj2waxf08K6vMlPRygWN3b4Mn0PnumuVzRYXKDGkP+QpepZk+NeEuXhznOEwdYITj0yDstnh0+ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=udZqbavF; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="udZqbavF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776487574; x=1777092374; i=quwenruo.btrfs@gmx.com;
	bh=DxciYcE+2ZF3qV4z78ohRwONadZXRmFPK7md+ZAAkQ0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=udZqbavF42tCdPWOO8/7nUAqmlscfoo0e4DmJtI/z8e4/6l9KDUlaf1LgqsO5jqw
	 WL+WHX+NMerE3hiPfUYZ72I2uWR2zQSpJlSzD0XCFWi1vW10pXR9tA4ER3p0NDxOf
	 CRPdHj0R0LJ2cPyH+tPABj1Lf+pwNSd3cLIgX7L0y04xD8U+1zwh+73s4x4dRRZWx
	 Ps/zHA8rUqRO64366ENrWrOiLrTQKD8ZeUsztq71Elvbl9bxAs2iSel4Bt3vVFu3s
	 Kd56Z9Fgn0T3IbnFvh5MGinwn6B6c55HY18ksgcRO8BMTISlrl5hEOHjKFISu9y8J
	 DictRdgjgj84hu9UFg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mnaof-1vWxJz1Gh3-00fOm8; Sat, 18
 Apr 2026 06:46:14 +0200
Message-ID: <767fe300-7ab0-4c91-ace9-ce73ad9b1771@gmx.com>
Date: Sat, 18 Apr 2026 14:16:11 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: preallocate extent changeset before acquiring
 extent_io_tree lock
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: tchou <tchou@synology.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
References: <20260417064011.1316310-1-tchou@synology.com>
 <20260417073836.1320467-1-tchou@synology.com>
 <9180d175-397c-45ba-94ac-8b6299fb9ec4@gmx.com>
Content-Language: en-US
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
In-Reply-To: <9180d175-397c-45ba-94ac-8b6299fb9ec4@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7UMkpwP5ahWHImJaJpSp2PRUOvXXyM+ZqSbzx05vjwp5FdcjL3E
 VTjsE8jVjGyb3CnURD557vSd0g+WSXcIg8Co2d1kbbUsMhC/lnYSDSsja4cSPVoX8j1J2qV
 p+lijPaiC4BqlZXS+LGLBeTJ+K84C/tXyie39VxoLsS73heJCG0xMd0XZORPJui4l3REOBt
 t2fI28ApQg+dbEAgf2oLw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:exkMPhIcOkQ=;CqOhlpe1RVSDG4WYJeXaElAC2RI
 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



=E5=9C=A8 2026/4/17 18:50, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/4/17 17:08, tchou =E5=86=99=E9=81=93:
>> In btrfs_clear_extent_bit_changeset(), the extent changeset ulist may=
=20
>> need
>> to allocate new nodes. Currently, this can happen while holding the
>> extent_io_tree->lock spinlock. Although ulist_prealloc() uses GFP_NOFS =
to
>> avoid deadlock with filesystem reclaim, it's better to preallocate befo=
re
>> acquiring the spinlock to:
>>
>> 1. Avoid potential allocation failures while holding the lock
>> 2. Be consistent with set_extent_bit() which already preallocates both
>> =C2=A0=C2=A0=C2=A0 extent state and changeset before the spinlock
>> 3. Reduce lock contention by not doing allocations under the lock
>>
>> Preallocate the changeset ulist node before acquiring the spinlock,
>> mirroring the pattern used for extent state preallocation.
>>
>> Signed-off-by: Ting-Chang Hou <tchou@synology.com>
>> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Forgot to mention, please do not add reviewed-by tags unless the=20
reviewer has explicitly provided.

Especially when you do not know which mail address the reviewer is=20
really using.

You do not need to resend, I have fixed the address in the for-next branch=
.

Thanks,
Qu

>=20
> Now pushed to for-next.
>=20
> Thanks,
> Qu
>=20
>> ---
>> =C2=A0 fs/btrfs/extent-io-tree.c | 3 +++
>> =C2=A0 1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
>> index 626702244809..b5ba650cdb55 100644
>> --- a/fs/btrfs/extent-io-tree.c
>> +++ b/fs/btrfs/extent-io-tree.c
>> @@ -663,6 +663,9 @@ int btrfs_clear_extent_bit_changeset(struct=20
>> extent_io_tree *tree, u64 start, u64
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prealloc =3D all=
oc_extent_state(mask);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 /* Preallocate the extent changeset ulist node befo=
re acquiring=20
>> spinlock. */
>> +=C2=A0=C2=A0=C2=A0 if (changeset)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_changeset_prealloc(c=
hangeset, mask);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&tree->lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cached_state) {
>=20
>=20

