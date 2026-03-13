Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64D63CE4BD;
	Fri, 13 Mar 2026 17:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773423674; cv=none; b=PoAb0H9RyVngtzlEc4wtb+eL1zZ2HGUszgM863zkxb3o7EGSALQaGdn1iN5XrTijZ02lyExQeC67ytJIHWbKShZw6fOayjcZT5QRUWULyxSJN6S38L7oziCsXMlhFj+LSKjRb9Gj2l1zodViLgKK9YV0Pld9dChOhF9pQoWimjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773423674; c=relaxed/simple;
	bh=IXfSFyY6NzJ1cn+WUQH+w/sjieLNa7e6oS1eoJmxQ1k=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ksg5yHRatrvAKvOiIJB53WLcNjnMKmtxngIobduwmYlyXMHtNR1YpHkIBCfSj7Y2GPK+ANoAqeg1fq18iu9w/3iHfKvuY4bIKdgj4uk3O0SToPj1uK9DuaUZxOVsxRNNPWM72fZy50r9LSq6pBC8V3DNF8rAuFEd0U3qOX1946w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R36vKp3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R36vKp3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00688C19421;
	Fri, 13 Mar 2026 17:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773423674;
	bh=IXfSFyY6NzJ1cn+WUQH+w/sjieLNa7e6oS1eoJmxQ1k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=R36vKp3z913vJh/gmJbExl1mP0+qz4Pdwm+KUz8oeyslYIWS93fEqr6P9CkF8jE3t
	 5fBLFFC6jNCgd2wVDltGIywN/4+Y9oRnfbnA7LEG83dO+BzG7DquTnXf5hiIcichq3
	 vwvsfNUaKKKouQ7SwrEVOZ8YH0nPWj2KEWb1PDw8pXlNcnCsiEEDMMHx743Bf7mhM5
	 MSHMDjQrck6GPf4A+dEhUn5tzbWVS9QD3XvfFbIS2EX9gaW3DYgAK8XljPf9txE5Iy
	 mGK3WzU/eodkaAFV4NM8NiqFKz6zrViDGFUglAQDJTUAxLcrUuu/5jCJvJAhlIWPiI
	 mC0V39VxHjBXg==
Date: Fri, 13 Mar 2026 07:41:12 -1000
Message-ID: <2eef24999c6eeef8e8ea8daf54990e76@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, puranjay@kernel.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Michael van der Westhuizen <rmikey@meta.com>,
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH RFC 1/5] workqueue: fix parse_affn_scope() prefix
 matching bug
In-Reply-To: <20260312-workqueue_sharded-v1-1-2c43a7b861d0@debian.org>
References: <20260312-workqueue_sharded-v1-0-2c43a7b861d0@debian.org>
 <20260312-workqueue_sharded-v1-1-2c43a7b861d0@debian.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

Hello,

Applied to wq/for-7.1.

Thanks.

--
tejun
