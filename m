Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC3937A821
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 04:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790656423; cv=none; b=U1g2m6iavG0UcUdZ288M0tlFAvZeP7b1qklXipmyi0ha2kzh2zawdg95TxiYIMj7wnGMF5jSeyXkjVlKwJunLYMaBkO5udiMP5oebAQvqH2Z4XSpK25vCoExQ9SAV68LwocmHspTwYNSn1SQP47lJpwitzH8QyUW/dBZ6M0kT2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790656423; c=relaxed/simple;
	bh=NMuRxajFxwKYAXK9ArsorGbUohYZKZjb15h9d67zcsU=;
	h=To:Content-Type:From:Subject:References:Date:Message-Id:
	 Mime-Version:In-Reply-To; b=EW3M8E4W+d7m/vTqHvm2QqkDoyHqIgvN9/etytE7BvUOOo4rwi704FOpIFYU/8E8Jp6jTD4teP0FFQc68cmK3xEqge3F1tUyVNyyad66oR0YteboxmIpj08LJL165yWBkaEcZh8gxuItjv7eHFrYnyqWmhoNqfEUm/jWRczXH5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=OW213ao1; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="OW213ao1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790656281;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Nktp1vxaXNUfSzQGOg3Ym5Y8XH3CfCjvDTF57f3Kk9M=;
 b=OW213ao1rJ8gKu5AbGnlGuRgtZAMyEVK7tMrzuJw9+bKNSUfKjoWNl13Oo5kigUf6sq/it
 sUBZDSjbJkuQW/QT2cZAg6TugNbnYD0G/7nDikDbNlb4vHUdut6JMQ08hpVF7Ey43B2sF2
 v+fVDNz0DEe5mBLC8OdB1Z1A6gxZKMhUFNT75xCZ8qgKqPccYWXSkf6SDne5QIUp/gTDls
 elp4p3HYXjhP+cPct5v4cK9fk5UJgrhrYUaknmNPOYbK6z1P2sWbJ6KCp0l7VTCTkWZfNe
 QIvla6p9N1QFsEVjzADb1apJmFTQ7wkn5mT6FyzWd6xBUOZ6Gwa7Etq9wBGSTQ==
X-Original-From: Sun YangKai <sunyangkai@fygo.io>
To: "Boris Burkov" <boris@bur.io>, <linux-btrfs@vger.kernel.org>, 
	<kernel-team@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: "Sun YangKai" <sunyangkai@fygo.io>
Subject: Re: [PATCH 0/6] btrfs: allocator perf improvements
References: <cover.1790641462.git.boris@bur.io>
Date: Tue, 29 Sep 2026 12:31:16 +0800
Message-Id: <5736105a-5ba3-463d-90a7-5c70bb034621@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
X-Lms-Return-Path: <lba+26abb3f18+762e79+vger.kernel.org+sunyangkai@fygo.io>
Received: from [192.168.10.251] ([183.34.163.142]) by smtp.larksuite.com with ESMTPS; Tue, 29 Sep 2026 04:31:19 +0000
In-Reply-To: <cover.1790641462.git.boris@bur.io>

On 2026/9/29 08:28, Boris Burkov wrote:
> Working on the bugs to do with large fs-es and unused block groups
> 
> https://lore.kernel.org/linux-btrfs/20260916230447.GA1706558@zen.localdomain/T/#t
> and
> https://lore.kernel.org/linux-btrfs/cover.1790641111.git.boris@bur.io/T/#t
> 
> revealed some low hanging fruit in allocation performance for very large
> mostly full fs-es. The gist is to try to skip unnecessary operations per block
> group which adds up with 10s of thousands of obviously skippable block
> groups. Running 20k fallocates in a loop on a sparse file fs improved from
> ~40s to ~7s.

Hi Boris,

Glad to see this patchset resolves the long existing blockgroup 
allocator performance issue and I'm really impressed by the numbers of 
performance improvement.

IMO we currently go along the list to look for a proper bg that have 
enough free space, which means we may have to go through thousands of 
bgs during the allocation, I wonder if it is worthy to use a more 
efficient method like something sorted by bg's free space to improve the 
lookup process?

Please correct me if I got anything wrong.

And thanks for bringing these great patches.

Sun Yangkai

> Boris Burkov (6):
>    btrfs: skip unhelpful size class relaxing allocation loops
>    btrfs: don't take block group references in find_free_extent()
>    btrfs: remove redundant checks in find_free_extent() hint path
>    btrfs: factor the find_free_extent() block group skip into a helper
>    btrfs: find_free_extent checks full block groups unlocked
>    btrfs: find_free_extent checks size class unlocked
> 
>   fs/btrfs/extent-tree.c | 88 +++++++++++++++++++++++++++++-------------
>   fs/btrfs/extent-tree.h |  3 ++
>   2 files changed, 65 insertions(+), 26 deletions(-)
