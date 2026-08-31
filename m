Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0621CD1E4
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 21:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788213320; cv=none; b=Xa57rs+/ljJITcF30RAeeGxy3N+PIAhWAcpOBK+fZmLqcnZqaJEYK0IER1ZA/iBUx1NBsOZ5WeY/Du5OrnV0jCu05ZkAjKbcJYB710YwO2vav49jXF3ay0chSUQZw/xwQfcNX8MBCVWYlttYUz5kZRZLxiMhDW1TwEUGn/Wl2tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788213320; c=relaxed/simple;
	bh=9DFnpwcHVbYTSvVOMBgcIie2m074yYCjUNNoxrNkZqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ppdPqhhINQmZfxhyk96u+2U8K5ptQEy1NxER0bLeJ4QLzBjA4jtaQGv6ta8MHWr0pkyiyqN93t2qiexyDK/jyOTMOkBSDKmm2P7dhiZY6frWY/fNLLtxLazqe+47RPy0WemsVp5E5IbQzyfATF4PHojTdPiCMutdHLdtSOEOTPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=OkRoei1S; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Nje5hjoc; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="OkRoei1S";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Nje5hjoc"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 894451400122;
	Mon, 31 Aug 2026 17:55:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 31 Aug 2026 17:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788213317; x=1788299717; bh=Z2pq8M+kcN
	E5ZdNN+RMVRU3H39GsAzcmRxHfCUMZv8I=; b=OkRoei1SJyb54gMf/ju1phAa8u
	3o3mCbNa+OScALgJ/oUMCaJ4Nx3W7W3TMUFd7qyiD4NEC8ib9vKQE923tCip3dtt
	PS9IULLHArHJLy/QBHNsmKpB7hasL43sIlEbkpZOz1hEJmCSLfWbO94W7rdoeTQG
	w9PGeGk9KCq22uI4z3Q+wXk8h8/oKKb8ucNkQdeaQiF/WlSA4jVMPDDmw27Rct4C
	evx5fSFTsp3+W13O4iBWE9QDv1MCok8Nl6+NxkkGygR4vYaTWmb5WawzXSocJdqT
	D2l9yuiJCxW/wEyv4aVgBVq+YK9KNjbSKbaoY23lZIZYSYygnzOegqpD1ELQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788213317; x=1788299717; bh=Z2pq8M+kcNE5ZdNN+RMVRU3H39GsAzcmRxH
	fCUMZv8I=; b=Nje5hjocUNHYwSmBmEHwl63n5jCU/yhScdeVF7E7qZK7ZX+pmRk
	SitRsNPdSoOFaDVF9u6CQnB1URgeBF4Ixn3T5NUOldOg7VE1/ERXz/tRpSV8Nq7/
	+njsy0M8rDm0eS5EFofeB9haU7+LGNKFTFkRY7ys+5whlvGfhWhTtGx6CY2Wuiyb
	AcvhP5fiEgZ5/QhErSNXnGUYHkVjS/k4CwfxwVy2s6QlJW0jtLdyEiz4t4yhcojt
	BqIac0DsQtsXPt0PlvMUrBAVW/I0bbi5+UMOhxKwlWEnVgHJBb807oR+0rwfoZaK
	5iwQroo7UniHrChQgXPFtqKU3k9ErlB4FGQ==
X-ME-Sender: <xms:RfiVaqy_SHfhXgtVj1-ejbKGDQAiaCnP3JHlZymz_hMG0_8lzmW3Yw>
    <xme:RfiVasTDUdnl0HwwetNglrYpmlJK9KdsYL2kNYdz9SQYTVf6UgumW4AHRNnJ6mG8H
    0HI5Fq7ik5g2VmqS2PXPXMd_0iX1Hi3sx1KgO0JYpCThmRujAEKxEE>
