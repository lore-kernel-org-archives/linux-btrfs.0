Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC61837E2ED;
	Wed, 15 Apr 2026 06:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776235496; cv=none; b=CKK2VhHAcESnl7Zw6MAy6B0Y1fQEi8kxs/OOxK8BlKo0+Nx8j5vZP4ml1+ZMCmsSt3HAAz32bZyfl/zF6HzZGDX4HD9mPlzZ9gOa2eDA5FPnobJ+J0nVbfSZvIl0GQhVvdiMsC3ORpNJBRi7CwrQVXHQ1atcy3u4E86i1vRkEFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776235496; c=relaxed/simple;
	bh=lTuN1HCq53nkOc6/J239jMUgC/6r4jS0w6ftpPZbovQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUyPxTwpeKsLtJO7gJpVNBM+KZycfC3OjaF5w+ukiP3Kjbmr8uvot4Hr3bXOeXTLK0TWZbrA0zf5nbvlJaMj30A4qCJ4Kf6hAJyDz8YKweHT55yX0IvGLsR19eTPNRrZmXSCZXPe+cDUQiDPXf9MvJtlznGZSH/hHHOdDfq8Wvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=N422xTeH; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="N422xTeH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776235484; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5mOipye9evHPcrGtSUD74q7SjHPzzHhjUmf7hrymf/c=;
	b=N422xTeHYal6S3PCIk34PhYJBvo1kGd5rstSkScnG1jqv7a0djt7aMtitQ+RcUBRiSJbjlHsShAZmp2MqGdNZUXX7Nr9gKxTBR4hxOUoN5wun4NHnOt0D9AI9nZZYWmNwSSuzDhWtddpDI8RD9gl12v5tTcjpsl1MMSPr7LLh/g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13mSFc_1776235482;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13mSFc_1776235482 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:44:43 +0800
Message-ID: <3fb827a2-cdf4-4b2f-b501-737ba7140c8d@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:44:41 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 07/12] fs: remove nr_thps from struct address_space
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
 <20260413192030.3275825-8-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-8-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/14/26 3:20 AM, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
