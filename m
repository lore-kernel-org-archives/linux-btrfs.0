Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2FE14900E;
	Mon, 27 Jul 2026 05:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785131238; cv=none; b=Tlr+Pah3K3PkfWSAZ9ezzLakoMucezYKCtaAw7RFi5EFPgP4ID7ZUbZPBh0eWZ07HyKmAXYcOtrOPF0uz8LmPB+WhBljSBLe07FrXlcLhsfkDiURYQ92103tRh4mjrYf0QNQ9tBp8kda57cWBSzx9MjjwXxzSs3GeVogAjt0JCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785131238; c=relaxed/simple;
	bh=pgcOYzwvQnOhz+rzNEeQKiMvph3Rh8U4RgKix8+KgSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CpRtQIWSbQ2WjTis8TpH/g9eTlwkMWW/yozCkpoYpmQsEX2+GaW1+7z6KfmbHxGx89tAWBJh4WaPaGvPs2UG1MZDwvH3/JOUp0sHs92HfPaA6mXIywIlcsEVqL9vAganVs/pYe5Tp1ie5p2O8PxLQW6lkvdP/Gkt/IC4Gek0x+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=n0wCiXVS; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="n0wCiXVS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785131229; x=1785736029; i=quwenruo.btrfs@gmx.com;
	bh=waKzNd7Rj0LwLrcFiyifg3inFenmStGkXYPEmNL2B9Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=n0wCiXVSBooFantayZtz0dLebRmHKb08OLEiQ4kixLvwXj+EZQGSVd/wkK//m1jK
	 8nN/D6yO++hUXCWMw1y3rROMeKG1aGoVNwd4gZBTBfL/0Or/cPzWxuP49DpD745Aq
	 GFCZfuFuEigbEuKGQgqeCoM7YDw4EaORYlBMEyPw8UQmTnxaO7d5MwA8/TikidnWm
	 zD12x5WSdEsRrco1BEbOP1bYCKJbuLCRVinMqR0SqoOuulh0LlqBsukMDjdUYQ9f4
	 yfhSSccl0OwsLfjRrGoBczAjIcHHZw0/ug0Sw3D2XpY9bHJbwTi/z5gFN0KBiKEZq
	 8zcc8zRv7rixyGDCuw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MMGNC-1wUusM1Ymc-00KSzV; Mon, 27
 Jul 2026 07:47:08 +0200
Message-ID: <6b315bd2-2d81-4926-8ae3-79dc2b19e493@gmx.com>
Date: Mon, 27 Jul 2026 15:17:03 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: lzo: reject inline extents without compressed
 data
To: David Lee <david.lee@trailofbits.com>, Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>,
 Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260715090516.512417-1-david.lee@trailofbits.com>
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
In-Reply-To: <20260715090516.512417-1-david.lee@trailofbits.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:U5Sh4bMMSpYNF/rJgUHmQSzaSLsL6vdHkEQMnNAqvl2xT/VXywM
 3gi09hPQ5neTe82kDSWrgA8zs1qGUgqNSqEuwG3x8shyk6uD+WkpBtiHnvOJ8sHRI/hh7v3
 TYi+QJv5F+jA29C7FJGHZxfaN4ac1JgZSiykAAfAG4ApKHHA5Ju9mWnlydFf68Kfpcl4Pv7
 wSt3vrEpEtb2mg+0jbHqQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1+lFzxoxQeM=;k+CnCoB/7/IBmQGhUsE61Y4agk6
 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
 =



