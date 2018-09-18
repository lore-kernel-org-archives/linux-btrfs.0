Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:40402 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727660AbeISAxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:53:21 -0400
Reply-To: kreijack@inwind.it
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <406ded26-bcef-ce8c-36e4-1b25bbb36768@libero.it>
 <CAJCQCtRsox-QC2xkmpuTynHM6+MjQHCff2bEy3659FNQ5YN1oA@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5bf40cee-ca21-da82-c522-69766241d735@inwind.it>
Date: Tue, 18 Sep 2018 21:11:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRsox-QC2xkmpuTynHM6+MjQHCff2bEy3659FNQ5YN1oA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/09/2018 20.52, Chris Murphy wrote:
> On Tue, Sep 18, 2018 at 11:15 AM, Goffredo Baroncelli
> <kreijack@libero.it> wrote:
>> On 18/09/2018 06.21, Chris Murphy wrote:
>>> b. The bootloader code, would have to have sophisticated enough Btrfs
>>> knowledge to know if the grubenv has been reflinked or snapshot,
>>> because even if +C, it may not be valid to overwrite, and COW must
>>> still happen, and there's no way the code in GRUB can do full blow COW
>>> and update a bunch of metadata.
>>
>> And what if GRUB ignore the possibility of COWing and overwrite the data ? Is it a so big problem that the data is changed in all the snapshots ?
>> It would be interested if the same problem happens for a swap file.....
> 
> I think it's an abomination :-) It totally perverts the idea of
> reflinks and snapshots and blurs the line between domains. 

:-)

> Is it a
> user file or not and are these user space commands or not and are they
> reliable or do they have exceptions?

On this statement I fully agree, on the one below a bit less
> 
> I have a boot subvolume mounted at /boot, and this boot subvolume gets
> snapshot, and if GRUB can overwrite grubenv, it overwrites the
> purported GRUB state information in every one of those boots, going
> back maybe months, even when these are read only subvolumes.

Also the 'suse' behavior have the same issue: storing the data somewhere in the storage reserved area suffers of the same problem. We should be realistic, without implement a full btrfs filesystem engine, it is near impossible to have a grubenv file visible by the filesystem and snapshot-able.


> 
> I think it's a problem, and near as I can tell it'll be a problem for
> all kinds of complex storage. I don't see how the bootloader itself
> can do an overwrite onto raid5 or raid6. 


> That's certainly supported by GRUB for reading
Not yet, I am working on that [1]

> but is the bootloader overwrite of gruvenv going to
> recompute parity and write to multiple devices? Eek!

Recompute the parity should not be a big deal. Updating all the (b)trees would be a too complex goal.
> 
> 

[1] http://lists.gnu.org/archive/html/grub-devel/2018-06/msg00064.html
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
