Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F08200110
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 04:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777868588; cv=none; b=Ixo4+kB0vbbatg9wIxxTIpKpUTN7mj9P2v9AIcwpEhjh1z6JA5hI7RIH6/NWxFI+ZWCqhdi+Iw/Gkw+zxKpk24Ikvnz9YGqdeeTw8Utc6SMnj/leQcWZlmYC/kEneU9j5JKH8SBY+5HFRkDh4hCQd0eFplupyGaSGt05ZQP08qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777868588; c=relaxed/simple;
	bh=qknSGugrII9bBwZy0ZaspbP78N2eOYdkT8w6FkDgfnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U0FjPseoS0lmojqPev/dXnpXDHhdVgeulRRkNissfa42Kd+TTB7GpBuDmm48jq+MSG09jWUZpbDmBD769h9AB8FF4Oj575+dFtGGhiH7L+pDIrMteq1CtfW/EsIRw0aBWM/Xw1QjnhNa3379tvBD0kbHdZ6ryos/1sKZ85YqiVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DoPAFXR8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTzZT/HY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DoPAFXR8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTzZT/HY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777868584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8JUpxs4HHb5TNL47sn37+M30nm78WhRCS5Q6b7JSuI=;
	b=DoPAFXR8xWYFwZ4g2UnorqZSgf60zNoOSp0XV/szFB60I/TBzXmAUeEmFLJ84LMo/a6do6
	QaN+iqO5ITUkhk95JQSvNFZgLoPvYQ1u9kxCg/IQ8Kfhw8bYXzJVvluwGzC7etKFV9gzh1
	5umxOcHWzgW1UUfg3bFUr4es7y0Z8rk=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-_hHDq3TqMzatZtdzqfaWPg-1; Mon, 04 May 2026 00:23:03 -0400
X-MC-Unique: _hHDq3TqMzatZtdzqfaWPg-1
X-Mimecast-MFC-AGG-ID: _hHDq3TqMzatZtdzqfaWPg_1777868583
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7bd795b6288so21913427b3.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 21:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777868583; x=1778473383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U8JUpxs4HHb5TNL47sn37+M30nm78WhRCS5Q6b7JSuI=;
        b=KTzZT/HYanMIEWNdUw/q0C8g2zR4hO8znTLPO9zSjCHEhNQiEcttruvKq6Bpo474BN
         cxpLD4Sv1KyD4knDTnPNHdIkGpI8F+XzJuQD2hdu/7+33MHNWz4eVGUmB0ZH6+PLedVh
         ZgpTX9VGhVdr3Br0ErgWWBVa4odWvS8cmmimd+QdanIwRoFu1pjAh6Zf9idExw5etwZz
         iArvXVGjz6YEe0htch16HI40N/RnCO6qhkcXyrGzFewwnJU7znh0bOfetY+Le1dtEae2
         iEPwbkpIh3Jbc7W5F78q9yBq86QhLurjvgJYdp+3NSZphlW8Zqf9WGyQSnbLlTQ5fRwr
         ponQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777868583; x=1778473383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8JUpxs4HHb5TNL47sn37+M30nm78WhRCS5Q6b7JSuI=;
        b=QkX0WTj2GaFZLY9d/xjIVfggdbZxBZWaq2b+FjCS9vns50an0WLXdpUOnM0xbm46L9
         e1gf+qCf8E6UkX35tysfrQdEqP60zF4R1KjaPUISb4j84YeV95vTNVq+rSDWBbIQ4FF7
         ICQeLVw4BkRleXKZsQq8R2lOuYnGMGQ6kJV8NXxvYHlbdDZ0g+IGsOqdT7vBj2URrYey
         C9GNM2ImXK+B7Le04yczB+G5hcAe62wcB7x3GeF5C5Sb755nKDMDUcq1YPWBzQvo2LrE
         VPqoA7tT+ivoXK13BzqpRWVTfsgA5zZGR34S9fqM44x6qh581Ih272a/iqWKEXm9fB2a
         YhPA==
X-Forwarded-Encrypted: i=1; AFNElJ+vUYwTzIoyeRIDJiUeLhVgffCl7AhUw3BkEv6ehPzWFI/+/7ce9sR93m/vMXJYayC50VdlSG5TVWWkJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzP9pNGcowbu9nxK+aS52COuiH5LmRXhBEmWf0KlTNChmLo+n91
	KoovMoJyLzxuxT+ianEzsHncmaIWgsReo/ltAuwBPjxPKHQ3MZueRJu8j2x4mc9QANisIX75Mkr
	j5qlicL+5tdjI+jTqwlK0ShT3m9dnldeYqXn3IZVYxc84riBcu3AKhidcYB+bhG3/
