Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:36566 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbcLIC6H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 21:58:07 -0500
Received: by mail-yw0-f176.google.com with SMTP id a10so4358176ywa.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 18:58:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 8 Dec 2016 19:58:05 -0700
Message-ID: <CAJCQCtS8zCMYYiedYpkL4bZE0PvEF+sLGG96Uq=Ms1qjd4uCpg@mail.gmail.com>
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 8, 2016 at 8:11 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

> Well, the damn thing has been running for 15 days uninterrupted !
> ...Until I [Ctrl]-C it this morning as I had to move with the machine (I
> wasn't expecting it to last THAT long...).

Can you check some bigger files and see if they've become fragmented?
I'm seeing 1.4GiB files with 2-3 extents reported by filefrag, go to
over 5000 fragments during dedupe. This is not something I recall
happening some months ago.

I inadvertently replied to the wrong dedupe thread about my test and
what I'm finding, it's here.
https://www.spinics.net/lists/linux-btrfs/msg61304.html

But if you're seeing something similar, then it would explain why it's
so slow in your case.

-- 
Chris Murphy
