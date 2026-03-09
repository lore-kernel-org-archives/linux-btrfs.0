Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27194285CB9;
	Mon,  9 Mar 2026 21:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773091165; cv=none; b=fVukF8E8zn1URPSZ0la486Tstxj+ANnUaK2of+A7YuxgZapW7T5vtPM+ri/uVopQZtC8Cg8+I0QPl9v9wGnZzTEr4mfZDYsGi8bTrcnKyJ4zc9RBhyWmrhEvYVDHBy+FnLYeGJspo7C36qNjeAoNHJ7mh8pGWb1R6SB83wKVJ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773091165; c=relaxed/simple;
	bh=W9PkIX75NbggaGPBF08hISAKO6FhQ7OoS5SI3g6cQ04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tHNi/p2TVdl5Zgx7Tk2GWwdMEDnJK6RDyI688R3X23GTwVI5K0VpfnUG1BoGX8x10N88Yg7s+5RPL2XA22SMv7ly7xVPVe7pgw5a93dONrCUecMfDokZUa0GLMHEO3IW7+otfaYBUljbKFzl5Y1oqSCfSvAwTxl1eYtA8M0w2VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=UuHqVIj4; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="UuHqVIj4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773091160; x=1773695960; i=quwenruo.btrfs@gmx.com;
	bh=xatGzLZnbmxVAVDqlgdHLjZiPKXIjURe1Jo09qGrn00=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UuHqVIj4ptR7LAwr/NEUJgK2/fprGr5s8repKEJiufUltjfUoCTotBsW1CofWese
	 WYafawBkjCCne/INvO3YCzaPpuL5ubX7mFglRt794M0DogHMkEPtFRKP9WgHigbXL
	 exk0sJUHoouUDVu6yXJQ2DowkTyrBeWnuYEtrx+bRZcjANI6RCpoJFY2fh77Qs+FF
	 XfVQLYIijJUZ1W737rk7IlZyX5psnd5B635WOzoAPQ6/L8iObwyHKN9kWdphwZqKZ
	 uF0KNTC0BQ9aydCAYAY6PB79VHcQ/0hQUea7HJVG9URwkv3fhQUenXXb8QuRw5oyp
	 eGnpi7iQMzadpqwepw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MbRfl-1vOAGc3T0j-00n7su; Mon, 09
 Mar 2026 22:19:20 +0100
Message-ID: <fde72b16-380d-4d94-9c7e-c90c6ab7c079@gmx.com>
Date: Tue, 10 Mar 2026 07:49:15 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: validate free space bitmap size before testing
 bits
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: osandov@fb.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, stable@vger.kernel.org
References: <20260309103638.1500791-1-gality369@gmail.com>
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
In-Reply-To: <20260309103638.1500791-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GO2Q5dqc/d/mH7LJNXG+0O+6FWUsd9ySzvf31fu5VMRzlS5HF0v
 M9v5gv3GMILHXNsDtO/0nB3vkOCAOMipGEK8g5g68xFPqmT+oV2KvjaSPklQW0Uo1GqXmR/
 jSFbtnngKZ6t7dtDSuRGATK/GZaLIW1BDuHoJFCLcOr/AUZalObkxBYQOhlsoAq9Lhi1fbC
 eE/Vc9NcT0rcRR7ewh8rw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8snwDcxeQIA=;sRtsss8Prcp5AQRcHLPTS1r8iE5
 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



=E5=9C=A8 2026/3/9 21:06, ZhengYuan Huang =E5=86=99=E9=81=93:
> A corrupt free-space-tree leaf can contain a FREE_SPACE_BITMAP item
> whose on-disk item size does not match the bitmap size implied by
> key.offset.
>=20
> The free-space-tree loading path currently uses key.offset to iterate
> bitmap coverage, but does not verify that the item size matches
> free_space_bitmap_size(fs_info, key.offset). This allows a zero-sized
> or otherwise truncated bitmap item to be consumed as if it contained
> valid bitmap data.

