Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D126A386C24
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778787539; cv=none; b=M8uZBMBMDv+6BqUTvZC7N928C5QUfCzqqyJzhC4ucdX4ob+zmPE/NAhjsfWXHye2+U2DEbFsT6JJzM28aHPtfFyA65aoChWw3WQR4+/rN/+WBViIbdQTkKAAZprnDjev3mum0wlsBjf5BaVWckdjOn7HGhgKWwSWomTiL57fjPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778787539; c=relaxed/simple;
	bh=FpMUvEryB2EenwcT9OwdZmgO0P/SEMEDQnwP5WnRJ4k=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MR9wxkf44nXBHK8XSJvPj8pAeEWjImZsnMZPV7+zcNCcCsA5zvimxbFQlakfUpd1VOWTd7MwRr5kM0U0lxzBtyBVS72ilm8ts5iPqF7FBIonnHQrkGNePdxQFfn41E5OZv90DxieRo2uMxVpuh0c2DyZDqf9QA1NUWPOhUDjCGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=lYkudZT9; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="lYkudZT9"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4gGgcY3lsVz9ttC
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 21:38:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1778787533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xYAOkNa5YeJpjruGjRibi4blsBsHeS5Va2VMTylJJBg=;
	b=lYkudZT9QjVWnQ7RGx0dUQbugMgc5CtESvGM0fCc8nx1ICeJz+H4ut/9pS04EPNurn+HIl
	7J952GNma1bfIs2XcLsJAfMnqj+6neczMFMhelWBpqocf+678/qDRt1H1CXdshdEnSSDmp
	Q+6F9l859kD2GIWQf6CX7ACN62E2meQdwbegdI/BoEnlqm7z8wufW442oopDxHiH4UlPfW
	sc96ByGcBZ4oOlro8UGfXrlvqLMkBPC7SzaSkN3hbmGjVPhRXkBrfb8b3qbB90CrugVvIS
	VFBmfvaXnH5ph9cmBiLtIpZUjkHnShGRW6KkIwCnnzI5b3Zu0n3MyuR9llJq+g==
Date: Thu, 14 May 2026 15:38:46 -0400
From: brainchild@mailbox.org
Subject: Re: Understanding and resolving super mismatch error
To: linux-btrfs@vger.kernel.org
Message-Id: <M8L1FT.5SMPO3MM6WWR2@mailbox.org>
In-Reply-To: <W4NDET.0Z0BXQT4DXWY2@mailbox.org>
References: <W4NDET.0Z0BXQT4DXWY2@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-META: 9rxhb9sm4yh1nu5h35q8f64scrxp94jb
X-MBO-RS-ID: 8b9dd8e83a59a08a8bf

I hope it is not objectionable that I bump my question, first asked 
several weeks ago.

I also hope someone might try to offer some answers or suggestions.

I would like to be able to use the file system normally and safely, by 
resolving the errors, and I know of no channels for such support other 
than the mailing list.

Thank you.

On Fri, May 1 2026 at 05:17:20 PM -04:00:00, brainchild@mailbox.org 
wrote:
> I would like to resize a Btrfs volume, as I normally would do through 
> Gparted.
> 
> Unfortunately, the check utility is reporting a problem:
> 
> ---
> [1/8] checking log skipped (none written)
> [2/8] checking root items
> [3/8] checking extents
> super bytes used 756613705728 mismatches actual used 753279578112
> ERROR: errors found in extent allocation tree or chunk allocation
> [4/8] checking free space tree
> [5/8] checking fs roots
> [6/8] checking only csums items (without verifying data)
> [7/8] checking root refs
> [8/8] checking quota groups skipped (not enabled on this FS)
> Opening filesystem to check...
> Checking filesystem on /dev/nvme0n1p5
> UUID: bbac86e5-eaba-45bf-bbaa-c2494e11831a
> found 753279516672 bytes used, error(s) found
> total csum bytes: 483872008
> total tree bytes: 8971255808
> total fs tree bytes: 7809040384
> total extent tree bytes: 558678016
> btree space waste bytes: 1983819676
> file data blocks allocated: 12001362440192
> referenced 1022445051904
> ---
> 
> I tried to resolve using `rescue fix-device-size`, but the results 
> were unhelpful:
> 
> ----
> No device size related problem found
> ---
> 
> Gparted, as I recall, normally will not proceed to resize a partition 
> that fails basic checks.
> 
> More importantly, I do not want to proceed while the health of the 
> partition reduces the safety of the operation.
> 
> The system is using btrfs-progs version 6.6.3, though the check and 
> rescue operations were performed in a recovery environment using 
> version 6.17.1
> 
> Further information is reported below.
> 
> I would like some advice in regard to a few questions:
> 
> 1. Does the super mismatch indicate an elevated risk of loss during a 
> resize operation?
> 
> 2. How can the error be resolved, so that the check succeeds, and the 
> volume is fully healthy?
> 
> ---
> 
> $ uname -a
> Linux *** 7.0.2-070002-generic #202604271502 SMP PREEMPT_DYNAMIC Mon 
> Apr 27 15:35:55 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
> 
> $ btrfs fi show
> Label: none uuid: bbac86e5-eaba-45bf-bbaa-c2494e11831a
> Total devices 1 FS bytes used 703.67GiB
> devid 1 size 831.26GiB used 723.38GiB path /dev/nvme0n1p5
> 
> $ btrfs fi df /
> Data, single: total=701.19GiB, used=692.17GiB
> System, DUP: total=32.00MiB, used=144.00KiB
> Metadata, DUP: total=11.06GiB, used=8.40GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> 


