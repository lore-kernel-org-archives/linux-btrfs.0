Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF42C3B9DA7
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 07:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784188611; cv=none; b=OGcearUmJlmVVFtyUbtYM6VvyvSVY6RfysiEVaIx6qlfk1XItRYbh25MQfEEhM1egZ2DAOHk7J7NBB4WpwzqRIfCzdwq9KcMRb1p4/TS0PeQvZcffrXu9eRKol4y2enMU8vFy2lS60K5Q68bKt5NYbHEkmVDXE/w6sR7Uq4EJjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784188611; c=relaxed/simple;
	bh=V7xLDobN+T1rpnECnich4L//7ZfNWS4jRDOYVXGGxgs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OZannVEwMkuxn0+w8q6ehM/Vo+UUPz5K+NuXwHEIhkD3aqAVsrvJNLXu1EdGxFVX1GjrhmDIEq+aOvqYPr5A4GhsxMgTjnyDuLl1qYjzMsqdvx9DMxxaiNjYlv6x3H5g53JrC7BvaRY1fczEBTHp4+8Y5UoNvUyni1W2/yGsgJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cq/VcLPH; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cq/VcLPH"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493ec555a26so40840545e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 00:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784188608; x=1784793408; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FH1Xv2Sf6Fe6cQsyWiF3DHBawLXP5L4mkYfgWwvK+WM=;
        b=Cq/VcLPHxh4of1SrBljZ5khJuU1gmq+Gg5zjOvMvtnWc5xmGYKupuvG1LwIg2xeDRd
         VvUY62XSvHbNLmdHFfRZrHtPbqwvsc8IA6p7S3h/4pfAkv6GMalCF7hTvCMrGjDSULcR
         aK24vOSNQo8yMxsnQuhHCrjDpZcRwUOwkTjk3imgXAfVGZucQCDpomdJbgY+08LNgkSe
         QVKOOplngkuPUQ42pWAz3tc8gVa1GgY0D7VpbuH1iXj/uDEkNaK4wsRZ3tLupRp8ipkr
         +EX1Fi3UrJdOLbTnhf41jliHMKmYNDfl7fit9OKpZucs7FQfyCy1CY1G1i8zHiH677Bs
         9dkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784188608; x=1784793408;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FH1Xv2Sf6Fe6cQsyWiF3DHBawLXP5L4mkYfgWwvK+WM=;
        b=Z7y/TRWu7rko09iDKEfgYuMF2moaC03+bwWylL+xQghCaCv7miOacgjHN/zpKmq2dz
         e97F0gw3ckhyoIvzKmf1bgSH8WqKuQG56xLbAbbptBoN0IOwCrB/lp9roD45ZdRxqDaE
         o4jm9rOyA4mBHXU2mp2IeEJnPqr5rhxYLDngFjoynNmCAQRgGMbIu1CsK26QRX9yfKrM
         LgoTi7hczI7z96HmOVtBQBTYZbO6Mk+IJD8WsFDis8Cg6Fk3a9WpsMvoYnsS7qC8p2Nk
         nF0ZUkSCv7gkfjAoGju+mt/XVlrdjLOToGryQ0C0A1AbsK385Rv7Umm6XKbyrCtIZ/h8
         LDWw==
X-Gm-Message-State: AOJu0YyiVLkMNGC3Cd4NOqREjlKC/h+ohOEAn6N05dHLobnLyUSUMDAQ
	U55kpNi1qzblTd7cvxZ8ZbeK8VH4xFMe/LFnq7Wjy29bS3tWGkEqmEem0BskTYMyZ5N2fFXhRIF
	T4gF+Kng=
X-Gm-Gg: AfdE7clqYyt7e2N43sL9XHfSmYSQgq2FZ9i5pSgMmJn9Ru+XYCUX7OOrsyDDaAbImsN
	MSnsthf/vp5f/39CqXvwZXBCxeMS0ItyjTTpdCZ6k3hLi0J9VRTfFIuLO3LgU40CbzILAaCDLKZ
	V8Gl6BnnyyPQ6h32KOnYqA1IwnlsVR5X6HrCU+QJ/rEeVft3gxFvow9mtRde7lSdW3pb7b4t422
	nS9Adsc6jnnMz1XMjcEJ/l6oDeZwhLdopRi0ixkI+PuOPuHTM0fmy71xoMe1gGCcoPDYwrlrOiX
	QMPUbQdcToJRHCOqWWIbGHykvND9AUQuRtST6f9Gb+eRqBliTg95SueJzSqHonz1EYSgI8n8K/Y
	R0Lhyaak52hew5KTUeI+HXlJ97XCk87GdYTrgTmm24hNat7kf621hQriV15t9kIweOjGkI5c=
X-Received: by 2002:a05:600c:8b16:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-495439109ebmr8209635e9.15.1784188607813;
        Thu, 16 Jul 2026 00:56:47 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6f0dcdsm7707650eec.31.2026.07.16.00.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 00:56:46 -0700 (PDT)
