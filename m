Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59286 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3HTQin (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 12:38:43 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C299D9A06AB
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 10:38:42 -0600 (MDT)
Date: Tue, 20 Aug 2013 12:38:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Lutz Euler <lutz.euler@freenet.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: BUG at fs/btrfs/relocation.c:1055 during balance.
Message-ID: <20130820163840.GF3990@localhost.localdomain>
References: <21010.37299.189607.141474@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <21010.37299.189607.141474@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 19, 2013 at 11:44:19PM +0200, Lutz Euler wrote:
> Hi,
> 
> during a balance I got the BUG from the subject line, followed by
> BUG: unable to handle kernel paging request at 000000000008a940.
> The machine needed to be rebooted afterwards; the filesystem was
> successfully mounted and the balance resumed and finished successfully.
> I then ran scrub which found no errors.
> 
> I have run the same balance command several times already in the past,
> without problems. This was the first time I tried it under kernel
> 3.11.0-rc6.
> 
> Please find below:
> 
> - the balance command I issued
> - software versions
> - filesystem information (taken after the reboot and after the balance
>   finished)
> - the syslog entries from the start of the balance until the machine
>   was rebooted
> - an excerpt from syslog at reboot
> 
> Thanks for looking into this,
> 

This should be fixed in btrfs-next.  Thanks,

Josef
