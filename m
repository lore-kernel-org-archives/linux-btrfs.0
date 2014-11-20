Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:47929 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaKTSjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 13:39:20 -0500
Received: by mail-yh0-f41.google.com with SMTP id a41so1622689yho.28
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 10:39:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546DCD20.6030602@inwind.it>
References: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net>
	<546DBFCB.4090506@inwind.it>
	<546DC3EC.1020903@nurfuerspam.de>
	<546DCD20.6030602@inwind.it>
Date: Thu, 20 Nov 2014 11:39:19 -0700
Message-ID: <CAJCQCtT88Ji52W2za++eUiAXYq1O2hpTaHo_FZgrpNvdVEN=Gg@mail.gmail.com>
Subject: Re: systemd.setenv and a mount.unit
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 20, 2014 at 4:14 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

> Supposing to have the following four subvolumes
>
> /root/
> /root/etc
> /root/usr
> /root/var
>
> When you need to snapshot, you should:
>
> # btrfs subvolume snapshot /root /backup-root-20141120
> # btrfs subvolume snapshot /root/etc /backup-root-20141120/etc
> # btrfs subvolume snapshot /root/usr /backup-root-20141120/usr
> # btrfs subvolume snapshot /root/var /backup-root-20141120/var
>
> So in order to remount an "old" filesystem, you need to make only
> 1 mount.

I like this layout better than either the openSUSE or Fedora layouts.
It's easier to mount and old filesystem, where on Fedora each
subvolume must be explicitly mounted. And it ensures old binaries
aren't in the current mount path – kinda like running in a chroot –
where on openSUSE the snapshots containing old binaries are in the
current mount path.


-- 
Chris Murphy
