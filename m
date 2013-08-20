Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:56271 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab3HTRTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 13:19:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21011.42147.72271.724888@localhost.localdomain>
Date: Tue, 20 Aug 2013 19:17:23 +0200
From: lutz.euler@freenet.de (Lutz Euler)
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: BUG at fs/btrfs/relocation.c:1055 during balance.
In-Reply-To: <20130820163840.GF3990@localhost.localdomain>
References: <21010.37299.189607.141474@localhost.localdomain>
	<20130820163840.GF3990@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On Mon, Aug 19, 2013 at 11:44:19PM +0200, Lutz Euler wrote:
> > Hi,
> > 
> > during a balance I got the BUG from the subject line, followed by
> > BUG: unable to handle kernel paging request at 000000000008a940.
> This should be fixed in btrfs-next.  Thanks,

Thanks for the info. That is great!

Unfortunately, I am reluctant to run btrfs-next, but I intend to add an
additional device to this filesystem in the near future and run balance
again then, so could you point me to a commit id in btrfs-next with the
fix? Then I could try to patch 3.6.11-rc6 with that commit or would at
least be able to notice when the fix is going to Linus' tree.

Thanks again,

Lutz
