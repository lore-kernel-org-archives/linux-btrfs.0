Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f52.google.com ([209.85.167.52]:43050 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbeIRLIm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 07:08:42 -0400
Received: by mail-lf1-f52.google.com with SMTP id x24-v6so587843lfe.10
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 22:37:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com> <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Sep 2018 23:37:44 -0600
Message-ID: <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2018 at 11:24 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 18.09.2018 07:21, Chris Murphy пишет:
>> On Mon, Sep 17, 2018 at 9:44 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>> https://btrfs.wiki.kernel.org/index.php/FAQ#Does_grub_support_btrfs.3F
>>>
>>> Does anyone know if this is still a problem on Btrfs if grubenv has
>>> xattr +C set? In which case it should be possible to overwrite and
>>> there's no csums that are invalidated.
>>>
>>> I kinda wonder if in 2018 it's specious for, effectively out of tree
>>> code, to be making modifications to the file system, outside of the
>>> file system.
>>
>> a. The bootloader code (pre-boot, not user space setup stuff) would
>> have to know how to read xattr and refuse to overwrite a grubenv
>> lacking xattr +C.
>> b. The bootloader code, would have to have sophisticated enough Btrfs
>> knowledge to know if the grubenv has been reflinked or snapshot,
>> because even if +C, it may not be valid to overwrite, and COW must
>> still happen, and there's no way the code in GRUB can do full blow COW
>> and update a bunch of metadata.
>>
>> So answering my own question, this isn't workable. And it seems the
>> same problem for dm-thin.
>>
>> There are a couple of reserve locations in Btrfs at the start and I
>> think after the first superblock, for bootloader embedding. Possibly
>> one or both of those areas could be used for this so it's outside the
>> file system. But other implementations are going to run into this
>> problem too.
>>
>
> That's what SUSE grub2 version does - it includes patches to redirect
> writes on btrfs to reserved area. I am not sure how it behaves in case
> of multi-device btrfs though.

The patches aren't upstream yet? Will they be?

They redirect writes to grubenv specifically? Or do they use the
reserved areas like a hidden and fixed location for what grubenv would
contain?

I guess the user space grub-editenv could write to grubenv, which even
if COW, GRUB can pick up that change. But GRUB itself writes its
changes to a reserved area.

Hmmm. Complicated.

-- 
Chris Murphy
