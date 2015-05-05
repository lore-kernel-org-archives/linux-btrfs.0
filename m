Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35783 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbEEGsg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:48:36 -0400
Received: by oign205 with SMTP id n205so132366067oig.2
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 23:48:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mi8452$i00$1@ger.gmane.org>
References: <mi8452$i00$1@ger.gmane.org>
Date: Tue, 5 May 2015 00:48:35 -0600
Message-ID: <CAJCQCtR2hZu7Dxr1PpHyTyaDYhRMeC7Rf=we59WzRCGncZ7=QA@mail.gmail.com>
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
From: Chris Murphy <lists@colorremedies.com>
To: TheJay <obiwantje@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 4, 2015 at 9:44 AM, TheJay <obiwantje@gmail.com> wrote:
> $ sudo btrfs fi show
> Label: 'roms03'  uuid: b0025417-4045-4c63-a432-0625b7cc41ea
>         Total devices 4 FS bytes used 2.67TiB
>         devid    1 size 1.36TiB used 1.36TiB path /dev/sdz
>         devid    3 size 1.36TiB used 1.36TiB path /dev/sdaa
>         devid    4 size 1.36TiB used 1.36TiB path /dev/sdab
>         *** Some devices missing

How many devices are missing?

> [Mon May  4 08:35:08 2015] BTRFS: failed to read chunk tree on sdz

That's not good. What do you get for 'btrfs check" (without --repair)?

-- 
Chris Murphy
