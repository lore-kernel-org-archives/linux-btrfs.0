Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57136 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaENXrN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 19:47:13 -0400
Date: Wed, 14 May 2014 16:47:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15rc5 deadlock
Message-ID: <20140514234706.GC12792@merlins.org>
References: <20140514114027.GA32301@merlins.org>
 <5373616E.9070409@fb.com>
 <20140514205519.GB12849@merlins.org>
 <EB973584-8C25-4D12-9EA6-03584C38A9D7@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <EB973584-8C25-4D12-9EA6-03584C38A9D7@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 05:13:20PM -0600, Chris Murphy wrote:
> 
> On May 14, 2014, at 2:55 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > INFO: task btrfs:13329 blocked for more than 120 seconds.
> 
> Pretty much anytime blocked for more than 120 seconds is reported, devs ask for sysrq-w. Typically that translates into three steps:
> 
> echo 1 > /proc/sys/kernel/sysrq
> echo w > /proc/sysrq-trigger
> dmesg
> 
> https://www.kernel.org/doc/Documentation/sysrq.txt
 
I took that just in case, but it's big (too long to be accepted on the
list), and inconvenient to share each time.

I was hoping the output of
legolas:~# ps -eo pid,user,args,wchan  | grep  btrfs

would do, but if not, I can upload the sysrq I have in my syslog.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
