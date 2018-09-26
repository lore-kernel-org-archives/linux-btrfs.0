Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF4BC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 00:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8033214AB
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 00:22:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8033214AB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbeIZGc2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 02:32:28 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9491 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbeIZGc2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 02:32:28 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl6.internode.on.net with ESMTP; 26 Sep 2018 09:52:20 +0930
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g4xas-0006Sl-2p; Wed, 26 Sep 2018 10:22:18 +1000
Date:   Wed, 26 Sep 2018 10:22:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org, riel@redhat.com,
        hannes@cmpxchg.org, tj@kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: push vm_fault into the page fault handlers
Message-ID: <20180926002217.GA18567@dastard>
References: <20180925153011.15311-1-josef@toxicpanda.com>
 <20180925153011.15311-2-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925153011.15311-2-josef@toxicpanda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 25, 2018 at 11:30:04AM -0400, Josef Bacik wrote:
> In preparation for caching pages during filemap faults we need to push
> the struct vm_fault up a level into the arch page fault handlers, since
> they are the ones responsible for retrying if we unlock the mmap_sem.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  arch/alpha/mm/fault.c         |  4 ++-
>  arch/arc/mm/fault.c           |  2 ++
>  arch/arm/mm/fault.c           | 18 ++++++++-----
>  arch/arm64/mm/fault.c         | 18 +++++++------
>  arch/hexagon/mm/vm_fault.c    |  4 ++-
>  arch/ia64/mm/fault.c          |  4 ++-
>  arch/m68k/mm/fault.c          |  5 ++--
>  arch/microblaze/mm/fault.c    |  4 ++-
>  arch/mips/mm/fault.c          |  4 ++-
>  arch/nds32/mm/fault.c         |  5 ++--
>  arch/nios2/mm/fault.c         |  4 ++-
>  arch/openrisc/mm/fault.c      |  5 ++--
>  arch/parisc/mm/fault.c        |  5 ++--
>  arch/powerpc/mm/copro_fault.c |  4 ++-
>  arch/powerpc/mm/fault.c       |  4 ++-
>  arch/riscv/mm/fault.c         |  2 ++
>  arch/s390/mm/fault.c          |  4 ++-
>  arch/sh/mm/fault.c            |  4 ++-
>  arch/sparc/mm/fault_32.c      |  6 ++++-
>  arch/sparc/mm/fault_64.c      |  2 ++
>  arch/um/kernel/trap.c         |  4 ++-
>  arch/unicore32/mm/fault.c     | 17 +++++++-----
>  arch/x86/mm/fault.c           |  4 ++-
>  arch/xtensa/mm/fault.c        |  4 ++-
>  drivers/iommu/amd_iommu_v2.c  |  4 ++-
>  drivers/iommu/intel-svm.c     |  6 +++--
>  include/linux/mm.h            | 16 +++++++++---
>  mm/gup.c                      |  8 ++++--
>  mm/hmm.c                      |  4 ++-
>  mm/ksm.c                      | 10 ++++---
>  mm/memory.c                   | 61 +++++++++++++++++++++----------------------
>  31 files changed, 157 insertions(+), 89 deletions(-)
> 
> diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
> index d73dc473fbb9..3c98dfef03a9 100644
> --- a/arch/alpha/mm/fault.c
> +++ b/arch/alpha/mm/fault.c
> @@ -84,6 +84,7 @@ asmlinkage void
>  do_page_fault(unsigned long address, unsigned long mmcsr,
>  	      long cause, struct pt_regs *regs)
>  {
> +	struct vm_fault vmf = {};
>  	struct vm_area_struct * vma;
>  	struct mm_struct *mm = current->mm;
>  	const struct exception_table_entry *fixup;
> @@ -148,7 +149,8 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
>  	/* If for any reason at all we couldn't handle the fault,
>  	   make sure we exit gracefully rather than endlessly redo
>  	   the fault.  */
> -	fault = handle_mm_fault(vma, address, flags);
> +	vm_fault_init(&vmfs, vma, flags, address);
> +	fault = handle_mm_fault(&vmf);

Doesn't compile.

> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -225,17 +225,17 @@ static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
>  }
>  
>  static vm_fault_t __kprobes
> -__do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
> -		unsigned int flags, struct task_struct *tsk)
> +__do_page_fault(struct mm_struct *mm, struct vm_fault *vm, unsigned int fsr,

vm_fault is *vm....

> +		struct task_struct *tsk)
>  {
>  	struct vm_area_struct *vma;
>  	vm_fault_t fault;
>  
> -	vma = find_vma(mm, addr);
> +	vma = find_vma(mm, vmf->address);

So this doesn't compile.

>  
>  check_stack:
> -	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, addr))
> +	if (vma->vm_flags & VM_GROWSDOWN && !expand_stack(vma, vmf->address))
>  		goto good_area;
>  out:
>  	return fault;
> @@ -424,6 +424,7 @@ static bool is_el0_instruction_abort(unsigned int esr)
>  static int __kprobes do_page_fault(unsigned long addr, unsigned int esr,
>  				   struct pt_regs *regs)
>  {
> +	struct vm_fault vmf = {};
>  	struct task_struct *tsk;
>  	struct mm_struct *mm;
>  	struct siginfo si;
> @@ -493,7 +494,8 @@ static int __kprobes do_page_fault(unsigned long addr, unsigned int esr,
>  #endif
>  	}
>  
> -	fault = __do_page_fault(mm, addr, mm_flags, vm_flags, tsk);
> +	vm_fault_init(&vmf, NULL, addr, mm_flags);
> +	fault = __do_page_fault(mm, vmf, vm_flags, tsk);

I'm betting this doesn't compile, either.

/me stops looking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
