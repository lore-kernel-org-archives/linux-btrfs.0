Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34395 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdBLXHZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Feb 2017 18:07:25 -0500
Received: by mail-yw0-f194.google.com with SMTP id v73so6089077ywg.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Feb 2017 15:07:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+M2ft9Aoj8S=i3N1G78BDm=4VOXkqM_dph1kXoyw2x9-thiig@mail.gmail.com>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
 <CAJCQCtQKj0yJS3SUb1fLJfg9rAvA-kebndk53mc=oTP3rxr0xg@mail.gmail.com> <CA+M2ft9Aoj8S=i3N1G78BDm=4VOXkqM_dph1kXoyw2x9-thiig@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 12 Feb 2017 16:07:24 -0700
Message-ID: <CAJCQCtTB-T40VqdmdrVcUkpEyXpv3HwE6m1qJWn9g0NggT_UGA@mail.gmail.com>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: John Hendy <jw.hendy@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2017 at 4:34 PM, John Hendy <jw.hendy@gmail.com> wrote:

>
> I did a couple of things after I sent this. For one, I ditched
> arch/root. Now I just have arch. That let me get away from the call to
> a nested subvol.
>
> That on it's own didn't work, but I started playing with the
> rootflags. I haven't tried one by one, but re-specifying my mount
> options seems to work. So instead of just rootflags=subvol=arch, I
> have:
>
> rootflags=compress=lzo,subvol=arch,ssd,discard
>
> Is there a reason that would make a difference?

The only change that should matter is subvol path change, and I'm not
even convinced of that. But I don't even know where exactly the
failure is. It sounds like the failure happens right away and you get
back to the syslinux menu; that suggests to me the kernel isn't even
loaded let alone executed, and the boot parameters don't matter until
the kernel is executed.


> I started wondering
> about the compression immediately and I admit I'm not savvy on how
> that works.

Not a factor for two reasons:
a. Your boot volume is not Btrfs, so the fact syslinux (actually
extlinux in this case) doesn't support compression doesn't matter. Its
job is just to load and execute the kernel and initrams.
b. The file system metadata contains information per extent whether
it's compressed and with which algorithm. So Btrfs doesn't need the
compression hint as a boot parameter either. This mount option is only
needed to tell the kernel to write new extents with compression.


-- 
Chris Murphy
