Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34445 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbcLLRGk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 12:06:40 -0500
Received: by mail-yw0-f171.google.com with SMTP id t125so68268018ywc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Dec 2016 09:06:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161212121935.GA4345@comcast.net>
References: <20161212121935.GA4345@comcast.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 12 Dec 2016 10:06:38 -0700
Message-ID: <CAJCQCtTd_2UgzNffSH7Wr=RYrviM_XLcair2N9a4dVwqfDstuQ@mail.gmail.com>
Subject: Re: btrfs check --repair question
To: Tim Walberg <twalberg@comcast.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 12, 2016 at 5:19 AM, Tim Walberg <twalberg@comcast.net> wrote:
> All -
>
> I have a file system I'm having some issues with. The initial symptoms were that mount
> would run for several hours, either committing or rolling back transactions (primarily
> due to a balance that was running when the system was rebooted for other reasons -
> the skip_balance mount option was specified because of this), but would then be killed
> due to an OOM condition (not much else running on the box at the time - a desktop system
> where everything else was waiting for the mount to finish). That's the background. Kernel
> 4.8.1 - custom config, but otherwise stock kernel - and btrfs-tools 4.8.3.

There were some OOM related issues early in 4.8, I would try 4.8.12 or
even 4.8.14.


>
> Ran btrfs check, and the only thing it reports is a sequence of these:
>
> ref mismatch on [5400814960640 16384] extent item 0, found 1
> Backref 5400814960640 parent 5401010913280 root 5401010913280 not found in extent tree
> backpointer mismatch on [5400814960640 16384]
> owner ref check failed [5400814960640 16384]
>
> Which, to my reading are simply some missing backrefs, and probably should be one of the
> easier issues to correct, but I know --repair is still considered experimental/dangerous,
> so I thought I'd ask before I run it... Is this a case that --repair can be reasonably
> expected to handle, or would I be better off recreating the file system and restoring from
> either my saved btrfs send archives or the more reliable backups?

It might be that usebackuproot,ro mount will happen faster, and you
can update the backups. Then use --repair. It's still listed as
dangerous but it's gotten quite a bit less dangerous in later
versions.


-- 
Chris Murphy
