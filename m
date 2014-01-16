Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:43949 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaAPV6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 16:58:31 -0500
Received: by mail-ve0-f177.google.com with SMTP id pa12so1242083veb.36
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 13:58:30 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 22:58:30 +0100
Message-ID: <CAC+fKQVrock85graBMn7o7WcHkkTqJaP904VCoPJwyrXJ2bp2Q@mail.gmail.com>
Subject: Cannot delete subvolume - Directory not empty
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to delete a emtpy subvolume, but I can't. It is a Luks
device and I'm using autofs, I have unmounted it, closed the Luks
device and remounted again, but it doesn't work.

# mount | grep hd04
systemd-1 on /mnt/hd04 type autofs
(rw,relatime,fd=46,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
systemd-1 on /mnt/hd04_duply type autofs
(rw,relatime,fd=47,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
/dev/mapper/luks-964185b6-7203-439f-a7c9-cbb374131af4 on /mnt/hd04
type btrfs (rw,relatime,seclabel,compress=lzo,space_cache)
/dev/mapper/luks-964185b6-7203-439f-a7c9-cbb374131af4 on
/mnt/hd04_duply type btrfs
(rw,relatime,seclabel,compress=lzo,space_cache)

# btrfs sub list .
ID 256 gen 2854 top level 5 path backups
ID 1063 gen 2876 top level 5 path duply
ID 1066 gen 1765 top level 5 path duply@2014-01-11_20:40:18
ID 1756 gen 2840 top level 5 path duply@2014-01-16_21:23:49

# ls -la backups/
total 4
drwxr-xr-x. 1 root root   0 ene 16 21:43 .
drwxr-xr-x. 1 root root 124 ene 16 21:26 ..

# btrfs sub delete backups
Delete subvolume '/mnt/hd04/backups'
ERROR: cannot delete '/mnt/hd04/backups' - Directory not empty

# btrfs fi show
Label: hd04_backups_externos  uuid: e163fa83-4a98-4c04-b69f-fb8518e7230a
        Total devices 1 FS bytes used 695.94GiB
        devid    1 size 1.82TiB used 1.46TiB path
/dev/mapper/luks-964185b6-7203-439f-a7c9-cbb374131af4

Btrfs v3.12

Kernel 3.12.7-300.fc20.x86_64

-- 
Juan Orti
GPG Key: DEEBD08B - http://jorti.fedorapeople.org/pubkey.asc
Blog: https://apuntesderoot.wordpress.com/
