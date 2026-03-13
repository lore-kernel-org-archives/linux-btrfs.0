Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E44A3C5532;
	Fri, 13 Mar 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773424641; cv=none; b=YeAhKjmtIxjOyjO0Elwt0cPVPKnlCD8AHPwGVqNEZuFAyzyIu5aP2sii5kBiVlh4jsNQmOSVJUepLX3dSxT13GcriV5L3rhVXucAGZIKQOMvVcbQmZnGGDK5Wbt0GKkxp/KWKDt842aTzKUIQamFd0COlF+bXjONPymwrH1mNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773424641; c=relaxed/simple;
	bh=SJ7kyq5/4Vl+xl4beLmS4hlIj/rrgmC7QP2y0GXI2TM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Wc9pSFxm8uoSi7uFAfkdxH0ASOkHFURcTw1C8LpQX5kVnga8vRvrpvkRUKYznecz1yOkD+/JJmdqXQEakna+Z3dvVTJlKWse1BMFfqaB6lRkuwkGTQR6kMflffLOScr4qvWfRdvw0ZERiFbs8N4nUIwfqMZqaitQodV+46BuRcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9RHZ5T8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9RHZ5T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA91C19425;
	Fri, 13 Mar 2026 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773424641;
	bh=SJ7kyq5/4Vl+xl4beLmS4hlIj/rrgmC7QP2y0GXI2TM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=s9RHZ5T8OzNsK7d6zhSrz1ggijzQ87ihASz1M5LoSgUhPcuus18a69GCCo3YVie66
	 8+YCtMBKfeDUmQ82DW4Hq0fCIEWA3Yu/LHokalHBSWbRwvKD8R3gMuc5gq0kaA8N9Q
	 LUb84+YxY5LAKK6jiXglQIldUWYqzgax4kq34OUc5AEsybF1CjpXtgoeNtC6M9Jyxi
	 Yt7zau6S+cOjreLoyvBxP6O662rWkcYv693i0t5zPwIAwnuAC/rqbaAZOi+OxXoYat
	 UhubaxuDApaKiD+08ofAp4ashvJs94nStTRJ/MQR/RtNAPiiSnKUudgQeqouUufwPV
	 tCiKAeFcrmkeQ==
Date: Fri, 13 Mar 2026 07:57:20 -1000
Message-ID: <6b952e7087c5fd8f040b692a92374871@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, puranjay@kernel.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Michael van der Westhuizen <rmikey@meta.com>,
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH RFC 0/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity
 scope
In-Reply-To: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

Hello,

Applied 1/5. Some comments on the rest:

- The sharding currently splits on CPU boundary, which can split SMT
  siblings across different pods. The worse performance on Intel compared
  to SMT scope may be indicating exactly this - HT siblings ending up in
  different pods. It'd be better to shard on core boundary so that SMT
  siblings always stay together.

- How was the default shard size of 8 picked? There's a tradeoff between
  the number of kworkers created and locality. Can you also report the
  number of kworkers for each configuration? And is there data on
  different shard sizes? It'd be useful to see how the numbers change
  across e.g. 4, 8, 16, 32.

- Can you also test on AMD machines? Their CCD topology (16 or 32
  threads per LLC) would be a good data point.

Thanks.

--
tejun
