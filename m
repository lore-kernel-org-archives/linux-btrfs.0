Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34694 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaFRTaA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 15:30:00 -0400
Received: by mail-oa0-f53.google.com with SMTP id l6so2945990oag.12
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 12:29:59 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>
Date: Wed, 18 Jun 2014 21:29:39 +0200
Message-ID: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
Subject: btrfs on whole disk (no partitions)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I created btrfs directly to disk using such a scheme (no partitions):

dd if=/dev/zero of=/dev/sda bs=4096
mkfs.btrfs -L dev_sda /dev/sda
mount /dev/sda /mnt

cd /mnt
btrfs subvolume create __active
btrfs subvolume create __active/rootvol
btrfs subvolume create __active/usr
btrfs subvolume create __active/home
btrfs subvolume create __active/var
btrfs subvolume create __snapshots

cd /
umount /mnt
mount -o subvol=__active/rootvol /dev/sda /mnt
mkdir /mnt/{usr,home,var}
mount -o subvol=__active/usr /dev/sda /mnt/usr
mount -o subvol=__active/home /dev/sda /mnt/home
mount -o subvol=__active/var /dev/sda /mnt/var

# /etc/fstab
UID=ID    /    btrfs rw,relative,space_cache,subvol=__active/rootvol    0 0
UUID=ID    /usr    btrfs rw,relative,space_cache,subvol=__active/usr    0 0
UUID=ID    /home    btrfs rw,relative,space_cache,subvol=__active/home    0 0
UUID=ID    /var    btrfs rw,relative,space_cache,subvol=__active/var    0 0

Everything works fine. Is such a solution is recommended? In my
opinion, the creation of the partitions seems to be completely
unnecessary if you can use btrfs.

I will be grateful for your feedback.
Best regards,
Daniel
