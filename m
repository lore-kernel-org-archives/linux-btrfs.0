Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:42145 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbeISA0O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:26:14 -0400
Received: by mail-lj1-f177.google.com with SMTP id f1-v6so2711845ljc.9
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 11:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <406ded26-bcef-ce8c-36e4-1b25bbb36768@libero.it>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com> <406ded26-bcef-ce8c-36e4-1b25bbb36768@libero.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 18 Sep 2018 12:52:16 -0600
Message-ID: <CAJCQCtRsox-QC2xkmpuTynHM6+MjQHCff2bEy3659FNQ5YN1oA@mail.gmail.com>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2018 at 11:15 AM, Goffredo Baroncelli
<kreijack@libero.it> wrote:
> On 18/09/2018 06.21, Chris Murphy wrote:
>> b. The bootloader code, would have to have sophisticated enough Btrfs
>> knowledge to know if the grubenv has been reflinked or snapshot,
>> because even if +C, it may not be valid to overwrite, and COW must
>> still happen, and there's no way the code in GRUB can do full blow COW
>> and update a bunch of metadata.
>
> And what if GRUB ignore the possibility of COWing and overwrite the data ? Is it a so big problem that the data is changed in all the snapshots ?
> It would be interested if the same problem happens for a swap file.....

I think it's an abomination :-) It totally perverts the idea of
reflinks and snapshots and blurs the line between domains. Is it a
user file or not and are these user space commands or not and are they
reliable or do they have exceptions?

I have a boot subvolume mounted at /boot, and this boot subvolume gets
snapshot, and if GRUB can overwrite grubenv, it overwrites the
purported GRUB state information in every one of those boots, going
back maybe months, even when these are read only subvolumes.

I think it's a problem, and near as I can tell it'll be a problem for
all kinds of complex storage. I don't see how the bootloader itself
can do an overwrite onto raid5 or raid6. That's certainly supported by
GRUB for reading, but is the bootloader overwrite of gruvenv going to
recompute parity and write to multiple devices? Eek!


-- 
Chris Murphy
