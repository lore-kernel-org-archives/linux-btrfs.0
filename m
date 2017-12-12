Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34221 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752570AbdLLVwq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 16:52:46 -0500
Received: by mail-io0-f195.google.com with SMTP id n41so627152ioe.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 13:52:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cover.1513111931.git.dsterba@suse.com>
References: <cover.1513111931.git.dsterba@suse.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 13 Dec 2017 00:52:05 +0300
Message-ID: <CAGqmi75L0Rw8rEW8LMcxo-X4ia0MHTfEHd4sjkZEnRbEyY1OGQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Minor compression heuristic cleanups
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-12-12 23:55 GMT+03:00 David Sterba <dsterba@suse.com>:
> The callback pointers for radix_sort are not needed, we don't plan to
> export the function now. The compiler is smart enough to replace the
> indirect calls with direct ones, so there's no change in the resulting
> asm code.
>
> David Sterba (3):
>   btrfs: heuristic: open code get_num callback of radix sort
>   btrfs: heuristic: open code copy_call callback of radix sort
>   btrfs: heuristic: call get4bits directly
>
>  fs/btrfs/compression.c | 42 +++++++++++-------------------------------
>  1 file changed, 11 insertions(+), 31 deletions(-)
>
> --
> 2.15.1
>

Thanks!
On whole series:
Reviewed-by: Timofey Titovets

-- 
Have a nice day,
Timofey.
