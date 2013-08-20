Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49618 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3HTSK4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 14:10:56 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A720E7C069B
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 12:10:55 -0600 (MDT)
Date: Tue, 20 Aug 2013 14:10:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Lutz Euler <lutz.euler@freenet.de>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: BUG at fs/btrfs/relocation.c:1055 during balance.
Message-ID: <20130820181053.GG3990@localhost.localdomain>
References: <21010.37299.189607.141474@localhost.localdomain>
 <20130820163840.GF3990@localhost.localdomain>
 <21011.42147.72271.724888@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <21011.42147.72271.724888@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 20, 2013 at 07:17:23PM +0200, Lutz Euler wrote:
> Josef Bacik wrote:
> > On Mon, Aug 19, 2013 at 11:44:19PM +0200, Lutz Euler wrote:
> > > Hi,
> > > 
> > > during a balance I got the BUG from the subject line, followed by
> > > BUG: unable to handle kernel paging request at 000000000008a940.
> > This should be fixed in btrfs-next.  Thanks,
> 
> Thanks for the info. That is great!
> 
> Unfortunately, I am reluctant to run btrfs-next, but I intend to add an
> additional device to this filesystem in the near future and run balance
> again then, so could you point me to a commit id in btrfs-next with the
> fix? Then I could try to patch 3.6.11-rc6 with that commit or would at
> least be able to notice when the fix is going to Linus' tree.
> 
> Thanks again,
> 

Yup it's

Btrfs: change how we queue blocks for backref checking

Thanks,

Josef
