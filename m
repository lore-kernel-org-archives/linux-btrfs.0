Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33095 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdBLXL7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Feb 2017 18:11:59 -0500
Received: by mail-yw0-f195.google.com with SMTP id u68so6083815ywg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Feb 2017 15:11:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+M2ft8-nS4dy-XgAjZmMG=hLMMdr1jk_4wZnVE+H-+Ojz3jAQ@mail.gmail.com>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
 <20170210234927.GK4249@carfax.org.uk> <CA+M2ft8-nS4dy-XgAjZmMG=hLMMdr1jk_4wZnVE+H-+Ojz3jAQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 12 Feb 2017 16:11:57 -0700
Message-ID: <CAJCQCtQ5kA0_iVz1RovtkKt25_8pif0Ss1P-Byqbv5E0TnX8dQ@mail.gmail.com>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: John Hendy <jw.hendy@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2017 at 5:05 PM, John Hendy <jw.hendy@gmail.com> wrote:
> On Fri, Feb 10, 2017 at 5:49 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Fri, Feb 10, 2017 at 11:40:41AM -0600, John Hendy wrote:
>>> Greetings,
>
>
>>    Just as an aside -- it doesn't affect you here, but you might want
>> to be aware -- syslinux doesn't support multi-device btrfs. I've been
>> bitten by that before, and it's a consideration for you should you
>> wish to add another device to this FS. Also, I haven't tried it, but I
>> suspect that it may not support compression in btrfs either.
>
> Aside appreciated! I don't plan to add a second device, so that's alright.

Nonfactor in your case because your boot volume is ext4 not Btrfs, so
none of the Btrfs limitations apply to the bootloader.


>
> I've run into the statement on compression as well... does this mean
> the device it's *on* or the device I want to mount as root?

rootflags applies mount options to the root filesystem only.

>
> I have to assume the former, and ran across this in my preparation,
> which is why I used ext4. Given that I've been able to specify
> rootflags=compress=lzo in my APPEND line, this is also in /etc/fstab
> and it booted... I'm using this as evidence that it must support
> compression on a root btrfs device? Any reason to think otherwise?

I don't understand the question. What is "it" when you ask "it must support"?


-- 
Chris Murphy
