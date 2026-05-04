Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716601DC9B3
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 04:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777867880; cv=none; b=EthJFfcmF59Iphqv/E0EmPHz+AVM9CgYO1jlj941tDwUtMSPmFtNZESockRb2ER7BzlEQ0rMlfk78KQhrWX+VSjtgi+FjWA0xg7L0qoJeLL5kCZXUS+WmcgeLlnQqG+Vx2nNls9fFniqHG17Vk7H07Vxmdcaw2DJFn403+VPEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777867880; c=relaxed/simple;
	bh=ALLpA1Spli6gEIvD2eBig7ozCGKkYWm7GRvHWMn4OJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P7zv426+iSp/gAdc4rxsAMWTwOhxIAIL9M0LrB28WeyQbVBF3CCW6nEFSbl43SMXYeHLx5pWz4IJ5yU9Fd9ynITH7Q0VO7U0cByR/pDezjoAnrkNd00ARadDXw7th/Ep4WJeSWpFvL+yAImvO1uNRV37NxTO+aBeOEeMVkIgyMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDk5odQF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sDOeSp2y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDk5odQF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sDOeSp2y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777867878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pu1MzcUI/l6Cm0rp2QFR6z3D/O2HWrrKP5PFPjdVM80=;
	b=cDk5odQFvyvKHGBt2sp8352TmCDoGENN+yb1fObvwXMqBQZOzNM8vYmwYuqF6UOHEqKDpE
	O/MeRaS6s3fAhygRwupZM0T9+ineNrvbw7DoRQmXvjGpW4QwQoxwrmox7W9rtsFe+9zA6A
	S1X6gfvjGNE5pdl9TqOrP2tQisT3y80=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-K4-zX3LRM7qgTxsZdR8QUQ-1; Mon, 04 May 2026 00:11:15 -0400
X-MC-Unique: K4-zX3LRM7qgTxsZdR8QUQ-1
X-Mimecast-MFC-AGG-ID: K4-zX3LRM7qgTxsZdR8QUQ_1777867875
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7bd9c8d6de1so974917b3.2
        for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 21:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777867875; x=1778472675; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pu1MzcUI/l6Cm0rp2QFR6z3D/O2HWrrKP5PFPjdVM80=;
        b=sDOeSp2y89ZUmkjVAg2qFmiPL7vgVeZe2wERf0/8fOrUEKvc95O03koS0hUGWicz07
         cOPmsVZyb3DIaTUKgsnWk7+T0IiuNEfJ9zmDnHlC4vXvGk1xudNDRJlCcB8rKoc8VVkk
         1mx7o6nME5XkOryjZK6S8E0ZomybNTFR16PuVPaud6Sb0MyqDT1KBf+KKG6FvJYsuhLG
         LsCOIPrRUUW4J2wqdhgQ64GUKBdCGa41Cz6gfL+gFWtDjirtIydfu71e4HR+l4dgNGjd
         rrv8HwNEJ9HeswovDGW1CsGDaLomgw7zHz+Vfa3eCWZtPAmSRIzMkJ/fzX2FvDFnFvgV
         FZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777867875; x=1778472675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pu1MzcUI/l6Cm0rp2QFR6z3D/O2HWrrKP5PFPjdVM80=;
        b=Hy8ApYBH66hTzblShVb3ttexjGsafFzBLG0fADfp26RCotO5ySfXmNVL6z4UfPsSt+
         kNF8fXWUuiXr3A0bMSRPr9Bh3bBQ2AE7DXYr9d/OCBeKZou8R+/U3JBdmPq9tKgdOnRQ
         v2qasWqyj8drQMS5oYPZ0veQEp0vKseZaYn9emkkgsKRvWJW6OrWq1AS//UkwmVhLGPI
         XgCJfe0RbzVlno/VYtYO4gnAmfMFe65LUMyoMkEd6sdECATALuvNHuY9nl7hNVmluM0i
         5Bln3iu2cWPCNO9LZsKyONYe5/Dt7+ViUvuV8yopdjlnO3jaCAmkdCpyHK7bNA/xrokL
         f7lA==
