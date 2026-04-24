Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC2B35AC35
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 10:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025268; cv=none; b=HBSaES6hkh1/a9wlrAXWMLvwxTTCET8Yt1KAbXqQcEF18vCK+3DiIJJ4ilptMU506hBmWEPnCGo9Gdxicntj+Ymj3Q9cVSnief4DqM5suE8KxGPrwqGZ6fRtUeSafHt1iHRMe3tHxpleeVehTDhfaLDKySZiE23fgwQLBX77QTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025268; c=relaxed/simple;
	bh=cUzXuePM0hibNeTCtcWIMO8HXEL4fyd/NfytlJU5oOI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=eE6bXJo6NXFGksN5P9viBfLM1P8OIA+bfkrmBfdPUIx9LDfoI7lcJLaPWQ866dstcfrJfdbWqyLgMmlughRuMKCxzTP8oGocKCpalS2q3BgfTdd4j2Y/xf5UKoB/eSbk1+MUcSWHIXXsmyAMfQBRT/ajG669YhaM7Ydo6myMsWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=l8Q0ffnS; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="l8Q0ffnS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777025262; x=1777630062; i=quwenruo.btrfs@gmx.com;
	bh=8VAMekYBlxvM2fBb4Jxum3oG6b986oeLpmWKCN5fXbE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=l8Q0ffnS4Nd2IlB50VfHlJ8Mc2Vhyd3zFNvyEoUR0PA+g3NlIsXggFsEH2Vy7psq
	 0rs/OOxGHuAePMOjUsUWGrJ1+Qk2is9rc3+MSngnpIQPddLBsIf3t02RE+WTmCYGy
	 5rr0tZFMDcZdSExLH2haA1Wqe46n9+qjedUEr8LiXSGiWhO+2eJYpR/uUPdD6tPWy
	 XDfetT7kSPwM4O0RG1s+d/KWl5FKiKF+NHZDWLJ3dtwaqX6DQfUuYnk+u8HI9kC7v
	 6klKpcWbu+DnVjWYhyZzVojKMwSr54b+6dxJsAC1IP0kzFU+86dH4nNFTiDAXdlzp
	 dtoxmjvPVWJS0CZ8og==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MNsw4-1w0m1t2Xiy-00TY0e; Fri, 24
 Apr 2026 12:07:42 +0200
Message-ID: <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>
Date: Fri, 24 Apr 2026 19:37:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
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
In-Reply-To: <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5kLutNNT3r4GEPiiP6l5h1tF13RVql8DFN3CnyReRYb6h7DLNqE
 szi2kZ1aiKak/p6ePq1qIEs1ZFSv9DBNGoQTe8uSufp1WAVcBL2ZhD/1aDCbKl1WcilPrbY
 z+iQebghuVZxCRQ+QghUziTVOdoU6HVeTBLB3yPy/eR91hvuGHTVw+FxhkcnGtmg09X9Kty
 5LfH1N/sJa1nuy7jHdM3Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JezHxW6Pvjo=;xxJhfMAKltDXVqfMsuqkLwPpJU5
 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
 z89OvfVv86Lqebg==



=E5=9C=A8 2026/4/24 16:08, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/4/10 03:18, Boris Burkov =E5=86=99=E9=81=93:
> [...]
>>
>> This means iterating over to_reclaim by 128MiB at a time until it is
>> drained or we satisfy a ticket, rather than trying 3 times to do the
>> whole thing.
>>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: Boris Burkov <boris@bur.io>
>=20
> Hi Boris,
>=20
> I'm testing the latest for-next base as the baseline for the incoming=20
> huge folio support.
>=20
> On arm64 64K page size, 4K fs block size, I'm seeing a very weird=20
> behavior on generic/027.
> On 7.0-rc7, the test case takes less than 5 seconds and passes as expect=
ed.
>=20
> But on for-next it never finished, furthermore there is always a kworker=
=20
> taking a full core, deadlooping inside=20
> btrfs_async_reclaim_metadata_space(), and you can not unmount the fs.
>=20
> Here is the "echo l > /proc/sysrq-trigger" stack dump for the involved=
=20
> btrfs kworker:
>=20
> [ 6616.093728] CPU: 0 UID: 0 PID: 501715 Comm: kworker/u33:0 Not tainted=
=20
> 7.0.0-rc7-custom-64k+ #9 PREEMPT(full)
> [ 6616.093732] Hardware name: QEMU KVM Virtual Machine, BIOS unknown=20
> 2/2/2022
> [ 6616.093734] Workqueue: events_unbound=20
> btrfs_async_reclaim_metadata_space [btrfs]
> [ 6616.093849] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS=20
> BTYPE=3D--)
> [ 6616.093852] pc : btrfs_start_delalloc_roots+0xf0/0x268 [btrfs]
> [ 6616.093923] lr : btrfs_start_delalloc_roots+0x88/0x268 [btrfs]
> [ 6616.093987] sp : ffff80008af0fbd0
> [...]
> [ 6616.094008] Call trace:
> [ 6616.094009]=C2=A0 btrfs_start_delalloc_roots+0xf0/0x268 [btrfs] (P)
> [ 6616.094073]=C2=A0 flush_space+0x3d4/0x6b0 [btrfs]
> [ 6616.094138]=C2=A0 do_async_reclaim_metadata_space+0x88/0x1d8 [btrfs]
> [ 6616.094201]=C2=A0 btrfs_async_reclaim_metadata_space+0x50/0x80 [btrfs=
]
> [ 6616.094263]=C2=A0 process_one_work+0x174/0x540
> [ 6616.094277]=C2=A0 worker_thread+0x1a0/0x318
> [ 6616.094279]=C2=A0 kthread+0x140/0x158
> [ 6616.094285]=C2=A0 ret_from_fork+0x10/0x20
>=20
> So it's a regression, and bisection points to this patch.
>=20
> And I tried the following steps to further confirm it's caused by this=
=20
> commit:
>=20
> - The test passes just before the commit
>  =C2=A0 The previous commit is "btrfs: make inode->outstanding_extents a=
 u64".
