Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37FF44682F
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 07:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149385; cv=none; b=Ipw3oYmBPeXLV1BHzUYrP40HoPRP0elqelbHG6BXpQjyE2dHuKDAFsyp1yg1F7jlWF/hQLiU+yHHeEQPFEVsJb/RuX3mF4nqFcdcX41g2qk41f41e/0aThBvbwYnzEbRGybEN3m5QejmBGkbOwDNnnwqiXD+9uEBf7UrvYooHHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149385; c=relaxed/simple;
	bh=FWqRFhIqADT7Fat6RAW2PyU0snk8/jc3WsZo5KoMWUQ=;
	h=In-Reply-To:Subject:References:Date:From:Message-Id:Mime-Version:
	 Content-Type:To; b=b/QR09eRxYgxxvLachHABkuwoUtLeexq6MTkTGBjL7bUSRMBBdAKrxzt6Ef7Kj/uAVp+Lpe1UcmiihBNaZqr++MR5H3Q6nephx2PsfR8Bq1FtqNkdshSoROV6QLYDSVms+x54aR4vWwvovZPfBousUFZPIxQvlYccntO+d4aHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=CExV9Bn7; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="CExV9Bn7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790149366;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UrpDmv91CVwyOInKrtNNSutAL7KbQ5AgFUutgR/l1so=;
 b=CExV9Bn7x8WH6z69o5v7M2JlOaaKbQKRTmUqY48+9a+fBeloSNbZHgoOV3T7EEE/J7cv4/
 1jjX6AooUh2AGfU6vo05Kc9DlYMoeA/Y6cDGY5VtcObPmPYt+WIUgFRGA5fq4zEy2tRdq4
 b/bPoRrKUiMUD7vZfIz/lq3EqUTc9YNoZiQhsdGfUE35LeQo1dQ4lPJAfqWCbomk+cLDRB
 nidzNA78TYsJviZbiVcKcrRzMF+0WpxxCstfyy0OZuvPduD/Y2wc+EM04hZ3848HNOHoUt
 Z/iLh88LqisSXA6FmrwWzivKTz8NNTEhZcn6Sell0f4e+MiOFowBBAKl4nvxtA==
User-Agent: Mozilla Thunderbird
X-Original-From: Sun YangKai <sunyangkai@fygo.io>
In-Reply-To: <cover.1790142027.git.wqu@suse.com>
X-Lms-Return-Path: <lba+26ab382f5+63056f+vger.kernel.org+sunyangkai@fygo.io>
Subject: Re: [PATCH 0/3] btrfs: use kvmalloc() for cases where allocation can be more than one page
References: <cover.1790142027.git.wqu@suse.com>
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Sep 2026 15:42:42 +0800
From: "Sun YangKai" <sunyangkai@fygo.io>
Message-Id: <9f4fe610-fd40-4a76-a472-28f11fa2e86f@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
Content-Language: en-US
Received: from [192.168.10.242] ([183.34.171.148]) by smtp.larksuite.com with ESMTPS; Wed, 23 Sep 2026 07:42:45 +0000

On 2026/9/23 13:44, Qu Wenruo wrote:
> There are still some cases where kmalloc() and its variants are called
> where the memory allocated can be multiple pages on x86_64.
> 
> Normally any kmalloc() with a size that <= PAGE_ALLOC_COSTLY_ORDER (3)
> should not fail that easily, so even we allocate a multi-page buffer
> using kmalloc() as long as it's not reaching 64K (4K page size) it
> should still be fine.
> 
> Thus those cases are all very rare:
> 
> - An inlined extent larger than 4K
>    This can only be archived by a system with page size larger than 4K,
>    along with larger max_inline.
> 
>    And still, only 64K sized inlined extent can really cause problems.
> 
> - Too many RAID56 data stripes with SHA256
>    To go beyond 4K, it only requires 9 data stripes, but to reach 64K
>    (order > 3) it requires 128 data stripes which is beyond sanity.
> 
> - Fragmented memory at btrfs module load time
>    This is in fact more common than the above 2 cases, but this requires
>    CONFIG_BTRFS_FS_RUN_SANITY_TESTS and load the module after the memory
>    is fragmented, it's still very rare.
>    
> So all of those fixes are just another bike shred problem, but
> considering it's not that hard to fix, so here comes the patches.
> 
> Qu Wenruo (3):
>    btrfs: use kvmalloc() for btrfs_encoded_read_inline()
>    btrfs: use kvzalloc() for btrfs_raid_bio::csum_buf
>    btrfs: use kvmalloc() inside test_eb_bitmaps()
> 
>   fs/btrfs/inode.c                 | 4 ++--
>   fs/btrfs/raid56.c                | 8 ++++----
>   fs/btrfs/tests/extent-io-tests.c | 4 ++--
>   3 files changed, 8 insertions(+), 8 deletions(-)
> 

Looks good to me
Reviewed-by: Sun YangKai <sunyangkai@fygo.io>
