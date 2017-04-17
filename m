Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34184 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754929AbdDQRgX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 13:36:23 -0400
Received: by mail-yw0-f182.google.com with SMTP id k13so58903975ywk.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 10:36:23 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Apr 2017 11:36:17 -0600
Message-ID: <CAJCQCtTnjNqhSNa9TypsJqvnKeh6H9dKJ9VU8_CHPuzu+zNxsA@mail.gmail.com>
Subject: compressing nocow files
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,


/dev/nvme0n1p8 on / type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=258,subvol=/root)

I've got a test folder with +C set and then copied a test file into it.

$ lsattr
----------------C--
./system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal

So now it's inherited +C. Next check fragments and compression.

$ sudo ~/Applications/btrfs-debugfs -f
system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
(290662 0): ram 100663296 disk 17200840704 disk_size 100663296
file: system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
extents 1 disk size 100663296 logical size 100663296 ratio 1.00


Try to compress it.

$ sudo btrfs fi defrag -c
system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal

Check again.

[snip faux fragments]
file: system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
extents 768 disk size 21504000 logical size 100663296 ratio 4.68

It's compressed! OK??

OK delete that file, and add +c to the temp folder.

$ lsattr
--------c-------C-- ./temp

Copy another test file into temp.

$ lsattr
--------c-------C--
./system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal

$ sudo ~/Applications/btrfs-debugfs -f
system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
(290739 0): ram 83886080 disk 21764243456 disk_size 83886080
file: system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
extents 1 disk size 83886080 logical size 83886080 ratio 1.00

Not compressed. Hmmm. So somehow btrfs fi defrag -c will force
compression even on nocow files? I've also done this without -c
option, with a Btrfs mounted using compress option; and the file does
compress also. I thought nocow files were always no compress, but it
seems there's exceptions.


Chris Murphy