X-ME-Received: <xmr:RfiVap9oq6I91sLQAtz0s3xZM5R6bUwd-vvvyBUsuixNfY7it6sTnx2aV9yS4DfUgam1zWc1_RYIyUVE2XKRKWjo8GM>
X-ME-Proxy-Cause: dmFkZTGY2aRhju9KILhs76dSDw98LP9Wb5EnhzJiISrD/HV09CJqIrWC/7QutApiLmFF2B
    oZNAWYztgXTULVGxSv+cF02zqZUJrs0KFpbgQAv8Rp995tTfwNQ52bg3HW9Y5Hc2NRzJVR
    z0gY7D+HHRe5BAY1ygNnM3W2Wm/dQs8fgx0Q8alKlsYsIgbgomqE7pSBuUMTbrDhF+v7as
    Z8lU+e4GRCNW48hjSkvqQ85eW7EhWDlwyI3ZodVLopoPV5F1QSo+e6U3LTpN3bUIQTlVCu
    l2Mesu0p3m99eNO3GDgwo5xdmpqk3Ho/GhAoBv/n7ClBXSiVnN//Sj2tOMOn5vK1bXD1ng
    FzBgE5tjuSJC4YDGM82wq81Hw1vLYFPRdtAqvN5bWd3PXOmXv9DY2zAkPLW0dj8GJWY1Ma
    TADjUbX4UZtFjUd/X6GzzM0wB9sWHK0p5bED44ORDJ2invisYvvk+ry8MeLx+VQ48bEq3B
    wrmpkjF+jN/fxwp6lJ/MzXYbXb15fjVzlleINf65Il3IhDJUy19lRjS/QjOHA+Qjn4y3bw
    K3+wGA0uglrNjlV8XRkYh+3s5Zq6Tzj36CgN3Je/OuJqMrfuAAyfrWE09dwexuB2c8pXIf
    5O4pRZky1bUdykbLsWutfGQSV8LwkL+gPljZIlejUY1lNCxyFTprSUA7o5zw
X-ME-Proxy: <xmx:RfiVarquaL-lNZ3l4noL2pAbst1T5IoiAUD0imi0f6tZ2IxbdBcZGA>
    <xmx:RfiVaun-y9UvsNG8NNXn0kZdHmdn5lt2EBVeW1pZ1Muck2TrO0jObQ>
    <xmx:RfiVaqLKRPmNqO2SC7c3mFz0rxjP74pbXQ2EEl9jS-LCmu88ACRN9g>
    <xmx:RfiVaryFRBXeFK8bOTO1078FhLQiBoiOqu4HTQM0M12FtoDAvWFxWw>
    <xmx:RfiVaq_FXpOcup5awjZtSHQdcrWBdRFxYpFqFGKVijxUedvy25GFmlto>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 17:55:17 -0400 (EDT)
Date: Mon, 31 Aug 2026 14:54:37 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: qgroup: mark qgroup inconsistent for more
Message-ID: <20260831215437.GC325502@zen.localdomain>
References: <cover.1787812966.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787812966.git.wqu@suse.com>

On Thu, Aug 27, 2026 at 04:25:28PM +0930, Qu Wenruo wrote:
> Commit 011b46c30476 ("btrfs: skip subtree scan if it's too high to avoid
> low stall in btrfs_commit_transaction()") covers the most common case
> that can cause a long qgroup stall, where a large subtree is rescanned
> when dropping a snapshot.
> 
> But there are more corner cases for the same long qgroup stall:
> 
> - A qgroup rescan is queued immediately after marking inconsistent
>   The new rescan will immediately revert the NO_ACCOUNTING flag, thus
>   still results long qgroup stalls.
> 
> - A subvolume with no shared subtree
>   This can still queue a lot of workload into the current transaction.
> 
> This series covers both less-common cases.

Reviewed-by: Boris Burkov <boris@bur.io>

Thanks,
Boris

> 
> Qu Wenruo (2):
>   btrfs: reject new qgroup rescan during subvolume dropping
>   btrfs: avoid long stall when dropping a non-shared large subvolume
> 
>  fs/btrfs/disk-io.c     |  4 ++++
>  fs/btrfs/extent-tree.c | 11 +++++++++++
>  fs/btrfs/qgroup.c      | 29 ++++++++++++++++++++++++++++-
>  fs/btrfs/qgroup.h      | 15 +++++++++++++++
>  4 files changed, 58 insertions(+), 1 deletion(-)
> 
> -- 
> 2.55.0
> 
