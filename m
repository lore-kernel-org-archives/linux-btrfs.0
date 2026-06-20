Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E4E86329
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jun 2026 01:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781919633; cv=none; b=UY1TNU2NdaDEbYQqD70yVvz9JE6Qp2cvc8uVCWU6BnUrNrVwg4gvK34frCn5fcM8K/d5AMtgzD4UlAkLOmhZWv1nmjupDHHuD4tr36xoCwUdkuJUxi4e175QoIr2X4JkhBymCVr2rDFDrzh0BlvnAvyIJY7T3A85XVLmZ3eyAeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781919633; c=relaxed/simple;
	bh=Qodb3kKt4NwivF9VQn191+0JCCDaAVaEYTST0v0GR4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TkTvSk3E2zv42rZZkR5p8qg6n7SXTO4YCHqwjF32P4Mzxz4dQn3wON5bYgpLEK6Y7LYq16mpmPnhwYvFlcvrc1tjH1kRba99k+J6VL1MjiU1SxUjd/XZLzVUjB/AVLrxPUNHPWjaAaeIhkIorzZHwRTKzJdO3d7RbskojnX1A+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L2AElgWQ; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L2AElgWQ"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec423a5265so463461666b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 18:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781919630; x=1782524430; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rgxdWNq5Xrs0eGkGh/KXnToTSB5tAXCFWPhr0/uIWBk=;
        b=L2AElgWQX8qEfxS72JjzNxJqSdUxnSu+DnAfYCxAvM76bQySUkk2PS2qwlL24O1nJh
         M4waCuixQWnQop3Q7RxAooOLQkQGuteo78qUfNYQ3//3Gcl3GbJWXN/67fbP6SiXGH3d
         6JnaRLNR+d0aI+sPae4kvIcZQrk8P5LWvfIlsGrlqoKfm6+19Q/d6lggwZHLtDntUirU
         W77m34aSsPIiL5+1nl/ZtxADQn8RbHDtCYClo9eepUOTdNvyBTbipiqtpfugglqeIqgF
         BIlEQVrEsiGt2nsDtzQaqM2gFV5T7MdEEyoQopA8sE+n1ixqkqe5eLcfDvGHLj9WJjyg
         /Qcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781919630; x=1782524430;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgxdWNq5Xrs0eGkGh/KXnToTSB5tAXCFWPhr0/uIWBk=;
        b=I9oYfh6GuymjMzLiUohY44JjiILdM40VHswnZ9XuU8pjXAWVgg5bt2DPZQLOrBfCo5
         QJLrW2Dg+kAC634oR636jSBwbK5Jw0xNg2VJMc05TcLWxYkAtJAj+32Go70IqvhNHuA+
         LjKgiiYb9nrJHJxxCzs1Q9oCIqRr1lL3B38YUPvMm3JPgSWN8vl8kbkMY+r+WNhcM4vm
         h1eqCx6+R5oxlR7sk3g6vrUNFVf2NBlqgWCmKo40A8a3rQj0dd7c+WjZUXlOhbNqlX/M
         SpCvvVc+1ZjehvLiErEZmvCGAMlP09aqN5NsAaLU7XXTdLQ7FPJqORH224Cpoxlrg1xu
         GDdQ==
X-Gm-Message-State: AOJu0YyEUv+6pfdbbdi3FDpsO+GoObG/YBMbg+A+FYNz9ikk3JueZbkH
	rtjM5okI4clTn0gNqDzf2Jn1JsdvZg9tCFwxSK94kX0YM1IPZA/cproCltJlQ/Eia//tekzdsGf
	VUMGzhEoufA==
