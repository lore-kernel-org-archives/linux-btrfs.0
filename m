Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E7A318EF0;
	Mon, 18 May 2026 22:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142878; cv=none; b=Z3I64lcv72c7Oq5uBpeHHIM2TmIVSdRzDyVQ9cDT9RQSj/QpDDQy50iuPLMX3mjDAjD4gcm5jHf0128lHGP+HV8inOSGrPHFZUcwggpEzSRPMDREC2goTX3TRVzRz14RBS13hPJl8Sr9J77rzOtiFqzCCJoxKPCRXGgHPeXWwzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142878; c=relaxed/simple;
	bh=CvHCd07/S3yhsVmuLEx0Das9gEcbosbXvIlvUM5YHeY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fvwLtXN/xXHyOmhBF9XHD8TpYXndLfICzyVHhDhoB9C3bUrssjMs4/7PDWhaIJ8GA5Cc11tT3jDDyZKX94am2dwwH1JtDT8RLE1RLDIGGcTVp39YNhzpUg4g3BiVljVHVBYvAPStfLakvg/eC7KrVqHq9a+BjRIQMiYQTXfS6t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LPOBTh+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LPOBTh+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2C8C2BCB7;
	Mon, 18 May 2026 22:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142877;
	bh=CvHCd07/S3yhsVmuLEx0Das9gEcbosbXvIlvUM5YHeY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LPOBTh+XmQ0iQXW5b+ZMakHisn/tcxyMDY7KiUbYiwAFMdlR/PUwsr15dJ+bjHqia
	 57tyfnpBGHCBy5CSE5qlDVzOJkNzoMfcA20++p3PbNNSUGnbwnxBCYexjmFErmideA
	 JuzfRDIdKVZr3V0U8yQms5Bo0BH4hzvIu2QEZNCc=
Date: Mon, 18 May 2026 15:21:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Luiz Capitulino
 <luizcap@redhat.com>, Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Liam Howlett <liam@infradead.org>, Mark Brown
 <broonie@kernel.org>, Peter Xu <peterx@redhat.com>, Li Wang
 <li.wang@linux.dev>, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v6 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
 file THP for writable files
Message-Id: <20260518152116.840e926e9992d47c9b3e33c3@linux-foundation.org>
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 17 May 2026 09:54:02 -0400 Zi Yan <ziy@nvidia.com> wrote:

> Hi all,
> 
> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> file-backed THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default, including for writable files.

