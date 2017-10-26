Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:50554 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbdJZUs3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 16:48:29 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:37770)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e7p4l-0001BY-3b
        for linux-btrfs@vger.kernel.org; Thu, 26 Oct 2017 21:48:27 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e7p4h-0001NV-TG
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 21:48:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23026.18966.937492.142646@tree.ty.sabi.co.uk>
Date: Thu, 26 Oct 2017 21:48:22 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: RE: SLES 11 SP4: can't mount btrfs
In-Reply-To: <011601d34e78$b184d170$148e7450$@helmholtz-muenchen.de>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
        <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
        <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>
        <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>
        <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de>
        <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net>
        <32022214.8113126.1508586366285.JavaMail.zimbra@helmholtz-muenchen.de>
        <20171021180752.iqkspyi2whnm4vui@angband.pl>
        <5b68b633-6069-067d-5b9b-81074807ab06@gmail.com>
        <006b01d34ccb$ee56bbd0$cb043370$@helmholtz-muenchen.de>
        <a4c7ccd2-c9ab-8a20-4156-f0f756aced81@gmail.com>
        <001001d34ce7$42c576f0$c85064d0$@helmholtz-muenchen.de>
        <006101d34e54$78c608a0$6a5219e0$@helmholtz-muenchen.de>
        <23025.56120.834544.576310@tree.ty.sabi.co.uk>
        <011601d34e78$b184d170$148e7450$@helmholtz-muenchen.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> But it could simply be that you have forgotten to refresh the
>> 'initramfs' with 'mkinitrd' after modifying the '/etc/fstab'.

> I finally managed it. I'm pretty sure having changed
> /boot/grub/menu.lst, but somehow changes got lost/weren't
> saved ?

So the next thing to check would indeed have been that the GRUB2
script had been updated, which you can do with 'grub2-mkconfig'.
Also double check that in '/etc/sysconfig/bootloader' there is a
line 'LOADER_TYPE="grub"' instead of "none".

The system config tools will update the 'initramfs' and the
'menu.lst' automatically only if you make system config changes
only using them, but you changed the UUID of '/' "manually", and
this perhaps put the GRUB2 config and the system state out of
sync.

> After entering the new UUID from my Btrfs partition system
> boots.

Alternatively you could have used 'btrfstune -U ... ...' to
change the UUID of the newly created '/' volume to the old one.

