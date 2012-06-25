Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:54650 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab2FYOUw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 10:20:52 -0400
Date: Mon, 25 Jun 2012 10:20:49 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
Message-ID: <20120625142048.GB7404@localhost.localdomain>
References: <4FE58366.8000302@profihost.ag>
 <4FE862D7.3060005@fusionio.com>
 <4FE870DF.90308@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE870DF.90308@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 08:08:31AM -0600, Stefan Priebe - Profihost AG wrote:
> Am 25.06.2012 15:08, schrieb Josef Bacik:>
>  > This isn't showing the guy who's actually trying to commit the
>  > transaction.  Next time this happens can you do a sysrq+w and capture
>  > the output and post it here so we can see what everybody is doing? 
> Thanks,
>  >
>  > Josef
> 
> No problem.
> 
> Kernel trace:
> http://pastebin.com/raw.php?i=puZkCRCn
> 
> # sys rq w trigger:
> # echo w > /proc/sysrq-trigger
> http://pastebin.com/raw.php?i=AQA8xxCX


Thats weird, sysrq+w should have a bunch of stacktraces but it's empty, so
unless theres a bug theres nothing blocked.  Is the box actually hung or is it
just taking forever?  Maybe try sysrq+w again to see if the one you pasted was
just a fluke?  Thanks,

Josef 
