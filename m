Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A583326938
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777414822; cv=none; b=Q1K/AEry/mYRcZWWa38LqETs77lVhCJ10LxplzcbeL4/tO7wdxUpJ4ZtC+ZvATrMIaiJwQpxNL76qzdmfohBKxHUWhWAeOIsIpCFnEJ4yAOyzn1qv+Ifp6K11wnpZoSS9/yHTWRDpY4fbjg2akwWxRnB+09C+vNrI3l84nPLKFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777414822; c=relaxed/simple;
	bh=0ikaJdIN/cnH8G8xSnYAifzIo5ed/laiZCJBB7tnT28=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RuAbaJxOp+RHK9xdfBpnOmoGWdQMeAAFDARvI4Ahk+SL6Ed85O1sIz4T6XeE6HfuN7KBo1DfwfJG/LveBH4kRSpMHm+j7xcBmg+u2SyQGklCwhp9jHvT/9BCvR26uiQonzhRA2okY10Yrech71ZdtFxCHjh1k/25zOppPVroF3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=lcBWoJhm; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="lcBWoJhm"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4g4vy8503dz9tqX
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 00:20:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777414816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SGg2o/bIc2lhPz0Gf+tiuwgfBwUUZOmKfMmTcKCDaVM=;
	b=lcBWoJhm8HMiMw4ca5bXt/Vu8/nOxJ0tWH9l9Gb7e1SwBCzvaXrZnSkg9bc8QLJ3geblEx
	zDocN72d9jqWfoiaw+RDdm+HCKgPboguNZ+9hr7/LgYSWbU4F2RU3/RxVBaUww6XArxnzn
	11uE7n57qTzUSMK/k1++49ntX7H17YICNUyzK7v0FLR//Va9WdU02NJCQ+hlzvEfBWmICy
	7rSt3ah1gjufoUoXboMmucG9MVTYJfmi1wuXiu8YqzcN0Mt4lihOhuYJjqSjI3xEY4wvoc
	jswVJIyJ3ncDOXFftlkvNuPh9h3/w1JPHVYyUJ1b3lRgtoL7w0IWqSuX+ceEDw==
Date: Tue, 28 Apr 2026 18:19:58 -0400
From: brainchild@mailbox.org
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <A168ET.AOECEOR9CWSE1@mailbox.org>
In-Reply-To: <06Y7ET.5XM6UHU999Y21@mailbox.org>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
	<20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
	<2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
	<KAR6ET.BWL8BEMZPLSV@mailbox.org>
	<0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
	<d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
	<19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
	<06Y7ET.5XM6UHU999Y21@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-ID: 84323ce5f5010d24e5f
X-MBO-RS-META: dnhnze35sda7pazgs6urcc96z4piaic1

Further to the comments in the previous message, I have also found some 
messages in the kernel log, from the balance operations, which may be 
relevant.

As the console output of the command is "ERROR: error during balancing 
'/': No space left on device", the kernel messages are as shown below.

---

balance: start -musage=50 -susage=50
BTRFS info (device nvme0n1p5): relocating block group 4126692868096 
flags metadata|dup
BTRFS info (device nvme0n1p5): found 9279 extents, stage: move data 
extents
BTRFS info (device nvme0n1p5): relocating block group 4126155997184 
flags metadata|dup
BTRFS info (device nvme0n1p5): found 6365 extents, stage: move data 
extents
BTRFS info (device nvme0n1p5): relocating block group 4125149364224 
flags metadata|dup
BTRFS info (device nvme0n1p5): found 10145 extents, stage: move data 
extents
BTRFS info (device nvme0n1p5): relocating block group 4124612493312 
flags metadata|dup
BTRFS info (device nvme0n1p5): found 11487 extents, stage: move data 
extents
BTRFS info (device nvme0n1p5): 1 enospc errors during balance
BTRFS info (device nvme0n1p5): balance: ended with status: -28


On Tue, Apr 28 2026 at 03:30:00 PM -04:00:00, brainchild@mailbox.org 
wrote:
> 
> On Tue, Apr 28 2026 at 04:11:05 PM +09:30:00, Qu Wenruo 
> <wqu@suse.com> wrote:
>> 
>> I strongly don't recommend to use swap files on btrfs, as you have 
>> already experienced the limit on scrub, and I believe a lot of end 
>> users are not aware of all the limits when using swap file on 
>> btrfs, please check the long long list of limitations in "SWAPFILE 
>> SUPPORT" of btrfs(5).
> 
> Is it expected that the scrub operation cannot function properly if 
> the volume has a swap file? I never before observed such a problem, 
> nor find any mention in the documentation.
> 
> The specific restrictions, as documented, for the swap file, seem 
> completely compatible with my use, a single partition with no data 
> duplication. I have no need for spanning devices or duplicating data, 
> on the particular system.
> 
>> Any dmesg of that RO flips? That indicates the fs flipped read-only, 
>> which is a huge problem by itself.
> 
> No. There are no kernel messages that are errors for the file system, 
> or switches to read-only.
> 
>> Especially with your initial info, there should be enough data 
>> space, metadata space is less ideal but should be enough.
> 
> I have read that the space allocated for metadata is expanded as 
> needed. Why would problems follow from too little space being 
> allocated?
> 
>> Considering how many snapshots you have (triggering qgroup lag), I 
>> strongly recommended to remove unused snapshots to free up space.
>> 
>> After freeing up enough space, then try to balance data block groups 
>> to make space for future metadata usages.
> 
> The situation with balance is quite confused.
> 
> The problem with the reported lack of free space first occurred 
> several weeks ago. At that time, I deleted snapshots, and ran balance 
> operations with incrementally higher usage values for data and 
> metadata. By the end, I had run the operation, without reported 
> failure, with values as high as 95%. Normally, such an operation 
> would be very long, but in my case it finished in less than a minute. 
> Also by the end, only about ten blocks in total had actually been 
> reported as moved.
> 
> Perhaps my installation of btrfsd has been successfully maintaining 
> the balance for the volume. The system logs are not extensive enough 
> for me to know when it last performed any operations.
> 
> Regardless, it seems that the general problems are not becoming 
> resolved by invocations of balance.
> 


