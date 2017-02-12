Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37903 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdBLXrX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Feb 2017 18:47:23 -0500
Received: by mail-it0-f48.google.com with SMTP id c7so61653112itd.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Feb 2017 15:47:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTB-T40VqdmdrVcUkpEyXpv3HwE6m1qJWn9g0NggT_UGA@mail.gmail.com>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
 <CAJCQCtQKj0yJS3SUb1fLJfg9rAvA-kebndk53mc=oTP3rxr0xg@mail.gmail.com>
 <CA+M2ft9Aoj8S=i3N1G78BDm=4VOXkqM_dph1kXoyw2x9-thiig@mail.gmail.com> <CAJCQCtTB-T40VqdmdrVcUkpEyXpv3HwE6m1qJWn9g0NggT_UGA@mail.gmail.com>
From: John Hendy <jw.hendy@gmail.com>
Date: Sun, 12 Feb 2017 17:47:21 -0600
Message-ID: <CA+M2ft8CEYaSg4HC6GbxPmDWtwY-aZrj7JnDyqfoSN6M7wx6tw@mail.gmail.com>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 12, 2017 at 5:07 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Feb 10, 2017 at 4:34 PM, John Hendy <jw.hendy@gmail.com> wrote:
>
>>
>> I did a couple of things after I sent this. For one, I ditched
>> arch/root. Now I just have arch. That let me get away from the call to
>> a nested subvol.
>>
>> That on it's own didn't work, but I started playing with the
>> rootflags. I haven't tried one by one, but re-specifying my mount
>> options seems to work. So instead of just rootflags=subvol=arch, I
>> have:
>>
>> rootflags=compress=lzo,subvol=arch,ssd,discard
>>
>> Is there a reason that would make a difference?
>
> The only change that should matter is subvol path change, and I'm not
> even convinced of that. But I don't even know where exactly the
> failure is. It sounds like the failure happens right away and you get
> back to the syslinux menu; that suggests to me the kernel isn't even
> loaded let alone executed, and the boot parameters don't matter until
> the kernel is executed.
>
>

Indeed, and see my most recent reply. Unfortunately, I think the issue
might have been paring down extra options (I had some libata.force
stuff), including the loading of intel-ucode at the same time I was
adding explicit rootflags options. Thus, compress=lzo stood out as a
notable change, but I think I overlooked the real culprit which was
intel-ucode. So, as you said, I think the issue was it not even
getting past the bootloader and not what I initially thought.


John

>
> --
> Chris Murphy
