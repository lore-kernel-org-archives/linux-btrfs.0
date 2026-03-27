Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8163C5DB1
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 07:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774596950; cv=none; b=ZwgpRDoq9F9B9+VqjDUMsxdHdUJTw0Y5hhRxDGKHaGF48XeGtlrsZO2qsEcxeHdRqTOyUMDGUDMCIOT2XnlXZuzfose6r5iP+Fi9sKNwPgcqvDC1kwm2BNpq+Xj2YYN4RcVYH2kBl+OKvjrQeM/du7VXhMUPiUDlcHQc8NMXF9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774596950; c=relaxed/simple;
	bh=g0ipE0PBVCTrVu6c5/xg7DMuXRK2oxGYEdYsbEz89Ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N56SgJSlUT8/xLC+kSLPNrrBlfATrGL0zHXGre2YGJyF/F/bzC+WjP3KCp3WSUEvNwmlHkcc1eOhyw39qWhgL/juQzJwT2epwbq2mWd24kxk1CLkAfgYAnhk/Hr/WiqW3rFd586m6V6k6hokAZYCN6cqOLPG4lQ4+Vpmb5woifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=au5Ukkkl; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="au5Ukkkl"
Message-ID: <5d7c5690-eb85-454c-ac82-b4cefb4a37f8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774596941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CLtU4cYf5f4ETgIAG+QOLy27idZtqxL/V9it4mlnfGA=;
	b=au5UkkklscMhF8BiLUMaSWklas9uysoBQuuD5MOuqCv/qB8+OgduNHqgh+UFXezl/6xv8e
	nrmScX5uN68uU0+H2Lp8zA9iJXEHXLVXwfjo4Q/qfYQiWvb3lD4Jhn7CrTudxykmtmWUCR
	GGaKymYb+rmaEcH7ZaELVBlUH1Cafpo=
Date: Fri, 27 Mar 2026 15:35:16 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Content-Language: en-US
To: ziy@nvidia.com
Cc: willy@infradead.org, songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-3-ziy@nvidia.com>
 <20260327072917.68630-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260327072917.68630-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2026/3/27 15:29, Lance Yang wrote:
> 
> On Thu, Mar 26, 2026 at 09:42:47PM -0400, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>> huge option turned on also sets large folio order on mapping, so the check
>> also applies to shmem.
>>
>> While at it, replace VM_BUG_ON with returning failure values.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> mm/khugepaged.c | 7 +++++--
>> 1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d06d84219e1b..45b12ffb1550 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>> 	int nr_none = 0;
>> 	bool is_shmem = shmem_file(file);
>>
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>> +	/* "huge" shmem sets mapping folio order and passes the check below */
>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>> +		return SCAN_FAIL;
> 
> Yep, for shmem inodes, if the mount has huge= enabled, inode creation
> marks the mapping are large-folio capable:

Oops, s/are/as/

> 
> 	/* Don't consider 'deny' for emergencies and 'force' for testing */
> 	if (sbinfo->huge)
> 		mapping_set_large_folios(inode->i_mapping);
> 
> LGTM!
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

