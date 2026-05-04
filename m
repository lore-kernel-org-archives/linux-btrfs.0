Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278891DE3B7
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 03:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777866810; cv=none; b=HBGumJ4WrC37p481vrkfb8R0OekDwBryayYj2eXfJslN6FzANk4zjC1mebp3eRPvIk3mwjNTgmw6NLMLCXqh13OwuiH0Z2haPSSMKifuhXd6IaR4Mtne84rsmCVTWrYuxRvDmz0D+tRGC/GaF6A4ibR1njtwplqnytxMP/vU4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777866810; c=relaxed/simple;
	bh=R0AUDzSWQxPWg+a126fEPwXl/Ajgx4AVi7lR7GVW0QY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZpsCV3ky70BfeqrvkW0cPTVwTtaOMuuIdJPiAUI3gFRb/CGrbWEKF6M6jkEHstXJLWg68YVH7m9I2K0Kifcbozd349YrCKQYlXgA8vSzM/vW6+nI73tkWP7wycFdy4Um7bX889/eI5kPgZxtX0UABy+rOm0lhADWTQKtTLK/9Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DggAExdJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jWo37643; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DggAExdJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWo37643"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777866808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nuwaC1QCoVaWPCWlh6YJVeUyAviJpTjgkGZ69+fjPic=;
	b=DggAExdJ9t/QzWWM4gwTcQqK9557AFouNO/DfqYftcycfZ4Dp6gVThzaghN1hK+YAVPRD0
	unu/NQAO80gPQi9wTUBhzaH9nuhL5Tx/dQ5jMk/EqfR2n47uZEvyagTJPo+vCxzO8tmX+J
	pAo1YZBQ714pb1pXxTg5S+H6Ah5fJek=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-bZKEd6eaOWKmhS9Ga_y1nA-1; Sun, 03 May 2026 23:53:27 -0400
X-MC-Unique: bZKEd6eaOWKmhS9Ga_y1nA-1
X-Mimecast-MFC-AGG-ID: bZKEd6eaOWKmhS9Ga_y1nA_1777866807
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6583252c117so5922536d50.2
        for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 20:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777866806; x=1778471606; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nuwaC1QCoVaWPCWlh6YJVeUyAviJpTjgkGZ69+fjPic=;
        b=jWo376438Jo7ccdSSjkHuLe0+b8Zg+79jUN3KTsof2DZiE1D0jCy4ayPclw3XTm6yN
         1iPsGcGZZ7XLfoYcOKNfFhYWyFit92pc3wcQIas5uSuxY5L5XVSkixvz+1Cr508dRirJ
         NLYCw7c0/L0Fb5uhj18wR0HSukfYhF3BqmQTE0oyQoURTM37tHLBkYqZs+sKwG9DsUCu
         CS8YFkD8BU1cu1KFImL+hqvwSmW1yO0nWeVWkvsDNkRet4e+h/rE/AANzLfWvXjQf+c/
         7vpCcc6fquUCIJtawZVtbfuVFJgl0Drt7/AjW6gVbWMFhy/AUzFQiESj5RZT/dO3J1za
         GY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777866806; x=1778471606;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuwaC1QCoVaWPCWlh6YJVeUyAviJpTjgkGZ69+fjPic=;
        b=VrIKdvJSzGuQ1VNOtF17WJ7sFY0GMBXMaGK/VBW+qkZ37SPCh/QqJT7kKKaXmVV1yd
         E8K9sCaZ9FUnAFUokO6f2Q7JPVi+Q7SMnNBpgjJsFVrZ7Jas3V3fMPFRbJNceNoWkJpD
         j3T+/l/x6WQ1FC7ECLarZHKJLrDyB/mc4KnRDFiVbVjvSR4xMdj0nGw29EVcL4IGHrkA
         25Wuab3e7NInreECUhlamsBZXlXDHRPRQScPCvLUCIrqthHTwoDtO6JWcAStScnxMJ/B
         OFG/lSHO3ZPLVHWS354qrs/sXLJHn6d9pBLmWa/HXPL9h0ofI19CGpfEpL37TL4BkzrB
         DE1g==
X-Forwarded-Encrypted: i=1; AFNElJ9kzAapmbPYnUvk9EHSsXKP5FW8HFJq4E/K3jbMlRcHhe5Uknd1helW1rd03U/4Toi7XdeqNcWkoFmnSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo0tqmzZyAqFVXB64fMfCjzkVQJ4wc2KAguo4ClocW3lpYwijS
	Q7PffY8ZH6b4Y0QkdPsDBm1nue70uIy/V5KHJjHzbaEsNDSicwdNs9TqjTUkbjG4PxYk8trL7o6
	+byVKM5rUcvVDiz7KJWcTO+ACVUmHZokWzUgelOUYpaMU9tDFyE3BNk3PxNqSRC7M