Cool.  Sashiko wasn't able to apply this (presumably because of Mike's
CI-friendly series).  I take it that the AI review from v5
(https://sashiko.dev/#/patchset/20260429152924.727124-1-ziy@nvidia.com)
was considered?

Also, please check that the below were considered:

https://lore.kernel.org/e9e61132-902a-445f-9c4c-4d405d164e70@kernel.org
https://lore.kernel.org/22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org
https://lore.kernel.org/959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org
https://lore.kernel.org/1895A67C-BB1F-49EA-ADC3-AA4F51A6ED57@nvidia.com

https://lore.kernel.org/20260508074643.55548-1-lance.yang@linux.dev
https://lore.kernel.org/b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org


> is an in-place replacement of V5 in mm-new. It affects Mike Rapoport's
> "make MM selftests more CI friendly", since "selftests/mm: khugepaged:
> use kselftest framework" needs to be updated. I updated it and put it at
> the end of this cover letter.

Helpful, thanks.  It was a little complicated because your email client
messes with whitespace (it always has!), but I figured it out.

> Changelog
> ===
> >From V5[6]:
> 1. added mapping_min_folio_order(mapping) <= PMD_ORDER check to
>    mapping_pmd_folio_support() in Patch 1 to correctly handle
>    filesystems whose minimum folio order exceeds PMD_ORDER. Also
>    improved the kernel-doc comment per David's suggestions.
> 
> 2. cleaned up Patch 11 per David's review: use const for open_opt and
>    mmap_prot, remove mmap_opt (use MAP_SHARED for both read-only and
>    read-write mappings), inline file_fault_common() into separate
>    file_fault_read() and file_fault_write() functions, fix "read only"
>    typo to "read-only", update usage message to "with PMD-sized large
>    folio support". Also fixed run_vmtests.sh to use elif test_selected
>    thp for the SKIP case to avoid spurious [SKIP] output per Nico's
>    report.
> 
> 3. revised stale comment in Patch 13: removed "There won't be new dirty
>    pages" and updated "khugepaged only works on read-only fd" to reflect
>    that writable files are now supported; merged the comment blocks per
>    David's suggestion.
> 

Here's how v6 altered mm.git:


 include/linux/pagemap.h                 |   12 +++----
 mm/khugepaged.c                         |   18 ++++-------
 tools/testing/selftests/mm/khugepaged.c |   35 ++++++++--------------
 3 files changed, 26 insertions(+), 39 deletions(-)

--- a/include/linux/pagemap.h~b
+++ a/include/linux/pagemap.h
@@ -514,15 +514,15 @@ static inline bool mapping_large_folio_s
 }
 
 /**
- * mapping_pmd_folio_support() - Check if a mapping support PMD-sized folio
+ * mapping_pmd_folio_support() - Check if a mapping supports PMD-sized folio
  * @mapping: The address_space
  *
- * Some file supports large folio but does not support as large as PMD order.
- * If a PMD-sized pagecache folio is attempted to be created on a filesystem,
- * this check needs to be performed first.
+ * While some mappings support large folios, they might not support PMD-sized
+ * folios. This function checks whether a mapping supports PMD-sized folios.
+ * For example, khugepaged needs this information before attempting to
+ * collapsing THPs.
  *
- * Return: true - PMD-sized folio is supported, false - PMD-sized folio is not
- * supported.
+ * Return: True if PMD-sized folios are supported, otherwise false.
  */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -2342,23 +2342,19 @@ static enum scan_result collapse_file(st
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
-				 * been flushed since first write. There
-				 * won't be new dirty pages.
+				 * been flushed since first write.
 				 *
-				 * Trigger async flush here and hope the
-				 * writeback is done when khugepaged
-				 * revisits this page.
+				 * Trigger async flush for read-only files and
+				 * hope the writeback is done when khugepaged
+				 * revisits this page. Writable files can have
+				 * their folios dirty at any time; blindly
+				 * flushing them would cause undesirable
+				 * system-wide writeback.
 				 *
 				 * This is a one-off situation. We are not
 				 * forcing writeback in loop.
 				 */
 				xas_unlock_irq(&xas);
-				/*
-				 * Only flush for read-only files. Writable
-				 * files can have their folios dirty at any
-				 * time; blindly flushing them would cause
-				 * undesirable system-wide writeback.
-				 */
 				if (!inode_is_open_for_write(mapping->host))
 					filemap_flush(mapping);
 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
--- a/tools/testing/selftests/mm/khugepaged.c~b
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -376,12 +376,11 @@ static bool anon_check_huge(void *addr,
 
 static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
+	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
+	const int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
 	int fd;
 	void *p;
 	unsigned long size;
-	int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
-	int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
-	int mmap_opt = setup == FILE_SETUP_READ_ONLY_FS ? MAP_PRIVATE : MAP_SHARED;
 
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
@@ -414,7 +413,7 @@ static void *file_setup_area_common(int
 	success("OK");
 
 	printf("Opening %s %s for collapse...", finfo.path,
-	       setup == FILE_SETUP_READ_ONLY_FS ? "read only" :
+	       setup == FILE_SETUP_READ_ONLY_FS ? "read-only" :
 	       setup == FILE_SETUP_READ_WRITE_FS_READ_DATA ?
 						  "read-write (read)" :
 						  "read-write (write)");
@@ -423,8 +422,7 @@ static void *file_setup_area_common(int
 		perror("open()");
 		exit(EXIT_FAILURE);
 	}
-	p = mmap(BASE_ADDR, size, mmap_prot,
-		 mmap_opt, finfo.fd, 0);
+	p = mmap(BASE_ADDR, size, mmap_prot, MAP_SHARED, finfo.fd, 0);
 	if (p == MAP_FAILED || p != BASE_ADDR) {
 		perror("mmap()");
 		exit(EXIT_FAILURE);
@@ -458,27 +456,17 @@ static void file_cleanup_area(void *p, u
 	unlink(finfo.path);
 }
 
-static void file_fault_common(void *p, unsigned long start, unsigned long end,
-		int madv_ops)
+static void file_fault_read(void *p, unsigned long start, unsigned long end)
 {
-	if (madvise(((char *)p) + start, end - start, madv_ops)) {
-		if (madv_ops == MADV_POPULATE_READ)
-			perror("madvise(MADV_POPULATE_READ");
-		else if (madv_ops == MADV_POPULATE_WRITE)
-			perror("madvise(MADV_POPULATE_WRITE");
+	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
+		perror("madvise(MADV_POPULATE_READ)");
 		exit(EXIT_FAILURE);
 	}
 }
 
-static void file_fault_read(void *p, unsigned long start, unsigned long end)
-{
-	file_fault_common(p, start, end, MADV_POPULATE_READ);
-}
-
 static void file_fault_read_and_flush(void *p, unsigned long start, unsigned long end)
 {
-	file_fault_common(p, start, end, MADV_POPULATE_READ);
-
+	file_fault_read(p, start, end);
 	/*
 	 * make folio clean, since dirty folios from read&write file are
 	 * rejected and not flushed
@@ -488,7 +476,10 @@ static void file_fault_read_and_flush(vo
 
 static void file_fault_write(void *p, unsigned long start, unsigned long end)
 {
-	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
+	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_WRITE)) {
+		perror("madvise(MADV_POPULATE_WRITE)");
+		exit(EXIT_FAILURE);
+	}
 }
 
 static bool file_check_huge(void *addr, int nr_hpages)
@@ -1191,7 +1182,7 @@ static void usage(void)
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
-	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");
+	fprintf(stderr,	"\twith PMD-sized large folio support\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
 	fprintf(stderr,	"\n\tSupported Options:\n");
_

