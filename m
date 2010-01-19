From: Liuwenyi <qingshenlwy@gmail.com>
Subject: Re: [RFC INFO PATCH 02/03] export use_mm and unuse_mm for filesystem
 modules.
Date: Wed, 20 Jan 2010 07:37:55 +0800
Message-ID: <4B564253.20405@gmail.com>
References: <4B562B14.3050208@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B562B14.3050208@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Maybe, you should send this patch to

Andrew Morton <akpm@linux-foundation.org>
Andrea Arcangeli <aarcange@redhat.com>
Michael S. Tsirkin <mst@redhat.com>
linux-kernel@vger.kernel.org
linux-mm@kvack.org


=E4=BA=8E 2010=E5=B9=B401=E6=9C=8820=E6=97=A5 05:58, jim owens =E5=86=99=
=E9=81=93:
> required for btrfs directio worker threads.
>
> Signed-off-by: jim owens<jowens@hp.com>
> ---
> mm/mmu_context.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> index ded9081..daabf4d 100644
> --- a/mm/mmu_context.c
> +++ b/mm/mmu_context.c
> @@ -3,6 +3,7 @@
>   * See ../COPYING for licensing terms.
>   */
>
> +#include<linux/module.h>
> #include<linux/mm.h>
> #include<linux/mmu_context.h>
> #include<linux/sched.h>
> @@ -37,6 +38,7 @@ void use_mm(struct mm_struct *mm)
>      if (active_mm !=3D mm)
>          mmdrop(active_mm);
> }
> +EXPORT_SYMBOL_GPL(use_mm);
>
> /*
>   * unuse_mm
> @@ -56,3 +58,4 @@ void unuse_mm(struct mm_struct *mm)
>      enter_lazy_tlb(mm, tsk);
>      task_unlock(tsk);
> }
> +EXPORT_SYMBOL_GPL(unuse_mm);
>   =20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
