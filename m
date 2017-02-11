Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35841 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753149AbdBKAGD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 19:06:03 -0500
Received: by mail-it0-f67.google.com with SMTP id f200so5839230itf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 16:05:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170210234927.GK4249@carfax.org.uk>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
 <20170210234927.GK4249@carfax.org.uk>
From: John Hendy <jw.hendy@gmail.com>
Date: Fri, 10 Feb 2017 18:05:57 -0600
Message-ID: <CA+M2ft8-nS4dy-XgAjZmMG=hLMMdr1jk_4wZnVE+H-+Ojz3jAQ@mail.gmail.com>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: Hugo Mills <hugo@carfax.org.uk>, John Hendy <jw.hendy@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2017 at 5:49 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Feb 10, 2017 at 11:40:41AM -0600, John Hendy wrote:
>> Greetings,


>    Just as an aside -- it doesn't affect you here, but you might want
> to be aware -- syslinux doesn't support multi-device btrfs. I've been
> bitten by that before, and it's a consideration for you should you
> wish to add another device to this FS. Also, I haven't tried it, but I
> suspect that it may not support compression in btrfs either.

Aside appreciated! I don't plan to add a second device, so that's alright.

I've run into the statement on compression as well... does this mean
the device it's *on* or the device I want to mount as root?

I have to assume the former, and ran across this in my preparation,
which is why I used ext4. Given that I've been able to specify
rootflags=compress=lzo in my APPEND line, this is also in /etc/fstab
and it booted... I'm using this as evidence that it must support
compression on a root btrfs device? Any reason to think otherwise?
Their wiki appears to talk about just the boot device:
- http://www.syslinux.org/wiki/index.php?title=Filesystem#Btrfs

Even with ext4, my current arch install is < May 2016 which is when
mkfs.ext4 auto-implemented some sort of new 64bit feature so that
caught me off guard. Initially syslinux just spit out a "can't find
ldlinux.sys" or similar.

Given I'm early enough here to abort the plan without much fuss, this
sort of aside is quite nice to consider if there's something
inherently wrong with this! So far I have a booting arch and I'm using
debootstrap to manually install Ubuntu since it's installer has ~zero
customization options to prep your mount points if you've already got
them ready...


Thanks,
John

>
>    Hugo.
>
> --
> Hugo Mills             | All mushrooms are edible, but some are only edible
> hugo@... carfax.org.uk | once.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
