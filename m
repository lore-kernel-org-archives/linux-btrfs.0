Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829763612E9;
	Tue, 24 Mar 2026 13:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774358157; cv=none; b=hPqUb9qgu/n6zguAADEyA20MP83iUEU0hHRAqKnbArtrskRXZpPFBQ6K5J7Kv654BXWjnxd7NSlNnoKmfHAu66MlGaUsQqz1CArtMwW4ZL5c6+O+WFel7cHA58c9ZZws8E7J5Gi/hIzCyClV/nW+wV0GRU7iRYt3pL/Ik0rgmdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774358157; c=relaxed/simple;
	bh=lZFKajMmRQ9M3RSSeVvnflgnt3r69qd9cZL+b/hFbb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPSW1mUn2xds+vYRLCX3qm7Ua879eXeQIjueqtcJsbRlln9xxxct90pM63D3m/0buLi5OC+i2QYMkA1r+U6pEeAT0TDWxdhksRaSNC+8+IGyBigOyHtrBnkpIV8b8GqO9TZsN9AKxHn4WNkLb5ku8ATudnT8t/jsCjP1+m8jkVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QnMYPf6l; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QnMYPf6l"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774358150; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/gTgQCP+5YBhbolPTDqqpYhG/7AEExmRx0uocLkbImg=;
	b=QnMYPf6lEjIktLFmrM64COUhEqdgXT6mZ5ss9TIjMoi2oW4Hj1VEdlFqVeuO+g2rp4m8LQNLE2ffIKUGgU4Xq25zX4eWJXgidnFDEX2+98BF7cR8zHxtBL10e/IMgrVclNMo4GKoBsmeYHZPzIlwRYSzWrmz88wVeVLdT1vOhH8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X.ehy5D_1774358147;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.ehy5D_1774358147 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 21:15:48 +0800
Message-ID: <33f09051-b5a2-4f40-8ea8-a7cade5019bf@linux.alibaba.com>
Date: Tue, 24 Mar 2026 21:15:47 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
 <acGqbeSjktT4biku@casper.infradead.org>
 <9648838a-ada7-4983-99e3-d694e803e06b@kernel.org>
 <EA39EF46-4331-43AB-8602-D0A73E9C9C9B@nvidia.com>
 <16117b49-d83d-4ceb-b85d-d117d6993ce1@kernel.org>
 <C3591451-D910-453F-980E-C12CC66D731E@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <C3591451-D910-453F-980E-C12CC66D731E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/24/26 8:12 AM, Zi Yan wrote:
> On 23 Mar 2026, at 17:21, David Hildenbrand (Arm) wrote:
> 
>> On 3/23/26 22:11, Zi Yan wrote:
>>> On 23 Mar 2026, at 17:05, David Hildenbrand (Arm) wrote:
>>>
>>>> On 3/23/26 22:02, Matthew Wilcox wrote:
>>>>>
>>>>> Not necessarily that lucky; if you set VM_HUGEPAGE,
>>>>> do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
>>>>> On busy database servers (and is there any other kind?), khugepaged
>>>>> takes too long to run and find opportunities to collapse text pages.
>>>>> Like, days.
>>>>
>>>> Yes, in particular given that the default khugepaged settings are awful.
>>>>
>>>>>
>>>>>
>>>>> I think the test needs to be:
>>>>>
>>>>> 	if (mapping_max_folio_order(mapping) >= PMD_ORDER)
>>>
>>> This is very helpful, since I was thinking about using
>>> mapping_large_folio_support().
>>>
>>>>>
>>>>> as there can be cases of filesystems which support up to, say, 64KiB,
>>>>> but not all the way up to 2MiB.  I disapprove of this situation, but
>>>>> this is where we are right now.
>>>>
>>>> Right, that's what I had in mind.
>>>
>>> Does Nico’s mTHP support for khugepaged include changes to collapse_file()?
>>> That might change the above test.
>>
>> At least not regarding adding support for other folio sizes. Baolin
>> (IIRC) had a version for shmem support, but that will come after Nico's
>> series was merged.

Right. Here is the link to the RFC version:

https://lore.kernel.org/all/cover.1755677674.git.baolin.wang@linux.alibaba.com/

Moreover, I have further updated my local tree based on Nico's series. I 
will send out the new version once his series is merged.