=E5=9C=A8 2026/7/15 18:35, David Lee =E5=86=99=E9=81=93:
> inline Btrfs LZO payload shorter than two LZO headers.
>=20
> Fix the validation or lifetime rule at the vulnerable boundary so malfor=
med
> or racing input cannot reach the faulting path.
>=20
> A four-byte extent produced the following KASAN report on Linux 7.2-rc2:
>=20
>    BUG: KASAN: slab-out-of-bounds in lzo_decompress+0x57d/0x700
>    Read of size 4 at addr ffff888006f2e644 by task btrfs_lzo_inlin/77
>=20
>    Call Trace:
>     <TASK>
>     dump_stack_lvl+0x5b/0x70
>     print_report+0xd1/0x610
>     ? _raw_spin_lock_irqsave+0x78/0xc0
>     ? kasan_complete_mode_report_info+0x2a/0x200
>     kasan_report+0xe0/0x110
>     ? lzo_decompress+0x57d/0x700
>     ? lzo_decompress+0x57d/0x700
>     __asan_report_load_n_noabort+0x13/0x20
>     lzo_decompress+0x57d/0x700
>     ? lzo_decompress_bio+0x1e80/0x1e80
>     btrfs_decompress+0x140/0x1c0
>     uncompress_inline+0x147/0x1b0
>     btrfs_get_extent+0xb23/0x10a0
>     ? btrfs_rename2+0xb0/0xb0
>     ? _raw_spin_lock+0x72/0xb0
>     ? _raw_read_lock_irq+0x50/0x50
>     ? __kasan_check_read+0x15/0x20
>     ? btrfs_folio_test_uptodate+0xc8/0x140
>     btrfs_do_readpage.constprop.0+0x538/0x1ac0
>     ? btrfs_lookup_ordered_extent+0x2c0/0x2c0
>     ? xa_load+0xb0/0x1e0
>     btrfs_readahead+0x32f/0x5f0
>     ? btrfs_writepages+0x180/0x180
>     ? lruvec_stat_mod_folio+0x240/0x330
>     ? write_one_eb+0xb30/0xb30
>     read_pages+0x16f/0x850
>     ? __kasan_check_read+0x15/0x20
>     ? __folio_batch_add_and_move+0x134/0x1c0
>     ? ractl_alloc_folio.constprop.0+0x90/0x90
>     ? filemap_add_folio+0x1cd/0x4f0
>     ? __folio_alloc_noprof+0x69/0xa0
>     page_cache_ra_unbounded+0x296/0x490
>     do_page_cache_ra+0xd9/0x130
>     page_cache_sync_ra+0x3ee/0x6f0
>     filemap_get_pages+0x306/0x15c0
>     ? is_bpf_text_address+0x14/0x30
>     ? kernel_text_address+0x89/0xf0
>     ? filemap_add_folio+0x4f0/0x4f0
>     ? putname+0x78/0xc0
>     filemap_read+0x329/0xd00
>     ? kasan_save_track+0x18/0x40
>     ? __kasan_slab_free+0x44/0x60
>     ? putname+0x78/0xc0
>     ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
>     ? filemap_get_pages+0x15c0/0x15c0
>     btrfs_file_read_iter+0x1f8/0x2b0
>     vfs_read+0x4ef/0x720
>     ? putname+0x78/0xc0
>     ? __kasan_slab_free+0x56/0x60
>     ? kernel_read+0x180/0x180
>     ? putname+0x78/0xc0
>     ? __kasan_check_read+0x15/0x20
>     ksys_read+0xf8/0x1d0
>     ? vfs_write+0xa30/0xa30
>     ? __x64_sys_open+0x180/0x180
>     __x64_sys_read+0x71/0xb0
>     ? __kasan_check_read+0x15/0x20
>     x64_sys_call+0x1ab0/0x1b70
>     do_syscall_64+0x61/0x470
>     entry_SYSCALL_64_after_hwframe+0x4b/0x53
>     </TASK>
>=20
> Link: https://lore.kernel.org/all/20260714071054.1715464-1-david.lee@tra=
ilofbits.com/
> Fixes: a6fa6fae40ec ("btrfs: Add lzo compression support")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: David Lee <david.lee@trailofbits.com>

Since the patch is fixing a real problem, I have pushed it to for-next,=20
but with commit message fully reworked.

Thanks,
Qu
