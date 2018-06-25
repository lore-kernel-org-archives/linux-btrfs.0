Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57442 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934051AbeFYRet (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 13:34:49 -0400
Date: Mon, 25 Jun 2018 10:34:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: james harvey <jamespharvey20@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20180625173445.ubp2jsxjd7pnm3ce@merlins.org>
References: <20180618130055.3rzngk5a5sktfp7p@merlins.org>
 <20180619154730.fblylttw2nyps4cp@merlins.org>
 <CA+X5Wn5_TEH5zwWS8cihnadK_hFg9CL6NcT9Q28mDxtZK97Beg@mail.gmail.com>
 <ab17f789-d475-9812-9c76-83702fc2bd65@gmail.com>
 <20180625160706.qnd22zgdv2kwq6dz@merlins.org>
 <a4c188e6-865f-664d-4031-a4ca5c3d8f64@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a4c188e6-865f-664d-4031-a4ca5c3d8f64@gmail.com>
Subject: Re: btrfs balance did not progress after 12H, hang on reboot, btrfs
 check --repair kills the system still
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 01:07:10PM -0400, Austin S. Hemmelgarn wrote:
> > - mount -o recovery still hung
> > - mount -o ro did not hang though
> One tip here specifically, if you had to reboot during a balance and the FS
> hangs when it mounts, try mounting with `-o skip_balance`.  That should
> pause the balance instead of resuming it on mount, at which point you should
> also be able to cancel it without it hanging.

Very good tip, I have this in all my mountpoints :)

#LABEL=dshelf2 /mnt/btrfs_pool2 btrfs defaults,compress=lzo,skip_balance,noatime

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
