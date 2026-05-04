Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA8A222599
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 03:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777867026; cv=none; b=HfeiE5HAejsHvsMN0+m94M4QIKmrRMNtHAIHWIEmgnCjodwXpo0UfCIVSUaGowxe6R5caygxe2R4dHScnGLZC6aj9QMeA1y5z1nsgnsFoNPEGCf0/SHXPFs0ycVGtIiL4RGt5PE6eP/B+MubVHMKoT0IQb0UPPvpY7UCoJi4qPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777867026; c=relaxed/simple;
	bh=v/hn59alj5J7N2H22CfQHHEbWjJ2B0vjPYXnMKwqp/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R1dHtgRqmvsbQuqrr3h8ilcaXH0HynXlNfrnIgrP7hv9vqOjnxhzwTxNPZ2fxUToLqRDYydQRtmhAx8c8JHAxUNz8IlPELcnYD7Kj7Mw3prp2EJYSfpy8J2ZqO3kbadF/dqREfwgQMG1eZrIgbRqDOqqgklerKzQeiiGHjbbtDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UBSiXzWW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rueF3pkF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBSiXzWW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rueF3pkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777867023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qmtvy+Ja1TH//9Y34ehxEV0VvVTj9S6URXD/jFo8hZY=;
	b=UBSiXzWWm+BNmsCDCzUOhI0oWtyyxy2Xx9cSEgr52JUXOzVvnmThE6KffgcUKUkWpiiDw9
	Ep2lHQjVoSkfhyVGj/CXXX4uTPx/YvIZRJRU6ANwmEkQSqmUKu/d2J90kyM0cUiHO0FguX
	1nDOiK5hQvwkTzSJ/vl7MENTDXIWgNU=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-3ZYII55yNRqrfvcfbZakpw-1; Sun, 03 May 2026 23:57:02 -0400
X-MC-Unique: 3ZYII55yNRqrfvcfbZakpw-1
X-Mimecast-MFC-AGG-ID: 3ZYII55yNRqrfvcfbZakpw_1777867022
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7985951fa83so87027277b3.3
        for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 20:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777867022; x=1778471822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qmtvy+Ja1TH//9Y34ehxEV0VvVTj9S6URXD/jFo8hZY=;
        b=rueF3pkFqbS3nsu8xuz80AomRvD5fgM9mKSRzOvaXyTkou78HOMtP5EWb17uOWBk4O
         zdOFqut2TFH5sm/lIet67bkxog8hsTbXDWf2In4DU0nZCvcRceT5JrW868GtzyR3U3zT
         vtloQshGOM1ZBs/DkG+VyJjEq7zOERszvzU1UJPhvRmUw3xJMaJRItxb8el2Psjy59hn
         NDnAEv9FJL8s6pAT9QQmIezj1V5Si4GQQhklUIKrzZlh1NYlW4d/+ZzatHhA1mNN9xC4
         OfbjTLI+c0mVZkt9WWgNT1puEnL1EJTYHskEX/8qg6TfblQrrfY4Iros9zj1p6q/vcyr
         E/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777867022; x=1778471822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qmtvy+Ja1TH//9Y34ehxEV0VvVTj9S6URXD/jFo8hZY=;
        b=W1pTuMMfa9xT1SWXABYemv+z4FAcn+nZO7KFoxmutvD143MFhzil67cRPzLnkySw01
         k78ko0t9UqupIguEQUoeCCfL6wGVcXnnJn/k7uJo3SwKY2yWjtucRNC5vG6ILUOA2MD5
         ipdQ1ixO1NsAwlzPLytj/eFO/BPw4TgOsoF/QNnhJJtZNW15XDr613AKGTtXWQpeb8TI
         qaW68x0Zp85QWk8I2uwkIFMZGcRxnPJMWgmEhJyyytKAK2PHBsKqveVBTKIC7k7X+Gzk
         4YzP0VjPi1MeS4Ol50bNakAoDo9A99senAt5CNgwL8d3tcuzLiqipmkHhVV97CmRnw9k
         LPjg==
X-Forwarded-Encrypted: i=1; AFNElJ/g6zlW4urfnNfnbw4FlLxeMpIO5HRjQQDw13Il2ZNPlIgAo6t+629v0STAfbX5Q7HnHI8cO2676AScHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCIH2bpxJgwxSgBQXT0Kb6BdtPqsXfg/AN/+6XiSwrQw92Oind
	qKwLQuTbsxazJ7xxLZt6LK7BAtspUoXgFzJXTzCJzr3B8DGBheHOfUArUKbxODrKNG5wjJMoQDe
	WwpOlWVwrDFowpF+cyg+mXrUCNSSv3KcrClBxCvxlRU0ZO6S8/Kjhv5d5cppTCcAl
X-Gm-Gg: AeBDiesiU18YfpPahP1EKu8e0WlqUHBVT2RUs2Jc9tKHbW2yeOgF2Jwtphg1jacdLDo
	J8JA4HT4O0DOs4UjAzsnCgC060DzYP4n+kM7YDw1i5DnplNr5lTAQEjHAsQBnD9F8RpyYa9Mui0
	A2jcd/eWJopz8TGwDwndyRCveBk/PTAOof2vP8vh8ABRYAElIBn9IKhCJ6hiJyXYkulb7qNyS0P
	1viLClrRVYS8sB3GRKNnoPRUwuLzDukF3tQcHfCOnSJAc9KVfAXhwCysmYgEMa1fqQxU+mpEEgN
	kU/2UcpxtFnzXCtQxcsSjp8tyBogo1d6OdnjOh66yfMfJkkkLobRFORlp5e/c9ObyLpwjNrpaaj
	K6E0mzraSCMO8inFluKwMvFBK2waZwCljTGgbAk05DJKejv83kN0Z93Ia1F7+1NxIT90=
X-Received: by 2002:a05:690c:e094:b0:7b8:c19c:ee9a with SMTP id 00721157ae682-7bd770db6a4mr85526757b3.32.1777867021832;
        Sun, 03 May 2026 20:57:01 -0700 (PDT)
X-Received: by 2002:a05:690c:e094:b0:7b8:c19c:ee9a with SMTP id 00721157ae682-7bd770db6a4mr85526497b3.32.1777867021452;
        Sun, 03 May 2026 20:57:01 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6683aa8asm44078807b3.26.2026.05.03.20.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 20:57:01 -0700 (PDT)
Message-ID: <fae1d9c9-1d8c-416c-bb53-90ef11edbba9@redhat.com>
Date: Sun, 3 May 2026 21:57:33 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
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
 <20260429152924.727124-4-ziy@nvidia.com>
Content-Language: en-US
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429152924.727124-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/26 9:29 AM, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD folio is supported. Keep the inode open-for-write
> check, since even if collapse_file() now makes sure all to-be-collapsed
> folios are clean and the created PMD file THP can be handled by FSes
> properly, the filemap_flush() could perform undesirable write back.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2f3fcb4dd1ef8..3b324f03e9283 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>   {
>   	struct inode *inode;
>   
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>   	if (!vma->vm_file)
>   		return false;
>   
> @@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>   	if (IS_ANON_FILE(inode))
>   		return false;
>   
> +	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))

Other than my question in the previous patch about >= PMD_ORDER vs == 
PMD_ORDER.

LGTM

Reviewed-by: Nico Pache <npache@redhat.com>

> +		return false;
> +
>   	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>   }
>   

