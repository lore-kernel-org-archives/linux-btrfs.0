Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:10524 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbcGYAge (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 20:36:34 -0400
Date: Mon, 25 Jul 2016 10:36:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <clm@fb.com>
Cc: Gabriel C <nix.or.die@gmail.com>, linux-btrfs@vger.kernel.org,
        quwenruo@cn.fujitsu.com
Subject: Re: A lot warnings in dmesg while running thunderbird
Message-ID: <20160725003630.GT16044@dastard>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
 <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
 <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 08, 2016 at 12:02:35PM -0400, Chris Mason wrote:
> Can you please run the attached test program:
> 
> gcc -o short-write short-write.c -lpthread
> ./short-write some-new-file-on-btrfs

Hi Chris, this seems like a useful thing to be testing on a regular
basis - can you turn this into an xfstests regression test and
submit it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