X-Forwarded-Encrypted: i=1; AFNElJ+VfvSIwS6Mcx6Vy98adh/iN0gFES73p+x+C4FvIJHALUB12+4mqJGSL3lVVi+LSHtfSJL4CHx4JnO+gQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQCyECnL8oQHRcIiBLIrg9jjPZejn7bfyL75jCvz+nGrsZ5puJ
	f3no0tuS6J5/0Dy9b5NUs3i+3GPV4UYJx0oFQfE4H+VrSLLWFJxcJ2xmbrkf4zhK5wfDU6cYWOw
	3aikiSqQcc8Wm44Dp8e7C/p/Rqf8s7umxc9Msaqk6/yk7yi2NF0F6q8Jt0BTgi9l0
X-Gm-Gg: AeBDieunbYLQTk5sha4ruUv8dl4m5/cM/wBR28BVzWdrCE/G8ocsmxgIQrCZl3sDC3G
	0oLoZQgacZapc4RoyJZFiJo2b8WALjI91MTYXzkXP+UTSsLh3j9YVGbVUBem0ATrJDR9qpddmRs
	dSlCZAKCeFGRoVIpCuRZuTDwMxKILsXgZlLUt3r/QfdngZxQkB60+ljQdAJX1955vjTB5hpVDiY
	KWIAj4PzT12oDqqNB9wcpHrmRBVvOvUb7lhEMpBrRjE1+aS9d5GWT0R3D7Kk0EtvkJWCTH40pzL
	8dOWvV3YnSWKXGB/Kk+nzXQjQtm0P6QhJWFDSOAsAtnDb7F7cQAbpn3W0088oAJ9pXyMbuWTbSj
	Z+gB8GrwE2ksNETmX3FZhSa49ia2p6oLcBajKzUgcYxTvukuA8SB9JVu0tuk5xH8o9xg=
X-Received: by 2002:a05:690c:398:b0:7bd:8cd8:d6b6 with SMTP id 00721157ae682-7bd8cd8d855mr29092467b3.22.1777867874996;
        Sun, 03 May 2026 21:11:14 -0700 (PDT)
X-Received: by 2002:a05:690c:398:b0:7bd:8cd8:d6b6 with SMTP id 00721157ae682-7bd8cd8d855mr29092277b3.22.1777867874473;
        Sun, 03 May 2026 21:11:14 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6654e464sm44532247b3.14.2026.05.03.21.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 21:11:14 -0700 (PDT)
Message-ID: <1f3aedf7-9e48-4650-a7e2-5584c8b299c7@redhat.com>
Date: Sun, 3 May 2026 22:11:46 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/14] fs: remove nr_thps from struct address_space
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
 <20260429153538.727855-3-ziy@nvidia.com>
Content-Language: en-US
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429153538.727855-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/26 9:35 AM, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it. This shrinks struct address_space by 8
> bytes on 64-bit systems which may increase the number of inodes we can
> cache.

We've had performance impacts in the past by changing the alignment of 
certain structs. This is a rather critical one. Ill keep an eye out for 
any performance differences noted by our PerfQE team surrounding this 
feature.

LGTM!

Reviewed-by: Nico Pache <npache@redhat.com>

> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   fs/inode.c         | 3 ---
>   include/linux/fs.h | 5 -----
>   2 files changed, 8 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 6a3cbc7dcd28c..d8a6d6266c3c3 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -279,9 +279,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
>   	mapping->flags = 0;
>   	mapping->wb_err = 0;
>   	atomic_set(&mapping->i_mmap_writable, 0);
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	atomic_set(&mapping->nr_thps, 0);
> -#endif
>   	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
>   	mapping->writeback_index = 0;
>   	init_rwsem(&mapping->invalidate_lock);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfbb..bb9cc4f7207c1 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -460,7 +460,6 @@ struct mapping_metadata_bhs {
>    *   memory mappings.
>    * @gfp_mask: Memory allocation flags to use for allocating pages.
>    * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
> - * @nr_thps: Number of THPs in the pagecache (non-shmem only).
>    * @i_mmap: Tree of private and shared mappings.
>    * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
>    * @nrpages: Number of page entries, protected by the i_pages lock.
> @@ -476,10 +475,6 @@ struct address_space {
>   	struct rw_semaphore	invalidate_lock;
>   	gfp_t			gfp_mask;
>   	atomic_t		i_mmap_writable;
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	/* number of thp, only for non-shmem files */
> -	atomic_t		nr_thps;
> -#endif
>   	struct rb_root_cached	i_mmap;
>   	unsigned long		nrpages;
>   	pgoff_t			writeback_index;

