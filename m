Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4AF344DB5
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 04:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781672396; cv=none; b=q0PZ5yXv8IkcteVZJk/iyUpJCGd2IM6pJEnFxCEFRDTHDorTY3Hcs4x9tTFCUrmTb+6qyBj2TYOAskqL2ysvhdESloALabAwv5xHi7opG8z1dBeBDGmiOI2RaVUKnSJsu5XWthdPfP2NI7NCJe6UQnlvC3Hss6AlqrRu/GzhwVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781672396; c=relaxed/simple;
	bh=My6gyivgZuvQEIvVuYPUp4CtjV/bqnmK6YTn2e5kG0U=;
	h=Date:From:Subject:To:Message-Id:MIME-Version:Content-Type; b=q+CO0Xxbm3pSrsUPL/BkHOZ+/YS5Q9NhVfIQD//dC/DHwN8waICzdAs5X0Q5q6xlVBBllrBWyvZpcQxav01BrB04d9GrSFvE16x9IDXxLFOecVVlA63objRQnCmAfV/h1obwYdQVOmfTy6dDUm5Kl80DnMMrMFVHJcnHVEiPZZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=iVZwba7/; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="iVZwba7/"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4ggBVP2DWQz9tRP
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 06:59:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1781672381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=GcT0bcE7ySYdO/CMYA1DIhGKmDWQpL+5L84T32mVIm8=;
	b=iVZwba7/NzIPRMjERIqRkd86mqIa0gtdefN2rcKtOSkWThE5L6IyPVvmK0CPiHX0ID4utJ
	qrxJcqJqZbDfta3pmn2kfP+PtREsOIwhMD+0lmP2wIg9uL2aFL5SxsRV7RooZz+WTV7DPM
	eiUhNZl+suKArnmT1uodBGI4e+x/xuoTVzCercaMEznUTetEXbJOkD9qyl3pf95G8BZ8YW
	Bm+9THmOPnxv42HDc4U3MfsPn3oH+tKMVg6HoK6mLleeibD6SMtQJWYsJL11INm4He12WQ
	QRDXdzBNBV3Q1GBQrt6kdr18arMwnIxj4vSK6minr+e9Oi3y2ngpIz3yhoYdJQ==
Date: Wed, 17 Jun 2026 00:59:31 -0400
From: brainchild@mailbox.org
Subject: Blocked by mismatch in super extents
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <77FRGT.AWPW4X7MQ16B3@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-META: kud59ob5akojxgg74sz5y4qfexjsfzea
X-MBO-RS-ID: b41bdedb65cb74eb92a

Hello.

I am seeking to shrink a Btrfs partition.

When the partition is mounted, Gparted reports "Unable to resize 
read-only file system".

The mount is not read only, however. It is the root file system, and 
functions normally as read-write.

The version of Gparted is 1.8.1, btrfs-progs 6.6.3, and kernel 7.0.12.

When the partition is unmounted `btrfs check` reports the following:

---
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
super bytes used 748052320256 mismatches actual used 744718192640
ERROR: errors found in extent allocation tree or chunk allocation
[4/8] checking free space tree
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
Opening filesystem to check...
Checking filesystem on /dev/nvme0n1p5
UUID: bbac86e5-eaba-45bf-bbaa-c2494e11831a
found 744718147584 bytes used, error(s) found
total csum bytes: 475357280
total tree bytes: 9006252032
total fs tree bytes: 7635779584
total extent tree bytes: 712065024
btree space waste bytes: 2140165860
file data blocks allocated: 12519291805696
 referenced 1070009720832
---

In this case, btrfs-progs is version 7.0, and the kernel version is 
6.18.20.

The results from `btrfs rescue fix-device-size` are "No device size 
related problem found".

Due to the failure of `btrfs check`, Gparted refuses to shrink the 
partition, when attempted with the partition unmounted.

Therefore, having attempted both with the partition mounted and with it 
unmounted, I have failed to find a means to shrink the partition safely.

I have succeeded in shrinking the file system, using `btrfs fi resize`, 
but not in shrinking the partition to match the smaller size. Gparted 
still expects its examination of the file system to reveal full health, 
before it updates the partition table, and I have failed also to 
restore the health of the file system.

I am grateful for any advice that may help resolve the errors.

Thank you.


