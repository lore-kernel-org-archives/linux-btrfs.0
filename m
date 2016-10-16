Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ijp134o.incoming.jp ([157.7.129.17]:35002 "EHLO
        ijp134o.incoming.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754290AbcJPCeT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Oct 2016 22:34:19 -0400
Date: Sun, 16 Oct 2016 11:34:18 +0900
From: Hiroshi Honda <xero@incoming.jp>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: Unable to rescue RAID5
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <0b965ca4-014b-33f2-295b-a02feb0d7ccb@gmail.com>
References: <20161014191141.2154.13A92CCA@incoming.jp> <0b965ca4-014b-33f2-295b-a02feb0d7ccb@gmail.com>
Message-Id: <20161016113357.2159.13A92CCA@incoming.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> You should probably look at `btrfs restore`.  I'm not sure how well it works with the raid56 code, and
> you'll need somewhere to put the data being restored, but that's probably your best option.

I tried it already. and then it was "cannot read chunk root".
Please take see 1st article of this thread.
http://www.spinics.net/lists/linux-btrfs/msg59683.html
And I specified -i option for ignore errors, but same result.

1st super mirror(67108864) and 2nd super mirror(274877906944) said all
devices are missing like below. But there are all devices...
> warning, device 10 is missing
> warning, device 8 is missing
> warning, device 7 is missing
> warning, device 6 is missing
> warning, device 5 is missing
> warning, device 4 is missing
> warning, device 3 is missing
> warning, device 2 is missing
> warning, device 1 is missing
> warning, device 2 is missing
> warning, device 3 is missing
> warning, device 4 is missing
> warning, device 5 is missing
> warning, device 6 is missing
> warning, device 7 is missing
> warning, device 8 is missing
> warning, device 10 is missing
> warning, device 1 is missing

How can I avoid those missing error?
Can I restore files if I could avoid those missing errors?
Do I need change source code or Is there btrfs command or the option?

Thank you
Hiroshi Honda