X-Gm-Gg: AeBDiesWDbg9M3/2KTetYAfrF+FZeqqQtwdI3f8YX/oIYoUuw/1cJo42hN4XHLoKUWQ
	6qO/6bvhJ4nT+dRCcg/SpvyyOZno+AXJ1KyIU8gq1n/h48FKGnx0aXWQZqh4xCusJ5cz/6rezkO
	XO3sa9RLLIqUq19LJfo0R5dDsmxKWoXe7p1arP4SkzKUn35590nj+rWkWN6wIEjTEPHS0ajicSX
	DV36aBtdOaDHRLdKv4dVgssQ5mFWznqzJVK7KxAq1COIsRUCWtOSXTpLLqewgAvkd5axS7rs1hj
	Lanzv7Sr678qOhvzLECip5zhF8XZ1Dr41PPfjK1DApGNzHzpH83TBSt0t9U3ebeOaSV8ExPrP4A
	QEKln5WQ73YD5rJ8G0YgyA+szzEZVHAlwl8rDPpNb0J3ieJsegZKuY2BcorOJGANXK9o=
X-Received: by 2002:a05:690c:110:b0:7bd:77a7:8292 with SMTP id 00721157ae682-7bd77a78b77mr62285837b3.7.1777868582857;
        Sun, 03 May 2026 21:23:02 -0700 (PDT)
X-Received: by 2002:a05:690c:110:b0:7bd:77a7:8292 with SMTP id 00721157ae682-7bd77a78b77mr62285667b3.7.1777868582351;
        Sun, 03 May 2026 21:23:02 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6654e464sm44622987b3.14.2026.05.03.21.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 21:23:01 -0700 (PDT)
Message-ID: <52285e2c-af42-4c0d-9926-017f80b6614c@redhat.com>
Date: Sun, 3 May 2026 22:23:33 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
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
 <20260429153538.727855-7-ziy@nvidia.com>
