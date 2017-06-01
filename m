Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34874 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdFAU0s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 16:26:48 -0400
Received: by mail-wm0-f53.google.com with SMTP id b84so2545332wmh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jun 2017 13:26:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170601173510.GA22952@lim.localdomain>
References: <20170526002631.8546-1-bo.li.liu@oracle.com> <CAMG9ccwjBmP9HKkodwARxQK7AkC68HACMzuT43wX6+gmWVUjbg@mail.gmail.com>
 <20170601173510.GA22952@lim.localdomain>
From: Ivan Sizov <sivan606@gmail.com>
Date: Thu, 1 Jun 2017 23:26:26 +0300
Message-ID: <CAMG9ccwxQn172kpUR61hp8OV_H+rRx4BQhRvMpUs4qn4DKic+Q@mail.gmail.com>
Subject: Re: [PATCH 0/6] add sanity check for extent inline ref type
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-01 20:35 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
> After I went through the output of leaf's content, most parts of the
> leaf is sane except the two corrupted items, it's still not clear to
> me what caused the corruption, there could be some corner cases that
> I'm not aware of.
>
> If fsck doesn't work for you, then a recovery from backup may be the
> best option.

I don't need to run any repair procedures because system is working
normally. Most likely that corrupted extents belong to files located
somewhere in /home.
Do you mean I should run fsck in order to determine which files are
corrupted? What are proper options to run fsck with?

-- 
Ivan Sizov
