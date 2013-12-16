Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49814 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3LPGSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 01:18:33 -0500
Received: by mail-pa0-f41.google.com with SMTP id lf10so2532430pab.28
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 22:18:33 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs send in 3.12 : can't find snapshot?
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <87y53lqx88.fsf@maru2.md5i.com>
Date: Mon, 16 Dec 2013 14:18:24 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4231AC1F-47B3-441B-B56D-53462F4FEF38@gmail.com>
References: <87y53lqx88.fsf@maru2.md5i.com>
To: Michael Welsh Duggan <mwd@md5i.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Michael,

> I built the new btrfs-progs 3.12 recently.  I note that the version
> information doesn't seem to match this:
> 
>    # ./btrfs --version
>    Btrfs v0.20-rc1-358-g194aa4a
> 
> Regardless, I was trying to use btrfs send (which worked in the older
> btrfs), and failed.  Here's an example:
> 
>    # ./btrfs send -vvv -p /snapshots/bo /snapshots/bp  > /dev/null
>    At subvol /snapshots/bp
>    ERROR: open @/snapshots/bp failed. No such file or directory
> 
> Any idea what might be going on here?
> 
> Here's the volume information:
> 
>    # ./btrfs sub show /
>    /
>            Name:                   @
>            uuid:                   e5e505d6-1309-8447-b51e-73f08c9401d1
>            Parent uuid:            156f93b9-1175-dc42-a1ee-65c00c5dcc2a
>            Creation time:          2013-07-17 20:44:46
>            Object ID:              259
>            Generation (Gen):       296321
>            Gen at creation:        20
>            Parent:                 5
>            Top Level:              5
>            Flags:                  -
>            Snapshot(s):
>                                    snapshots/bo
>                                    snapshots/bp
> 
> Kernel information:

Here it seemed that you changed your default sub-volume.(259 not 5)
I sent a patch before to fix this problem, it has not been pushed into chris's master branch, patch url is:

https://patchwork.kernel.org/patch/3258971/

But is has been pushed into david's latest integration branch , you can pull from:

git pull http://github.com/kdave/btrfs-progs.git integration-20131211

Hopely it can fix your problem.^_^


Thanks,
Wang
> 
>    # uname -a
>    Linux maru2 3.11-2-amd64 #1 SMP Debian 3.11.10-1 (2013-12-04) x86_64 GNU/Linux
> 
> -- 
> Michael Welsh Duggan
> (md5i@md5i.com)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