Such check should be put into tree-checker, as that where we do all the=20
proper on-disk metadata checks.

>=20
> Once bit access runs past the valid extent buffer range, the computed
> folio index can reach an unpopulated eb->folios[] slot and trigger a
> NULL dereference in assert_eb_folio_uptodate().
>=20
> Fix this by validating FREE_SPACE_BITMAP item sizes in
> load_free_space_bitmaps() before testing any bits. If the on-disk item
> size does not match the expected bitmap size, treat the free-space-tree
> leaf as corrupt and fail loading it with -EUCLEAN.
>=20
> Also add a defensive range check in extent_buffer_test_bit() so that
> corrupt metadata cannot drive bitmap bit access beyond the extent
> buffer even if a bad caller reaches that helper.
>=20
> The bug is reproducible on 7.0.0-rc2-next-20260306 with a dynamic
> metadata fuzzing tool that injects single-bit corruptions into btrfs
> leaf blocks at runtime.

The "injects single-bit corruption into btrfs at runtime" part is confusin=
g.

As far as the fix goes, it's really just extra checks for on-disk metadata=
.

The sentense gives an impression that it's injecting error into the=20
memory, which is not fixable as such memory corruption can easily=20
corrupt any critical kernel structure.

Just says it's a fuzzed image.

> After this change, the corrupt bitmap item is
> rejected and the filesystem reports corruption instead of crashing.
>=20
> Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
> Cc: stable@vger.kernel.org # 4.5+
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> Root cause
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Put the proper analyze into the commit message.

In fact, put a btrfs ins dump-tree output for that item (the content of=20
that item may not be properly displayed though) would be more than=20
enough to explain the situation.

> The direct fault is a NULL dereference in assert_eb_folio_uptodate(),
> reached from the free-space-tree bitmap loading path:
>=20
>    caching_thread()
>      -> btrfs_load_free_space_tree()
>      -> load_free_space_bitmaps()
>      -> btrfs_free_space_test_bit()
>      -> extent_buffer_test_bit()
>      -> assert_eb_folio_uptodate()
>=20
> The corrupted metadata pattern is a FREE_SPACE_BITMAP item whose
> item_size is smaller than the bitmap size described by key.offset. In th=
e
> reproducer, multiple bitmap items had item_size =3D=3D 0 while key.offse=
t
> still described non-empty bitmap ranges.
>=20
> For one failing item, the instrumented run showed:
>=20
>    leaf_len =3D 16384
>    ptr =3D 16312
>    item_size =3D 0
>    expected =3D 402
>    key.type =3D BTRFS_FREE_SPACE_BITMAP_KEY
>=20
> So only 72 bytes remained in the leaf data area, while the bitmap range
> described by key.offset required 402 bytes of bitmap data. The existing
> code did not validate that mismatch before iterating over bitmap bits.
>=20
> btrfs_free_space_test_bit() uses btrfs_item_ptr_offset() as the bitmap
> start, and extent_buffer_test_bit() then translates the bit access into
> a folio index. Without a range check, once start + BIT_BYTE(nr) goes pas=
t
> eb->len, the computed folio index can exceed the populated folio range o=
f
> the extent buffer.
>=20
> extent_buffer objects are zero-initialized and only the first
> num_extent_folios(eb) entries in eb->folios[] are populated. An access
> past that range can therefore hit a NULL eb->folios[] slot, which is the=
n
> dereferenced by assert_eb_folio_uptodate() via folio_test_uptodate().
>=20
> Reproduction (v6.18, x86_64, KASAN)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The PoC is relatively large, so it is provided separately through google=
 drive:
> https://drive.google.com/drive/folders/1eB6QzkGViZhlq8xouE5WSVRU0fovu0qw

Since you know the root cause, you can easily craft the image with just=20
corrupted item size for that FREESPACE_BITMAP item.

