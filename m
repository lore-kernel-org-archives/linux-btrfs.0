Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E901EB19B;
	Wed,  1 Apr 2026 20:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775075533; cv=none; b=nI7rqrN+Dony40ItERbWYEJSLP28VpBTRwUFb7hsgQtzQDYs91nQFHOKxvc+F0ThRpxyIYks9w1qhlagQwpmAJCUeEsXIJXiEbI4AdIKTuLqWQ5Pa/riRoSuD6uEmL7iimfERNjZfedalkt73uyMjCNxSyYkFrr9Sc7fJJEm9ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775075533; c=relaxed/simple;
	bh=nYW5g1VvC9kM7IdnhRH0cccs40ZcgKrVNoGr3sp/v00=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=cCvkT7Dx/4tm02XOohhC2Z9/XwKrRJ9XLYnivUA/KMj2FXYXgJpRUzEc5PfhOAKcgm45g9ukJeNt+y04W/4csoCS5y87pMySyVkrRCnAT+qGiImINbwIh3OubKBQLlThQMvG8J5AQaZJMNoOMFcV7VBi3Ol1sZu3BWyI5Gl/EZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVTaksi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVTaksi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C86C4CEF7;
	Wed,  1 Apr 2026 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775075533;
	bh=nYW5g1VvC9kM7IdnhRH0cccs40ZcgKrVNoGr3sp/v00=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KVTaksi5fPbboDT950vmqdBszxdhgA1A5brMOIXrcq+DLA1aoxyQMreJzZwEW0MqG
	 3nhpMieq2A/mc2uUYLlgY/+7VMyIvZsiaMIZ7vwGvwmEV5z7yX0iBVQFovBAQ6PGhl
	 yJPwqpTUI2IkbLk/Rch1U1f4rgQ1SsKv65FUUKMU8XXf4klia46gskOSSLMRoRTOdC
	 VPz8atsYBaHJN+6Fp7K628vhd0OP4t5p6UFMXSLhvduVKxDSpuR33rFWEhI343zDUb
	 tXrZf77V8xdz42teYi5bjG33ee29bRIyKOFVAW6t3SOVt+1MWcbwRyaS8WEGMWrjmQ
	 E5mb8Gzq4oT7g==
Date: Wed, 01 Apr 2026 10:32:12 -1000
Message-ID: <d689b6644895ab4ab0cec5e316db1022@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, puranjay@kernel.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Michael van der Westhuizen <rmikey@meta.com>,
 kernel-team@meta.com, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH v3 0/6] workqueue: Introduce a sharded cache affinity
 scope
In-Reply-To: <20260401-workqueue_sharded-v3-0-ab0b9336bf0b@debian.org>
References: <20260401-workqueue_sharded-v3-0-ab0b9336bf0b@debian.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

Hello,

Applied 1-6 to wq/for-7.1.

Thanks.

-- 
tejun
