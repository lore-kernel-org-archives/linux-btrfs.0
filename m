Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589862EACEF
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 21:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777670260; cv=none; b=oNN2sEevR9C9YqOsGoC7hY4AG8JPXz5714y+OMupH7toCm7SdaXE4kXs+ALSIvXHJTz93CS5RJ9ff+rMPh2YHEOYwHMdYAHqxYYf2HsmVkhFoviCXKnaFEyYPfhahZPzGirj/sVyHH7mNjUBSfid03P8i2YFeJqgvbj31xTAY3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777670260; c=relaxed/simple;
	bh=14NqhAPbdI0uVUMAwvVsNjd7xdnrlkzPkMqNpLZs5v0=;
	h=Date:From:Subject:To:Message-Id:MIME-Version:Content-Type; b=IamPopgVtAJONgN+YwKSLNSw/o8gOuOxkBV8YfQA6LnDLVEiZ34LI48oCigkalv7L1Uj8qG7woT+XBIDxm5KRkmfGRWAhy5hDo0DAo2wuNkco+i3nT3L017TfPaQ4kvkoRbuEzmN/GJjgxQ3Oh/qvaWlDT+e8Mu3j0K06nOP6wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=yKO7OHj8; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="yKO7OHj8"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4g6kQJ21ycz9tpM
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 23:17:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777670248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=yvaGygx8A2wr9qUAsGqbFIPNJUKnLifiAAK/EVBIdvU=;
	b=yKO7OHj8YXFZoYithl5bBRwu4ZhPr5JSsbA73krzqBsOa5mdNQCOqP+PsKvSc1oOl/jUun
	1G6Qz6qIxrGRpDVfIin4mTIoDiQ5iP1a3b7mgN/+oXgzd7fFVmXWM51NgSrLyJUkn54PN7
	GT+2ZhimttUR0CNeWc7S+CBoPsNs9PFTDsk4DuUrXNpicB0pt/n8y/HGl4ZG2vpT4RiflB
	MxN2IaO1BI28sbarvDM+mFklTVgzC4Dkc/SuyOU420SqdwvUqEkG6lGBkEgGh6Fcb8qbqe
	gOlPqFacmEtWp/EJN10oKofkNTYKAhVHcEQewqJ+ToNZk9obFtllEQAaArFXpw==
Date: Fri, 01 May 2026 17:17:20 -0400
From: brainchild@mailbox.org
Subject: Understanding and resolving super mismatch error
To: linux-btrfs@vger.kernel.org
Message-Id: <W4NDET.0Z0BXQT4DXWY2@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-META: 4m1t4h9g8fgr3c3zpya9rkg6p57jiuza
X-MBO-RS-ID: f4f15e8cf3e07f0f2bc

I would like to resize a Btrfs volume, as I normally would do through 
Gparted.

Unfortunately, the check utility is reporting a problem:

---
[1/8] checking log skipped (none written)
[2/8] checking root items
[3/8] checking extents
super bytes used 756613705728 mismatches actual used 753279578112
ERROR: errors found in extent allocation tree or chunk allocation
[4/8] checking free space tree
[5/8] checking fs roots
[6/8] checking only csums items (without verifying data)
[7/8] checking root refs
[8/8] checking quota groups skipped (not enabled on this FS)
Opening filesystem to check...
Checking filesystem on /dev/nvme0n1p5
UUID: bbac86e5-eaba-45bf-bbaa-c2494e11831a
found 753279516672 bytes used, error(s) found
total csum bytes: 483872008
total tree bytes: 8971255808
total fs tree bytes: 7809040384
total extent tree bytes: 558678016
btree space waste bytes: 1983819676
file data blocks allocated: 12001362440192
 referenced 1022445051904
---

I tried to resolve using `rescue fix-device-size`, but the results were 
unhelpful:

----
No device size related problem found
---

Gparted, as I recall, normally will not proceed to resize a partition 
that fails basic checks.

More importantly, I do not want to proceed while the health of the 
partition reduces the safety of the operation.

The system is using btrfs-progs version 6.6.3, though the check and 
rescue operations were performed in a recovery environment using 
version 6.17.1

Further information is reported below.

I would like some advice in regard to a few questions:

1. Does the super mismatch indicate an elevated risk of loss during a 
resize operation?

2. How can the error be resolved, so that the check succeeds, and the 
volume is fully healthy?

---

$ uname -a
Linux *** 7.0.2-070002-generic #202604271502 SMP PREEMPT_DYNAMIC Mon 
Apr 27 15:35:55 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs fi show
Label: none uuid: bbac86e5-eaba-45bf-bbaa-c2494e11831a
 Total devices 1 FS bytes used 703.67GiB
 devid 1 size 831.26GiB used 723.38GiB path /dev/nvme0n1p5

$ btrfs fi df /
Data, single: total=701.19GiB, used=692.17GiB
System, DUP: total=32.00MiB, used=144.00KiB
Metadata, DUP: total=11.06GiB, used=8.40GiB
GlobalReserve, single: total=512.00MiB, used=0.00B




