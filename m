Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9543E51C4
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 09:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779700502; cv=none; b=YELGUsd2EnNC1wh+GusjowPihUo9ZTfIOeAioyHEDoU5kkkStVlt5kWGMdvlCkXG/6ONOoekWa+eMoKfKv3crPGGn3NSQuSs3SoY+rkcQuY9ebS0PLQlhCjMhvkeJe9k3KN7qxmF7NOFQ2AhCTsAgf/QxPrpWiXSy0tRR98nb4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779700502; c=relaxed/simple;
	bh=girKkYfSFgdvsSiQdpwp+GP+P9jui3mikn2r7UlvChk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=MRtTzwtAn8Cgf7HU2Z/HgVmeMNipQkqhcit7Db/irr9zsA93cVvQpC0MlBYznO1/fG+hEOi1ulGdeT4yNfkUHkA+i8Iaw5Duhe+/goE1ShrK0dMs0Lt0HzlLdijk1qjxRA5q1CoRyXS//GhHRCwzuet3vPWbu67RfeyTiRsskNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ec7S+M/T; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ec7S+M/T"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so69372555e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 02:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779700495; x=1780305295; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SvI7GKMQVMfTxX4dHHfJjIBJCutpOS4doZtpvRSZmew=;
        b=ec7S+M/TBpHT7hHIyCkXxE47fUaqhkIPJ7ELWrDq9ulKwojDR/yxExQ8gc6uQE01GD
         pWs9l2VPLPnuv2f8SA0ELNvTBeLbxg+BPWC3zsn5dYbUs/V1vvOA8qF1wQ+tt4t73Cyb
         IVr5Oq5IQaJKuVFpxEYi2+r78IbF025XJpVjaxB0rKMv5UtFbsohqqpQVSqS8yt03vlv
         lxR7JywaSEBv/yXm+ixsYM+AIEH6z6G16FvpZmUdMH7jCV5IZPIVjgzglXlmroqz4DmC
         USwh7zpcFBOiSebH0IKAEIkFsHhiGu+zMbI5fKX9fpxWWUt4Bd3v7om1M162U96KXb1c
         N9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779700495; x=1780305295;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SvI7GKMQVMfTxX4dHHfJjIBJCutpOS4doZtpvRSZmew=;
        b=DQ68HgxRhnMZqp+h8HMy5BOWld39P4e4WNSrRwwdrMaUyCnheEwmbpzu7z+2YPD5e2
         3V/Mv5AhYt6/pf9dlDYgH3jBZUevxJuhtZcrmcPEOdBIjqK0f45FgnllsjjTdYJwcnQJ
         zSmBbN7X9g2BypC9W4HO6TNH+kKZcMA4bL3iTOXwXENP5W5TCcG0wVyibogQB7CwM1s8
         eR+LgXdgMwwki/JW2rDb0uiEBJwIJOyc1P5IJjImldgqahfUyyzFD/uCMeesQXte0EVV
         vibtS/zPTirvIjMiKvLpBA3PmsecYGJfMq9bzTiSulZGJUMW3SyH4Hjkf28+AWAHXLc6
         jhpg==
X-Gm-Message-State: AOJu0Yzj9Cr35DGuMfS/WEjDyXu271WRReJ5ifWqCbGX0iWrjyIqm7Qk
	QO9euw4Mw/9A/fpjjimc0AqDWvePusqJ7ajQfwQXny3erTUVCuaDXgxce0o1aHrjocz/t0eyk4P
	2iNzN
X-Gm-Gg: Acq92OEXRzV3lyNQsqDcrZ6Wtqh29YoQT/YXR+tv5qp4P0t0EAMT42IPq7Wk3LDPGWS
	cS27Z4D62MT+OpseHQp+a+kf2iHI5OGRVDYxewGtWE4B5PymOgiDpOIbhGtn2jf88msWyWUuZN1
	1duzAPsFlMWFTmSbvil3QOS+BGIpRtlNjpctmstou13zkj95zbyEaDqd5BNUsBzGQK38u8ucuu4
	9ZmatIkxKsLsHqgzdPghfc4PCn4CffCZhGxKlLu8fovFcxNNL3DA7hqVNBvX+Q0UxoKEa64J0g+
	x654fXRdprAsqVpEvPWWp2SMiNHVzAoyvh6ajImBKyh3PHPc6Hz2cwdwWV9wxeT15IvyuVh0vVm
	OSCxEpaBOquR3FK29D7p9zG1sJHTwpyIu63j7H+xyLrWXI7D6/n3DinL52qXE67twcg5BzD4pG/
	lRdu38huomZKrCV8Fr1WDbRHsjFpc6sIKrFHia/UNgOmU4TU5CZRr9xuCUwkHzSD3DbVOXJrI+h
	4pr4ha0UkoY2JfsXtGYt0dlC0AQnSWdgy4HhTjjKoEWEk08JcN/XB5ZKg==
