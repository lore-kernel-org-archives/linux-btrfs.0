Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962BB3921C8;
	Wed, 15 Apr 2026 06:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776235654; cv=none; b=ngLGtEGe8oFNEF6J9WDZLkqcaX4gay6KeVZQ/FcYJUuBGWbTyLQNpCJEpPKpuleoO4iddodSYC0ojQe3ezjiwAZQhlZ4CbCSzRkA5R1qxWEVwpiap5F15Rgao6ZJesLspONDuTvSO3fPEFXsAqpOUTN6kTUeqhGcCjr/D0H09BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776235654; c=relaxed/simple;
	bh=Hk4nYJEU2RrRQYlFhoHaSwFVwxZOUlCA6odjAQKVGqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h+oEVP9/RHM+WglsRm+S1fmwnm8oSumNMjmRL4TNhzQjCGLAmlH3uBFGZpwkXyMQ1Yo3oxO1qabfuVZWB+tBPKYllfeYg/yarKVGT7/maSjErbzqUDQy87B9gKaNT8S4x/ReUcXiZEMdQJY3u9y11wUek8qbIp8wttLxj0ik1Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CRAwgA+D; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CRAwgA+D"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776235643; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3DQuf7+0kMfpKJ4/36jkKibmxFPSSLW8kPR0wcs9GMs=;
	b=CRAwgA+D6uo1M7V91aCCKF32+XngwOE9s7FOKM5z/f2zFyl1BM5uKjQ3OwqvQwSoVrJaILhMNuW5T8wUyV5TGf6cpkdq1IFBLV/eGmZYwVK6dghNqFqPC5HOMkC1Xli356xGXavu9TYnL/J0LcWLVV2vQmebh7123EJTOMPBLOY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13bM1d_1776235640;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13bM1d_1776235640 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:47:21 +0800
Message-ID: <ff491f4d-46b0-4463-9daf-7f89e2d1b638@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:47:20 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 08/12] mm/huge_memory: remove folio split check for
 READ_ONLY_THP_FOR_FS
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
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-9-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-9-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/14/26 3:20 AM, Zi Yan wrote:
> Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
> a FS without large folio support. The check is no longer needed.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
