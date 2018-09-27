Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BE4C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF77216FE
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OEIqtxU7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CF77216FE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbeI0Wns (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 18:43:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbeI0Wns (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Wby51G2NB9G7Kn3hCCXsZ0XQPL0e9eaX7u2kScMWcVQ=; b=OEIqtxU7Ezkw61T5Z/99++hgG
        vUvJEv4nT1kah2xME5EGse5H2r6vMg8mu5KQuyM63L0ZlCHfUcJnQxxorVhcw2ZLLOvbqAblhCxIJ
        VWsQMEpXITXltZjITvbiqa5It6YS1zm96keH4qlwSUaUA0E+IH1Rjhf8Z4V38DMSAs/OmTC8F3X58
        ER9FOiZUopyz41+BSQ71KZfZiGCNpc0vJ+ofRF3ewXo1rgvhJ/vGuPxCwKLQveH/ZiFQl9OjWqoBD
        Y6GHlUXobL7j1uYmHxDaRtohpdeuWwyldL1KLpKWghq0TFmmfzvqouvPtbEr9nyD6SVHSQNWFFzDQ
        JJEiGeHYA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g5Z5n-0006s5-9K; Thu, 27 Sep 2018 16:24:43 +0000
Date:   Thu, 27 Sep 2018 09:24:43 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, tj@kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, riel@redhat.com, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] mm: infrastructure for page fault page caching
Message-ID: <20180927162442.GC19006@bombadil.infradead.org>
References: <20180926210856.7895-1-josef@toxicpanda.com>
 <20180926210856.7895-2-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926210856.7895-2-josef@toxicpanda.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 05:08:48PM -0400, Josef Bacik wrote:
> We want to be able to cache the result of a previous loop of a page
> fault in the case that we use VM_FAULT_RETRY, so introduce
> handle_mm_fault_cacheable that will take a struct vm_fault directly, add
> a ->cached_page field to vm_fault, and add helpers to init/cleanup the
> struct vm_fault.
> 
> I've converted x86, other arch's can follow suit if they so wish, it's
> relatively straightforward.

Here's what I did back in January ... feel free to steal any of it if you
like it better.


diff --git a/mm/memory.c b/mm/memory.c
index 5eb3d2524bdc..403934297a3d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3977,36 +3977,28 @@ static int handle_pte_fault(struct vm_fault *vmf)
  * The mmap_sem may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
-static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
-		unsigned int flags)
+static int __handle_mm_fault(struct vm_fault *vmf)
 {
-	struct vm_fault vmf = {
-		.vma = vma,
-		.address = address & PAGE_MASK,
-		.flags = flags,
-		.pgoff = linear_page_index(vma, address),
-		.gfp_mask = __get_fault_gfp_mask(vma),
-	};
-	unsigned int dirty = flags & FAULT_FLAG_WRITE;
-	struct mm_struct *mm = vma->vm_mm;
+	unsigned int dirty = vmf->flags & FAULT_FLAG_WRITE;
+	struct mm_struct *mm = vmf->vma->vm_mm;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	int ret;
 
-	pgd = pgd_offset(mm, address);
-	p4d = p4d_alloc(mm, pgd, address);
+	pgd = pgd_offset(mm, vmf->address);
+	p4d = p4d_alloc(mm, pgd, vmf->address);
 	if (!p4d)
 		return VM_FAULT_OOM;
 
-	vmf.pud = pud_alloc(mm, p4d, address);
-	if (!vmf.pud)
+	vmf->pud = pud_alloc(mm, p4d, vmf->address);
+	if (!vmf->pud)
 		return VM_FAULT_OOM;
-	if (pud_none(*vmf.pud) && transparent_hugepage_enabled(vma)) {
-		ret = create_huge_pud(&vmf);
+	if (pud_none(*vmf->pud) && transparent_hugepage_enabled(vmf->vma)) {
+		ret = create_huge_pud(vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-		pud_t orig_pud = *vmf.pud;
+		pud_t orig_pud = *vmf->pud;
 
 		barrier();
 		if (pud_trans_huge(orig_pud) || pud_devmap(orig_pud)) {
@@ -4014,50 +4006,51 @@ static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 			/* NUMA case for anonymous PUDs would go here */
 
 			if (dirty && !pud_access_permitted(orig_pud, WRITE)) {
-				ret = wp_huge_pud(&vmf, orig_pud);
+				ret = wp_huge_pud(vmf, orig_pud);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
 			} else {
-				huge_pud_set_accessed(&vmf, orig_pud);
+				huge_pud_set_accessed(vmf, orig_pud);
 				return 0;
 			}
 		}
 	}
 
-	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
-	if (!vmf.pmd)
+	vmf->pmd = pmd_alloc(mm, vmf->pud, vmf->address);
+	if (!vmf->pmd)
 		return VM_FAULT_OOM;
-	if (pmd_none(*vmf.pmd) && transparent_hugepage_enabled(vma)) {
-		ret = create_huge_pmd(&vmf);
+	if (pmd_none(*vmf->pmd) && transparent_hugepage_enabled(vmf->vma)) {
+		ret = create_huge_pmd(vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-		pmd_t orig_pmd = *vmf.pmd;
+		pmd_t orig_pmd = *vmf->pmd;
 
 		barrier();
 		if (unlikely(is_swap_pmd(orig_pmd))) {
 			VM_BUG_ON(thp_migration_supported() &&
 					  !is_pmd_migration_entry(orig_pmd));
 			if (is_pmd_migration_entry(orig_pmd))
-				pmd_migration_entry_wait(mm, vmf.pmd);
+				pmd_migration_entry_wait(mm, vmf->pmd);
 			return 0;
 		}
 		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
-			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
-				return do_huge_pmd_numa_page(&vmf, orig_pmd);
+			if (pmd_protnone(orig_pmd) &&
+						vma_is_accessible(vmf->vma))
+				return do_huge_pmd_numa_page(vmf, orig_pmd);
 
 			if (dirty && !pmd_access_permitted(orig_pmd, WRITE)) {
-				ret = wp_huge_pmd(&vmf, orig_pmd);
+				ret = wp_huge_pmd(vmf, orig_pmd);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
 			} else {
-				huge_pmd_set_accessed(&vmf, orig_pmd);
+				huge_pmd_set_accessed(vmf, orig_pmd);
 				return 0;
 			}
 		}
 	}
 
-	return handle_pte_fault(&vmf);
+	return handle_pte_fault(vmf);
 }
 
 /*
@@ -4066,9 +4059,10 @@ static int __handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
  * The mmap_sem may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
-int handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
-		unsigned int flags)
+int vm_handle_fault(struct vm_fault *vmf)
 {
+	unsigned int flags = vmf->flags;
+	struct vm_area_struct *vma = vmf->vma;
 	int ret;
 
 	__set_current_state(TASK_RUNNING);
@@ -4092,9 +4086,9 @@ int handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 		mem_cgroup_oom_enable();
 
 	if (unlikely(is_vm_hugetlb_page(vma)))
-		ret = hugetlb_fault(vma->vm_mm, vma, address, flags);
+		ret = hugetlb_fault(vma->vm_mm, vma, vmf->address, flags);
 	else
-		ret = __handle_mm_fault(vma, address, flags);
+		ret = __handle_mm_fault(vmf);
 
 	if (flags & FAULT_FLAG_USER) {
 		mem_cgroup_oom_disable();
@@ -4110,6 +4104,26 @@ int handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 
 	return ret;
 }
+
+/*
+ * By the time we get here, we already hold the mm semaphore
+ *
+ * The mmap_sem may have been released depending on flags and our
+ * return value.  See filemap_fault() and __lock_page_or_retry().
+ */
+int handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
+		unsigned int flags)
+{
+	struct vm_fault vmf = {
+		.vma = vma,
+		.address = address & PAGE_MASK,
+		.flags = flags,
+		.pgoff = linear_page_index(vma, address),
+		.gfp_mask = __get_fault_gfp_mask(vma),
+	};
+
+	return vm_handle_fault(&vmf);
+}
 EXPORT_SYMBOL_GPL(handle_mm_fault);
 
 #ifndef __PAGETABLE_P4D_FOLDED
