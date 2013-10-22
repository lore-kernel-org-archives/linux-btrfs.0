Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58548 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3JVSRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 14:17:41 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 463DE9A06BC
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 12:17:41 -0600 (MDT)
Date: Tue, 22 Oct 2013 14:17:36 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin <m_btrfs@ml1.co.uk>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: 8 days looped? (btrfsck --repair --init-extent-tree)
Message-ID: <20131022181736.GB27304@localhost.localdomain>
References: <l46ece$pi4$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <l46ece$pi4$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 06:58:48PM +0100, Martin wrote:
> Dear list,
> 
> I've been trying to recover a 2TB single disk btrfs from a good few days
> ago as already commented on the list. btrfsck complained of an error in
> the extents and so I tried:
> 
> btrfsck --repair --init-extent-tree /dev/sdX
> 
> 
> That was 8 days ago.
> 
> The btrfs process is still running at 100% cpu but with no disk activity
> and no visible change in memory usage.
> 
> Looped?
> 
> Is there any way to check whether it is usefully doing anything or
> whether this is a lost cause?
> 
> 
> The only output it has given, within a few seconds of starting, is:
> 
> 
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> parent transid verify failed on 911904604160 wanted 17448 found 17449
> Ignoring transid failure
> 
> 
> Any comment/interest before abandoning?
> 
> This all started from trying to delete/repair a directory tree of a few
> MBytes of files...
> 

Sooo it probably is looped, you should be able to attach gdb to it and run bt to
see where it is stuck and send that back to the list so we can figure out what
to do.  Thanks,

Josef