>=20
> - The test failed at that commit
>  =C2=A0 The test case never finish and one kworker dead looping.
>=20
> - The test case pass at for-next with this commit reverted
>  =C2=A0 The test case finishes in seconds as usual.

Furthermore, even with this particular patch *reverted*, I'm still=20
seeing generic/224 hitting the same problem.

Currently I'm testing at the commit before the whole series, which is
"btrfs: abort transaction in do_remap_reloc_trans() on failure", and no=20
generic/224 hang nor 100% kworker CPU usage.

Thus I'm afraid the whole series may be involved.

Thanks,
Qu

>=20
> Do you have any clue on what's going wrong? I guess it's pretty hard to=
=20
> hit on x86_64.
>=20
> I have a local btrfs branch with huge folios support, with that it's=20
> pretty easy to hit similar problems on x86_64, but without that branch,=
=20
> no hit is observed so far on x86_64.
>=20
> Thanks,
> Qu
>=20
>> ---
>> =C2=A0 fs/btrfs/space-info.c | 31 ++++++++++++++++++++-----------
>> =C2=A0 1 file changed, 20 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
>> index f0436eea1544..e931deb3d013 100644
>> --- a/fs/btrfs/space-info.c
>> +++ b/fs/btrfs/space-info.c
>> @@ -725,9 +725,8 @@ static void shrink_delalloc(struct=20
>> btrfs_space_info *space_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 delalloc_bytes;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ordered_bytes;
>> -=C2=A0=C2=A0=C2=A0 u64 items;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 long time_left;
>> -=C2=A0=C2=A0=C2=A0 int loops;
>> +=C2=A0=C2=A0=C2=A0 u64 orig_tickets_id;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 delalloc_bytes =3D percpu_counter_sum_po=
sitive(&fs_info-=20
>> >delalloc_bytes);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ordered_bytes =3D percpu_counter_sum_pos=
itive(&fs_info-=20
>> >ordered_bytes);
>> @@ -735,9 +734,7 @@ static void shrink_delalloc(struct=20
>> btrfs_space_info *space_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Calc the number of the pages we need =
flush for space=20
>> reservation */
>> -=C2=A0=C2=A0=C2=A0 if (to_reclaim =3D=3D U64_MAX) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 items =3D U64_MAX;
>> -=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0 if (to_reclaim !=3D U64_MAX) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to_recla=
im is set to however much metadata we need to
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * reclaim,=
 but reclaiming that much data doesn't really track
>> @@ -751,7 +748,6 @@ static void shrink_delalloc(struct=20
>> btrfs_space_info *space_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * aggressi=
ve.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to_reclaim =3D m=
ax(to_reclaim, delalloc_bytes >> 3);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 items =3D calc_reclaim_item=
s_nr(fs_info, to_reclaim) * 2;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans =3D current->journal_info;
>> @@ -764,10 +760,14 @@ static void shrink_delalloc(struct=20
>> btrfs_space_info *space_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ordered_bytes > delalloc_bytes && !f=
or_preempt)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_ordered =3D=
 true;
>> -=C2=A0=C2=A0=C2=A0 loops =3D 0;
>> -=C2=A0=C2=A0=C2=A0 while ((delalloc_bytes || ordered_bytes) && loops <=
 3) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 temp =3D min(delalloc_b=
ytes, to_reclaim) >> PAGE_SHIFT;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 long nr_pages =3D min_t(u64=
, temp, LONG_MAX);
>> +=C2=A0=C2=A0=C2=A0 spin_lock(&space_info->lock);
>> +=C2=A0=C2=A0=C2=A0 orig_tickets_id =3D space_info->tickets_id;
>> +=C2=A0=C2=A0=C2=A0 spin_unlock(&space_info->lock);
>> +
>> +=C2=A0=C2=A0=C2=A0 while ((delalloc_bytes || ordered_bytes) && to_recl=
aim) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 iter_reclaim =3D min_t(=
u64, to_reclaim, SZ_128M);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 long nr_pages =3D min_t(u64=
, delalloc_bytes, iter_reclaim) >>=20
>> PAGE_SHIFT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 items =3D calc_reclaim_=
items_nr(fs_info, iter_reclaim) * 2;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int async_pages;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_start_dela=
lloc_roots(fs_info, nr_pages, true);
>> @@ -811,7 +811,7 @@ static void shrink_delalloc(struct=20
>> btrfs_space_info *space_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_read(&fs_info->async_delalloc_pages) <=
=3D
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 async_pages);
>> =C2=A0 skip_async:
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loops++;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to_reclaim -=3D iter_reclai=
m;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (wait_ordered=
 && !trans) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_wait_ordered_roots(fs_info, items, NULL);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> @@ -834,6 +834,15 @@ static void shrink_delalloc(struct=20
>> btrfs_space_info *space_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 spin_unlock(&space_info->lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 break;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If a ticket was sat=
isfied since we started, break out
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so the async reclai=
m state machine can process delayed
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * refs before we flus=
h more delalloc.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (space_info->tickets_id =
!=3D orig_tickets_id) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spi=
n_unlock(&space_info->lock);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&spa=
ce_info->lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 delalloc_bytes =
=3D percpu_counter_sum_positive(
>=20
>=20

