Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45340 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab3BVPym (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 10:54:42 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 68DD19A040D
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 08:54:42 -0700 (MST)
Date: Fri, 22 Feb 2013 10:54:40 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Alexandre Oliva <oliva@gnu.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: clear chunk_alloc flag on retryable failure
Message-ID: <20130222155440.GD2062@localhost.localdomain>
References: <orvc9lqsgt.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <orvc9lqsgt.fsf@livre.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 02:15:14PM -0700, Alexandre Oliva wrote:
> I've experienced filesystem freezes with permanent spikes in the active
> process count for quite a while, particularly on filesystems whose
> available raw space has already been fully allocated to chunks.
> 
> While looking into this, I found a pretty obvious error in
> do_chunk_alloc: it sets space_info->chunk_alloc, but if
> btrfs_alloc_chunk returns an error other than ENOSPC, it returns leaving
> that flag set, which causes any other threads waiting for
> space_info->chunk_alloc to become zero to spin indefinitely.
> 
> I haven't double-checked that this patch fixes the failure I've observed
> fully (it's not exactly trivial to trigger), but it surely is a bug and
> the fix is trivial, so...  Please put it in :-)

Yup putting in btrfs-next, thanks.

Josef
