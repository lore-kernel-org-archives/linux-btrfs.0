Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35991 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdHGBZf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Aug 2017 21:25:35 -0400
Received: by mail-wm0-f41.google.com with SMTP id t201so56922655wmt.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Aug 2017 18:25:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1502030988.13428.5.camel@cloud.haefemeier.eu>
References: <1502030988.13428.5.camel@cloud.haefemeier.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 6 Aug 2017 19:25:33 -0600
Message-ID: <CAJCQCtQwU_bF9mSLEJ7uNzb_GWS8Ne1tVxXoWVcC2NhtGau_dw@mail.gmail.com>
Subject: Re: Save to use 'clear_cache' in mount -o remount?
To: Cloud Admin <admin@cloud.haefemeier.eu>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 6, 2017 at 8:49 AM, Cloud Admin <admin@cloud.haefemeier.eu> wrote:
> Hi,
> is it safe (has it an effect?) to use the 'clear_cache' option in a
> 'mount -o remount'? I recognize messages in my kernel log regarding
> 'BTRFS info (device dm-7): The free space cache file (31215079915520)
> is invalid. skip it'. I would like to fix it and would do it (in best
> case) without rebooting.

It is safe and the cache is immediately rebuilt. You will see
'space_cache,clear_cache' as mount options, which is normal and you
can ignore. I just tried this with a remount and I get the expected
messaging.

[  400.465624] BTRFS info (device sda7): force clearing of disk cache
[  400.465639] BTRFS info (device sda7): disk space caching is enabled




Chris Murphy
