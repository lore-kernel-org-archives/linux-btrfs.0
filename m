Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:33347 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdHMSn4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 14:43:56 -0400
Received: by mail-ua0-f173.google.com with SMTP id 80so30289712uas.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Aug 2017 11:43:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1386d7aa-10c2-4463-a26b-50f2b022f6b6@email.android.com>
References: <1386d7aa-10c2-4463-a26b-50f2b022f6b6@email.android.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 13 Aug 2017 12:43:54 -0600
Message-ID: <CAJCQCtSPiDWkZjdM+rqdOBC5UxWit6cdw8GS1FFFqnk_Bm4aFw@mail.gmail.com>
Subject: Re: Btrfs data recovery
To: Christian Rene Thelen <the@len.li>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 13, 2017 at 11:12 AM, Christian Rene Thelen <the@len.li> wrote:
> I have formated an encrypted disk, containing a LVM with a btrfs system.
>
> All superblocks appear to be destroyed;

This is an unclear description. I don't understand the exact layout of
the storage stack, and what part of it you formatted. For example I
can't tell if the whole block device is encrypted, a partition is
encrypted, or if it's the LV that's encrypted. And I can't tell if the
formatting was a mistake, and what you accidentally formatted. I can't
tell if the encrypted device opens without error, if the LV is
discovered.

You need to be really clear because any changes you make dramatically
increase the chance of total data loss.

What do you get for:

$ sudo btrfs rescue super -v /dev/mapper/...


This should be the logical block device that contains the Btrfs file
system, the device you would mount (if it weren't damaged).

It's possible but somewhat unlikely that all of the supers are
damaged; but it depends on the size of the file system and what you
formatted.


-- 
Chris Murphy
