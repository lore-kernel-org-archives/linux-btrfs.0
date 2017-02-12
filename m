Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38650 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdBLA3C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Feb 2017 19:29:02 -0500
Received: by mail-it0-f44.google.com with SMTP id c7so52390610itd.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Feb 2017 16:29:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
References: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
From: John Hendy <jw.hendy@gmail.com>
Date: Sat, 11 Feb 2017 18:29:00 -0600
Message-ID: <CA+M2ft-SdDSGG-mw_u8=5VWbWbKv311zYqsBZSCUQL_601=uzQ@mail.gmail.com>
Subject: Re: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2017 at 11:40 AM, John Hendy <jw.hendy@gmail.com> wrote:
> Greetings,
>
>
> I'm trying to utilize btrfs subvols to allow me to boot separate
> distros without having to create so many partitions. I'm on Arch Linux
> and not finding the wiki super helpful with specifics on dm-crypt/luks
> and btrfs.

[snip]

> Here's the setup I'm looking for once booted, with the /mnt/btf becoming /
>
> $ mount
> /dev/mapper/btr on /mnt/btr type btrfs
> (rw,relatime,ssd,space_cache,subvolid=259,subvol=/arch/root)
> /dev/mapper/btr on /mnt/btr/home type btrfs
> (rw,relatime,ssd,space_cache,subvolid=260,subvol=/arch/home)
> /dev/sdb1 on /mnt/btr/boot type ext4 (rw,relatime,data=ordered)
>
> My functioning syslinux.cfg:
>
> LABEL arch-ssd
>     MENU LABEL arch-ssd-uuid
>     LINUX ../vmlinuz-linux
>     APPEND luks.uuid=7101e83b-31c0-4cdf-bc07-678e00e19c32
> root=UUID=eb20c219-0df8-4051-bad2-39d57aed7b59 luks.allow-discards rw
>     INITRD ../intel-ucode.img,../initramfs-linux.img
>
> I tried this:
>
> LABEL arch-btrfs
>     MENU LABEL arch-btrfs-uuid
>     LINUX ../vmlinuz-linux
>     APPEND luks.uuid=bcacb6d5-2874-4652-a25d-88b0bf3bbce8
> root=UUID=e1284231-c264-4944-807d-5fcb1832ce47
> rootflags=subvol=/arch/root luks.allow-discards rw
>     INITRD ../intel-ucode.img,../initramfs-linux.img
>
> Current behavior is I successfully get a syslinux boot menu (at least
> after I disabled the 64bit default option), but selecting the above
> entry just refreshes the menu and I'm stuck there with an automatic
> countdown from 5sec and then back to 5sec when it hits 0. It's like it
> just keeps pointing at the /dev/sdb MBR or can't find something and
> thus tries again?

Closing the loop on this. It took a while but after a couple of
install option tries, I got ubuntu planing nicely with syslinux so I
figured the arch process would be piece of cake. I had everything
setup and then went to boot and got the same behavior... I tabbed to
get out the loop behavior and thought "ah! I wonder if I installed the
intel-ucode package?" So, previously, I thought it was specifying the
compress=lzo option, but now I think that was just one of many steps I
did when fiddling with the syslinux entry above. I'm guessing another
was removing the loading of intel-ucode.

I don't want to go through all the steps again to be sure, but at
least wanted this updated with my experience in case someone else
stumbles on the issue. Thus far:

- I have a single /boot partition (sdb1) with syslinux installed
- I can boot either arch or ubuntu from separate btrfs subvols on the
same encrypted partition (sdb2)
- thus far I just have an arch and ubuntu top level subvol with nested
home subvol under each
- I *don't* think the issue was loading a nested subvol for root [1]
- this is awesome and so much cooler than having to guess what size to
make everything ahead of time

Thanks for the quick responses all and like most issues the problem
was almost certainly me!


John

[1] this post suggests loading __active/rootvol
- https://www.brunoparmentier.be/blog/how-to-install-arch-linux-on-an-encrypted-btrfs-partition.html

[snip]


> Best regards,
> John
