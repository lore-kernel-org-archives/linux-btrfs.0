Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E932AAB3
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 15:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821236; cv=none; b=Zdg3GRL4QTFStAmLDbvRT9njV/toZjt8nuCnrjyFqLBroJFf4w01nOnm15zBqWSJhATjhwOjaiQEU7fKlLf4M/cAdgKUlXhksWjFgBbqryK0z7ZAJ7XpPOjxkL1lx6PRdPWgT6Ij6OABzURyLU43G497u4G8n0BiZef9ci9WwS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821236; c=relaxed/simple;
	bh=kZN9xujJ8aQuyoQPmi08Q2kGQVR8yN9jazLdb/hRs6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9gxLyNC6aTuRqK2P78cS1tAZn3JBy2htx4opJw+b65L5qGyyWkhSdOCJC7ido4jFKOpIFCAP+Ywq9FEYzDjF3eB76FSMWU3TQfu5eNuNdoXAmRW50QAID91B3jeqPYTdPDlPbF6rG46kAJyXYGa1RmaK2cFp213aGpLq4arkqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Mh3DQu8N; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AGhDKagu; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Mh3DQu8N";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AGhDKagu"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 82516EC02C5;
	Thu, 23 Jul 2026 11:40:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 23 Jul 2026 11:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784821233; x=1784907633; bh=J4b5OoJ24h
	AEmfYzhIWlX6CDfcua68Ck5D2fgQO2aSQ=; b=Mh3DQu8NQT1b5uk7Pjk32IFKbb
	W70q/CAzlJn7jgSw4+kN1Nb+Oz+WHAbG4VMO9e3grUC36yw+058uR5vq1Vl+ngU2
	b8ObSqlyDMxqIxuKQKkd0RMWTH2vFASnU7riEUONTPL13lKs7TPpJ3m1cW6L+ACN
	d3N+hiINR9ffKxlafXOILgaoGORAd5Aelg2PUtQRVNOGw7Fo1AlmRpLUiMyR9Q+B
	Lewd6+1xUIeLNugCmVhTnOA6CdPDA9Y1BEj+mzMGwqusnyoiQGOy0ZiWKanEJwYO
	orMdBHnN3PxUJLbhergcBGm8MOQECemFCFj4S4o46nGVxxgkzStqEhaFdb6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784821233; x=1784907633; bh=J4b5OoJ24hAEmfYzhIWlX6CDfcua68Ck5D2
	fgQO2aSQ=; b=AGhDKaguoID4o/YkPAmqOnvBKiemjcyf6YIizcjdjsqjqHtNCTd
	Yg188b2JvjQaF1EXi+bez2GqB7zYXTblBLHC3aNK9X0TGFK/58+MEmKyoAgou5Fa
	WLO3RJH2P9Nqr1nlfWmvgLWmbZcwPmxqLcT2goClvXc6Z4HcC1gEdGRy9LnZGTcS
	kxq67tQsHx+abTUtD4Nq4yrk9L3ytFLFMw3NsZxbeY6Pyf14lbWV3wjSNHIsjgDu
	7NoP3LBMP9pef3fLREZ3bYKoARr9bDAmcoxWeoppGh3aKwTFnnFAFqtgVkCYK/Bs
	u3fx+LGckfZ0O/vsUuIkSJCczMEofy47DpQ==
X-ME-Sender: <xms:8TViamx_pYAKSf0_3ZromZQTC3z0hYPT4EZxuMB79Blhjp43juHXOQ>
    <xme:8TViapIvr7Ek7yVwCoxL7aap8RmU7OxBsrLfCo9OtTC0s3fqD66yiE28LvUplO0o_
    2KPaFIY0UWNNQCoVEhvDp_jgIdEsrBSQP4FyR4iVh1tGaBemiezH4GY>
