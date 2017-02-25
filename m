Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:50166 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdBYUtv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Feb 2017 15:49:51 -0500
Subject: Re: BTRFS hybrid system setup issues
To: Bhasker C V <bhasker@unixindia.com>, linux-btrfs@vger.kernel.org
References: <CAPLCSGCeD5KaFmMZWCKQ8nEbMEYTeDsb4ksgxQiU7-6P7dR=3w@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1020cf90-bb59-eea4-5f82-166427b3363e@mendix.com>
Date: Sat, 25 Feb 2017 21:40:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAPLCSGCeD5KaFmMZWCKQ8nEbMEYTeDsb4ksgxQiU7-6P7dR=3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2017 08:30 PM, Bhasker C V wrote:
> Hi all,
> 
>   I have an x86_64 kernel running with i386 userland rootfs.

Which kernel version? (`uname -a`)

>  Long back I believe there were some fixes for btrfs-tools which ran
> smoothly in this setup but after several dist-upgrades(debian) and
> long forgotten command, the btrfs-tools commands have started to fail

Which btrfs progs version? (`btrfs version`)

> for instance
> 
> $ sudo btrfs fi sync  .
> ERROR: sync ioctl failed on '.': Inappropriate ioctl for device
> $
> 
> Is there any fix for this ? I downloaded the git master branch and it
> too seems to suffer from this issue.

Maybe this is relevant here:
https://www.spinics.net/lists/linux-btrfs/msg62692.html

-- 
Hans van Kranenburg
