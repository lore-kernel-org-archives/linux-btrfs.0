Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7722135AD;
	Wed, 22 Jul 2026 07:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784704926; cv=none; b=fxJmCvAu52XGmVes2KR8rWyv1708XU7lFX1eoSrOUrvv+C+UzQL1u1YojnfygW61/D6ZaICXnRQyBQSFmlbfd1NGnl6OeCt6Dh+yg3alm1Pw6fm8qPB5yOS7l3XyEUbi+XvMWe666wG94O8v1PqexlEGyi3hoejUmrCPSHq71J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784704926; c=relaxed/simple;
	bh=Rbgk3KRg98turYTv6dBDrOhY+2L1Yt5jg1Gvb1wvz40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyvQwXaWrQmEwmyQ7RNaUtTP5+6fm4HNQRLbeoDQHUSMPrWTXbMQTvoGUcPy+Zoequ18DW7yAZxOp4SXyAelRgJZWPO7lPTZKl0njrF3NAjU9mqHnfgpJkFjAbG//iG1LyqNlvarujrirTWGDy5u69Ss7uwyMZ2vOD3cMs+/1Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Z+zUDdXr; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Z+zUDdXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784704914; x=1785309714; i=quwenruo.btrfs@gmx.com;
	bh=l41LH8Rx4hAje2YIlzm853zPiNBm0v93I0bg53wXMR8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Z+zUDdXrnAOxYibFBOBtDGqaKKTm/y6JgVf74zziSc83GtdvwTcKK5x7TySYh+bQ
	 tdg1ydxQUiE1juaP8i92aRL68Q+LtXHHCPUkb2JjuFn7QYGqaHqCPdTvD4dJuB2rv
	 n7tuNUsc7U7mcnIXcM3P1LnBGjXSlZBy7fmjzDoRUevHgbc651u3BZQsVYYtdQxAH
	 Dilg/OvNDpIywNF8GzGeUY8YDMKn8LPgPCZ8y4DU+5WYYTUfJeuXkCUn/YbCwBnFt
	 qxW13Jd/THFZxLE5kamHKPkkmXEsQW3mOqE90ZITQlnt2h4sociXLdVnG+GSaPpvR
	 ewaMicWhDtsEJYweZg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MysW2-1x94SZ3GyY-00sgOF; Wed, 22
 Jul 2026 09:21:54 +0200
Message-ID: <79b9b1b2-0455-4a7c-85fd-929f4103f198@gmx.com>
Date: Wed, 22 Jul 2026 16:51:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 7.2-rc1 regression Folio lock leak in writepage_delalloc()
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
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
In-Reply-To: <20260721191152.101118-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3c24Va3/BGdIWjPY8MAJ1WpMPEKt3KgWW5OyCWKcOZt+eZxHFid
 GZMNfwUYpykAZg5GFZ5mXaWU4618YL9pDaAQn7RJlbhc3KuWGEJ0g4AI4YCcX5gwR8OyoRx
 YKGDtOIbrf/0fG2nwPxY/oy4NdCtDAwjp9dlh0bIeGGhHn4Jdo3+1kvIxlafs5ZT2uK8SXJ
 F8TO+Uda2cWEiLm4Ehzog==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W5r62/q36e8=;wA59sZ8/kcnNcmJQ0exT+I5Pnxm
 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
 mzCOht/udSd34epZamByW



