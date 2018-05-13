Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:38456 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbeEMLzd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 May 2018 07:55:33 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Rolf Wald <rolf.wald@lug-balista.de>
Cc: <faurepierr@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs installation advices
Date: Sun, 13 May 2018 13:55:27 +0200
MIME-Version: 1.0
Message-ID: <f590ec5e-f3f3-4fc3-a2be-b8f531821a34@linuxsystems.it>
In-Reply-To: <63a6c2b4-79ab-18bd-2e24-6acf10b2fd63@lug-balista.de>
References: <a064411e-dcec-ecc8-98b9-98cb86284f1e@gmail.com>
 <63a6c2b4-79ab-18bd-2e24-6acf10b2fd63@lug-balista.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On martedì 8 maggio 2018 09:50:23 CEST, Rolf Wald wrote:
> You need to build three partitions, e.g. named boot, swap, root.

You don't need to use an unencrypted boot if you use grub:
https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Encrypted_boot_partition_.28GRUB.29

A few hints for btrfs + LUKS + swap:
https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Btrfs_subvolumes_with_swap

Another solution is to use SED, as someone mentioned:
https://wiki.archlinux.org/index.php/Self-Encrypting_Drives

The only downside is that you can rest assured there will be NSA backdoors 
in hardware crypto.

Even better I suggest you to move to ZFS and use Native Encryption:
https://github.com/zfsonlinux/zfs/pull/5769

I recently got tired of btrfs never implementing things like snapshot-aware 
defrag (with no signs on the horizon that this is going to change soon) so 
I decided to switch my servers to ZFS. I'll let you know how crypto works 
if you're interested. I'll keep using btrfs on the clients though, at least 
for now.

Niccolò
