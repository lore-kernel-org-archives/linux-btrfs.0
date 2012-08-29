Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:59635 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2H2OfF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 10:35:05 -0400
Date: Wed, 29 Aug 2012 10:35:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer
 rcu_string_strdup.constprop.63+0x14/0x48
Message-ID: <20120829143501.GB2272@localhost.localdomain>
References: <20120824174233.GB18380@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120824174233.GB18380@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 24, 2012 at 11:42:33AM -0600, Marc MERLIN wrote:
> With 3.5.2, I created 5 dm-crypted devices from 5 drives.
> I created a raid0 btrfs filesystem and wrote stuff to it.
> One drive died.
> 

I fixed this in btrfs-next, please build that and verify it fixes your problem.
Thanks,

Josef