X-Received: by 2002:a05:600c:1c0b:b0:490:44eb:c1dc with SMTP id 5b1f17b1804b1-49044ebc2e0mr240134415e9.20.1779700494385;
        Mon, 25 May 2026 02:14:54 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ac9df3sm11192239b3a.9.2026.05.25.02.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 02:14:53 -0700 (PDT)
Message-ID: <150d5b1f-d1b0-48c1-ae33-56b4c049576f@suse.com>
Date: Mon, 25 May 2026 18:44:48 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Filipe Manana <fdmanana@kernel.org>
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
Content-Language: en-US
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
In-Reply-To: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/25 14:35, Qu Wenruo 写道:
> Previously btrfs forces direct writes to fall back to buffered ones if the
> inode has data checksum or the profile has duplication.
> 
> That fallback is to avoid the content being modified that the final
> content may mismatch with the checksum or the other mirrors.
> 
> That brings a pretty huge performance cost, which already caused some
> concern at that time.
> 
> But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
> buffer direct I/O") introduced a new method by copying the content into
> new pages, and do all the operations based on the newly allocated pages.
> 
> So let btrfs to utilize the new flag for direct writes if we require
> stable folios.
> 
> There is a quick benchmark, using the following fio setup:
> 
>   fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
>       --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
>       --bs=$blocksize
> 
> Unit is MiB/s.
> 
>   Blocksize | Zero-copy (*) | Buffered |   Bounce
> -----------+---------------+----------+-----------
>          4K |          35.1 |     17.1 |      33.8
>         64K |           522 |      251 |       492
> 
> *: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
>     fallback to buffered write if the inode requires checksum")
> 
> Although with page bouncing the performance is only around 95% of
> true-zero copy, it's still almost double the performance of buffered
> fallback.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Rework the comment in btrfs_dio_write()
> ---
>   fs/btrfs/direct-io.c | 45 ++++++++++++++++----------------------------
>   1 file changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 57167d56dc72..173fe065fc38 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -768,10 +768,25 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
>   static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
>   					 size_t done_before)
>   {
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
>   	struct btrfs_dio_data data = { 0 };
> +	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
> +				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
> +	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
> +
> +	/*
> +	 * Userspace may modify the buffer while DIO is in flight. With
> +	 * data checksumming this would produce a checksum that doesn't
> +	 * match the persisted data; with duplicated profiles the mirrors
> +	 * would diverge. Bounce in those cases so writeback sees stable
> +	 * content.
> +	 */
> +	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
> +	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
> +		dio_flags |= IOMAP_DIO_BOUNCE;

Unfortunately this will deadlock at generic/647.

Currently btrfs avoids the deadlock by disabling page fault for the 
@from iov_iter.

But that iov_iter->nofault is not respected during 
bio_iov_iter_bounce_write() -> copy_from_iter(), thus we will hit a 
deadlock at exactly the situation described in the comment just before 
btrfs_dio_write() call.


I tried to check how XFS handles this, and XFS seems to go a completely 
different way using different flags for xfs_ilock().

And it doesn't look like it's even possible to make copy_from_iter() to 
properly respect the nofault flag.

I'm wondering if there is any good idea to handle such situation.

Or we should add some extra checks inside btrfs? E.g. if we found out 
that the folio we're reading belongs to a direct write, instead of 
waiting for the OE to finish, returning -EFAULT?


The blocked call traces looks like the following:

  task:mmap-rw-fault   state:D stack:0     pid:1157  tgid:1157  ppid:981 
    task_flags:0x440100 flags:0x00080000
  Call Trace:
   <TASK>
   __schedule+0x408/0x1870
   ? __blk_flush_plug+0xea/0x140
   schedule+0x27/0xd0
   btrfs_start_ordered_extent_nowriteback+0x16d/0x200 [btrfs 
8565e31bdc0fd7f3ea5ed5d7c25129d026ba3f05]
   ? wake_up_bit+0xc0/0xc0
   lock_extents_for_read.constprop.0+0x1d6/0x2a0 [btrfs 
8565e31bdc0fd7f3ea5ed5d7c25129d026ba3f05]
   btrfs_readahead+0x91/0x1c0 [btrfs 
8565e31bdc0fd7f3ea5ed5d7c25129d026ba3f05]
   read_pages+0x72/0x210
   page_cache_ra_order+0x232/0x390
   filemap_fault+0x630/0x1220
   __do_fault+0x2e/0x180
   do_fault+0x300/0x570
   ? __pte_offset_map+0x1b/0x100
   __handle_mm_fault+0x94e/0xf50
   ? btrfs_clear_extent_bit_changeset+0x316/0x770 [btrfs 
8565e31bdc0fd7f3ea5ed5d7c25129d026ba3f05]
   handle_mm_fault+0xf2/0x300
   do_user_addr_fault+0x15b/0x680
   exc_page_fault+0x82/0x1c0
   asm_exc_page_fault+0x26/0x30
  RIP: 0010:_copy_from_iter+0x9f/0x620
  Code: 8b 6d 08 e8 33 ab 0c 00 84 c0 75 60 48 b8 00 f0 ff ff ff 7f 00 
00 4b 8d 34 2e 48 39 c6 48 0f 47 f0 0f 01 cb 48 89 d9 4c 89 e7 <f3> a4 
0f 1f 00 0f 01 ca 49 89 dd 49 29 cd 48 03 4d 18 4c 01 6d 08
  RSP: 0018:ffffd3644303f778 EFLAGS: 00050287
  RAX: 00007ffffffff000 RBX: 0000000000001000 RCX: 0000000000001000
  RDX: ffff8cff8f578000 RSI: 00007f601a7b4000 RDI: ffff8cff85565000
  RBP: ffffd3644303fb58 R08: 0000000000000000 R09: 000000000000010f
  R10: ffffffffa37aee20 R11: ffff8d00fffd73c0 R12: ffff8cff85565000
  R13: 0000000000000000 R14: 00007f601a7b4000 R15: fffffbdb04155940
   ? _copy_from_iter+0x7d/0x620
   ? alloc_pages_mpol+0xb6/0x170
   bio_iov_iter_bounce+0x1a9/0x2c0
   iomap_dio_bio_iter+0x20e/0x620
   __iomap_dio_rw+0x4e5/0x8f0
   btrfs_direct_write+0x282/0x4b0 [btrfs 
8565e31bdc0fd7f3ea5ed5d7c25129d026ba3f05]
   btrfs_do_write_iter+0x19a/0x220 [btrfs 
8565e31bdc0fd7f3ea5ed5d7c25129d026ba3f05]
   vfs_write+0x253/0x480
   __x64_sys_pwrite64+0x98/0xd0
   do_syscall_64+0xe1/0x7c0
   ? vm_mmap_pgoff+0x15b/0x200
   ? ksys_mmap_pgoff+0x168/0x200
   ? do_syscall_64+0xe1/0x7c0
   ? switch_fpu_return+0x52/0xe0
   ? do_syscall_64+0x26e/0x7c0
   ? do_syscall_64+0x26e/0x7c0
   ? __x64_sys_openat+0x61/0xa0
   ? do_syscall_64+0xe1/0x7c0
   ? __x64_sys_close+0x3d/0x80
   ? do_syscall_64+0xe1/0x7c0
   ? do_syscall_64+0x98/0x7c0
   ? exc_page_fault+0x82/0x1c0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f601a49318e
  RSP: 002b:00007fffbfd38e80 EFLAGS: 00000202 ORIG_RAX: 0000000000000012
  RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f601a49318e
  RDX: 0000000000001000 RSI: 00007f601a7b4000 RDI: 0000000000000003
  RBP: 00007fffbfd38e90 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
  R13: 0000000000000003 R14: 0000000000000000 R15: 0000559f60b73d58
   </TASK>
