Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:35945 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FXPVl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 11:21:41 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 748917C035B
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 09:21:41 -0600 (MDT)
Date: Mon, 24 Jun 2013 11:21:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin Mailand <martin@tuxadero.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/backref.c:903
Message-ID: <20130624152139.GG4288@localhost.localdomain>
References: <51C83A06.2090309@tuxadero.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51C83A06.2090309@tuxadero.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 24, 2013 at 02:22:30PM +0200, Martin Mailand wrote:
> Hi,
> 
> I tried 3.10.0-rc7 with the btrfs option skinny extents (btrfstune -x),
> I get this warning after a few seconds of ceph workload.
> 

Can you file a bug at bugzilla.kernel.org and make sure the component is set to
btrfs.  Also can you try and reproduce on btrfs-next?  I had to fix a few things
related to skinny extents and it may already be fixed.  Thanks,

Josef
