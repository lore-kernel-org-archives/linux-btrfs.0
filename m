Return-Path: <SRS0=p5gK=R3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CEBC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 16:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10D9D20823
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 16:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="wJVcFKjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbfCXQxC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Mar 2019 12:53:02 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35847 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfCXQxC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Mar 2019 12:53:02 -0400
Received: by mail-lj1-f196.google.com with SMTP id r24so4716888ljg.3
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Mar 2019 09:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZK9Dwt1iuBzDMlOy7I7p/z1y2yQi0/fO3KdQfvnhGI8=;
        b=wJVcFKjyNdMCjJx3t71hf7NfN07x4B+Lg7aAhvA7KJNYKkxTU2F+Zi1+yzbvQenSmL
         8EbH1gLX4ifS7Kp9DS8P8K2STZCUYXvb4bhhqac6FoIKz8RQPdOcKNAYgT5KMjlZWMp+
         dtcBhZSJ4l9sYz57ayj9R3mWuOF/hqbIRv54htxff11f2UG+acwIThqSner9U6dddXRY
         UhwkZH/7O+mmkesLAgyXDOjVmTdCEwf8irFnEliK3L99AqjuAKiGjtaNifNtXOWSTog3
         18Du5N+47IzRx59i/lsEncpdpb4NOlIDJjXgRLXj/pxm78gehw8NGiVzldY971fpAlPP
         m/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZK9Dwt1iuBzDMlOy7I7p/z1y2yQi0/fO3KdQfvnhGI8=;
        b=taY6cVmaaEIX9kl8NG+g/pfbOhcEMhlb7DZyW1HT/ppDKexvsc/9rFfaaXOyXy01dj
         OGfUxT/TYCqmIFG9/0TEN4WWy+bsT/b1C7IJz5/Tjsgn+P4ZfFmhBV0wBw85J0eX1EN4
         F3TkarQZfqQ44GpincDioF+AL79h551TXfKdACocV47VwKMGCH85l7v3HMWXV3sByrg6
         cMnSUX9vWlJN3pp4yIQOResSqB1z8UpOFNLYEioU+ddWkdGuplTo2FMdlKYxNgRoqixl
         q9Iz9aRB8/stkagL6UqFwb/pZ6VB0hVvIUW9Sy1TMkv1N7ENurZl9kDRYrFP5YTMu+UI
         85MQ==
X-Gm-Message-State: APjAAAXNtW5fY4vd4wYYVmBB2g2TD2HMHzFLcn6edh48MUc4IDpjE+jf
        2yWO+vNDyxtJX7ziD4m6Sj+TcgSHhRQsBjmQl2fqqBZbZUA=
X-Google-Smtp-Source: APXvYqysnej15bLI8595wUpww0EDYKueKC6OKC/eTlgUyomIgRskAE2awK5//FfsAJz2y4Y5ROmFK+jnJb2a4pSiuSI=
X-Received: by 2002:a2e:9a91:: with SMTP id p17mr10055553lji.127.1553446379693;
 Sun, 24 Mar 2019 09:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
 <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com> <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
In-Reply-To: <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 24 Mar 2019 10:52:48 -0600
Message-ID: <CAJCQCtR6FKOiNXupU-6UVX-zKzwmg848Jok_z-VStAwtjoGdEQ@mail.gmail.com>
Subject: Re: Fw: kernel oops when mounting btrfs
To:     Thorsten Hirsch <t.hirsch@web.de>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 23, 2019 at 2:30 AM Thorsten Hirsch <t.hirsch@web.de> wrote:
>
> Hi Qu,
>
> thank you, but unfortunately that didn't work out so well. The tree
> dump was no problem [1], but clearing the space cache resulted in a
> core dump. Now btrfs check --readonly reports some errors. I attached
> the output of these commands.
>
> Thorsten
>
> [1] https://gist.github.com/thorstenhirsch/65d4308ce54729c902cb09c0d4ad2baf
>
> # btrfs check --clear-space-cache v1 /dev/nvme0n1p3
> Opening filesystem to check...
> Checking filesystem on /dev/nvme0n1p3
> UUID: 4284a794-ad75-450d-b023-ebc5e75f31f5
> Failed to find [544448348160, 168, 16384]
> btrfs unable to find ref byte nr 544448364544 parent 0 root 2  owner 0 offset 0
> transaction.c:195: btrfs_commit_transaction: BUG_ON `ret` triggered, value -5
> btrfs(+0x3be68)[0x556936269e68]
> btrfs(btrfs_commit_transaction+0x12a)[0x55693626a2ec]
> btrfs(btrfs_clear_free_space_cache+0x32a)[0x55693625fecf]
> btrfs(+0x4be5b)[0x556936279e5b]
> btrfs(cmd_check+0x5c2)[0x556936284d86]
> btrfs(main+0x1f6)[0x556936241ef6]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xeb)[0x7fb9a7911b6b]
> btrfs(_start+0x2a)[0x556936241f3a]
> Aborted (core dumped)
>
>
> # btrfs check --readonly /dev/nvme0n1p3
> Opening filesystem to check...
> parent transid verify failed on 419860414464 wanted 30188 found 30105
> parent transid verify failed on 419860414464 wanted 30188 found 30105
> Ignoring transid failure
> Checking filesystem on /dev/nvme0n1p3
> UUID: 4284a794-ad75-450d-b023-ebc5e75f31f5
> [1/7] checking root items
> [2/7] checking extents
> ref mismatch on [544448348160 16384] extent item 1, found 0
> backref 544448348160 root 2 not referenced back 0x563ce432f010
> incorrect global backref count on 544448348160 found 1 wanted 0
> backpointer mismatch on [544448348160 16384]
> owner ref check failed [544448348160 16384]
> ref mismatch on [544448364544 16384] extent item 0, found 1
> tree backref 544448364544 parent 2 root 2 not found in extent tree
> backpointer mismatch on [544448364544 16384]
> ERROR: errors found in extent allocation tree or chunk allocation
> [3/7] checking free space cache
> cache and super generation don't match, space cache will be invalidated
> [4/7] checking fs roots
> [5/7] checking only csums items (without verifying data)
> [6/7] checking root refs
> [7/7] checking quota groups skipped (not enabled on this FS)
> ERROR: transid errors in file system
> found 275464060928 bytes used, error(s) found
> total csum bytes: 266882612
> total tree bytes: 1513570304
> total fs tree bytes: 1135788032
> total extent tree bytes: 73220096
> btree space waste bytes: 236694654
> file data blocks allocated: 1962517999616
>  referenced 221128466432

This looks like the same problem I reported earlier this month, and
also filed a bug for at
https://bugzilla.kernel.org/show_bug.cgi?id=202717

In my case I did a scrub and check before clearing space cache v1. No
problems reported. And then clearing space cache v1 crashed. And then
check reports corruption.

Bug 1, for sure btrfs check clear cache crashing is a bug
Bug 2, btrfs check appears to do non-COW overwrite of the extent tree,
which might be fine as long as it doesn't crash but it seems risky
considering how fragile the extent tree is anyway

Clear cache right now is not fail safe near as I can tell. It can make
an error free file system corrupt.

If there's some problem already, before clearing space cache, that
means more bugs:

Bug 3, btrfs check doesn't find the problem, reports no errors
Bug 4, btrfs kernel code doesn't find the problem during scrub,
reports no errors


-- 
Chris Murphy