=E5=9C=A8 2026/7/22 04:41, Christian Borntraeger =E5=86=99=E9=81=93:
> We have seen random hangs in our daily CI run where qemu/KVM
> processes  deadlocks guests with file-backed RAM on btrfs (large data fo=
lios)
>=20
> With the help of claude I think we found the/one problem on an s390
> KVM host running 7.2.0-rc3 (KASAN test kernel, but the issue is not
> KASAN related). And to be honest here, most of the writeup was created
> by claude and I added things where appropriate. Also the patch was
> mostly done with the help of claude.
>=20
> A KVM guest with its RAM backed by a file on btrfs (zstd compression
> enabled) locked up together with the host's writeback: two vCPU
> threads, an irqfd worker, two flusher workers, khugepaged and a
> syncfs caller (dnf) were all stuck in D state for hours.  Analysis
> of the crash dump shows a leaked folio lock in btrfs'
> writepage_delalloc(); a proposed fix is in the reply mail.
>=20
> I still need to verify that this patches fixes the deadlock in our
> CI but wanted some feedback first.
>=20
> Dump analysis (shortened)
> -------------------------
> All blocked tasks funnel into one 64-page (256K) large data folio of
> the guest RAM file:
>=20
>    folio 0x800083fb000, inode 1881035 (the 1.25G s390.ram file)
>    flags: PG_locked | PG_waiters | PG_dirty | PG_private | PG_uptodate
>           (PG_writeback NOT set)
>    btrfs_folio_state: nr_locked =3D=3D 0, subpage dirty bitmap empty
>    still mapped (63/64 PTEs) and on the LRU, no outstanding block I/O
>=20
> Waiters on that folio lock:
>    - 2 vCPU threads + 1 irqfd kworker, all in
>      btrfs_page_mkwrite() -> folio_lock, holding mmap_lock (read)
> crash> bt 66448
> PID: 66448    TASK: 9e934a00          CPU: 9    COMMAND: "CPU 1/KVM"
>   #0 [b8b25dbe7d8] __schedule at c0b186d5e78
>   #1 [b8b25dbe908] schedule at c0b186d7040
>   #2 [b8b25dbe948] io_schedule at c0b186d723c
>   #3 [b8b25dbe978] folio_wait_bit_common at c0b167e719c
>   #4 [b8b25dbeaf0] btrfs_page_mkwrite at c0b172816fc
>   #5 [b8b25dbec98] do_page_mkwrite at c0b168a4ada
>   #6 [b8b25dbecf0] do_wp_page at c0b168b2350
>   #7 [b8b25dbed70] handle_pte_fault at c0b168bfaf4
>   #8 [b8b25dbee58] __handle_mm_fault at c0b168c003e
>   #9 [b8b25dbefc0] handle_mm_fault at c0b168c09b6
> #10 [b8b25dbf020] __get_user_pages at c0b16899cfc
> #11 [b8b25dbf148] get_user_pages_unlocked at c0b1689af1c
> #12 [b8b25dbf248] hva_to_pfn at c0a9711e20e [kvm]
> #13 [b8b25dbf3f0] __kvm_faultin_pfn at c0a9711ea26 [kvm]
> #14 [b8b25dbf4e8] kvm_s390_faultin_gfn at c0a971c092c [kvm]
> #15 [b8b25dbf5f8] vcpu_post_run_handle_fault at c0a97148b5e [kvm]
> #16 [b8b25dbf6f0] __vcpu_run at c0a9715c1f2 [kvm]
> #17 [b8b25dbf808] kvm_arch_vcpu_ioctl_run at c0a9715d3e4 [kvm]
> #18 [b8b25dbfbb8] kvm_vcpu_ioctl at c0a97117bd8 [kvm]
> #19 [b8b25dbfdd8] __s390x_sys_ioctl at c0b16aa3614
> #20 [b8b25dbfe40] __do_syscall at c0b186cdaee
> #21 [b8b25dbfe98] system_call at c0b186ebd42
>   USER-MODE INTERRUPT FRAME; pt_regs at b8b25dbff38:
>   PSW:  0705000180000000 000003ff8a92662c (user space)
>   GPRS: 000003ff627faf50 0000000000000036 ffffffffffffffda 000000000000a=
e80
>         0000000000000000 000003ff627fc8c0 000002aa1f8a7880 000003ff8a8ad=
310
>         000002aa1e1f3c60 0000000000000000 000000000000ae80 000002aa1f8a2=
f60
>         000003ff8d3adfa8 000003ff627fc8c0 000003ff627faff0 000003ff627fa=
e88
>=20
>=20
>    - flusher: extent_write_cache_pages() -> folio_lock
>    - delalloc space reclaim worker: same, while holding
>      fs_info->delalloc_root_mutex (which in turn blocks
>      btrfs_async_reclaim_metadata_space on the mutex)
> Behind those: khugepaged in down_write(mmap_lock), and syncfs.
>=20
> No task in the system owns the folio lock; nothing references the
> folio except the six waiters.  The lock was leaked.
>=20
> Root cause
> ----------
> A folio can carry the folio-level dirty flag with an EMPTY btrfs
> subpage dirty bitmap.  btrfs data mappings use filemap_dirty_folio(),
> so a generic folio_mark_dirty() sets only the folio flag and xarray
> tag - no subpage dirty bits, no delalloc reservation.  On s390 this
> happens all the time: the KVM irq adapter path
> (arch/s390/kvm/interrupt.c, adapter_indicators_set()) pins the guest
> interrupt indicator page with pin_user_pages_remote(FOLL_WRITE),
> sets the indicator bit and calls set_page_dirty_lock().  Once a
> previously written folio has gone through one complete writeback
> cycle (subpage dirty bitmap empty again), the next adapter interrupt
> re-dirties it with only the folio flag.

No, that's not how things should work.

I have explained the problem in the RFC patch. I am only going to add=20
some extra explanation inlined below.

