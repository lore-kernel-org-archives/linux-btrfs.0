Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:43448 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdIREXX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 00:23:23 -0400
Received: by mail-lf0-f50.google.com with SMTP id c80so6696799lfh.0
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 21:23:23 -0700 (PDT)
Subject: Re: ERROR: parent determination failed (btrfs send-receive)
To: Dave <davestechshop@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
Date: Mon, 18 Sep 2017 07:23:20 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.09.2017 05:31, Dave пишет:
> Sometimes when using btrfs send-receive, I get errors like this:
> 
> ERROR: parent determination failed for <subvolume name>
> 
> When this happens, btrfs send-receive backups fail. And all subsequent
> backups fail too.
> 
> The issue seems to stem from the fact that an automated cleanup
> process removes certain earlier subvolumes. (I'm using Snapper.)
> 
> I'd like to understand exactly what is happening so that my backups do
> not unexpectedly fail.
> 

You try to send incremental changes but you deleted subvolume to compute
changes against. It is hard to tell more without seeing subvolume list
with uuid/parent uuid.

> In my scenario, no parent subvolumes have been deleted from the
> target. Some subvolumes have been deleted from the source, but why
> does that matter? I am able to take a valid snapshot at this time and
> every snapshot ever taken continues to reside at the target backup
> destination (seemingly meaning that a parent subvolume can be found at
> the target).
> 
> This issue seems to make btrfs send-receive a very fragile backup
> solution. 

btrfs send/receive is not backup solution - it is low level tool that
does exactly what it is told to do. You may create backup solution that
is using btrfs send/receive to transfer data stream, but then do not
blame tool for incorrect usage.

To give better advice how to fix your situation you need to describe
your backup solution - how exactly you select/create snapshots.

I hope, instead, there is some knowledge I'm missing, that
> when learned, will make this a robust backup solution.
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