As we also put the minimal fuzzed image into btrfs-progs'=20
tests/fuzzed-tests directory.

Thus a minimal image is always appreciated.

Thanks,
Qu

>=20
> To reproduce the issue:
>    1. Build the PoC program: gcc poc.c -o poc
>    2. Build the ublk helper program from the ublk codebase, which is
> 	 used to provide the runtime corruption capability:
> 	  g++ -std=3Dc++20 -fcoroutines -O2 -o standalone_replay \
>        standalone_replay_btrfs.cpp targets/ublksrv_tgt.cpp \
>        -I. -Iinclude -Itargets/include \
>        -L./lib/.libs -lublksrv -luring -lpthread
>    3. Attach the crafted image through ublk:
>        ./standalone_replay add -t loop -f /path/to/image
>    4. Run the PoC: ./poc
> This reliably reproduces the bug.
>=20
> Test notes
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The reproducer was verified on 7.0.0-rc2-next-20260306 with runtime
> single-bit corruption injected into btrfs leaf blocks. I have not yet
> retested it on the latest stable kernel, but I can do so if needed.
>=20
> Fix
> =3D=3D=3D
> Two complementary defences are added:
>=20
> 1. In load_free_space_bitmaps() (free-space-tree.c), validate that the
>     on-disk item_size equals free_space_bitmap_size(fs_info, key.offset)
>     before entering the per-sector bit-reading loop.  A mismatch is a
>     clear sign of on-disk corruption; log a specific error message and
>     return -EUCLEAN so the caller can handle it gracefully instead of
>     walking off the end of the leaf.
>=20
> 2. In extent_buffer_test_bit() (extent_io.c), call check_eb_range()
>     before eb_bitmap_offset(), mirroring the pattern already used by
>     read_extent_buffer() and extent_buffer_get_byte().  This makes the
>     function safe against any caller that passes an out-of-range (start,
>     nr) pair, regardless of how the corruption reached this point.
>=20
> Defence (1) catches the specific free-space-tree path at the semantic
> layer and produces a meaningful log entry. Defence (2) is a generic
> safety net for the low-level helper that prevents the NULL-folio crash
> for any future caller that might bypass the upper-layer check.
>=20
> KASAN reports
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instr=
umented.h:68 [inline]
> BUG: KASAN: null-ptr-deref in _test_bit include/asm-generic/bitops/instr=
umented-non-atomic.h:141 [inline]
> BUG: KASAN: null-ptr-deref in folio_test_uptodate include/linux/page-fla=
gs.h:787 [inline]
> BUG: KASAN: null-ptr-deref in assert_eb_folio_uptodate+0x198/0x2b0 fs/bt=
rfs/extent_io.c:4071
> Read of size 8 at addr 0000000000000000 by task kworker/u8:0/12
>=20
> CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted 6.18.0+ #12 PREEMPT=
(voluntary)
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 19=
96), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: btrfs-cache btrfs_work_helper
> Call Trace:
> <TASK>
> dump_stack_lvl+0xbe/0x130
> print_report+0x437/0x650
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? early_section include/linux/mmzone.h:2184 [inline]
> ? pfn_valid include/linux/mmzone.h:2196 [inline]
> ? __virt_addr_valid+0xca/0x4c0 arch/x86/mm/physaddr.c:65
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? kasan_addr_to_slab+0xd/0xb0 mm/kasan/common.c:46
> kasan_report+0xfb/0x140
> ? instrument_atomic_read include/linux/instrumented.h:68 [inline]
> ? _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [in=
line]
> ? folio_test_uptodate include/linux/page-flags.h:787 [inline]
> ? assert_eb_folio_uptodate+0x198/0x2b0 fs/btrfs/extent_io.c:4071
> ? instrument_atomic_read include/linux/instrumented.h:68 [inline]
> ? _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [in=
line]
> ? folio_test_uptodate include/linux/page-flags.h:787 [inline]
> ? assert_eb_folio_uptodate+0x198/0x2b0 fs/btrfs/extent_io.c:4071
> kasan_check_range+0x11c/0x200
> __kasan_check_read+0x11/0x20
> assert_eb_folio_uptodate+0x198/0x2b0
> extent_buffer_test_bit+0xce/0x200
> btrfs_free_space_test_bit+0x1b3/0x270
> ? __pfx_btrfs_free_space_test_bit+0x10/0x10 include/linux/sched/mm.h:332
> ? __asan_memmove+0x30/0x80 mm/kasan/shadow.c:95
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? read_extent_buffer+0x114/0x3d0 fs/btrfs/extent_io.c:3946
> btrfs_load_free_space_tree+0x57a/0xe40
> ? __pfx_btrfs_load_free_space_tree+0x10/0x10 fs/btrfs/free-space-tree.c:=
1492
> ? __entry_text_end+0x1025b9/0x1025bd
> ? __kasan_check_write+0x14/0x30 mm/kasan/shadow.c:37
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? instrument_atomic_write include/linux/instrumented.h:82 [inline]
> ? atomic_long_set include/linux/atomic/atomic-instrumented.h:3223 [inlin=
e]
> ? __rwsem_set_reader_owned kernel/locking/rwsem.c:177 [inline]
> ? rwsem_set_reader_owned kernel/locking/rwsem.c:182 [inline]
> ? rwsem_read_trylock kernel/locking/rwsem.c:257 [inline]
> ? rwsem_read_trylock kernel/locking/rwsem.c:249 [inline]
> ? __down_read_common kernel/locking/rwsem.c:1260 [inline]
> ? __down_read kernel/locking/rwsem.c:1274 [inline]
> ? down_read+0x1c5/0x4a0 kernel/locking/rwsem.c:1539
> ? hung_task_set_blocker include/linux/hung_task.h:55 [inline]
> ? rwsem_down_read_slowpath+0xbd0/0xca0 kernel/locking/rwsem.c:1070
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? trace_hardirqs_on+0x53/0x60 kernel/trace/trace_preemptirq.c:79
> caching_thread+0x3d5/0x1f20
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? save_trace+0x54/0x390 kernel/locking/lockdep.c:587
> ? __pfx_caching_thread+0x10/0x10 fs/btrfs/block-group.c:533
> ? __entry_text_end+0x1025b9/0x1025bd
> ? instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
> ? atomic_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:=
1301 [inline]
> ? queued_spin_lock include/asm-generic/qspinlock.h:111 [inline]
> ? do_raw_spin_lock+0x133/0x290 kernel/locking/spinlock_debug.c:116
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? find_held_lock+0x31/0x90 kernel/locking/lockdep.c:5350
> ? spin_unlock include/linux/spinlock.h:391 [inline]
> ? thresh_exec_hook fs/btrfs/async-thread.c:203 [inline]
> ? btrfs_work_helper+0x1a2/0xa50 fs/btrfs/async-thread.c:311
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:562 [inline]
> ? queued_spin_unlock arch/x86/include/asm/qspinlock.h:57 [inline]
> ? do_raw_spin_unlock+0x14b/0x200 kernel/locking/spinlock_debug.c:142
> btrfs_work_helper+0x1d4/0xa50
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> process_one_work+0x8e0/0x1980
> ? __pfx_process_one_work+0x10/0x10 include/linux/list.h:226
> ? move_linked_works+0x1a8/0x2c0 kernel/workqueue.c:1165
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? assign_work+0x19d/0x240 kernel/workqueue.c:1206
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? __lock_is_held kernel/locking/lockdep.c:5601 [inline]
> ? lock_is_held_type+0xa3/0x130 kernel/locking/lockdep.c:5940
> worker_thread+0x683/0xf80
> ? __pfx_worker_thread+0x10/0x10 kernel/workqueue.c:3570
> kthread+0x3f0/0x850
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? __pfx_kthread+0x10/0x10 arch/x86/include/asm/bitops.h:202
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? trace_hardirqs_on+0x53/0x60 kernel/trace/trace_preemptirq.c:79
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> ? _raw_spin_unlock_irq+0x27/0x70 kernel/locking/spinlock.c:202
> ? srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:220
> ? spin_unlock_irq include/linux/spinlock.h:401 [inline]
> ? calculate_sigpending+0x7c/0xb0 kernel/signal.c:194
> ? __pfx_kthread+0x10/0x10 arch/x86/include/asm/bitops.h:202
> ret_from_fork+0x50f/0x610
> ? __pfx_kthread+0x10/0x10 arch/x86/include/asm/bitops.h:202
> ret_from_fork_asm+0x1a/0x30
> </TASK>
> ---
>   fs/btrfs/extent_io.c       | 10 ++++++++++
>   fs/btrfs/free-space-tree.c | 19 +++++++++++++++++++
>   2 files changed, 29 insertions(+)
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 23273d0e6f22..14da72a9a950 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4254,6 +4254,16 @@ bool extent_buffer_test_bit(const struct extent_b=
uffer *eb, unsigned long start,
>   	size_t offset;
>   	u8 *kaddr;
>  =20
> +	/*
> +	 * Defend against a corrupt bitmap item whose item_size is smaller
> +	 * than what key.offset implies: if start + BIT_BYTE(nr) would fall
> +	 * outside this extent buffer, eb_bitmap_offset() would compute an
> +	 * out-of-bounds folio index, and assert_eb_folio_uptodate() would
> +	 * then dereference a NULL eb->folios[] slot.
> +	 */
> +	if (check_eb_range(eb, start, BIT_BYTE(nr) + 1))
> +		return false;
> +
>   	eb_bitmap_offset(eb, start, nr, &i, &offset);
>   	assert_eb_folio_uptodate(eb, i);
>   	kaddr =3D folio_address(eb->folios[i]);
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index d86541073d42..04fde74c35e5 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1555,6 +1555,8 @@ static int load_free_space_bitmaps(struct btrfs_ca=
ching_control *caching_ctl,
>   	u64 end, offset;
>   	u64 total_found =3D 0;
>   	u32 extent_count =3D 0;
> +	u32 expected_bitmap_size;
> +	u32 actual_bitmap_size;
>   	int ret;
>  =20
>   	block_group =3D caching_ctl->block_group;
> @@ -1578,6 +1580,23 @@ static int load_free_space_bitmaps(struct btrfs_c=
aching_control *caching_ctl,
>   		ASSERT(key.type =3D=3D BTRFS_FREE_SPACE_BITMAP_KEY);
>   		ASSERT(key.objectid < end && key.objectid + key.offset <=3D end);
>  =20
> +		/*
> +		 * Validate the on-disk item size matches what we compute
> +		 * from key.offset.  A zero-sized (or otherwise wrong-sized)
> +		 * bitmap item would cause extent_buffer_test_bit() to walk
> +		 * past the end of the leaf, ultimately dereferencing a NULL
> +		 * folio pointer in assert_eb_folio_uptodate().
> +		 */
> +		expected_bitmap_size =3D free_space_bitmap_size(fs_info, key.offset);
> +		actual_bitmap_size =3D btrfs_item_size(path->nodes[0], path->slots[0]=
);
> +		if (unlikely(actual_bitmap_size !=3D expected_bitmap_size)) {
> +			btrfs_err(fs_info,
> +				  "corrupt free space bitmap for block group %llu: objectid=3D%llu =
expected item size %u got %u",
> +				  block_group->start, key.objectid,
> +				  expected_bitmap_size, actual_bitmap_size);
> +			return -EUCLEAN;
> +		}
> +
>   		offset =3D key.objectid;
>   		while (offset < key.objectid + key.offset) {
>   			bool bit_set;

