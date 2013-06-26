Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33852 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3FZTeu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 15:34:50 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C83547C0427
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 13:34:49 -0600 (MDT)
Date: Wed, 26 Jun 2013 15:34:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, <xfs@oss.sgi.com>,
        <linux-btrfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: check if the scratch dev pool is mounted in
 _require_scratch
Message-ID: <20130626193446.GO4288@localhost.localdomain>
References: <1372261768-1795-1-git-send-email-jbacik@fusionio.com>
 <20130626191804.GA20692@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130626191804.GA20692@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 26, 2013 at 12:18:04PM -0700, Zach Brown wrote:
> > $SCRATCH_DEV, so anybody who wants to just use the scratch mnt with the scratch
> > dev will fail to work because we never unmount the scratch mount.
> 
> Yeah, this is annoying.
> 
> > Fix this by
> > checking to see if the scratch dev pool is mounted at scratch mnt and unmount it
> > so we can run our test.  This fixes the issue I was seeing by running
> 
> But this fix seems bonkers.  Can we have _scratch_unmount unmount the
> mountpoint instead of the device?  That's what Eric suggested when I
> whined about this a while ago.
> 

Well actually we probably need both, since we need callers of _scratch_umount to
actually work.  But my patch is slightly wrong, I need to be making sure the
device is actually mounted at scratch mnt before I unmount it, otherwise error
out.  Thanks,

Josef
