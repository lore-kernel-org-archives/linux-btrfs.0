Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34677 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbcEDR63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 13:58:29 -0400
Received: by mail-oi0-f44.google.com with SMTP id k142so74763282oib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 10:58:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
	<pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
Date: Wed, 4 May 2016 11:58:28 -0600
Message-ID: <CAJCQCtSg7f_U2bJ8UpbEDJwn2d2GGJFKx5yss2tOWS-AdWGJfw@mail.gmail.com>
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Niccolò Belli posted on Wed, 04 May 2016 11:46:10 +0200 as excerpted:
>
>> Hi,
>> I have the following options for my rootfs in /etc/fstab:
>> rw,relatime,compress=lzo,ssd,discard,space_cache,autodefrag,
>> subvolid=257,subvol=/@

The combination of subvolid and subvol is rejected in recent kernels.
I don't know if it's rejected only if they point to different fs
trees, or if it's always rejected to have both. In any case, both does
not make sense. Pick one.




>>
>> grub2 already placed rootflags=subvol=@ in its cmdline, but not the
>> other options.

Separate them with a comma, it's valid just as it is in fstab. All you
appear to need are:

rootflags=autodefrag,discard,compress=lzo,subvolid=257

ssd should be automatically detected unless the volume is on dmcrypt
or lvm or raid. rw, relatime, space_cache are defaults. Discard is
only advised if your SSD supports queued trim, otherwise you should
rely on the systemd fstrim.timer service being enabled instead.
Everything else in your fstab is already the default.






-- 
Chris Murphy
