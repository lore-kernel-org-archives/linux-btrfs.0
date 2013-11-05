Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:54721 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3KEGP6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 01:15:58 -0500
Received: by mail-vb0-f54.google.com with SMTP id q12so2097608vbe.13
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 22:15:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201311051224.44255.russell@coker.com.au>
References: <201311051224.44255.russell@coker.com.au>
Date: Tue, 5 Nov 2013 07:15:57 +0100
Message-ID: <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
Subject: Re: csum failure messages
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As you were in the process of a rebalance these errors may actually be
caused by this serious bug "Btrfs: relocate csums properly with
prealloc extents".

I hit that myself with several preallocated files made by rtorrent
during a rebalance and I lost several huge files as a consequence. The
only way I could rebalance without large scale corruptions was to
manually patch the 3.11.6 kernel with the small patch that fixes the
issue.
For some reason this patch is not pushed upstream yet. I think that is
strange as it leads to corruption and actual data loss and it is 100%
reproducible with preallocated files. Only systemd logs is mentioned
in the bug reports, but in my case it was actually hitting several
terabytes of files created by rtorrent.

Mvh

Hans-Kristian Bakke


On 5 November 2013 02:24, Russell Coker <russell@coker.com.au> wrote:
> The below messages are from dmesg on a system where "btrfs balance" just
> aborted.  It's running kernel 3.11.6 (the latest Debian package).
>
> This seems to be telling me that Inode 388 is involved, but there are over 300
> subvols on that system which could contain such an Inode.
>
> I think that more information is needed for such log messages.  We need to at
> least be able to identify the subvol (is it possible to extract this from the
> numbers in the log messages?).  Ideally we would be able to identify the file
> name as well.
>
>
> [10751.637517] BTRFS info (device sda3): csum failed ino 388 off 23191552 csum
> 2566472073 private 3193692311
> [10751.646390] BTRFS info (device sda3): csum failed ino 388 off 24104960 csum
> 5219137 private 2264608335
> [10751.654472] BTRFS info (device sda3): csum failed ino 388 off 24154112 csum
> 4084831521 private 1792217768
> [10751.731830] BTRFS info (device sda3): csum failed ino 388 off 23191552 csum
> 2566472073 private 3193692311
>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
