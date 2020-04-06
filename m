Return-Path: <SRS0=ixrC=5W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD4BC2BA19
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Apr 2020 10:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707FE2072A
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Apr 2020 10:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586170293;
	bh=fM/cSC6/USDpOc5vk66xXdyE/0V3c1fJk29Y3Khxldk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=wtUxp27gicV9J5eOtVsKvxzBA5uyNSNUWspL2ar7uAKAkHMIjvzavutbpor5ppgeH
	 Gsj2m4FXvPz07HDo9/D63GrQVVeNfs/kTZxFOSTI2b9IeMhW8A0vL2Toy7cNLquZN+
	 6pVAndaEwqLgKeFLydLYGbQlUWnOWQE+i31U3v/4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgDFKvc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 06:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgDFKvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Apr 2020 06:51:32 -0400
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED89120678
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2020 10:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586170292;
        bh=fM/cSC6/USDpOc5vk66xXdyE/0V3c1fJk29Y3Khxldk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DfXdYVMsTBk4NhYpjquvIo8P0J9C2CM1K0pjWCOLUVFzXJ88nzWejJuHYThK/rFwa
         HuSecEVuZgoSD1O0FlVwniCcsJRs4ewwSb1s4S1AfpGDg3pmE1DLLcrLZVu3fvpm/X
         keEWTLS8zyFzK9rMdV5IlvD7uOBKr8l+VEmrguAE=
Received: by mail-vs1-f45.google.com with SMTP id s10so9457211vsi.9
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2020 03:51:31 -0700 (PDT)
X-Gm-Message-State: AGi0PuYvNfjKvwTRGlbRJhnwKLsxbvCOKixQfFl9QmTP23UzvzfqgdVv
        wU5atsK4GwVC4ivc41uyuXA6c5ztEin+nnAjQFE=
X-Google-Smtp-Source: APiQypKfFQMjDRbBfOhqT3qIQ5OnK3cYM6k6JwQWzT9xFvYU7P4y7H44IPYYUCwpcmyelxS/1KVU/vgrXBIwH+u6/To=
X-Received: by 2002:a67:7c8f:: with SMTP id x137mr13157951vsc.99.1586170291051;
 Mon, 06 Apr 2020 03:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200404202022.30192-1-fdmanana@kernel.org>
In-Reply-To: <20200404202022.30192-1-fdmanana@kernel.org>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 6 Apr 2020 11:51:20 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6cZS7mq7d6aHPxMPnng_P7nuMHaBi=F4L86CoHhFZVJg@mail.gmail.com>
Message-ID: <CAL3q7H6cZS7mq7d6aHPxMPnng_P7nuMHaBi=F4L86CoHhFZVJg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix lost i_size update after cloning inline extent
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     Johannes Hirte <johannes.hirte@datenkhaos.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 4, 2020 at 9:21 PM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> When not using the NO_HOLES feature we were not marking the destination's
> file range as written after cloning an inline extent into it. This can
> lead to a data loss if the current destination file size is smaller than
> the source file's size.
>
> Example:
>
>   $ mkfs.btrfs -f -O ^no-holes /dev/sdc
>   $ mount /mnt/sdc /mnt
>
>   $ echo "hello world" > /mnt/foo
>   $ cp --reflink=always /mnt/foo /mnt/bar
>   $ rm -f /mnt/foo
>   $ umount /mnt
>
>   $ mount /mnt/sdc /mnt
>   $ cat /mnt/bar
>   $
>   $ stat -c %s /mnt/bar
>   0
>
>   # -> the file is empty, since we deleted foo, the data lost is forever
>
> Fix that by calling btrfs_inode_set_file_extent_range() after cloning an
> inline extent.
>
> A test case for fstests will follow soon.
>
> Fixes: 9ddc959e802bf ("btrfs: use the file extent tree infrastructure")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reported-by: Johannes Hirte <johannes.hirte@datenkhaos.de>
Link: https://lore.kernel.org/linux-btrfs/20200404193846.GA432065@latitude/
Tested-by: Johannes Hirte <johannes.hirte@datenkhaos.de>

> ---
>  fs/btrfs/reflink.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index d1973141d3bb..040009d1cc31 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -264,6 +264,7 @@ static int clone_copy_inline_extent(struct inode *dst,
>                             size);
>         inode_add_bytes(dst, datal);
>         set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(dst)->runtime_flags);
> +       ret = btrfs_inode_set_file_extent_range(BTRFS_I(dst), 0, aligned_end);
>  out:
>         if (!ret && !trans) {
>                 /*
> --
> 2.11.0
>