X-ME-Received: <xmr:8TViagoA_yUkZ3g286LFE-nzW3jRVbKPhbh3KpVmHwm0EwWDxXA54lTWejdmUflDu1fJsG6PDQH6gjjPeGlwnozLURY>
X-ME-Proxy-Cause: dmFkZTEMlkofrH/V9TU36gvH9Hzcdwdyo/5YugYeQMzCm5Gt/ejDPWT1CL1Ypc6y3wOQfz
    QnS2wVOxlebLFLS8k+E1JiozgPZHvUwPSoE9Wz3tmuYXUW5dTiHnk1syXZn+lID2f4PObR
    gq5zmxRVrxUQ9I4pQurV3R8o6Pejl5jvRP/5OmKV49y0FJl0saLoln4NzLTUmo6fkInHu7
    7l+G026WN9mdsuXslr33S1AZhI4qipqHQbhDcgi5KoeHXqpOJyv+o/TRGLcj1aLFCMRr2e
    RUgEEaGFuz66yz6scTOueF+eSLsyP1olzuNbNTKwWcYKVhoJ/RQzc4JuhfsEdSz8CN30iX
    yaBK/4t5FSxRDWKIVMC+2CiZRzaQpFovWgNkv6eYbfD8sAV9yqTEA44qweMqGX3dCVCb5F
    kxErNkZPJkTiiKGqucQPZGYT20iV0eqrQf0eEv8ZSMctZadmL0zc9Iwo+o/bfuI9evhEIF
    P9eFKFCigcqCWeLVDBRx5J1wChBQFuq0cBGkUeNCU8CHm9SZFaH2dDbqBKozxBjnz0+xOm
    dLZM4DiaY262YFYWAv+plzrzU0huOVla7+4I9Bity4AT8XCn5BBaEcw+8DLyc9WWiCVAyQ
    5ar7y8d++S7K1v8667rerQhBqFvU94FLV8YnOD/j/gDSHfkNMbX2qPW5l4XA
X-ME-Proxy: <xmx:8TViaoIqdYK1yWOQz2QONmoPNeYBOvZ-YNnKwPVu1Mp74pz1pAyirw>
    <xmx:8TVialSiAfG6T7DiSfm5w3gaVfi9Mi3Q7fj6d_x2u2VFg8a_XS8tWQ>
    <xmx:8TVianvv9ZaFn427Z0uGyOHKOZXEcjoJMqO9xQHMVYaNgVlOgiWfGQ>
    <xmx:8TViambBfAGobW5bZZUTW4MST0Vk04TO1D4s-rDl92q2BD16mzk0jA>
    <xmx:8TViagPNG4sNVlcRaqJyn81Z22DNPWGZ45viJ8UgGLO0cQGxoCOuwNkI>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 11:40:32 -0400 (EDT)
Date: Thu, 23 Jul 2026 08:40:22 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/4] btrfs: zoned: flush active metadata block group at
 btree_writepages() start
Message-ID: <20260723154022.GA718817@zen.localdomain>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
 <20260722113016.1896990-2-johannes.thumshirn@wdc.com>
 <20260722170835.GB26033@zen.localdomain>
 <20260722190138.GA107842@zen.localdomain>
 <a4d55d8d-c512-4e9a-af71-694437f50825@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d55d8d-c512-4e9a-af71-694437f50825@wdc.com>

On Thu, Jul 23, 2026 at 04:02:27PM +0200, Johannes Thumshirn wrote:
> On 7/22/26 9:01 PM, Boris Burkov wrote:
> > Furthermore, I feel like this is actually quite redundant with the whole
> > EBUSY pivot logic.
> > 
> > So for random reclaim writeback, we walk the ebs in index order and skip
> > any not in the active bg if the active bg has dirty ebs. Then we reach
> > the active bg and flush it, submitting everything. Subsequent tries to
> > writeback the non-active will now wait on that submitted IO and
> > ultimately win and get to become active, and do more submission.
> > 
> > But we could save the bother and make things more direct and simple if
> > we just had btree_writepages() always write out the active bg first then
> > the rest. I don't know if we could fully delete the EBUSY, though, maybe
> > there is some racy case where it would still happen a bit, even if
> > mostly it didn't?
> 
> I got a v2 with your comments (and Sashiko's) addressed. I can look into
> that as well, but that feels a bit more involved and we're seeing random
> hangs in our CI system due to these stalled folios and we have one report on
> the list because of the hole -EAGAIN, so I'd like to get it (hot-)fixed
> possibly in this cycle and take care about that once the hotfix is there.
> 
> How does that sound?
> 

100% fine to fix without going crazy removing EBUSY or whatever. Sorry
for holding you up on that, I just found the problem interesting.

All else being equal, I would *prefer* to not have the eb submit loop
totally duplicated even in the short term fix. But again, OK with
whatever you need to land to unbreak things.

Thanks,
Boris
