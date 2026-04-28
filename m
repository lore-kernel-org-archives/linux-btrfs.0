Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ABB361DB1
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 19:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777404623; cv=none; b=bHPOvnWWEHHAcakpYYMt1uheEs0nmxWHNhWbeqAe4KnWatTD7djnBh5+r7nI8nSUFr+nYVZbZCz6P6DUMNj4K+PMrXOwEVSmHgptL3Die2mkFUnpaUohP2QfV8xqyFnaRD6bj7I8OvbH45MUyaHe1lSAIrIXoTKRVRu2gTKhqtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777404623; c=relaxed/simple;
	bh=z2TSjTKFMBjxMZqU5LCepr9g406DSBqGNNqUjM5/SjU=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KHKWi9ynHJlRD840hx1StxZsT0gAAu1urfJqJc92v9c/cdHk94zM0YfgqmaMe0sBdE5SGkyN86fcR637YrM0mDiqQad2GXIdISQFLe1kWJ4Brn7iD4yX7tsvb7UkRPRzrs0arpVLe1LVlWs0NXjLVXSWBXeeItdHHEKAJ5rhHzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=IrjdwYZj; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="IrjdwYZj"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g4rB15mGHz9tvc
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 21:30:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777404617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zYEl3LPy3XMVgjS6L4JOzULQ8Jgo7XWrWLfG/6HQ/LE=;
	b=IrjdwYZj2P0MwNURxA0MbGuTE56wZEC5/HfqbhXZd3RMFcFX5clm+yFfX9HrSFUUoHjZxr
	4YQhb6sBNNLH8hxSr8AngxpF5QNWxp8ymgrXnc6Qqsf777yAAjBAVB7SPfl+1ajvl2y0bB
	26E8bvZu99xsXNewIKxy/5m4EXjnGq0pn/GEJGmjNzofiUakYThFlXIcCRn6RBucI6emG9
	OuVM7Enbd74csIdb7PrqBgmXdQyi/C714sPbKJTVGBS9BvejYyCqDij6UQEdhYqXYl9ROV
	xDT7Z2tGyTYkjwvTrA7ybTcmf597/CFOBCUTkiM9Z1qtx2zesIg93lUn9HKdAg==
Date: Tue, 28 Apr 2026 15:30:00 -0400
From: brainchild@mailbox.org
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <06Y7ET.5XM6UHU999Y21@mailbox.org>
In-Reply-To: <19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
	<20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
	<2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
	<KAR6ET.BWL8BEMZPLSV@mailbox.org>
	<0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
	<d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
	<19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-META: 3n5wmuyy33moodfb8moroictndo171ci
X-MBO-RS-ID: 78fb8e21ba2d8bb044b


On Tue, Apr 28 2026 at 04:11:05 PM +09:30:00, Qu Wenruo <wqu@suse.com> 
wrote:
> 
> I strongly don't recommend to use swap files on btrfs, as you have 
> already experienced the limit on scrub, and I believe a lot of end 
> users are not aware of all the limits when using swap file on btrfs, 
> please check the long long list of limitations in "SWAPFILE SUPPORT" 
> of btrfs(5).

Is it expected that the scrub operation cannot function properly if the 
volume has a swap file? I never before observed such a problem, nor 
find any mention in the documentation.

The specific restrictions, as documented, for the swap file, seem 
completely compatible with my use, a single partition with no data 
duplication. I have no need for spanning devices or duplicating data, 
on the particular system.

> Any dmesg of that RO flips? That indicates the fs flipped read-only, 
> which is a huge problem by itself.

No. There are no kernel messages that are errors for the file system, 
or switches to read-only.

> Especially with your initial info, there should be enough data space, 
> metadata space is less ideal but should be enough.

I have read that the space allocated for metadata is expanded as 
needed. Why would problems follow from too little space being allocated?

> Considering how many snapshots you have (triggering qgroup lag), I 
> strongly recommended to remove unused snapshots to free up space.
> 
> After freeing up enough space, then try to balance data block groups 
> to make space for future metadata usages.

The situation with balance is quite confused.

The problem with the reported lack of free space first occurred several 
weeks ago. At that time, I deleted snapshots, and ran balance 
operations with incrementally higher usage values for data and 
metadata. By the end, I had run the operation, without reported 
failure, with values as high as 95%. Normally, such an operation would 
be very long, but in my case it finished in less than a minute. Also by 
the end, only about ten blocks in total had actually been reported as 
moved.

Perhaps my installation of btrfsd has been successfully maintaining the 
balance for the volume. The system logs are not extensive enough for me 
to know when it last performed any operations.

Regardless, it seems that the general problems are not becoming 
resolved by invocations of balance.


