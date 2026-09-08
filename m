Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A011936F433
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 05:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788846112; cv=pass; b=o6Bz/E/n+FRPkF1v06mFCl4Ji3XAJjXO9mE8mhy3nFVppXwm9JvWdh0oI4u9aV4qKm3AYEHYEi2ieRqZE2eztcBXQRHL5/ZuLxPrk68Je/nUZkJw6lbCv+eqMlsC2OsH1zL8rbysetHPoL4ArZil2G3CUNwo5BSsF4yzwDPrjYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788846112; c=relaxed/simple;
	bh=tAQXiHW4tuqTNNRHb/W/SBvcOKcGKIyjBTn0a/paM5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=muL46djOVr/g4JxGsc2kjGTUjAOdpFFAHt3WGJTdD5Z4Za9gSzJoQ0o1SC8zJOgHRJK7LswF4rnNsl2KtpTeR/Er1Fk3AsEsSsb8Yv9WMPd70Px/HQJduaegWbSfp2eMS9l8HGt9hrffozYiVCDfaenFzshQWnPsK2oJoqebV/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gd4v1rU1; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gd4v1rU1"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4843efcbdb2so2290910f8f.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 22:41:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788846109; cv=none;
        d=google.com; s=arc-20260327;
        b=k9WRmDhV/pxUYMUGtF7j5e08TSqSrsFioZJUe/y/V+g9wnXF4CZjkLVLiFOdsNKiF6
         mNjcCZ/yTQ4JCbQ+wYyjoQ2qSqMU5t5VsFfrnOx9kMR9KUR6INV4fo4mWZBJVoyBX5yM
         4p3mY6m/mCqZxIPe1quQSAXIg73paw86ol8w/0A23g+bkDLXeDNQcnof3qQViW8vqSxJ
         bkxfjAZdJxonPlyRvC2wXhhqTeDfRZudYZvmXErLIWyFxPByHihY2XyAxth2cgl67QeW
         +lBoaWWMsPKp7Vt/7an4hOls0SBMv7uesnp/Fkwb2Z8C8074TgXfNErTxpEXt0f7gVCo
         3eEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6oannQ40US+nr3+2s4vybLAaI7OejFK3omhtQDXAlf4=;
        fh=MeWjyQZycpzv3AqI0sSRFQG3jyOO7GknUrbVSe/gH48=;
        b=prUbSQtJrkcpaeLSXGdBiiYuThCPbyUcz74YNOTSCSEMrmlfGOYRGR1R8zcxUt5Gpq
         I3fHXU/ad/xdRJ/+YasHWXrjxYFVzjLpeXXxpJ8e9h0LW2GeHGxsm3h8XCDzYjQE0RaF
         1xuS/FAn8zXRbIv5VfzPgM9gnRIsVp8ly2G0RTt1IhMWWX4vxkUBrt6LNpYmIBYW4ZAl
         XdsdOlYLcvjbHnPzgKi2wOLL5EwQVQrfGbfCFuDJ7L9Ab+WsSizdXlD9HRI/cZFb213I
         29FLka09e58aIHj/u0FKt/kxgBZcPK7BoOKKOGwkuFlK6SjlwsN4soEVcEoSFoBRGwm2
         4JUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788846109; x=1789450909; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6oannQ40US+nr3+2s4vybLAaI7OejFK3omhtQDXAlf4=;
        b=gd4v1rU1rXB7mapmEHbQ5sRefcZoQJ5UAGeJJOzay194weXM/xi3sIkN14mqq261jz
         0bjuI4FutsExvadZ14iuf3n1RR0F6nzHuW6CvSkJryUQPHqStP3mYRjvs13KWo4Wx8UD
         gGNI3uhajO44rzNIkjoVxuJdMGO/grGCQqAG0Y/e1KY/c5sg2G3cWuQ3U2S8xpy89AmB
         ksL3YRBHU/gTRZj1HFZkyMMlroA8SAtJLeQsE69OwnQvS3pznAB6vwPgrgdq5AWKQFHw
         KXy1k8Cabx9QZ/CeKi8NRtSPARsK9rk/Ze+/AqNTxgEEXUnJMbilUNKZnH+Gz2EDr/wO
         QFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788846109; x=1789450909;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6oannQ40US+nr3+2s4vybLAaI7OejFK3omhtQDXAlf4=;
        b=sscAQx72mrI4OQnpCUaB2G/QyZ44QhyLydQ54GWvrIwjbk6LYfLS18P0H2IHJaYG53
         UZ00wqTYhJJ+eo1cDZm3S681H8rZgJ66rdnLHF+Yz4HoPdw2nxj+0aX+qxFiKAfjDqrR
         9v0TRr4eXgkOK35NeisF0h/GDKJs08O6qEjMLN4AzQ+C50ryjd5YggmFvzrkBfctjUDK
         MQA1JQciFRmLeb7Jq9SzY+9a3oBzck9B84Vq7gljYtV1ovXVv/KtXPdikhV+sowApo+1
         RuqzK9uKIzlt9cOk5CEyrM57Kt61sMLfTyKoMvdl2zbtRYmHaLmFPbETynrnyPTIUR+7
         N4pQ==
X-Gm-Message-State: AFuF++kfBVOMGrLQlomjwhHF5EYzCMIOHSFjXe0QzGMPtXZhmMrH1lNr
	mr2ksShso/MuK4ZdzSSNuOsYqtzON7UySDmgs5WpT8Q/RTHTZNj2ZZyN5o1yuA4c7J3mN8eaZKR
	iWJAn0C5IwQCaqpiBZTym7rlueE7NBHAClHfxrwR51lFWlLC6ruGBZuo=