>=20
> Writeback then does:
>=20
>    extent_write_cache_pages(): folio_lock(), folio is dirty -> proceed
>    extent_writepage() -> writepage_delalloc():
>      - btrfs_copy_subpage_dirty_bitmap() -> submit_bitmap is EMPTY
>      - the btrfs_folio_set_lock() loop sets nothing (nr_locked stays 0)
>      - find_lock_delalloc_range() finds nothing -> goto out
>      - out: bitmap_empty(submit_bitmap) is true -> return 1
>=20
> The "return 1" path means "all dirty ranges were submitted
> asynchronously, the async submission owns the folio unlock" - but
> nothing was submitted, so extent_writepage() returns and the folio
> stays locked forever.  This matches every flag of the dump folio
> (locked, dirty, nr_locked =3D=3D 0, no writeback, still mapped/LRU).
>=20
> Verifying this in the dump:
>=20
> - uptodate =3D 0xffffffffffffffff =E2=80=94 all 64 blocks uptodate (cons=
istent with PG_uptodate)
> - dirty =3D 0x0 =E2=80=94 the subpage dirty bitmap is EMPTY, exactly as =
the root cause predicts
> - writeback =3D 0x0 =E2=80=94 no writeback in flight (consistent with PG=
_writeback clear)
>=20
>=20
> Exposure
> --------
> - Single-block folios are immune: btrfs_copy_subpage_dirty_bitmap()
>    unconditionally reports bit 0 for blocks_per_folio =3D=3D 1.

Unfortunately no.

One of the biggest problem is, all the other things, from extent map to=20
ordered extent are not properly prepared.

E.g. even if btrfs_copy_subpage_dirty_bitmap() returns bit 0 set, later=20
EXTENT_DELALLOC is not set.

So find_lock_delalloc_range() will return false, and since we found no=20
delalloc range, @last_delalloc_end is still zero, we goto out label,=20
without creating any ordered extent/extent map.

Then we go into extent_writepage_io(), which will rely on the extent_map=
=20
created by run_delalloc_range() for IO submission.

But since we have no OE/EM created, we will grab one from on-disk=20
metadata, and if the original on-disk metadata shows there is a hole, we=
=20
will trigger the ASSERT() inside submit_one_sector(), about the EM is a=20
hole.

Before v7.2-rc1, we have a lot of extra handling (folio ordered flag) to=
=20
exactly catch such situation.
But since we haven't really hit such case anymore for a while, in=20
v7.2-rc we also remove the that flag, otherwise it should catch such=20
problem much earilier.

> - Subpage setups (e.g. 64K page size with 4K sectorsize) have been
>    exposed since the submission bitmap rework in v6.12
>    (bd610c0937aa "btrfs: only unlock the to-be-submitted ranges
>    inside a folio").
> - 4K page size systems became exposed with large data folio support
>    in v7.2-rc1, which routes every large folio through the subpage
>    machinery.  That is why we only started seeing this now.
>=20
> Any GUP-style dirtier can trigger it (KVM adapter interrupts on
> s390, vfio, RDMA, io_uring fixed buffers, ...) as long as the target
> is a multi-block folio of a btrfs data mapping that was clean at the
> time of set_page_dirty_lock().
>=20
> Reproducer outline: KVM guest on s390 with memory-backend-file on
> btrfs + virtio devices using irqfd adapter indicators;

I strongly doubt if it's a specific S390 feature breaking the assumption.

As io uring is also heavily tested, and IIRC there is already a huge GUP=
=20
work to address the long existing unexpected dirty page behavior in v5.15.

So I strongly doubt if it's some S390x feature not properly following=20
the existing scheme.

At least on both x86_64 and arm64 (64K page size), since the=20
introduction of experimental large folios, I haven't seen something=20
similar like this.

If it's S390X specific, then I do not think it's something we can handle=
=20
by ourselves.

Thanks,
Qu

> hangs within
> ~25 minutes of guest uptime in our setup.  A targeted reproducer
> should also work on x86: mmap a file on btrfs, write it, fsync, let
> writeback finish, then pin_user_pages(FOLL_WRITE) +
> set_page_dirty_lock() on a page of a large folio and trigger sync.
>=20
> Proposed fix
> ------------
> Detect the empty-at-entry bitmap right after it has been copied,
> before any range lock is set up, clear the stale folio dirty flag
> (nothing can ever be written back for it; all dirty flag setters
> serialize on the folio lock we hold) and unlock the folio.  Patch
> attached below; it survives our compile test and we are preparing a
> test run on the affected machine.  Comments welcome - especially on
> whether clearing the folio dirty flag is the desired semantic here,
> versus e.g. routing such folios through the cow fixup worker to
> actually persist GUP-written data.
>=20
> Thanks
>=20
> Christian
>=20
>=20
>=20
>=20
>=20

