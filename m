Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37201 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdBJRlb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 12:41:31 -0500
Received: by mail-it0-f50.google.com with SMTP id r185so37985254ita.0
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 09:40:42 -0800 (PST)
MIME-Version: 1.0
From: John Hendy <jw.hendy@gmail.com>
Date: Fri, 10 Feb 2017 11:40:41 -0600
Message-ID: <CA+M2ft-sXH14tHK9rRv_T59dUC2KDzEMm5AyZwpgcK9KH0Uk7g@mail.gmail.com>
Subject: proper syslinux settings for ext4 boot, dm-crypt + btrfs subvol root?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,


I'm trying to utilize btrfs subvols to allow me to boot separate
distros without having to create so many partitions. I'm on Arch Linux
and not finding the wiki super helpful with specifics on dm-crypt/luks
and btrfs.

Requested info:

$ uname -a
Linux arch_zbook 4.9.8-1-ARCH #1 SMP PREEMPT Mon Feb 6 12:59:40 CET
2017 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.9

$ sudo btrfs fi show
Label: 'bigD'  uuid: e1284231-c264-4944-807d-5fcb1832ce47
Total devices 1 FS bytes used 1.27GiB
devid    1 size 232.38GiB used 3.02GiB path /dev/mapper/btr

$ btrfs fi df /mnt/btr/
Data, single: total=2.01GiB, used=1.21GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=1.01GiB, used=56.45MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

/dev/sdb1 is ext4 for /boot
/dev/sdb2 is a luks/dm-crypt device which I've opened as /dev/mapper/btr

I have a top level arch subvol with root and home undeneath. I'll
create a similar set for an Ubuntu install I need for work, a separate
shared data subvol, and then one for snapshots. I'm ignoring those and
would just like to get arch linux working properly.

Here's the setup I'm looking for once booted, with the /mnt/btf becoming /

$ mount
/dev/mapper/btr on /mnt/btr type btrfs
(rw,relatime,ssd,space_cache,subvolid=259,subvol=/arch/root)
/dev/mapper/btr on /mnt/btr/home type btrfs
(rw,relatime,ssd,space_cache,subvolid=260,subvol=/arch/home)
/dev/sdb1 on /mnt/btr/boot type ext4 (rw,relatime,data=ordered)

My functioning syslinux.cfg:

LABEL arch-ssd
    MENU LABEL arch-ssd-uuid
    LINUX ../vmlinuz-linux
    APPEND luks.uuid=7101e83b-31c0-4cdf-bc07-678e00e19c32
root=UUID=eb20c219-0df8-4051-bad2-39d57aed7b59 luks.allow-discards rw
    INITRD ../intel-ucode.img,../initramfs-linux.img

I tried this:

LABEL arch-btrfs
    MENU LABEL arch-btrfs-uuid
    LINUX ../vmlinuz-linux
    APPEND luks.uuid=bcacb6d5-2874-4652-a25d-88b0bf3bbce8
root=UUID=e1284231-c264-4944-807d-5fcb1832ce47
rootflags=subvol=/arch/root luks.allow-discards rw
    INITRD ../intel-ucode.img,../initramfs-linux.img

Current behavior is I successfully get a syslinux boot menu (at least
after I disabled the 64bit default option), but selecting the above
entry just refreshes the menu and I'm stuck there with an automatic
countdown from 5sec and then back to 5sec when it hits 0. It's like it
just keeps pointing at the /dev/sdb MBR or can't find something and
thus tries again?

Output of blkid:

$ sudo blkid
/dev/sda1: UUID="37441f68-9d76-45bc-b98c-996e68a3555c" TYPE="ext2"
PARTUUID="81053e11-01"
/dev/sda2: UUID="7101e83b-31c0-4cdf-bc07-678e00e19c32"
TYPE="crypto_LUKS" PARTUUID="81053e11-02"
/dev/sdb1: UUID="e046823f-c7bc-4ff0-8d76-307e6353d324" TYPE="ext4"
PARTUUID="45dbad3a-01"
/dev/sdb2: UUID="bcacb6d5-2874-4652-a25d-88b0bf3bbce8"
TYPE="crypto_LUKS" PARTUUID="45dbad3a-02"
/dev/mapper/luks-7101e83b-31c0-4cdf-bc07-678e00e19c32:
UUID="eb20c219-0df8-4051-bad2-39d57aed7b59" TYPE="ext4"
/dev/mapper/btr: LABEL="bigD"
UUID="e1284231-c264-4944-807d-5fcb1832ce47"
UUID_SUB="123f46c6-1b3a-4273-a84c-fa2c257652d0" TYPE="btrfs"

Am I specifying the wrong uuid to use, incorrect subvol, other? I
haven't been able to find anyone specifying a 2nd level subvol for the
root in their kernel parameters and wondered if that's the issue. I
just find "rootflags=subvol=__active" or similar in various google
hits.

Thanks for any suggestions; my apologies is asking about this to the
btrfs list isn't correct. I wasn't sure if this should be directed at
syslinux or here.


Best regards,
John