Message-ID: <5381a8d5-1bc5-4fe9-a802-fde6058c485f@suse.com>
Date: Thu, 16 Jul 2026 17:26:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: make sure EXTENT_BUFFER_READING is cleared under
 refs_lock
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Su Yue <glass.su@suse.com>
References: <14aca1944da7170799aea08df9af85728a2f2233.1781932019.git.wqu@suse.com>
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
In-Reply-To: <14aca1944da7170799aea08df9af85728a2f2233.1781932019.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Gentle ping?

The race window exists, although less common to hit and shouldn't affect 
end users that much (no call trace, but only a warning line), we should 
still address the race window.

Although I have to admit that the refs lock handling is pretty hacky, I 
had no better solution other than removing the refs check from 
invalidate_and_check_btree_folios(), which will decrease the meaning of 
that function.

Thanks,
Qu

在 2026/6/20 14:37, Qu Wenruo 写道:
> [FALSE ALERTS]
> There is a bug report that the warning inside
> invalidate_and_check_btree_folios() got triggered duriong btrfs/298:
> 
>   BTRFS info (device sdd): first mount of filesystem f9bf732a-a19b-44b9-99a7-614ddff168e2
>   BTRFS info (device sdd): using crc32c checksum algorithm
>   BTRFS error (device sdd): failed to find fsid cb2fdb42-b638-4f2f-badd-4127467ba674 when attempting to open seed devices
>   BTRFS error (device sdd): failed to read chunk tree: -2
>   ------------[ cut here ]------------
>   WARNING: disk-io.c:3342 at invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs], CPU#4: mount/125993
>   CPU: 4 UID: 0 PID: 125993 Comm: mount Tainted: G        W  OE       7.1.0-rc7-custom+ #1 PREEMPT(full)
>   Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250812-19.fc42 08/12/2025
>   Call trace:
>    invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs] (P)
>    open_ctree+0x1f50/0x23b0 [btrfs]
>    btrfs_get_tree+0x89c/0xc48 [btrfs]
>    vfs_get_tree+0x30/0x110
>    vfs_cmd_create+0x58/0xe8
>    __arm64_sys_fsconfig+0x39c/0x518
>    invoke_syscall.constprop.0+0x48/0x120
>    el0_svc_common.constprop.0+0x40/0xe8
>    do_el0_svc+0x24/0x38
>    el0_svc+0x50/0x310
>    el0t_64_sync_handler+0xa0/0xe8
>    el0t_64_sync+0x198/0x1a0
>   ---[ end trace 0000000000000000 ]---
>   BTRFS warning (device sdd): unable to release extent buffer 365985792 owner 3 gen 17 refs 3 flags 0x5
> 
> [CAUSE]
> In that invalidate_and_check_btree_folios() we wait for the eb to finish
> its read, then check if it's only held by us and the btree inode.
> 
> If not, then do a warning as it may be still held, and could cause
> problems.
> 
> But there is a small window where the check can lead to false alerts:
> 
>      Thread A (Read endio)         |        Thread B (Unmount)
> ----------------------------------+-------------------------------------
>   end_bbio_meta_read()             |
>   | The eb has one extra ref held  |
>   | by the reader, and has         |
>   | EXTENT_BUFFER_READING flag set | invalidate_and_check_btree_folios()
>   |                                | |
>   |- clear_extent_buffer_reading() | |
>   |                                | |- wait_on_bit_io();
>   |                                | |  The EXTENT_BUFFER_READING flag is
>   |                                | |  cleared
>   |                                | |- if (refcount_read(eb->refs) > 2)
>   |                                |    The eb is held by the read, us
>   |                                |    and btree inode, thus it
>   |                                |    will trigger the warning
>   |- free_extent_buffer()          |
> 
> [FIX]
> Introduce a helper, free_extent_buffer_clear_reading().
> 
> If the new parameter, @clear_reading, is set, we will hold the spinlock
> at the beginning of free_extent_buffer_clear_reading() to make sure the
> READING flag is cleared inside the same critical of decreasing refs.
> 
> Now free_extent_buffer() will just call
> free_extent_buffer_clear_reading() with @clear_reading set to false, so
> no behavior change.
> 
> But for end_bbio_meta_read(), it will not clear_extent_buffer_reading()
> directly, but pass @clear_reading as true.
> 
> Then inside invalidate_and_check_btree_folios(), hold the refs_lock
> before reading refs.
> So that we eliminate the race window completely.
> 
> Reported-by: Su Yue <glass.su@suse.com>
> Link: https://lore.kernel.org/linux-btrfs/DC0C775E-13B3-47D9-9AB2-895BB11C029D@suse.com/
> Fixes: 83f7e52b7ed1 ("btrfs: warn about extent buffer that can not be released")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/disk-io.c   | 15 +++++++++++++--
>   fs/btrfs/extent_io.c | 42 ++++++++++++++++++++++++++++++++----------
>   2 files changed, 45 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0a7d80da9c94..c4143c847827 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3318,6 +3318,8 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
>   	 */
>   	rcu_read_lock();
>   	xa_for_each(&fs_info->buffer_tree, index, eb) {
> +		unsigned int refs;
> +
>   		/* Increase the ref so that the eb won't disappear. */
>   		if (!refcount_inc_not_zero(&eb->refs))
>   			continue;
> @@ -3327,17 +3329,26 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
>   		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
>   			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
>   				       TASK_UNINTERRUPTIBLE);
> +		/*
> +		 * We hold the spinlock to make sure above READING is
> +		 * cleared with the held ref dropped.
> +		 * Or we can hit a race window and lead to false alerts.
> +		 */
> +		spin_lock(&eb->refs_lock);
> +		refs = refcount_read(&eb->refs);
> +		spin_unlock(&eb->refs_lock);
> +
>   		/*
>   		 * The refs threshold is 2, one held by us at the beginning
>   		 * of the loop, one for the ownership in the buffer tree.
>   		 */
> -		if (unlikely(refcount_read(&eb->refs) > 2 || extent_buffer_under_io(eb))) {
> +		if (unlikely(refs > 2 || extent_buffer_under_io(eb))) {
>   			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
>   			btrfs_warn(fs_info,
>   			"unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
>   				   eb->start, btrfs_header_owner(eb),
>   				   btrfs_header_generation(eb),
> -				   refcount_read(&eb->refs), eb->bflags);
> +				   refs, eb->bflags);
>   		}
>   		free_extent_buffer(eb);
>   		rcu_read_lock();
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0edd532174fa..33f50cb89a81 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3709,12 +3709,30 @@ static int release_extent_buffer(struct extent_buffer *eb)
>   	return 0;
>   }
>   
> -void free_extent_buffer(struct extent_buffer *eb)
> +static void clear_extent_buffer_reading(struct extent_buffer *eb)
> +{
> +	clear_and_wake_up_bit(EXTENT_BUFFER_READING, &eb->bflags);
> +}
> +
> +static void free_extent_buffer_clear_reading(struct extent_buffer *eb,
> +					     bool clear_reading)
>   {
>   	int refs;
> +
>   	if (!eb)
>   		return;
>   
> +	/*
> +	 * We want to clear READING flag and decrease refs in the same
> +	 * critical section.
> +	 * This will make sure invalidate_and_check_btree_folios() won't
> +	 * see an eb with READING cleared but refs not yet decreased.
> +	 */
> +	if (clear_reading) {
> +		spin_lock(&eb->refs_lock);
> +		clear_extent_buffer_reading(eb);
> +	}
> +
>   	refs = refcount_read(&eb->refs);
>   	while (1) {
>   		if (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags)) {
> @@ -3725,11 +3743,16 @@ void free_extent_buffer(struct extent_buffer *eb)
>   		}
>   
>   		/* Optimization to avoid locking eb->refs_lock. */
> -		if (atomic_try_cmpxchg(&eb->refs.refs, &refs, refs - 1))
> +		if (atomic_try_cmpxchg(&eb->refs.refs, &refs, refs - 1)) {
> +			if (clear_reading)
> +				spin_unlock(&eb->refs_lock);
>   			return;
> +		}
>   	}
>   
> -	spin_lock(&eb->refs_lock);
> +	if (!clear_reading)
> +		spin_lock(&eb->refs_lock);
> +
>   	if (refcount_read(&eb->refs) == 2 &&
>   	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
>   	    !extent_buffer_under_io(eb) &&
> @@ -3743,6 +3766,11 @@ void free_extent_buffer(struct extent_buffer *eb)
>   	release_extent_buffer(eb);
>   }
>   
> +void free_extent_buffer(struct extent_buffer *eb)
> +{
> +	return free_extent_buffer_clear_reading(eb, false);
> +}
> +
>   void free_extent_buffer_stale(struct extent_buffer *eb)
>   {
>   	if (!eb)
> @@ -3868,11 +3896,6 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
>   		btrfs_meta_folio_set_uptodate(eb->folios[i], eb);
>   }
>   
> -static void clear_extent_buffer_reading(struct extent_buffer *eb)
> -{
> -	clear_and_wake_up_bit(EXTENT_BUFFER_READING, &eb->bflags);
> -}
> -
>   static void end_bbio_meta_read(struct btrfs_bio *bbio)
>   {
>   	struct extent_buffer *eb = bbio->private;
> @@ -3896,8 +3919,7 @@ static void end_bbio_meta_read(struct btrfs_bio *bbio)
>   	else
>   		clear_extent_buffer_uptodate(eb);
>   
> -	clear_extent_buffer_reading(eb);
> -	free_extent_buffer(eb);
> +	free_extent_buffer_clear_reading(eb, true);
>   
>   	bio_put(&bbio->bio);
>   }

