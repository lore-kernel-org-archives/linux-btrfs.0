Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34465 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab3HHNCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 09:02:11 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B9EA29A06BE
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 07:02:10 -0600 (MDT)
Date: Thu, 8 Aug 2013 09:02:07 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Josef Bacik <jbacik@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        <viro@ZenIV.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>,
        Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130808130207.GA16712@localhost.localdomain>
References: <20130807195718.GC31381@wotan.suse.de>
 <20130807201826.GA23804@infradead.org>
 <20130807205146.GE2397@localhost.localdomain>
 <20130808121349.GC5180@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130808121349.GC5180@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 05:13:49AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 07, 2013 at 04:51:46PM -0400, Josef Bacik wrote:
> > Not possible, this will break other things as subvolumes have their own inode
> > space, it will confuse applications that get multiples of an inode number for
> > different devices with the same st_dev.  Each subvolume has it's own anonymous
> > dev to segregate things.  Thanks,
> 
> Yes, it's the same old issue of btrfs volumes misbehaving, and the
> solution is still the same as 5 years ago: make sure each subvolume
> has it's own sb, vfsmount and gets automounted, similar to what nfs4
> does for this case.

This won't work, try having 10000 subvolumes with dirty inodes and do sync then
go skiing, you'll have time :).  Thanks,

Josef
