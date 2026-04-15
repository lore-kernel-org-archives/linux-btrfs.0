Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEE930EF6C;
	Wed, 15 Apr 2026 09:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244928; cv=none; b=K+OaBEpGKEv7JkhLOCfJbluqtRLu+nXuVQ0UCDE17S/Y1v/GmMSd0KP2dlD1VQdf5MzMUH6MkDWon99l+hx70uhGqKoKLIbNTevuO8ivTytULL7lXUP/m2YZN2vTxNrb6sb3UkTG6EtzunZO11hinx4uGVM9BEyxiZ3/PiuqfW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244928; c=relaxed/simple;
	bh=jSXUuO7MB0ozSTHA0qbNnvDU+pBKa0kbvrLqzmCTy3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQ3wmj4TWQMMD9ZE76bOojdeU0SOCsvrHrWZXQKTFrI0N+x5Dr4x6QHlbaioYFXMr0KSc55V0uTKA8QU5A93prjA25R9OnjY2Tgfqiwp4Ixzr+gPZ2+9fGUKo0SuiJkOxsYjaBNbBnztObD26IXO7bWq/l45h9MwXtZgYJF9rBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KG1zE8Ix; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KG1zE8Ix"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776244921; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=k50XcOiZunNGbhAMmY/+OGWwibmB7NY3ZE/wH+AVnkA=;
	b=KG1zE8Ix/+6YPKirWQJuwrYwdCLHIk1PEZafvAvrp2aCheunNxIFWvlQT1r9xCNAcOoC7nioQo5ldJxxlxweRB24yO0br3Y8O1ZhajwPBH38sh7TrJ48FoZULrOVzIzlY2uOpWdR+bnIrErOULipp6fcGQVNPVgnUJtKDCh3lJ4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X14F.Ps_1776244917;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X14F.Ps_1776244917 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 17:21:58 +0800
Message-ID: <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
Date: Wed, 15 Apr 2026 17:21:57 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
 <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
> On 4/15/26 08:36, Baolin Wang wrote:
>>
>>
>> On 4/15/26 2:25 AM, Zi Yan wrote:
>>> On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:
>>>
>>>>
>>>> Yeah, it would be better if we could avoid it. But the dependency on the
>>>> global toggle as it is today is a bit weird.
>>>>
>>>>
>>>> I don't think there is other interaction with FS and the global toggle
>>>> besides this and the one you are adjusting, right?
>>>>
>>
>> I'm afraid not. Please also consider the per-size mTHP interfaces. It's
>> possible that hugepage_global_enabled() returns false, but
>> hugepages-2048kB/enabled is set to "always", which would still allow
>> khugepaged to collapse folios.

My comments are in reply to Zi’s comment:

"I think hugepage_global_enabled() should be enough to decide whether 
khugepaged should run or not. "

I’m concerned that only relying on hugepage_global_enabled() to decide 
whether khugepaged should run would cause a regression for anonymous and 
shmem memory collapse, as it ignores per-size mTHP configuration.

> The question is really which semantics we want.
> 
> Right now, there is no way to disable khugepaged for anon pages, to just
> get them during page faults.

Right.

> And we are now talking about the same problem for FS: to only get them
> during page faults (like we did so far without CONFIG_READ_ONLY_THP_FOR_FS).

OK. I’m fine with using hugepage_global_enabled() to determine whether 
khugepaged scans file folios.

My concern is that for anonymous memory and shmem, the per-size mTHP 
settings should be considered.
