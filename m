Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380312367D9;
	Fri,  8 May 2026 03:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778210601; cv=none; b=a2SQMCNHGufRZQT/Q2HSmU2tHqLnH72tPQEEoaRPT+aFuk+SN6fgD5IaH4UH341FQ35XR3murXP0o2Szgt7LBDVZ9ZMaezeNWwE6o0E69yYpDk3xU+TZCM5IIKbI70Jlzu6WL7idzI5L1XEwnNchHVF4mB8YpkijD9SGiNlhPbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778210601; c=relaxed/simple;
	bh=Eh/FGNLHBEzDwfvjLfBu7vuOLl6EgBouX/FSElG8v8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KL1Al9/Tc3PEvlTWYw55peN+/iT7apyVeePJH6o0v8HPG6R3LGYkL8urY+RsN152TokHbuuCldS+LIT9yzUcgyZ++LMwHFFCK8tnpL77hn0TpqIqxWUELQH034TEoFn9wZSvMEjSiSDBpNDxVzhUOMw2W2s3Evlr9EZLICfgTJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aLNfjoRb; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aLNfjoRb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778210588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wamRUvxjWlqEsV1JMZy9Va3V7zbfvaQwt51lgTFp7hg=;
	b=aLNfjoRbLy/9OdKerp4shVKvFDT3cB579XDdW6LZGs+NefsYE5jd7oumC3mDsweRauB5lj
	LoQ6mI57hKDtlXBt292fCUa1VEOR8cLHq3qrHr/xXvhszjg8JjvjuX01NI+nF9lUor63dp
	q+5thdb6fjyQQVBoHkEUuV34QCAJKXs=
From: Lance Yang <lance.yang@linux.dev>
To: richard.weiyang@gmail.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org
Cc: david@kernel.org,
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
Subject: Re: [PATCH v5 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Fri,  8 May 2026 11:22:53 +0800
Message-Id: <20260508032253.1659-1-lance.yang@linux.dev>
In-Reply-To: <20260508025239.ooz5kc5a3n372ebb@master>
References: <20260508025239.ooz5kc5a3n372ebb@master>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Fri, May 08, 2026 at 02:52:39AM +0000, Wei Yang wrote:
>On Wed, Apr 29, 2026 at 11:35:28AM -0400, Zi Yan wrote:
>>After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
>>khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
>>support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
>>so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
>>mapping->nr_thps, which its safe guard mechanism relies on.
>>
>>Signed-off-by: Zi Yan <ziy@nvidia.com>
>>Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>---
>> mm/Kconfig | 11 -----------
>> 1 file changed, 11 deletions(-)
>>
>>diff --git a/mm/Kconfig b/mm/Kconfig
>>index e221fa1dc54d0..27dc5b0139ba6 100644
>>--- a/mm/Kconfig
>>+++ b/mm/Kconfig
>>@@ -936,17 +936,6 @@ config THP_SWAP
>> 
>> 	  For selection by architectures with reasonable THP sizes.
>> 
>>-config READ_ONLY_THP_FOR_FS
>>-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
>>-	depends on TRANSPARENT_HUGEPAGE
>>-
>>-	help
>>-	  Allow khugepaged to put read-only file-backed pages in THP.
>>-
>>-	  This is marked experimental because it is a new feature. Write
>>-	  support of file THPs will be developed in the next few release
>>-	  cycles.
>>-
>
>Hi,
>
>I see hugepage_enabled() in khugepaged.c still use READ_ONLY_THP_FOR_FS.
>

Yes, I noticed that[1] as well. Maybe it was dropped by accident :)

[1] https://lore.kernel.org/linux-mm/20260507044938.12529-1-lance.yang@linux.dev/
