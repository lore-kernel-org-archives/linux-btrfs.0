Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54193 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab3HHPo4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 11:44:56 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4F57A7C06A3
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 09:44:56 -0600 (MDT)
Date: Thu, 8 Aug 2013 11:44:54 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Josef Bacik <jbacik@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        <viro@ZenIV.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>,
        Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130808154454.GF16712@localhost.localdomain>
References: <20130807195718.GC31381@wotan.suse.de>
 <20130807201826.GA23804@infradead.org>
 <20130807205146.GE2397@localhost.localdomain>
 <20130808121349.GC5180@infradead.org>
 <20130808130207.GA16712@localhost.localdomain>
 <20130808134805.GB24181@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130808134805.GB24181@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 06:48:05AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 08, 2013 at 09:02:07AM -0400, Josef Bacik wrote:
> > This won't work, try having 10000 subvolumes with dirty inodes and do sync then
> > go skiing, you'll have time :).  Thanks,
> 
> Why would the dirty inodes make any difference?  If you share the bdi
> between the subvolumes the sync workflow should be exactly the same
> still.
> 

If we could dis-entangle vfsmounts from sb's and have it so you could have
multiple vfsmounts with just one sb that would solve at least the in-kernel
confusion, but I think we still have the userspace confusion.  Thanks,

Josef
