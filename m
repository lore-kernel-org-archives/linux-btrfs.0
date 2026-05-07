Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C8A2EAD0D;
	Thu,  7 May 2026 04:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778128223; cv=none; b=u+Rhoq+j+31/FFEQg3XMpYoQy5scN8/eIvTY92VVuRyTkEskqZUsg0ijsf0jrfTjj1v5puomGhMdF1cxcobr27988DTU1wQ5HHZNJaoJbHJZ4amL2XC0SK6sZIzTN9vN4DDB1OEyD/aU9OL0g2X4T5lv/vtnx7yAR4D1Cm4vpbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778128223; c=relaxed/simple;
	bh=WSQDx1aVKPjTjfW9+Z2g0z5Qu0eZ2gr6y7uhSWPGOrk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p4S0hiJpbM+rzov4SmopO6tuIl8KouGLmZfo6jEjj3bB3yc/VaIu8rQBB0Naw/J99BaujwgVViP2CA6//tBNCSMJhWFInhrLSvnosoHBRT6SjGp6Se7brouOzXRrNSamryZWuc+jMdQxSRFuuXbfDKR2lChj1tfJ2f5wH0hIJrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FgIWb9//; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FgIWb9//"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778128218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSQDx1aVKPjTjfW9+Z2g0z5Qu0eZ2gr6y7uhSWPGOrk=;
	b=FgIWb9//6CirMif9jMkRE2sFeDtubBFUKxL0Y3xet2wlqV5u2uYK3DW7vatHlJ5IwIDTRD
	Xrz8yfaC4Oo8qfmk7+ZMJIgtjnvlxLQyLf1w5tnFyBXRTvZcSd1yCfvmkdK6FE9dufNFTl
	mJHFO07KgJcE95/ao3OH6VdGkYz3kzI=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
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
Subject: Re: [PATCH v5 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Thu,  7 May 2026 12:29:58 +0800
Message-Id: <20260507042958.95301-1-lance.yang@linux.dev>
In-Reply-To: <20260429152924.727124-4-ziy@nvidia.com>
References: <20260429152924.727124-4-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Wed, Apr 29, 2026 at 11:29:13AM -0400, Zi Yan wrote:
>Replace it with a check on the max folio order of the file's address space
>mapping, making sure PMD folio is supported. Keep the inode open-for-write
>check, since even if collapse_file() now makes sure all to-be-collapsed
>folios are clean and the created PMD file THP can be handled by FSes
>properly, the filemap_flush() could perform undesirable write back.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>
