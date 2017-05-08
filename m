Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35706 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755400AbdEHTP3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 15:15:29 -0400
Received: by mail-pf0-f170.google.com with SMTP id v14so37573937pfd.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 12:15:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170508190257.GB1699@fox>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com> <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
 <20170508112617.7e33bed6@ad> <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
 <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com> <20170508170106.GA1699@fox>
 <CAPktuGtS-K9ZvXf_3G5UkS2Xrj-cWx+DaqrFDOu-Hi9r1HqUKw@mail.gmail.com> <20170508190257.GB1699@fox>
From: Alexandru Guzu <alexguzu@gmail.com>
Date: Mon, 8 May 2017 15:15:28 -0400
Message-ID: <CAPktuGuQHoaVELgyLtEzt63ccQYhoDWrNH49KmWeExmutHHJ=Q@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Sean Greenslade <sean@seangreenslade.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Sanidhya Solanki <lkml.page@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My setup is a single disk, single btrfs subvolume (/) without a
separate boot partition.
I resolved the issue like this from a Live CD:

1 - take a (read-only) snapshot of the current problematic root system
and use send-receive to another BTRFS disk
2 - re-format the original partition as btrfs (mkfs.btrfs is enought)
and mount it under /mnt (I added -o compress=lzo)
3 - cp -arv  the files from the other disk subovlume to the newly
formatted partition, /mnt
4 - chroot to the new partition:
    # cd /mnt
    # mount --bind /sys sys/
    # mount --bind /dev dev/
    # mount --bind /proc proc/
    # chroot /mnt /bin/bash
5 - re-install grub:
    # update-grub
    # grub-install
6 - edited the /mnt/etc/fstab entry to match the new blkid /dev/sda1
7 - reboot magically brought me to the original system.
8 - reboot again in LiveCD, and using btrfs-tools 4.10.2 I ran a
lowmem check without errors.

So the bottom line is that send-receive did not carry over the
problems and that cp -arv is good enough to clone the partition, but
you need to manually install the bootloader. Maybe Boot-repair could
have done it, not sure.
Also I was unable to find a way to send-receive a snapshot to the root
subvolume of a different disk. Is this possible?

Thanks for the help and may this solution remain on the internet for
anyone that has a similar issue.

On Mon, May 8, 2017 at 3:02 PM, Sean Greenslade <sean@seangreenslade.com> wrote:
> On Mon, May 08, 2017 at 02:22:52PM -0400, Alexandru Guzu wrote:
>> Getting a bit off-topic here, but were you able to boot from that fs
>> with grub after a simple rsync?
>
> Grub was installed to the MBR, and /boot was a separate partition, so I
> didn't have to re-install grub. I did have to edit the root partition
> UUID in /etc/fstab and in the kernel command line in grub.cfg, though.
>
> --Sean
>
