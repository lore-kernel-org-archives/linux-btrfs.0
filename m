Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:46806 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932348AbdJZMza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 08:55:30 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:60756)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e7hh2-00021D-Fs
        for linux-btrfs@vger.kernel.org; Thu, 26 Oct 2017 13:55:28 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e7hgv-0008Lw-M9
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 13:55:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23025.56120.834544.576310@tree.ty.sabi.co.uk>
Date: Thu, 26 Oct 2017 13:55:20 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: RE: SLES 11 SP4: can't mount btrfs
In-Reply-To: <006101d34e54$78c608a0$6a5219e0$@helmholtz-muenchen.de>
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
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I formatted the / partition with Btrfs again and could restore
> the files from a backup.  Everything seems to be there, I can
> mount the Btrfs manually. [ ... ] But SLES finds from where I
> don't know a UUID (see screenshot). This UUID is commented out
> in fstab and replaced by /dev/vg1/lv_root. Using
> /dev/vg1/lv_root I can manually mount my Btrfs without any
> problem. Where does my SLES find that UUID ?

This sounds like a SLES issue, rather than a Btrfs one.

But it could simply be that you have forgotten to refresh the
'initramfs' with 'mkinitrd' after modifying the '/etc/fstab'.
