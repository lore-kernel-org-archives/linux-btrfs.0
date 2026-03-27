Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD4E78F4A
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 09:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774604000; cv=none; b=b4LsqoURstF2rRM7by/QWCPWItsJL4oBoJleWK/n6tPX3+scwi/zOiblJaG7V9D/BsVOBRUtFSszpxw5q8TMwsr2/ul7QucVZh7McXQap7igGupZhyEqeYXUkonQv0Zc8ypCV5FVdhVgVnq/a16eA5YUhphjZ+QFJjEImgGdimY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774604000; c=relaxed/simple;
	bh=v3p8rhSFUQ2cdcKTAQ1HEiPQb+GhAfDZkyN3q7ICtqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JbfqUZ5oy5JID6Bd5IhXwnsARYesvobeL7sHZHUXgCesexfbvPeq5THNsIk+His7KPnatbQ3WW/hKFCV9D0mT2otLCU9K9zBeJi+vN1Lws5ghqFN6w/UkGv1OWeQ1g8rzF7tneELOVB8MdEOWOjtPxwLpbzdrKEVRHI2jPVVrP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D3qK82Ed; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D3qK82Ed"
Message-ID: <710a9152-83ac-4d5d-a74d-ef0653596bf8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774603986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Lpsur5mfhIYIdcGTVML/ZxkQ0VDgNhtSZ2tOFHDJTk=;
	b=D3qK82Edy8XhDc0vBrTeZETe7pTWZ1aqy26Q2CHBvfLW1hhtD8uA39WUpR7gwJC1eNy5dy
	vimnFAwMAPkSbf15e1ev92Fqrn1kRoilpUGR+8coKrQLDzApVrsvMagiHDz+3ULa71u6Pk
	tB/QHzmUxD9Vi+5nRiQpt+xefOW9a8k=
Date: Fri, 27 Mar 2026 17:32:40 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Song Liu
 <songliubraving@fb.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2026/3/27 09:42, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>
