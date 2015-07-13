Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f54.google.com ([209.85.216.54]:42200 "EHLO
	mail-vn0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbGMC01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 22:26:27 -0400
Received: by vnbf62 with SMTP id f62so43061165vnb.9
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2015 19:26:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150713012350.ZA6925@many.eyes.bnd.bund.de>
References: <20150713012350.ZA6925@many.eyes.bnd.bund.de>
Date: Sun, 12 Jul 2015 20:26:26 -0600
Message-ID: <CAJCQCtRtndhZXaQgZ9gLi+iRjWT9Aakgm43KAiTuO-wvsqrgHw@mail.gmail.com>
Subject: Re: Btrfs read-only after btrfs-convert from Ext4 & workaround
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Ren=C3=A9_Pfeiffer?= <lynx@luchs.at>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 12, 2015 at 7:23 PM, René Pfeiffer <lynx@luchs.at> wrote:
> Hello!
>
> I also hit the Btrfs read-only after btrfs-convert bug when converting my
> Ext4 root filesystem with btrfs-convert. I used the btrfs tools v4.0 and
> Linux kernel 4.1.1.
>
> As a workaround I mounted the converted Btrfs read-only and copied it to a
> new Btrfs created by mkfs.btrfs (from the btrfs tools v4.0). Debian 8
> system booted without problems, and the bug hasn't been seen (so far).
>
> Output of uname, btrfs, and the dmesg log is attached. Let me know if you
> need anything else. The old Btrfs is still on another disk, and I can
> extract information from it.

If you can run 'btrfs check' on it (without repair) using btrfs-progs
4.0, and 3.19.1, and report the results of each, that would be really
useful.

-- 
Chris Murphy
