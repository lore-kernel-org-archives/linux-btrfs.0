Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:45532 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbeAYM3g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 07:29:36 -0500
Received: by mail-wr0-f170.google.com with SMTP id 16so7469584wry.12
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 04:29:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com> <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com> <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com> <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com> <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com> <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
From: "^m'e" <marcoep@gmail.com>
Date: Thu, 25 Jan 2018 12:29:14 +0000
Message-ID: <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No luck this time:

# ./btrfs-corrupt-block.static -X /dev/sdb3
ERROR: Failed to unlink the old file "Manifest": No such file or directory
extent buffer leak: start 4210688 len 16384
extent_io.c:607: free_extent_buffer_internal: BUG_ON `eb->flags &
EXTENT_DIRTY` triggered, value 1
[0x416a32]
[0x41720e]
[0x41725a]
[0x40a6e1]
[0x40aee3]
[0x403245]
[0x43ba83]
[0x43bbdf]
[0x400989]
Aborted

On Thu, Jan 25, 2018 at 12:09 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> Confirmed same problem as previous root.
>
> So branch updated to fix the same problem for root 257.
>
> Please try and see if the following error message is gone:
>
> ------
> ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
> INODE_ITEM[0] namelen 0 filename  filetype 0
> ERROR: root 257 DIR_ITEM[30039322 4007295565] data_len shouldn't be 32907
> ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
> INODE_ITEM[0] namelen 3 filename  filetype 0
> ------
>
> Thanks,
> Qu
>
>



-- 
^m'e
