Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34302 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaKVX0k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 18:26:40 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so2500407wiw.1
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 15:26:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141122222606.GO8916@merlins.org>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
Date: Sun, 23 Nov 2014 00:26:38 +0100
Message-ID: <CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22 November 2014 at 23:26, Marc MERLIN <marc@merlins.org> wrote:
>
> This one hurts my brain every time I think about it :)

I'm new to Btrfs so I may very well be wrong, since I haven't really
read up on it. :-)


> So, the bigger the -dusage number, the more work btrfs has to do.

Agreed.


> -dusage=0 does almost nothing
> -dusage=100 effectively rebalances everything

And -dusage=0 effectively reclaims empty chunks, right?


> But saying saying "less than 95% full" for -dusage=95 would mean
> rebalancing everything that isn't almost full,

But isn't that what rebalance does? Rewriting chunks <=95% full to
completely full chunks and effectively defragmenting chunks and most
likely reduce the number of chunks.

A -dusage=0 rebalance reduced my number of chunks from 1173 to 998 and
dev_item.bytes_used went from 1593466421248 to 1491460947968.


> Now, just to be sure, if I'm getting this right, if your filesystem is
> 55% full, you could rebalance all blocks that have less than 55% space
> free, and use -dusage=55

I realize that I interpret the usage parameter as operating on blocks
(chunks? are they the same in this case?) that are <= 55% full while
you interpret it as <= 55% free.

Which is correct?
