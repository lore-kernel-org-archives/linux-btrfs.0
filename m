Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve1eur01on0083.outbound.protection.outlook.com ([104.47.1.83]:35306
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752772AbdLAOwO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 09:52:14 -0500
Subject: Re: btrfs-transacti hammering the system
To: Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
Date: Fri, 1 Dec 2017 15:52:09 +0100
MIME-Version: 1.0
In-Reply-To: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2017 03:25 PM, Matt McKinnon wrote:
> 
> Is there any way to figure out what exactly btrfs-transacti is chugging
> on?  I have a few file systems that seem to get wedged for days on end
> with this process pegged around 100%.  I've stopped all snapshots, made
> sure no quotas were enabled, turned on autodefrag in the mount options,
> tried manual defragging, kernel upgrades, yet still this brings my
> system to a crawl.
> 
> Network I/O to the system seems very tiny.  The only I/O I see to the
> disk is btrfs-transacti writing a couple M/s.
> 
> # time touch foo
> 
> real    2m54.303s
> user    0m0.000s
> sys     0m0.002s
> 
> # uname -r
> 4.12.8-custom
> 
> # btrfs --version
> btrfs-progs v4.13.3
> 
> Yes, I know I'm a bit behind there...

One of the simple things you can do is watch the stack traces of the
kernel thread.

watch 'cat /proc/<pid>/stack'

where <pid> is the pid of the btrfs-transaction process.

In there, you will see a pattern of reoccuring things, like, it's
searching for free space, it's writing out free space cache, or other
things. Correlate this with the disk write traffic and see if we get a
step further.

-- 
Hans van Kranenburg
