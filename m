Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC571F427C
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778124661; cv=none; b=i16Beg8hS432Gk3c9QKisMNGGzP5t/MNdKk8qqtesHgcfflsy40R/hdSR3ZKT6V13ejb+9Cz6Pd4CgUE0Gjk/yDmPt+kKi++nBidwKjDOY/9pEgOwbD1eryDH1jAksu/fximDGdackT2m1tidrD04LC4RAMQdZTRPcnVin55gEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778124661; c=relaxed/simple;
	bh=jqKPQiXpW98oldrpDjDj8FIZFTLmhrpfzebJ9KHHGwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Re896gD3rGkr32hmDfcK7tHOaBBMfkJzvyBaDCXX2k70CyaEuSjEtHiVyVEVJoW64U2qrI+eLGQD3cd8SEQ6TrkOG05mtF070Y4xiQlobgfu0MN67a4YQpciILwSbJmggPlpaLFXdiMjepFdo4iRYDD8hAWGKIYG1zmOfKPJGQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wKNe1+eN; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wKNe1+eN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778124646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyZVzRsxXhQaw+/BT2qurWH8p+SNTVYpiB+XsnLougQ=;
	b=wKNe1+eNgeqPd05y2iLWXfahEWECb2xBV6LFtMbhJ/SgQmjH9tQEUCZeFHpSXAQKhrRJOp
	Azr0VuQ3gyPGc04emwvgd4V9ks6rWAWm5Z/ewD5QSMupmexgbMlVW5cYJy3E1Q/wRixsWK
	2D2oc9njborSjMOUdqtqKxJWTK4j0aA=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com,
	ziy@nvidia.com
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
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu,  7 May 2026 11:29:56 +0800
Message-Id: <20260507032956.51667-1-lance.yang@linux.dev>
In-Reply-To: <aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redhat.com>
References: <aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redhat.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Sun, May 03, 2026 at 09:48:40PM -0600, Nico Pache wrote:
>
>
>On 4/29/26 9:29 AM, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>> 
>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>> 
>> Add a helper function mapping_pmd_folio_support() for FSes supporting large
>> folio with at least PMD_ORDER.
>> 
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>>   mm/khugepaged.c         | 10 ++++++++--
>>   2 files changed, 34 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 1f50991b43e3b..1fed3414fe9b8 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>>   	return mapping_max_folio_order(mapping) > 0;
>>   }
>>   
>> +/**
>> + * mapping_pmd_folio_support() - Check if a mapping support PMD-sized folio
>> + * @mapping: The address_space
>> + *
>> + * Some file supports large folio but does not support as large as PMD order.
>> + * If a PMD-sized pagecache folio is attempted to be created on a filesystem,
>> + * this check needs to be performed first.
>> + *
>> + * Return: true - PMD-sized folio is supported, false - PMD-sized folio is not
>> + * supported.
>> + */
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
>> +{
>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
>> +
>> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;
>
>Probably a stupid question, but I dont know FS thats well.
>
>Here we are checking that the max allowed folio order is greater than 
>(or eq) to the PMD_ORDER. Yet the function asks if PMD specifically is 
>supported. In the future could we have some FS that does not support PMD 
>orders, but does support larger orders (eg. PUD)?

Good point.

IIUC, mapping_max_folio_order() means "maximum supported order" not
"the only supported order", so mapping_pmd_folio_support() just means
"PMD order is within the supported range".

Also, mapping_set_large_folios() sets the range to:

mapping_set_folio_order_range(mapping, 0, MAX_PAGECACHE_ORDER);

and __filemap_get_folio_mpol() treats max as a cap, then falls back down
towards min.

That said, if we want the helper name to mean "PMD order specifically is
supported", the more future-proof test would be:

mapping_min_folio_order(mapping) <= PMD_ORDER &&
mapping_max_folio_order(mapping) >= PMD_ORDER

Thoughs?
