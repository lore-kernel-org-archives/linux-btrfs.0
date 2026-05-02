Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF48215F42
	for <linux-btrfs@vger.kernel.org>; Sat,  2 May 2026 07:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777707377; cv=none; b=uPeKlFlcAfdSGzT94zq6uMfrRgcTAC5RptvTgEXZ3ZA1bC0mN8GTGdOufRKB6q2Faepm1A/KYCw4yFJGTrsexveC+olYugUCybcWcupvtFXI6f0acSXpZIkG+HnF1M2zIDAjV7bsK6tIaOeGip2mF5wyCZZAzJOkYr/JlvKoy20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777707377; c=relaxed/simple;
	bh=LB3YdO/YzGfFTDzhDTadSRLd4waSJdO1JnKewqeQBEI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NWQOqrTIRgselNSWXCgNat5U9etrghM2y0tYCAhoNqpRTABXoWM5YUq+RwQv9fl2Y3M+qc/P+188Q7i4PKCrdtQJI7J/AL3U4i1wE0oFk9tO7rcaVHNMkVCNip1/ghNgnerv3B0tRz09yOBgcqs5jgqi701lZE2TMZQXbUXLfBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca; spf=pass smtp.mailfrom=maxchernoff.ca; dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b=lhbWZavi; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b="lhbWZavi"
Message-ID: <5b2ff34a3dabf213c2a0058578ab73cafe36b16d.camel@maxchernoff.ca>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxchernoff.ca;
	s=key1; t=1777707372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uqoB99KE1jptE0SHr3XId2a0Y4uthBHTlPm8bdZiVmk=;
	b=lhbWZavi3ulTZHfXgpOAhwwYwdHqxQYjIRbAAdl4K2yrhtn0XKGSxZU681U8oIkjeMg+Qd
	Ak6SkVjLQrKRRBqA4DdmY2904BjOUu4ILk3bRhMgxPCOkYWIPK3RqQqDDdGlYlgGPh18h4
	J4tQqSt3wiSeFPc4CtwmEi+mS64HAFV4yCSXNdznUktyic1JzrxFARLqWugcWot43yYjyQ
	4YrEuBRABD1M5JQMX+JnoTK5oQTivcpxUctXkSFDqv6RPDpQMuH/XqYddH0LrImvp2JqXo
	Z8d2Muiqu+I2MiRnYty3Qr1FwOayjbjLAs7imr5xRbEV/u37X17GNrK36ytGBg==
Subject: Re: [PATCH] btrfs-progs: docs: update the qgroup performance hit
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Max Chernoff <git@maxchernoff.ca>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Date: Sat, 02 May 2026 01:36:08 -0600
In-Reply-To: <313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
References: 
	<313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT

Hi Qu,

On Fri, 2026-05-01 at 20:13 +0930, Qu Wenruo wrote:
> Although we have mentioned the qgroup performance hit, we have never
> explained how large the impact is.
>
> Update the documentation to:
>
> - Explain what affects qgroup performance
>   Including snapshots and reflinks.
>
> - Explain that the automatic rescan can cause performance problem
>
> - Add extra warning to avoid qgroup
>   If there are too many snapshots or reflinks.
>
> Reported-by: Max Chernoff <git@maxchernoff.ca>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM also, thanks for the fast patch.

Reviewed-by: Max Chernoff <git@maxchernoff.ca>

Would it maybe be worth adding something like the following?

    If quota support is absolutely required for a filesystem with many
    snapshots, then "simple quotas" (``squota``) should be preferred
    over "quota groups" (``qgroups``).

I've never used simple quotas myself, so I have no idea if that is
actually true, but the documentation suggests that that's the case at
least.

Thanks,
-- Max
