Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5581C3B19AC;
	Mon, 23 Mar 2026 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275089; cv=none; b=FXAcDkEhBwKLQefmoWZDHHnBn980CpuAqGQ0C70EusTlStd+OYLNTr7i4Da9pCQ0QeEY5lBlIKhnH85pH66ZeW2LnQBvMeL/IV1aM+tHjs3xjbeiV/gGG04LJ2+6RVW1K0UpTZx+thCNp6RF5T0mR5n5mDtXw4hOHv1NCgpx2Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275089; c=relaxed/simple;
	bh=0+CZ6ku7umQV9JD+LWSWo22te4Wf6f5NpXO6DvOaRKM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=FhwXikti5kYhXgrr9djujvMgaJVlE4AS2GpfQjgK5laKnXjmcISJrFh57qhlwotd8fbRn3s1rLjrQPYtB1Ryntqy1Po7+bdg3Pv3BZso8C1k1EfuqoXYsDksb4mwC6grkc92ldgi5GhpGewnORWRpZgbQ5adrWsIGCv7f8xmybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZV8iAnp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZV8iAnp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60E4C2BC9E;
	Mon, 23 Mar 2026 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774275089;
	bh=0+CZ6ku7umQV9JD+LWSWo22te4Wf6f5NpXO6DvOaRKM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=ZV8iAnp2q8LQP4eoryVZXUsTV5WFVtS3n2YQFYZ2Lfw+1JEhm3VdiZKxaexWiEamA
	 /DLEv5daEKPFE1OqJkBEySZX/BwZjp1buCFNOhT+7FukMvHBivMgP4GwhC1SXumib+
	 NDe03Pn4adVnJwnGLBuqeZ+crAC46kWLyLG3QjUA5Ks5X6RTbujozV4wgm7E9ywFxG
	 Zp7E+L8TcyzFjUjkQoZ4BVE1MiUxrCTb9UWWa+mR8eHS0+Ci5eAPUBbvF6H7gGl33J
	 SZBO2lBLAm2bsLyyawfJERPnJQp5jQ5LkWdRiyG36nfj2H/uLEHXdR/sJ3FJjTFFGq
	 pUzYqHzdghCzA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id DA857F40078;
	Mon, 23 Mar 2026 10:11:27 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 23 Mar 2026 10:11:27 -0400
X-ME-Sender: <xms:D0rBadsRqZsE1EeVbeZFSNtFEQZhJfjO9xJH1Vw4Qh4KuY_KYD0AXQ>
    <xme:D0rBaRQwemiIU8SoTSVhF15XDhjDo8IcMJA68LaCOsAyeDhcq_RHQq7cLcUhQ2RXQ
    UVhqlDbqwBTXR0yW2mooYWwzph9D9-EScv_yrrbVTNZlsvkpyKMJSze>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefudekledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfvehhuhgt
    khcunfgvvhgvrhdfuceotggvlheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhffekffeftdfgheeiveekudeuhfdvjedvfedvueduvdegleekgeetgfduhfefleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhutg
    hklhgvvhgvrhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeifeegleel
    leehledqfedvleekgeegvdefqdgtvghlpeepkhgvrhhnvghlrdhorhhgsehfrghsthhmrg
    hilhdrtghomhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehlvghithgrohesuggvsghirghnrdhorhhgpdhrtghpthhtohepjhhirghngh
    hshhgrnhhlrghisehgmhgrihhlrdgtohhmpdhrtghpthhtohepphhurhgrnhhjrgihsehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehtjheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthho
    pehkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdprhgtphhtthhopehrmhhikhgvhi
    esmhgvthgrrdgtohhmpdhrtghpthhtoheptghhuhgtkhdrlhgvvhgvrhesohhrrggtlhgv
    rdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:D0rBaWcHLCbnRNgOyVgaJfYZsLpRcBIfC4DXtKZM5-pjUVwh5lcjww>
    <xmx:D0rBaWtQx1mTtp-aDx2DkvT7srYIq8Hcewa8nkceV7yO8OIrZpwilQ>
    <xmx:D0rBaVhqq9EdGH4Ss3jvcn9szlcXvJh_NT1yVpfACmeGkCdSy0Q-UQ>
    <xmx:D0rBaWujUa56ZDElJ1ycxC9E-sxFqcsb9b_qbGTQyRlHIjgZaIFK0g>
    <xmx:D0rBaY-ZJnxhWBgya2DfdnEgc5T8xOZVEQOdGysyEHTS_t51z8N65xTI>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B0971780075; Mon, 23 Mar 2026 10:11:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AUmdj42xMw6V
Date: Mon, 23 Mar 2026 10:11:07 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Breno Leitao" <leitao@debian.org>, "Tejun Heo" <tj@kernel.org>,
 "Lai Jiangshan" <jiangshanlai@gmail.com>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, puranjay@kernel.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 "Michael van der Westhuizen" <rmikey@meta.com>, kernel-team@meta.com,
 "Chuck Lever" <chuck.lever@oracle.com>
Message-Id: <04af531d-d8a3-4fbb-993d-e1da2df62a03@app.fastmail.com>
In-Reply-To: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
Subject: Re: [PATCH v2 0/5] workqueue: Introduce a sharded cache affinity scope
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Mar 20, 2026, at 1:56 PM, Breno Leitao wrote:
> TL;DR: Some modern processors have many CPUs per LLC (L3 cache), and
> unbound workqueues using the default affinity (WQ_AFFN_CACHE) collapse
> to a single worker pool, causing heavy spinlock (pool->lock) contention.
> Create a new affinity (WQ_AFFN_CACHE_SHARD) that caps each pool at
> wq_cache_shard_size CPUs (default 8).
>
> Changes from RFC:
>
> * wq_cache_shard_size is in terms of cores (not vCPU). So,
>   wq_cache_shard_size=8 means the pool will have 8 cores and their siblings,
>   like 16 threads/CPUs if SMT=1

My concern about the "cores per shard" approach is that it
improves the default situation for moderately-sized machines
little or not at all.

A machine with one L3 and 10 cores will go from 1 UNBOUND
pool to only 2. For virtual machines commonly deployed as
cloud instances, which are 2, 4, or 8 core systems (up to
16 threads) there will still be significant contention for
UNBOUND workers.

IOW, if you want good scaling, human intervention (via a
boot command-line option) is still needed.


-- 
Chuck Lever
