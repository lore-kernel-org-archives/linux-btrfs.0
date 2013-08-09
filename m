Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48520 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031131Ab3HIVFD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Aug 2013 17:05:03 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 969289A03DE
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Aug 2013 15:05:02 -0600 (MDT)
Date: Fri, 9 Aug 2013 17:05:00 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs: don't double brelse on device rm
Message-ID: <20130809210500.GB861@localhost.localdomain>
References: <1376080634-1714-1-git-send-email-zab@redhat.com>
 <1376080634-1714-2-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1376080634-1714-2-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 09, 2013 at 01:37:14PM -0700, Zach Brown wrote:
> Device removal currently causes bdev removal to try to double free a bh
> in the bdev:
> 
> [   55.714833] WARNING: at fs/buffer.c:1160 __brelse+0x36/0x40()
> [   55.714833] VFS: brelse: Trying to free free buffer
> 
> Commit 7e3d9ebb1 added a double release of the bh for a device being
> removed when all the supers don't fit in the device.  In that case it
> releases the bh assuming that it's going to read a new one, finds that
> it won't read, and goes to a label that releases the bh again.
> 
> All it needed to do was only brelse() right before overwriting the
> current bh with __bread().

I've dropped this patch so we don't need this anymore.  Thanks,

Josef