X-Gm-Gg: AYBFou3qwkfPtDs0WmV07eY+sNWTPGGdgb/eVj1Q5BkRZbtcH1SGIDPtu70qhFzL0j2
	cOZhark62wNgETjEJLteE4Pf1N/DCqyLgwEQlYDe7gSIVp7hYcLeh6KqLOXcyh7OilAmEby75uY
	J3ES8flAePuPMqPumacRgLL0OhICczVWC0Nke0rIk1OTfpAUwjbF4FZpD1sxCuDYk/qf0/Fs7Ik
	PUCbAvuFK/6wXNr10iFV6RlktROP8h7BRY2opcY0nHHn5Vt7ni0qKxvfByJbJx11y8e+mGZvPdH
	fmLIihxCR1JjT1U7gTJGVX3/Ma2m0IcpYrfVvLC1F+pwlz1DLTJWi7feydk7/1bIDNX+1IIUk0W
	8uNYfvL6za3GGe417xr2SIyMOwzoCmz+g/ll0mrtOcQ==
X-Received: by 2002:a05:6000:40d9:b0:485:8a47:5b91 with SMTP id
 ffacd0b85a97d-4858a475cfamr25419205f8f.46.1788846108766; Mon, 07 Sep 2026
 22:41:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2ab022c5c7e07345a9fc91915836cbd4ab2d25ef.1788819456.git.wqu@suse.com>
In-Reply-To: <2ab022c5c7e07345a9fc91915836cbd4ab2d25ef.1788819456.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 8 Sep 2026 07:41:37 +0200
X-Gm-Features: AcwNN1X3drqqvYC0J2Stjluzlr_1Jk108hOrrPn8ANMM7rraehLTumd8gonC_5k
Message-ID: <CAPjX3Fe=mLZ74hBPMHx9hdn6B1ROaOBSS3YjkqC60NrfSjUDTg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: use kvmalloc() for split_item()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 00:18, Qu Wenruo <wqu@suse.com> wrote:
> [BUG]
> There is a bug report that the kmalloc() call inside split_item() failed
> with the following call trace, and triggered a transaction abort:
>
>  kworker/u69:8: page allocation failure: order:4, mode:0x40c40(GFP_NOFS|__GFP_COMP), nodemask=(null)
>  CPU: 3 UID: 0 PID: 1154528 Comm: kworker/u69:8 Not tainted 7.0.2 #1 PREEMPTLAZY
>  Workqueue: events_unbound btrfs_async_reclaim_metadata_space
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x47/0x60
>   warn_alloc.cold+0x67/0xec
>   __alloc_pages_slowpath.constprop.0+0x9bf/0xed0
>   __alloc_frozen_pages_noprof+0x1ac/0x1c0
>   ___kmalloc_large_node+0x9d/0xc0
>   __kmalloc_noprof+0x17b/0x1f0
>   split_item+0x9e/0x2e0
>   btrfs_del_csums+0x285/0x400
>   __btrfs_free_extent.isra.0+0x6de/0x12b0
>   __btrfs_run_delayed_refs+0x522/0x10c0
>   btrfs_run_delayed_refs+0x4d/0x1d0
>   flush_space+0x34d/0x4e0
>   do_async_reclaim_metadata_space+0x89/0x1d0
>   btrfs_async_reclaim_metadata_space+0x44/0x60
>   process_one_work+0x145/0x230
>   worker_thread+0x185/0x2e0
>   kthread+0xca/0x100
>   ret_from_fork+0x14e/0x200
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  BTRFS error (device dm-3 state A): Transaction aborted (error -12)
>  BTRFS: error (device dm-3 state A) in btrfs_del_csums:1053: errno=-12 Out of memory
>  BTRFS info (device dm-3 state EA): forced readonly
>  BTRFS: error (device dm-3 state EA) in do_free_extent_accounting:3168: errno=-12 Out of memory
>  BTRFS error (device dm-3 state EA): failed to run delayed ref for logical 1202913873920 num_bytes 274432 type 184 action 2 ref_mod 1: -12
>  BTRFS: error (device dm-3 state EA) in btrfs_run_delayed_refs:2247: errno=-12 Out of memory
>
> [CAUSE]
> The kmalloc() call is to allocate a buffer to store the full item.
> However as shown in the above call trace, the order can be high (4),
> and since we're using GFP_NOFS, it's impossible to reclaim memory by
> writing back dirty pages.
>
> When there is no physically contiguous memory left, such high order
> allocation can easily fail, and if such kmalloc() happens in a critical
> path we can trigger a transaction abort.
>
> [FIX]
> Instead of kmalloc(), which requires physically contiguous pages, use
> kvmalloc().
>
> There is no special requirement for physically contiguous pages here, we
> just want virtually contiguous memory as a buffer.
>
> Reported-by: xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
> Link: https://lore.kernel.org/linux-btrfs/250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/ctree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 8fe330d81b8f..fef0e49dd918 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3943,7 +3943,7 @@ static noinline int split_item(struct btrfs_trans_handle *trans,
>         orig_offset = btrfs_item_offset(leaf, path->slots[0]);
>         item_size = btrfs_item_size(leaf, path->slots[0]);
>
> -       buf = kmalloc(item_size, GFP_NOFS);
> +       buf = kvmalloc(item_size, GFP_NOFS);
>         if (!buf)
>                 return -ENOMEM;
>
> @@ -3981,7 +3981,7 @@ static noinline int split_item(struct btrfs_trans_handle *trans,
>         btrfs_mark_buffer_dirty(trans, leaf);
>
>         BUG_ON(btrfs_leaf_free_space(leaf) < 0);
> -       kfree(buf);
> +       kvfree(buf);
>         return 0;
>  }
>
> --
> 2.55.0
>
>