Content-Language: en-US
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429153538.727855-7-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/26 9:35 AM, Zi Yan wrote:
> Change the requirement to a file system with large folio support and the
> supported order needs to include PMD_ORDER.
> 
> Also add tests of opening a file with read write permission and populating
> folios with writes. Reuse the XFS image from split_huge_page_test.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------
>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>   2 files changed, 102 insertions(+), 41 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index a6bb9d50363d2..80b913185c643 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -49,7 +49,8 @@ struct mem_ops {
>   	const char *name;
>   };
>   
> -static struct mem_ops *file_ops;
> +static struct mem_ops *read_only_file_ops;
> +static struct mem_ops *read_write_file_ops;
>   static struct mem_ops *anon_ops;
>   static struct mem_ops *shmem_ops;
>   
> @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>   static void save_settings(void)
>   {
>   	printf("Save THP and khugepaged settings...");
> -	if (file_ops && finfo.type == VMA_FILE)
> +	if ((read_only_file_ops || read_write_file_ops) &&
> +	    finfo.type == VMA_FILE)
>   		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>   	thp_save_settings();
>   
> @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_hpages)
>   	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>   }
>   
> -static void *file_setup_area(int nr_hpages)
> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>   {
>   	int fd;
>   	void *p;
>   	unsigned long size;
> +	int open_opt = read_only ? O_RDONLY : O_RDWR;
> +	int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
> +	int mmap_opt = read_only ? MAP_PRIVATE : MAP_SHARED;
>   
>   	unlink(finfo.path);  /* Cleanup from previous failed tests */
>   	printf("Creating %s for collapse%s...", finfo.path,
> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>   	munmap(p, size);
>   	success("OK");
>   
> -	printf("Opening %s read only for collapse...", finfo.path);
> -	finfo.fd = open(finfo.path, O_RDONLY, 777);
> +	printf("Opening %s %s for collapse...", finfo.path,
> +	       read_only ? "read only" : "read-write");
> +	finfo.fd = open(finfo.path, open_opt, 777);
>   	if (finfo.fd < 0) {
>   		perror("open()");
>   		exit(EXIT_FAILURE);
>   	}
> -	p = mmap(BASE_ADDR, size, PROT_READ,
> -		 MAP_PRIVATE, finfo.fd, 0);
> +	p = mmap(BASE_ADDR, size, mmap_prot,
> +		 mmap_opt, finfo.fd, 0);
>   	if (p == MAP_FAILED || p != BASE_ADDR) {
>   		perror("mmap()");
>   		exit(EXIT_FAILURE);
> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>   	return p;
>   }
>   
> +static void *file_setup_read_only_area(int nr_hpages)
> +{
> +	return file_setup_area_common(nr_hpages, /* read_only= */ true);
> +}
> +
> +static void *file_setup_read_write_area(int nr_hpages)
> +{
> +	return file_setup_area_common(nr_hpages, /* read_only= */ false);
> +}
> +
>   static void file_cleanup_area(void *p, unsigned long size)
>   {
>   	munmap(p, size);
> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned long size)
>   	unlink(finfo.path);
>   }
>   
> -static void file_fault(void *p, unsigned long start, unsigned long end)
> +static void file_fault_common(void *p, unsigned long start, unsigned long end,
> +		int madv_ops)
>   {
> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>   		perror("madvise(MADV_POPULATE_READ");
>   		exit(EXIT_FAILURE);
>   	}
>   }
>   
> +static void file_fault_read(void *p, unsigned long start, unsigned long end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_READ);
> +}
> +
> +static void file_fault_write(void *p, unsigned long start, unsigned long end)
> +{
> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
> +}
> +
>   static bool file_check_huge(void *addr, int nr_hpages)
>   {
>   	switch (finfo.type) {
> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops = {
>   	.name = "anon",
>   };
>   
> -static struct mem_ops __file_ops = {
> -	.setup_area = &file_setup_area,
> +static struct mem_ops __read_only_file_ops = {
> +	.setup_area = &file_setup_read_only_area,
>   	.cleanup_area = &file_cleanup_area,
> -	.fault = &file_fault,
> +	.fault = &file_fault_read,
> +	.check_huge = &file_check_huge,
> +	.name = "file",
> +};
> +
> +static struct mem_ops __read_write_file_ops = {
> +	.setup_area = &file_setup_read_write_area,
> +	.cleanup_area = &file_cleanup_area,
> +	.fault = &file_fault_write,
>   	.check_huge = &file_check_huge,
>   	.name = "file",
>   };
> @@ -504,6 +539,18 @@ static struct mem_ops __shmem_ops = {
>   	.name = "shmem",
>   };
>   
> +static bool is_tmpfs(struct mem_ops *ops)
> +{
> +	return (ops == &__read_only_file_ops ||
> +		ops == &__read_write_file_ops) &&
> +	       finfo.type == VMA_SHMEM;
> +}
> +
> +static bool is_anon(struct mem_ops *ops)
> +{
> +	return ops == &__anon_ops;
> +}
> +
>   static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>   			       struct mem_ops *ops, bool expect)
>   {
> @@ -512,6 +559,10 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>   
>   	printf("%s...", msg);
>   
> +	/* read&write file collapse always fail */

Just to confirm, you are adding the write part here so that before 
commit 13 & 14, the behavior is that it will fail. Whereas after with 
patch 13/14, we expect this behavior to be supported correct?

Thanks for working on this :)

I plan on testing the selftests changes at some point this week (if I 
find some downtime during LSFMM), and finishing my review here.

Cheers,
-- Nico


> +	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
> +		expect = false;
> +
>   	/*
>   	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
>   	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
> @@ -578,6 +629,10 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
>   static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>   				struct mem_ops *ops, bool expect)
>   {
> +	/* read&write file collapse always fail */
> +	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
> +		expect = false;
> +
>   	if (wait_for_scan(msg, p, nr_hpages, ops)) {
>   		if (expect)
>   			fail("Timeout");
> @@ -612,16 +667,6 @@ static struct collapse_context __madvise_context = {
>   	.name = "madvise",
>   };
>   
> -static bool is_tmpfs(struct mem_ops *ops)
> -{
> -	return ops == &__file_ops && finfo.type == VMA_SHMEM;
> -}
> -
> -static bool is_anon(struct mem_ops *ops)
> -{
> -	return ops == &__anon_ops;
> -}
> -
>   static void alloc_at_fault(void)
>   {
>   	struct thp_settings settings = *thp_current_settings();
> @@ -1097,8 +1142,8 @@ static void usage(void)
>   	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
>   	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
>   	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
> -	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
> -	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
> +	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
> +	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");
>   	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
>   	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
>   	fprintf(stderr,	"\n\tSupported Options:\n");
> @@ -1154,20 +1199,22 @@ static void parse_test_type(int argc, char **argv)
>   		usage();
>   
>   	if (!strcmp(buf, "all")) {
> -		file_ops =  &__file_ops;
> +		read_only_file_ops =  &__read_only_file_ops;
> +		read_write_file_ops =  &__read_write_file_ops;
>   		anon_ops = &__anon_ops;
>   		shmem_ops = &__shmem_ops;
>   	} else if (!strcmp(buf, "anon")) {
>   		anon_ops = &__anon_ops;
>   	} else if (!strcmp(buf, "file")) {
> -		file_ops =  &__file_ops;
> +		read_only_file_ops =  &__read_only_file_ops;
> +		read_write_file_ops =  &__read_write_file_ops;
>   	} else if (!strcmp(buf, "shmem")) {
>   		shmem_ops = &__shmem_ops;
>   	} else {
>   		usage();
>   	}
>   
> -	if (!file_ops)
> +	if (!read_only_file_ops && !read_write_file_ops)
>   		return;
>   
>   	if (argc != 2)
> @@ -1239,37 +1286,43 @@ int main(int argc, char **argv)
>   	} while (0)
>   
>   	TEST(collapse_full, khugepaged_context, anon_ops);
> -	TEST(collapse_full, khugepaged_context, file_ops);
> +	TEST(collapse_full, khugepaged_context, read_only_file_ops);
> +	TEST(collapse_full, khugepaged_context, read_write_file_ops);
>   	TEST(collapse_full, khugepaged_context, shmem_ops);
>   	TEST(collapse_full, madvise_context, anon_ops);
> -	TEST(collapse_full, madvise_context, file_ops);
> +	TEST(collapse_full, madvise_context, read_only_file_ops);
> +	TEST(collapse_full, madvise_context, read_write_file_ops);
>   	TEST(collapse_full, madvise_context, shmem_ops);
>   
>   	TEST(collapse_empty, khugepaged_context, anon_ops);
>   	TEST(collapse_empty, madvise_context, anon_ops);
>   
>   	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
> -	TEST(collapse_single_pte_entry, khugepaged_context, file_ops);
> +	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
> +	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_ops);
>   	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
>   	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
> -	TEST(collapse_single_pte_entry, madvise_context, file_ops);
> +	TEST(collapse_single_pte_entry, madvise_context, read_only_file_ops);
> +	TEST(collapse_single_pte_entry, madvise_context, read_write_file_ops);
>   	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
>   
>   	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
> -	TEST(collapse_max_ptes_none, khugepaged_context, file_ops);
> +	TEST(collapse_max_ptes_none, khugepaged_context, read_only_file_ops);
> +	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_ops);
>   	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
> -	TEST(collapse_max_ptes_none, madvise_context, file_ops);
> +	TEST(collapse_max_ptes_none, madvise_context, read_only_file_ops);
> +	TEST(collapse_max_ptes_none, madvise_context, read_write_file_ops);
>   
>   	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
> -	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
> +	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_only_file_ops);
>   	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
> -	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
> +	TEST(collapse_single_pte_entry_compound, madvise_context, read_only_file_ops);
>   
>   	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
> -	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
> +	TEST(collapse_full_of_compound, khugepaged_context, read_only_file_ops);
>   	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
>   	TEST(collapse_full_of_compound, madvise_context, anon_ops);
> -	TEST(collapse_full_of_compound, madvise_context, file_ops);
> +	TEST(collapse_full_of_compound, madvise_context, read_only_file_ops);
>   	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
>   
>   	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
> @@ -1291,10 +1344,10 @@ int main(int argc, char **argv)
>   	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
>   
>   	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
> -	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
> +	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
>   	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
>   
> -	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
> +	TEST(madvise_retracted_page_tables, madvise_context, read_only_file_ops);
>   	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
>   
>   	restore_settings(0);
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 3b61677fe9840..854c5c3e3a6ae 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -490,8 +490,6 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
>   
>   CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>   
> -CATEGORY="thp" run_test ./transhuge-stress -d 20
> -
>   # Try to create XFS if not provided
>   if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>       if [ "${HAVE_HUGEPAGES}" = "1" ]; then
> @@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>       fi
>   fi
>   
> +if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
> +CATEGORY="thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
> +else
> +	count_total=$(( count_total + 1 ))
> +	count_skip=$(( count_skip + 1 ))
> +	echo "[SKIP] ./khugepaged all:file" | tap_prefix
> +fi
> +
>   CATEGORY="thp" run_test ./split_huge_page_test ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
>   
>   if [ -n "${MOUNTED_XFS}" ]; then
> @@ -516,6 +522,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
>       rm -f ${XFS_IMG}
>   fi
>   
> +CATEGORY="thp" run_test ./transhuge-stress -d 20
> +
>   CATEGORY="thp" run_test ./folio_split_race_test
>   
>   CATEGORY="migration" run_test ./migration

