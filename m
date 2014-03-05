Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaCEOKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 09:10:32 -0500
Date: Wed, 5 Mar 2014 15:10:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: add readahead for send_write
Message-ID: <20140305141030.GI7004@suse.cz>
Reply-To: dsterba@suse.cz
References: <1393985255-16974-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393985255-16974-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 05, 2014 at 10:07:35AM +0800, Liu Bo wrote:
> Btrfs send reads data from disk and then writes to a stream via pipe or
> a file via flush.
> 
> Currently we're going to read each page a time, so every page results
> in a disk read, which is not friendly to disks, esp. HDD.  Given that,
> the performance can be gained by adding readahead for those pages.
> 
> Here is a quick test:
> $ btrfs subvolume create send
> $ xfs_io -f -c "pwrite 0 1G" send/foobar
> $ btrfs subvolume snap -r send ro
> $ time "btrfs send ro -f /dev/null"
> 
>            w/o             w
> real    1m37.527s       0m9.097s
> user    0m0.122s        0m0.086s
> sys     0m53.191s       0m12.857s
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
