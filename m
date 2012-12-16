Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:52182 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2LPUki (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Dec 2012 15:40:38 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2436677dak.19
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Dec 2012 12:40:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CDF3ED.8060601@libero.it>
References: <50CDCFD1.5000304@libero.it>
	<50CDF3ED.8060601@libero.it>
Date: Sun, 16 Dec 2012 14:40:38 -0600
Message-ID: <CAE5mzviNM9w_q7WSZJ_S7J9rTXUgW=qbPLuYgVAHBP5zUNybog@mail.gmail.com>
Subject: Re: unmountable partition and live distro (no space left)
From: cwillu <cwillu@cwillu.com>
To: Claudio Carbone <erupter@libero.it>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Try booting with bootflags=ro,recovery in grub (with the latest
possible kernel), or mounting with -o recovery from the livecd
(likewise).  If it works, then you're done, you should be able to boot
normally after a clean umount and shutdown.  If it doesn't, post dmesg
from the attempt.

> I'v been told this is missing relevant details.
> The original kernel version was 3.2.0-something (standard Ubuntu 12.04 LTS).
> I've since upgraded to 3.7 but this has made no difference.
> Right now I don't have the dmesg, I'll post it later.
>
> Currently I've been able to mount the partition with btrfs-restore and am
> trying to rsync it on another ext4 volume.

Terminology note: btrfs-restore doesn't "mount" anything, it just
copies files directly from a device.
