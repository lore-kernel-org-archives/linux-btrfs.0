Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42535 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbeIRJwj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 05:52:39 -0400
Received: by mail-lj1-f193.google.com with SMTP id f1-v6so451863ljc.9
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 21:21:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Sep 2018 22:21:54 -0600
Message-ID: <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2018 at 9:44 PM, Chris Murphy <lists@colorremedies.com> wrote:
> https://btrfs.wiki.kernel.org/index.php/FAQ#Does_grub_support_btrfs.3F
>
> Does anyone know if this is still a problem on Btrfs if grubenv has
> xattr +C set? In which case it should be possible to overwrite and
> there's no csums that are invalidated.
>
> I kinda wonder if in 2018 it's specious for, effectively out of tree
> code, to be making modifications to the file system, outside of the
> file system.

a. The bootloader code (pre-boot, not user space setup stuff) would
have to know how to read xattr and refuse to overwrite a grubenv
lacking xattr +C.
b. The bootloader code, would have to have sophisticated enough Btrfs
knowledge to know if the grubenv has been reflinked or snapshot,
because even if +C, it may not be valid to overwrite, and COW must
still happen, and there's no way the code in GRUB can do full blow COW
and update a bunch of metadata.

So answering my own question, this isn't workable. And it seems the
same problem for dm-thin.

There are a couple of reserve locations in Btrfs at the start and I
think after the first superblock, for bootloader embedding. Possibly
one or both of those areas could be used for this so it's outside the
file system. But other implementations are going to run into this
problem too.

I'm not sure how else to describe state. If NVRAM is sufficiently wear
resilient enough to have writes to it possibly every day, for every
boot, to indicate boot success/fail.

-- 
Chris Murphy
