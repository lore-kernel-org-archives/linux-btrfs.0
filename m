Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:37344 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbdIGOnW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 10:43:22 -0400
Received: by mail-lf0-f53.google.com with SMTP id 80so20279864lfy.4
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Sep 2017 07:43:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ed7cf7b6-e848-e581-e079-6c0cec383140@prismatelecomtesting.com>
References: <737e0bff-dad1-d779-4de8-46f8995d5f42@prismatelecomtesting.com>
 <20170905162718.GC14677@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <315fef6d-e60a-3155-e10c-bebdf21cb55a@prismatelecomtesting.com>
 <CAEtw4r0By7Gmdo6=yFKi2t6LyKHAOygKdMW-+2OUkQ041zWZ7Q@mail.gmail.com> <ed7cf7b6-e848-e581-e079-6c0cec383140@prismatelecomtesting.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Thu, 7 Sep 2017 16:43:20 +0200
Message-ID: <CAEtw4r0vY0SanSuLfx1+TKbxY7h85wZTf6TKOhV_j-+exWCG0w@mail.gmail.com>
Subject: Re: Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Cc: bo.li.liu@oracle.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-07 16:37 GMT+02:00 Marco Lorenzo Crociani
<marcoc@prismatelecomtesting.com>:
[...]
> I got:
>
> 00-49:  1
> 50-79:  0
> 80-89:  0
> 90-99:  1
> 100:    25540
>
> this means that fs has only one block group used under 50% and 1 between 90
> and 99% while the rest are all full?
>

yes .. imo, balance wouldn't help
