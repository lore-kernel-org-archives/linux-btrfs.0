Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EDCC64EB4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 09:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA8E20868
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 09:11:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oJ54QHBD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AA8E20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbeK3UUc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 15:20:32 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44191 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbeK3UUc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 15:20:32 -0500
Received: by mail-qk1-f193.google.com with SMTP id n12so2733367qkh.11;
        Fri, 30 Nov 2018 01:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xPgiQv76Tbaq5oCVyqFwL3566XE+B00LG3k/7dV9AcE=;
        b=oJ54QHBD9Fb+hY5WE/KT5Iq58+uCn5UJTPyrt515UH/P7qtAnJombyk707833+rnPY
         20/M5ZwHHzZGBfAtSVgXy1LSCjTaZkLIfLWcRJusQ+Bh9wGr+UMI6A6MLgTYaICkb17F
         QaGKIxYEPQRSDt8digwBzBVPNWmunOPXJbh0dfqt+RJZsfs/C4YbiAOFPb5DKb3XB2Ze
         qe6JEirblPlnsO17RROCPEJg6hkUbu726lvmObiakEtUqd2azKv85eRATTYRDFbNpFMb
         IS0rzpon0X+mydpT0yVc3I1sgWcIMCi+47NmAHT+T3pmX/vbEa8cV93bRq0p45wk6Nm7
         473Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xPgiQv76Tbaq5oCVyqFwL3566XE+B00LG3k/7dV9AcE=;
        b=LsTNhQ+mTCgvqTG7Al/HoaMP0CD9Hkr5ya0UL2kT1eMaQT3l/o1io+vTsEWSSlpv8I
         4f6mXlHje/HGFFYVCTlJHObb5k2W7MXIVn+owcTx3xdwpaYadXUA+fuWV4smVV0jJkEO
         DwbtzQ08n2xr/Yf590eGfE2I7dcMSI8fsPLoT0dJ/o1n0hU7MdeQL8BkxymdVRBMJHOE
         eZIBEARG5wPbYIQ93EE1ggiZG8twa0GjhxofxfzZLdG8GixRkC9i0q1SmeOAinvkkLYT
         RMTNpalw+POfl8O6GWYqPGGWbKQQRDnjwfef3ObA7LH1sKPjOWgQ22ONxaP599tdLrOp
         HuRw==
X-Gm-Message-State: AA+aEWY8lyBas8TIvoaNmgc+M+JGMPGFqw/Uhg1ebjmuv7qHouzGedvO
        Ar0GtCUV8fl8MthN0IYI7ocGYtEKcgyuXUlUBFw=
X-Google-Smtp-Source: AFSGD/WnhoE6N7sxX9mqDyLE/7V8TTL3chu/zMlu2b7iABiCnX1kGBRLaT9bEvafnDxyCsvqVyo7a60Nt1P22I3/Lmw=
X-Received: by 2002:a37:b2c2:: with SMTP id b185mr4420885qkf.194.1543569112384;
 Fri, 30 Nov 2018 01:11:52 -0800 (PST)
MIME-Version: 1.0
References: <20181129075301.29087-1-nborisov@suse.com> <20181129075301.29087-2-nborisov@suse.com>
In-Reply-To: <20181129075301.29087-2-nborisov@suse.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 30 Nov 2018 17:11:39 +0800
Message-ID: <CAAM7YA==GN5epC5BZYVmcXuyZp-reVi+_MdhDrgcOjnVwME6zA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: Don't open-code lru_to_page
To:     nborisov@suse.com
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>,
        josef@toxicpanda.com, David Sterba <dsterba@suse.com>,
        Zheng Yan <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, sfrench@samba.org,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        mark@fasheh.com, jlbec@evilplan.org, hubcap@omnibond.com,
        martin@omnibond.com, Andrew Morton <akpm@linux-foundation.org>,
        rppt@linux.vnet.ibm.com, willy@infradead.org,
        rdunlap@infradead.org, yuehaibing@huawei.com, shakeelb@google.com,
        dan.j.williams@intel.com, mhocko@suse.com,
        linux-afs@lists.infradead.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        devel@lists.orangefs.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 29, 2018 at 3:56 PM Nikolay Borisov <nborisov@suse.com> wrote:
>
> There are a bunch of filesystems which essentially open-code lru_to_page
> helper. Change them to using the helper. No functional changes.
>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>
> Since this is a mostly mechanical change I've actually batched all of them in
> a single patch.
>
>  fs/afs/file.c        | 5 +++--
>  fs/btrfs/extent_io.c | 2 +-
>  fs/ceph/addr.c       | 5 ++---
>  fs/cifs/file.c       | 3 ++-
>  fs/ext4/readpage.c   | 2 +-
>  fs/ocfs2/aops.c      | 3 ++-
>  fs/orangefs/inode.c  | 2 +-
>  mm/swap.c            | 2 +-
>  8 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index d6bc3f5d784b..323ae9912203 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -17,6 +17,7 @@
>  #include <linux/writeback.h>
>  #include <linux/gfp.h>
>  #include <linux/task_io_accounting_ops.h>
> +#include <linux/mm.h>
>  #include "internal.h"
>
>  static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
> @@ -441,7 +442,7 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
>         /* Count the number of contiguous pages at the front of the list.  Note
>          * that the list goes prev-wards rather than next-wards.
>          */
> -       first = list_entry(pages->prev, struct page, lru);
> +       first = lru_to_page(pages);
>         index = first->index + 1;
>         n = 1;
>         for (p = first->lru.prev; p != pages; p = p->prev) {
> @@ -473,7 +474,7 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
>          * page at the end of the file.
>          */
>         do {
> -               page = list_entry(pages->prev, struct page, lru);
> +               page = lru_to_page(pages);
>                 list_del(&page->lru);
>                 index = page->index;
>                 if (add_to_page_cache_lru(page, mapping, index,
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 19f4b8fd654f..8332c5f4b1c3 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4104,7 +4104,7 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
>         u64 prev_em_start = (u64)-1;
>
>         for (page_idx = 0; page_idx < nr_pages; page_idx++) {
> -               page = list_entry(pages->prev, struct page, lru);
> +               page = lru_to_page(pages);
>
>                 prefetchw(&page->flags);
>                 list_del(&page->lru);
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 8eade7a993c1..5d0c05e288cc 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -306,7 +306,7 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
>         struct ceph_osd_client *osdc =
>                 &ceph_inode_to_client(inode)->client->osdc;
>         struct ceph_inode_info *ci = ceph_inode(inode);
> -       struct page *page = list_entry(page_list->prev, struct page, lru);
> +       struct page *page = lru_to_page(page_list);
>         struct ceph_vino vino;
>         struct ceph_osd_request *req;
>         u64 off;
> @@ -333,8 +333,7 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
>                         if (got)
>                                 ceph_put_cap_refs(ci, got);
>                         while (!list_empty(page_list)) {
> -                               page = list_entry(page_list->prev,
> -                                                 struct page, lru);
> +                               page = lru_to_page(page_list);
>                                 list_del(&page->lru);
>                                 put_page(page);
>                         }

For the ceph patch

Acked-by:: "Yan, Zheng" <zyan@redhat.com

> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 74c33d5fafc8..b16a4d887d17 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -33,6 +33,7 @@
>  #include <linux/mount.h>
>  #include <linux/slab.h>
>  #include <linux/swap.h>
> +#include <linux/mm.h>
>  #include <asm/div64.h>
>  #include "cifsfs.h"
>  #include "cifspdu.h"
> @@ -3975,7 +3976,7 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
>
>         INIT_LIST_HEAD(tmplist);
>
> -       page = list_entry(page_list->prev, struct page, lru);
> +       page = lru_to_page(page_list);
>
>         /*
>          * Lock the page and put it in the cache. Since no one else
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index f461d75ac049..6aa282ee455a 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -128,7 +128,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
>
>                 prefetchw(&page->flags);
>                 if (pages) {
> -                       page = list_entry(pages->prev, struct page, lru);
> +                       page = lru_to_page(pages);
>                         list_del(&page->lru);
>                         if (add_to_page_cache_lru(page, mapping, page->index,
>                                   readahead_gfp_mask(mapping)))
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index eb1ce30412dc..832c1759a09a 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -30,6 +30,7 @@
>  #include <linux/quotaops.h>
>  #include <linux/blkdev.h>
>  #include <linux/uio.h>
> +#include <linux/mm.h>
>
>  #include <cluster/masklog.h>
>
> @@ -397,7 +398,7 @@ static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
>          * Check whether a remote node truncated this file - we just
>          * drop out in that case as it's not worth handling here.
>          */
> -       last = list_entry(pages->prev, struct page, lru);
> +       last = lru_to_page(pages);
>         start = (loff_t)last->index << PAGE_SHIFT;
>         if (start >= i_size_read(inode))
>                 goto out_unlock;
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index fe53381b26b1..f038235c64bd 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -77,7 +77,7 @@ static int orangefs_readpages(struct file *file,
>         for (page_idx = 0; page_idx < nr_pages; page_idx++) {
>                 struct page *page;
>
> -               page = list_entry(pages->prev, struct page, lru);
> +               page = lru_to_page(pages);
>                 list_del(&page->lru);
>                 if (!add_to_page_cache(page,
>                                        mapping,
> diff --git a/mm/swap.c b/mm/swap.c
> index aa483719922e..20b9e9d99652 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -126,7 +126,7 @@ void put_pages_list(struct list_head *pages)
>         while (!list_empty(pages)) {
>                 struct page *victim;
>
> -               victim = list_entry(pages->prev, struct page, lru);
> +               victim = lru_to_page(pages);
>                 list_del(&victim->lru);
>                 put_page(victim);
>         }
> --
> 2.17.1
>