X-Gm-Gg: AeBDiesdVQZrIV6se+AUnBDAE28Bih1nBCnMZLQpF+pdCbowPXOJ+YEaWFZ1Z7o2kpv
	dMrbdvwlAG5yjFRkMqeiDA/C08CHo3T5a/EJmXpAsrRSVwPxbCNSAesC9xJ+xohwUAoUQHSDpgM
	9wxM9BlNRQs1wF5TSVR28PEnozz/eTGFS/9jYsT8DpKcgarq05YUnJTw47Nfo8BaICnLDzYI/qI
	jiPg/kpnkW/xFEBcjaD0t40MdejJbgh1FbHcR7DFZgzB/LV8wA1L8aE3P5ZD8SygcDP1I3eLKXp
	loYuz7Iem8mrqWbyYL3y1XieTwXf2y59jENBGdv7J3GWkKWdSLRbzHoehwMx296mXB7hLDuXLKz
	Rm5Ao/aiE9Le+z2sObA6H9d61Ax17xRs4FQSC3ZEA8ifaqk5r1AY92xmx8xksNysWbTI=
X-Received: by 2002:a05:690e:13cb:b0:651:be50:af09 with SMTP id 956f58d0204a3-65c3d96ca98mr7541984d50.3.1777866806640;
        Sun, 03 May 2026 20:53:26 -0700 (PDT)
X-Received: by 2002:a05:690e:13cb:b0:651:be50:af09 with SMTP id 956f58d0204a3-65c3d96ca98mr7541955d50.3.1777866806149;
        Sun, 03 May 2026 20:53:26 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65c2e8b2e55sm4980740d50.20.2026.05.03.20.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 20:53:25 -0700 (PDT)
Message-ID: <b3b5cfc6-e61f-4904-ad2a-dc1f53f04838@redhat.com>
Date: Sun, 3 May 2026 21:53:57 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/14] mm/khugepaged: add folio dirty check after
 try_to_unmap()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-3-ziy@nvidia.com>
Content-Language: en-US
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429152924.727124-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/26 9:29 AM, Zi Yan wrote:
> This check ensures the correctness of read-only PMD folio collapse
> after it is enabled for all FSes supporting PMD pagecache folios and
> replaces READ_ONLY_THP_FOR_FS.
> 
> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
> and inode->i_writecount to prevent any write to read-only to-be-collapsed
> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
> aforementioned mechanism will go away too. To ensure khugepaged functions
> as expected after the changes, skip if any folio is dirty after
> try_to_unmap(), since a dirty folio at that point means this read-only
> folio can get writes between try_to_unmap() and try_to_unmap_flush() via
> cached TLB entries and khugepaged does not support writable pagecache folio
> collapse yet.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM

Reviewed-by: Nico Pache <npache@redhat.com>

> ---
>   mm/khugepaged.c | 28 ++++++++++++++++++++++++----
>   1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6808f2b48d864..71209a72195ab 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   				}
>   			} else if (folio_test_dirty(folio)) {
>   				/*
> -				 * khugepaged only works on read-only fd,
> -				 * so this page is dirty because it hasn't
> +				 * This page is dirty because it hasn't
>   				 * been flushed since first write. There
>   				 * won't be new dirty pages.
>   				 *
> @@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   		if (!is_shmem && (folio_test_dirty(folio) ||
>   				  folio_test_writeback(folio))) {
>   			/*
> -			 * khugepaged only works on read-only fd, so this
> -			 * folio is dirty because it hasn't been flushed
> +			 * khugepaged only works on clean file-backed folios,
> +			 * so this folio is dirty because it hasn't been flushed
>   			 * since first write.
>   			 */
>   			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> @@ -2431,6 +2430,27 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   			goto out_unlock;
>   		}
>   
> +		/*
> +		 * At this point, the folio is locked and unmapped. If the PTE
> +		 * was dirty, try_to_unmap() has transferred the dirty bit to
> +		 * the folio and we must not collapse it into a clean
> +		 * file-backed folio.
> +		 *
> +		 * If the folio is clean here, no one can write it until we
> +		 * drop the folio lock. A write through a stale TLB entry came
> +		 * from a clean PTE and must fault because the PTE has been
> +		 * cleared; the fault path has to take the folio lock before
> +		 * installing a writable mapping. Buffered write paths also
> +		 * have to take the folio lock before modifying file contents
> +		 * without a mapping, typically via write_begin_get_folio().
> +		 */
> +		if (!is_shmem && folio_test_dirty(folio)) {
> +			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +			xas_unlock_irq(&xas);
> +			folio_putback_lru(folio);
> +			goto out_unlock;
> +		}
> +
>   		/*
>   		 * Accumulate the folios that are being collapsed.
>   		 */

