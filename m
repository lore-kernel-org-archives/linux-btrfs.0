Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47119 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3HGUvt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 16:51:49 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 522D97C067E
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Aug 2013 14:51:49 -0600 (MDT)
Date: Wed, 7 Aug 2013 16:51:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Mark Fasheh <mfasheh@suse.de>, <viro@ZenIV.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130807205146.GE2397@localhost.localdomain>
References: <20130807195718.GC31381@wotan.suse.de>
 <20130807201826.GA23804@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130807201826.GA23804@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 01:18:26PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 07, 2013 at 12:57:18PM -0700, Mark Fasheh wrote:
> > stat(2) on btrfs returns a custom device, but proc uses s_dev from the super
> > block. This causes problems (abi breakage) because software (and users) are
> > not expecting the kernel to return different devices from these calls.
> 
> So fix stat on btrfs to return the proper device instead.
> 

Not possible, this will break other things as subvolumes have their own inode
space, it will confuse applications that get multiples of an inode number for
different devices with the same st_dev.  Each subvolume has it's own anonymous
dev to segregate things.  Thanks,

Josef
