Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F11E32D6
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 00:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777424278; cv=none; b=okGax4s2zLqQJvKcJ0/x5UlOZEwE0yDz1mtfyod8GEvRHbMc6ZFOdDp3Bo99hgHLp2lUZVdTBKY6Xdq8pQgRFkA+46wx46E2WjNom2afsSll3uvRGSUTUn4QJj6ohsYEI+Kcl0eEy/dxXdp0SHHtMCtylYu7XMPzTsIPkieXrKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777424278; c=relaxed/simple;
	bh=TPYmmSqbOwapKvCNLV/s/gGCmt3J2YVqxAVGQIT6/z8=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GfXOqx8XWYtPCi2E5jYHGjhhmAwCCJClCpoPOu9xvKQkeLyQl5Icz+Jw0VE3eaEyfWCkvnZd8FaO9upZrIybDGItOyl9sVksUZFYAt0bQypQ8RWBSeC04XHKG5vaJTf3Bpj7deLrkUT79EDvoOS9W8WgIutE7snqgtpJ+5Qao+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=IjPU+O7T; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="IjPU+O7T"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4g4zRs5y7sz9tpl
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 02:57:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777424265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bR4sapWVBfOECzuNvLcWyCJjx+qvLJzaqSPQtqfO2uc=;
	b=IjPU+O7TiEEwtI3zSH1NvWqNxeb20SNk7fCjxnYNQcjNg75ag+YXkiyLsm6Ee0hTXcPpZ+
	m7Y9g4zNVLivoFFXOVvM/LY3iVsqa5sW1TR+O5ewxNKRn27fXX2GwDsup3bvyizGhrnoPI
	jsjzLbNHCVHWEzE7b20bJG3gxXxl9hZJaLEvptIdydrkgi8grNqXll0mzKcLOL2EYp/k+n
	qJkrWEGV+2wqO2Y/cEUiqtgX7ap0T/LfA+bXTOeqRpqGEPmPLEPqk9SjCZSR2L1XFgEEDu
	U5FnuK550FjFrYMIaLNpJPdA/+M8FF4QdB4Me68qld0fmhTNNzZEeqsLEOaDFA==
Date: Tue, 28 Apr 2026 20:57:38 -0400
From: brainchild@mailbox.org
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <2CD8ET.98SA563QWYJ71@mailbox.org>
In-Reply-To: <70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
	<20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
	<2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
	<KAR6ET.BWL8BEMZPLSV@mailbox.org>
	<0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
	<d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
	<19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
	<06Y7ET.5XM6UHU999Y21@mailbox.org>
	<70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-META: gwj4rh6yrgwxbddm3fam97euewgmz6hn
X-MBO-RS-ID: 16cc8540f915b77218e

On Wed, 2026-04-29 at 07:53 +0930, Qu Wenruo wrote:
> 

> >Then how did the problem of failing to create new files happen?

It began suddenly, with no clear cause.

The Timeshift snapshots had been causing serious lag since a few weeks 
earlier, but investigating had not yet become a top priority.

One similarity for the two times the problem has occurred is that I was 
running file searches across the whole system using 'find'. Perhaps 
something about these searches triggered the more immediate problem.

> >Any extra output when that happened?
> >Just returning -ENOSPC error messages but the fs is still read-write?

Yes, the FS is still RW.

> >Because you have no unallocated space so metadata can not be expanded
> >anymore.
> >
>> 
> >Meanwhile all the free space is inside data block groups, you need to
> >balance *only* data block groups to free up space for metadata.
> >
> >Not the opposite.

I already tried balancing just data, but there is no longer any 
benefit. It seems all of the data is already balanced. Otherwise, 
balance is failing to do its job.

Attempts to balance data now instantly complete, reporting nothing to 
do:

---
$ time sudo btrfs balance start -dusage=95 /
Done, had to relocate 0 out of 833 chunks

real 0m0.059s
user 0m0.000s
sys 0m0.013s
---

The only hint of any problem is from the kernel log:

---
_btrfs_printk: 788 callbacks suppressed
---

The other messages relate only to reporting blocks as skipped due to 
the swap file.

Earlier the more aggressive balance operations were failing, reporting 
no available space. From this situation, I started with -dusage=5, and 
then reached 95, in increments of 5. Each of the calls lasted no more 
than a few minutes, and in total only about ten blocks were reported as 
moved.

I would consider removing the swap file, but it would require shrinking 
the Btrfs partition, to make room for another partition dedicated to 
swap. I wonder whether it is safe to resize the volume, considering its 
unstable condition.
> 

Also, since the swap file is so small compared to the size of the 
volume, I doubt that it is causing the serious problems.