X-Gm-Gg: AfdE7cmd7BjzU8sS7Hcn7BDR8qZ4gWCKXv3pvl5R7jZm6xxqcUZH6ePEDjhjkExT/G7
	xJCEu8vZ38mccNtIrNIzRoppncBe2rUFmMJ3HA/99EJT+n4fP/pmTchow/Jr49N+iTiixypy9sv
	/HAzy37LOnLT+2hdsrp7FMVRXv4kc427m6h7ExXOxTyQ0u4KRjOuAMwuJGMYZjRJPZ+j6RcbmKd
	QpFcS7T0qeYGTKTvDTrTC28h/cBM/7kTbBNhF+4d+U4sJJ+7DDHm2CDtPC86FB4O3jE4yw/wYJU
	DvPwy1eoZky7z3IeSuqBJywcw9wb26/29sPtdTv5L3FpXq9EJUapj+XQNmSzjihGC7OSgLPXFCh
	HvXKmmBwQuk1zdunLGFDfFs7SpZ2UxFS3zfiDD332K9RRhQBrETpjoP37LF+Mf3i2GgYPdo1E9A
	FtQbpwYaytO7v0GC2YZ+xY0vwArTvbZDNtnrAzHOnCqEo3Z1V5SREPLlYhVFZFIXwBryX+SvU+c
	PDsboRMpVK49b3fHasuPmMdDi0MyNEQ5ok=
X-Received: by 2002:a17:907:6d2a:b0:bee:f0d5:1c71 with SMTP id a640c23a62f3a-c09900bfe5bmr340566466b.42.1781919629567;
        Fri, 19 Jun 2026 18:40:29 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc563c131sm932139a12.18.2026.06.19.18.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2026 18:40:28 -0700 (PDT)
Message-ID: <2aeb8d7f-48e8-4e9a-bfb5-086b854bbc27@suse.com>
Date: Sat, 20 Jun 2026 11:10:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: warn about extent buffer that can not be
 released
To: Glass Su <glass.su@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>,
 Teng Liu <27rabbitlt@gmail.com>, Su Yue <l@damenly.org>
References: <4ac4a9f2c599841b00f39f3be082432f43130f3e.1776379191.git.wqu@suse.com>
 <DC0C775E-13B3-47D9-9AB2-895BB11C029D@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <DC0C775E-13B3-47D9-9AB2-895BB11C029D@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/20 10:14, Glass Su 写道:
