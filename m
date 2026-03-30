Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2639713777E
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 03:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774840029; cv=none; b=bl1KigOwPNkYT8IvTvsOOemIqYmVp77Tom++7DhsC194qGfuOhwnakWGNNCjFUH5DPB8O0Eqj9/a5UaN4C1HVRQ5Hr6NFibCPgZij80KiVMDa5YPrrv4jGyhlxbrfnzJ+IoQL82Awe2IfD0aGuEpxrj8OgSagKaRcREq7cssxnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774840029; c=relaxed/simple;
	bh=UalHkVycX+NXGkiL0MweP9opAxL7gDSEqcLiRlLhSqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYzuWhKAn84EFGmbNr/7IsIeTGgKx9D/IQ9UOunEl6YOxcmBDqN5411RSNjuT7URseUqC71vMbyfL4LC7liAIF/AL6eD8xBplYlJf4YLfBbiEmjGE9ZTKbYtlZY5MokE14cejgSbWveUhEj0y7KsyTtIEMr9QaCYB3SC0lHlB7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XDyvwwml; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XDyvwwml"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774840026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UalHkVycX+NXGkiL0MweP9opAxL7gDSEqcLiRlLhSqM=;
	b=XDyvwwmlZfGPBfumFMNR2CVyXrjtyNVgJFVMtJnq3L0aFHSuQh+LuuUZN2TDg03dwa8Exm
	1Tdez0OnntjgvTkKHubNbH9ehZlReMkFpLHO3+TDcG2oliblem1NJnlEGABA32ODhbc0C/
	SQ2D9YKkJ70TxxnDFRDoH2ohboq3yLY=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 04/10] fs: remove nr_thps from struct address_space
Date: Mon, 30 Mar 2026 11:06:42 +0800
Message-Id: <20260330030642.46972-1-lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-5-ziy@nvidia.com>
References: <20260327014255.2058916-5-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Thu, Mar 26, 2026 at 09:42:49PM -0400, Zi Yan wrote:
>filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
>is no longer needed. Remove it.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>
