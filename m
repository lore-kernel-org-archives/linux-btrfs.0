Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6148B15746F;
	Mon, 20 Apr 2026 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776666717; cv=none; b=ZfmoTs1yw4uHb5QO0q6KTpgG/hatf5sQ5YYhUZCi7vw/954lZ+i3HA+Qlo6oygBZjFRXmKm99rQjeUaNjHKJX9xrIZmeXCmnl4KZ8la0O26BG3wAXtZiGC/34eMlYfzHSsrubOnOAICh6cSxv4SZS5pQSNZCPrc6TDE/5TKddpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776666717; c=relaxed/simple;
	bh=6xQihWuAN6X0vR6c7iGH60kQRSbU7gLnWjXt5CdwF4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f/+8eLM9sF3UTrklQLYlw9ywWJ8Xk04FZMZ03t36u7e/6v+oAZOgnIUBR/Yzdlj3+rS+wx5CYkchyNFErAEhneYwNnCqCNc7tntq2WtjmCUf8isgzwZ7Azok1JkzFSCH5s61YKZL4fdx+uvK6tTPb3iakMoY+tcWrBHrxiBQmI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ixvvzp3Q; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ixvvzp3Q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776666707; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Fl4jBlNrsLzHQOt9Xuwu05ZRkyi97MaFfuf5gBZ/Gy4=;
	b=ixvvzp3QD2U+5ew2BdEu2oLxz2167csNGMu9AKWvlYR0HAfyaR4PNrvJIyJ2vQDmPb852FOacMeFGRI3O+Eg+I7JoZX5DpOo6JSMvlslMi3DAEpfULqFOGlPALs5dHesiDbOYGTh0IMwpBQU2Qj5EJsXsiFTgIG0gyYRGu+sljg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1I6p8D_1776666704;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1I6p8D_1776666704 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 14:31:45 +0800
Message-ID: <6797d16b-5db9-4bbf-a7d9-314cd98ac95e@linux.alibaba.com>
Date: Mon, 20 Apr 2026 14:31:43 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-4-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/18/26 10:44 AM, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