> 
> 
> 
> On Fri, Apr 17, 2026 at 6:47 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> When we unmount the fs or during mount failures, btrfs will call
>> invalidate_inode_pages() to release all btree inode folios.
>>
>> However that function can return -EBUSY if any folios can not be
>> invalidated.
>> This can be caused by:
>>
>> - Some extent buffers are still held by btrfs
>>   This is a logic error, as we should release all tree root nodes
>>   during unmount and mount failure handling.
>>
>> - Some extent buffers are under readahead and haven't yet finished
>>   This is much rarer but valid cases.
>>   In that case we should wait for those extent buffers.
>>
>> Introduce a new helper invalidate_btree_folios() which will:
>>
>> - Call invalidate_inode_pages2() and catch its return value
>>   If it returned 0 as expected, that's great and we can call it a day.
>>
>> - Otherwise go through each extent buffer in buffer_tree
>>   Increase the ref by one first for the eb we're checking.
>>   This is to ensure the eb won't be freed after the readahead is
>>   finished.
>>
>>   For eb that still has EXTENT_BUFFER_READING flag, wait for them to
>>   finish first.
>>
>>   After waiting for the readahead, check the refs of the eb and if it's
>>   still dirty.
>>
>>   If the eb refs is greater than 2 (one for the buffer tree, one hold by
>>   us), it means we are still holding the extent buffer somewhere else,
>>   which is a logic bug.
>>
>>   If the eb is still dirty, it means a bug in transaction handling.
>>   Unfortunately there are already test cases triggering this warning, so
>>   our transaction cleanup hasn't done its work reliably.
>>
>>   For either case, show a warning message about the eb, including its
>>   bytenr, owner, refs and flags.
>>   And if it's a debug build, also trigger WARN_ON_ONCE() so that fstests
>>   can properly catch such situation.
>>
>> Furthermore, to help debugging the unreleased extent buffers, output the
>> transid of the current aborted transaction, so that we can know which
>> transaction the unreleased extent buffers belong to.
>>
>> This will help future debugging as we're already hitting the new
>> warnings from test cases like generic/388.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
>> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
>> Cc: Teng Liu <27rabbitlt@gmail.com>
>> Tested-by: Teng Liu <27rabbitlt@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v3:
>> - Revert the DEBUG_WANR_ON_ONCE() change
>>   As there is only one user, a simple
>>   WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG)) is more than enough.
>>
>> - Output the generation of the unreleased eb too
>>   Since it's possible to have 2 transactions (one committing and reached
>>   UNBLOCKED state, one new running), the generation output will help us
>>   to know which transaction the unreleased eb belongs to.
>>
>> - Also output the transid when a transaction is aborted
>>   To co-operate with the above change for debugging.
>>
>> v2:
>> - Add one extra ref before checking the eb
>>   Although readahead has one extra ref, after the readahead finished the
>>   extra ref will be dropped, and memory pressure can kick in to free the
>>   extent buffer.
>>
>> - Use rcu lock with xa_for_each() instead of xas lock and xas_for_each()
>>   Since we're holding one extra eb ref to prevent eb from disappearing,
>>   we no longer needs the more strict xas lock nor the extra xas
>>   pause/unlock.
>>
>>   Although xa_for_each() is more time consuming, we're at the cold path
>>   already, not a huge cost.
>>
>> - Remove the temporarary void pointer
>>   And pass eb pointer directly into xas_for_each().
>>
>> - Introduce DEBUG_WARN_ON_ONCE() helper
>>   To follow the existing DEBUG_WARN() helper.
>>
>> - Fix a typo
>>
>> - Also fix the checkpatch warning on the exist DEBUG_WARN()
>> ---
>> fs/btrfs/disk-io.c     | 49 ++++++++++++++++++++++++++++++++++++++++--
>> fs/btrfs/extent_io.c   |  6 ------
>> fs/btrfs/extent_io.h   |  6 ++++++
>> fs/btrfs/transaction.h |  8 +++----
>> 4 files changed, 57 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 7800a1b20290..241acdc16da1 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3272,6 +3272,51 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
>>         return false;
>> }
>>
>> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
>> +{
>> +       unsigned long index = 0;
>> +       struct extent_buffer *eb;
>> +       int ret;
>> +
>> +       ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> +       if (likely(ret == 0))
>> +               return;
>> +
>> +       /*
>> +        * Some btree pages can not be invalidated, this happens when some
>> +        * tree blocks are still held (either by some pointer or readahead).
>> +        */
>> +       rcu_read_lock();
>> +       xa_for_each(&fs_info->buffer_tree, index, eb) {
>> +               /* Increase the ref so that the eb won't disappear. */
>> +               if (!refcount_inc_not_zero(&eb->refs))
>> +                       continue;
>> +               rcu_read_unlock();
>> +
>> +               /* Wait for any readahead first. */
>> +               if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
>> +                       wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
>> +                                      TASK_UNINTERRUPTIBLE);
>> +               /*
>> +                * The refs threshold is 2, one hold by us at the beginning
>> +                * of the loop, one for the ownership in the buffer tree.
>> +                */
> 
> However, IIUC, there is still a small window between clear_extent_buffer_reading()
> and free_extent_buffer() in end_bbio_meta_read().

You're right, and that's also one of my existing concern but I was 
unable to hit.

One idea is to make EXTENT_BUFFER_READING and the later refs check to be 
protected by refs_lock.
But that will require some extra changes which may not be trivial.

For now I'll change hide the whole error message behind DEBUG builds.

Thanks for the report,
Qu

> 
> btrfs/298 with added DEBUG output:
> 
> [47724.849583] BTRFS info (device sdd): first mount of filesystem f9bf732a-a19b-44b9-99a7-614ddff168e2
> [47724.849597] BTRFS info (device sdd): using crc32c checksum algorithm
> [47724.854471] DEBUG: before clear_extent_buffer_reading on 365985792 refs 3
> [47724.855333] BTRFS error (device sdd): failed to find fsid cb2fdb42-b638-4f2f-badd-4127467ba674 when attempting to open seed devices
> [47724.855349] BTRFS error (device sdd): failed to read chunk tree: -2
> [47724.855403] ------------[ cut here ]------------
> [47724.855405] WARNING: disk-io.c:3342 at invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs], CPU#4: mount/125993
> [47724.855503] Modules linked in: btrfs(OE) xor(E) libblake2b(E) raid6_pq(E) sctp(E) ip6_udp_tunnel(E) udp_tunnel(E) dm_mod(E) virtio_net(E) net_failover(E) arm_smccc_trng(E) failover(E) virtio_balloon(E) vfat(E) fat(E) drm(E) fuse(E) xfs(E) virtio_scsi(E) qemu_fw_cfg(E) virtio_pci(E) virtio_pci_legacy_dev(E) virtio_pci_modern_dev(E) virtio_console(E) virtio_rng(E) rng_core(E) [last unloaded: xor(E)]
> [47724.855549] CPU: 4 UID: 0 PID: 125993 Comm: mount Tainted: G        W  OE       7.1.0-rc7-custom+ #1 PREEMPT(full)
> [47724.855555] Tainted: [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> [47724.855558] Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250812-19.fc42 08/12/2025
> [47724.855561] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [47724.855564] pc : invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs]
> [47724.855648] lr : invalidate_and_check_btree_folios+0x11c/0x3c0 [btrfs]
> [47724.855728] sp : ffff80008e123b90
> [47724.855730] x29: ffff80008e123ba0 x28: ffff0000d1e41000 x27: ffff000127d14558
> [47724.855736] x26: ffffaa8f7cfc0000 x25: ffff00010734e400 x24: ffff0000d1e44000
> [47724.855741] x23: ffff0000ca10c000 x22: 0000000000001000 x21: ffff000125509000
> [47724.855746] x20: ffff00011d54c000 x19: ffff00011bf5eb58 x18: 000000000000000a
> [47724.855751] x17: 663266342d383336 x16: ffffaa8f7ba36cf0 x15: 0000000000000000
> [47724.855756] x14: 0000000000000000 x13: 322d203a65657274 x12: 206b6e7568632064
> [47724.855761] x11: 0000000000003cd8 x10: 0000000000000000 x9 : ffffaa8f3721d7cc
> [47724.855767] x8 : ffffaa8f7cefe848 x7 : ffff00010bdc8bf0 x6 : 0000000000000009
> [47724.855772] x5 : 0000000000000003 x4 : ffff00010bdc8040 x3 : ffff80008e123b44
> [47724.855777] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000003
> [47724.855782] Call trace:
> [47724.855784]  invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs] (P)
> [47724.855865]  open_ctree+0x1f50/0x23b0 [btrfs]
> [47724.855944]  btrfs_get_tree+0x89c/0xc48 [btrfs]
> [47724.856019]  vfs_get_tree+0x30/0x110
> [47724.856025]  vfs_cmd_create+0x58/0xe8
> [47724.856031]  __arm64_sys_fsconfig+0x39c/0x518
> [47724.856035]  invoke_syscall.constprop.0+0x48/0x120
> [47724.856042]  el0_svc_common.constprop.0+0x40/0xe8
> [47724.856046]  do_el0_svc+0x24/0x38
> [47724.856051]  el0_svc+0x50/0x310
> [47724.856057]  el0t_64_sync_handler+0xa0/0xe8
> [47724.856061]  el0t_64_sync+0x198/0x1a0
> [47724.856065] irq event stamp: 16018
> [47724.856067] hardirqs last  enabled at (16017): [<ffffaa8f7c81029c>] _raw_spin_unlock_irqrestore+0x74/0x80
> [47724.856073] hardirqs last disabled at (16018): [<ffffaa8f7c7f65a0>] el1_brk64+0x20/0x68
> [47724.856077] softirqs last  enabled at (13320): [<ffffaa8f7b8fdeec>] kernel_neon_begin+0x11c/0x178
> [47724.856082] softirqs last disabled at (13318): [<ffffaa8f7b8fde90>] kernel_neon_begin+0xc0/0x178
> [47724.856085] ---[ end trace 0000000000000000 ]---
> [47724.856089] BTRFS warning (device sdd): unable to release extent buffer 365985792 owner 3 gen 17 refs 3 flags 0x5
> [47724.856195] DEBUG: before free_extent_buffer on 365985792 refs 2
> [47724.856200] DEBUG: after free_extent_buffer on 365985792 refs 1
> 
> Standard Output
> 
> Full:
> #setup seed sprout device
> btrfs-progs v7.0
> See https://btrfs.readthedocs.io for more information.
> 
> Performing full device TRIM /dev/sdc (300.00MiB) ...
> NOTE: default settings have changed in version 6.19 (supported since linux 6.1):
>       - enable block-group-tree (-O bgt)
> 
> Label:              (null)
> UUID:               43f147f8-e91b-4306-82ef-4829ce018dae
> Node size:          16384
> Sector size:        4096 (CPU page size: 4096)
> Filesystem size:    300.00MiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP              32.00MiB
>   System:           DUP               8.00MiB
> SSD detected:       no
> Zoned device:       no
> Features:           extref, skinny-metadata, no-holes, free-space-tree, block-group-tree
> Checksum:           crc32c
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1   300.00MiB  /dev/sdc
> 
> mount: /mnt/scratch: WARNING: source write-protected, mounted read-only.
> Performing full device TRIM /dev/sdd (8.00GiB) ...
> #Scan seed device and check using mount
> Scanning for btrfs filesystems on '/dev/sdc'
> #check again, ensures seed device still in kernel
> #Now scan of non-seed device makes kernel forget
> WARNING: seeding flag cleared on /dev/sdc
> Scanning for btrfs filesystems on '/dev/sdc'
> #Sprout mount must fail for missing seed device
> umount: /mnt/scratch: not mounted.
> 
> 
>> +               if (unlikely(refcount_read(&eb->refs) > 2 ||
>> +                            extent_buffer_under_io(eb))) {
>> +                       WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
>> +                       btrfs_warn(fs_info,
>> +                       "unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
>> +                                  eb->start, btrfs_header_owner(eb),
>> +                                  btrfs_header_generation(eb),
>> +                                  refcount_read(&eb->refs), eb->bflags);
>> +               }
>> +               free_extent_buffer(eb);
>> +               rcu_read_lock();
>> +       }
>> +       rcu_read_unlock();
>> +       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> +}
>> +
>> int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
>> {
>>         u32 sectorsize;
>> @@ -3702,7 +3747,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>         if (fs_info->data_reloc_root)
>>                 btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
>>         free_root_pointers(fs_info, true);
>> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> +       invalidate_btree_folios(fs_info);
>>
>> fail_sb_buffer:
>>         btrfs_stop_all_workers(fs_info);
>> @@ -4431,7 +4476,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>>          * We must make sure there is not any read request to
>>          * submit after we stop all workers.
>>          */
>> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> +       invalidate_btree_folios(fs_info);
>>         btrfs_stop_all_workers(fs_info);
>>
>>         /*
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 8d241a7a880f..4eab0f9909e3 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2872,12 +2872,6 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask)
>>         return try_release_extent_state(io_tree, folio);
>> }
>>
>> -static int extent_buffer_under_io(const struct extent_buffer *eb)
>> -{
>> -       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
>> -               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
>> -}
>> -
>> static bool folio_range_has_eb(struct folio *folio)
>> {
>>         struct btrfs_folio_state *bfs;
>> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
>> index fd209233317f..b284aee1bfb0 100644
>> --- a/fs/btrfs/extent_io.h
>> +++ b/fs/btrfs/extent_io.h
>> @@ -326,6 +326,12 @@ static inline bool extent_buffer_uptodate(const struct extent_buffer *eb)
>>         return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>> }
>>
>> +static inline bool extent_buffer_under_io(const struct extent_buffer *eb)
>> +{
>> +       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
>> +               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
>> +}
>> +
>> int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
>>                          unsigned long start, unsigned long len);
>> void read_extent_buffer(const struct extent_buffer *eb, void *dst,
>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
>> index 7d70fe486758..264dcd4b3788 100644
>> --- a/fs/btrfs/transaction.h
>> +++ b/fs/btrfs/transaction.h
>> @@ -255,13 +255,13 @@ do {                                                              \
>>                 __first = true;                                 \
>>                 if (WARN(btrfs_abort_should_print_stack(error), \
>>                         KERN_ERR                                \
>> -                       "BTRFS: Transaction aborted (error %d)\n",      \
>> -                       (error))) {                                     \
>> +                       "BTRFS: Transaction %llu aborted (error %d)\n", \
>> +                       (trans)->transid, (error))) {                   \
>>                         /* Stack trace printed. */                      \
>>                 } else {                                                \
>>                         btrfs_err((trans)->fs_info,                     \
>> -                                 "Transaction aborted (error %d)",     \
>> -                                 (error));                     \
>> +                       "Transaction %llu aborted (error %d)",  \
>> +                                 (trans)->transid, (error));   \
>>                 }                                               \
>>         }                                                       \
>>         __btrfs_abort_transaction((trans), __func__,            \
>> --
>> 2.53.0
>>
>>

