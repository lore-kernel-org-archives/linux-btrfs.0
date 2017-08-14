Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:37782 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbdHNXkb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 19:40:31 -0400
Received: by mail-ua0-f181.google.com with SMTP id f9so42366724uaf.4
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 16:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170814225740.GK19638@pontus.sran>
References: <20170814225740.GK19638@pontus.sran>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 14 Aug 2017 17:40:30 -0600
Message-ID: <CAJCQCtR6CXOC+veFEWoC1aC+BvKgwpnAZ_ZsA2acuLRNwybkTw@mail.gmail.com>
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
To: Piotr Szymaniak <szarpaj@grubelek.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 4:57 PM, Piotr Szymaniak <szarpaj@grubelek.pl> wrote:

>
> and... some issues:
> ~ # btrfs fi du -s /mnt/red/\@backup/
>      Total   Exclusive  Set shared  Filename
> ERROR: cannot check space of '/mnt/red/@backup/': Inappropriate ioctl for device


It's a bug, but I don't know if any devs are working on a fix yet.

The problem is that the subvolume being snapshot, contains subvolumes.
The resulting snapshot, contains an empty directory in place of the
nested subvolume(s), and that is the cause for the error.


Other messages on this:
https://www.spinics.net/lists/linux-btrfs/msg67330.html
https://www.spinics.net/lists/linux-btrfs/msg61883.html



-- 
Chris Murphy
