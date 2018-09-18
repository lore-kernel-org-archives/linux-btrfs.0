Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:58958 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730180AbeIRW50 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 18:57:26 -0400
Reply-To: kreijack@inwind.it
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <406ded26-bcef-ce8c-36e4-1b25bbb36768@libero.it>
Date: Tue, 18 Sep 2018 19:15:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/09/2018 06.21, Chris Murphy wrote:
> b. The bootloader code, would have to have sophisticated enough Btrfs
> knowledge to know if the grubenv has been reflinked or snapshot,
> because even if +C, it may not be valid to overwrite, and COW must
> still happen, and there's no way the code in GRUB can do full blow COW
> and update a bunch of metadata.

And what if GRUB ignore the possibility of COWing and overwrite the data ? Is it a so big problem that the data is changed in all the snapshots ? 
It would be interested if the same problem happens for a swap file.....


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
