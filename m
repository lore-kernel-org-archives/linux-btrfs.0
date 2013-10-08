Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab3JHOQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 10:16:35 -0400
Date: Tue, 8 Oct 2013 16:16:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not defrag extent root in ioctl
Message-ID: <20131008141623.GB4322@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381227570-6829-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381227570-6829-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 06:19:30PM +0800, Liu Bo wrote:
> We can't defrag the extent root without deadlock.

Deadlock under what circumstance? Eg. with snapshot aware defag turned
on or extent tree cannot be safely defragmented at all?

david
