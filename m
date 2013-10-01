Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab3JANjV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 09:39:21 -0400
Date: Tue, 1 Oct 2013 15:39:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
Message-ID: <20131001133919.GE18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com>
 <1380468336-5170-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380468336-5170-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 29, 2013 at 11:25:36PM +0800, Anand Jain wrote:
> It needs a lot more information about the snapshots if
> snapshot's life cycle has to be all auto managed by
> scripts _some day_.  this patch is a step towards that.
> 
> This patch provides the size which would be freed
> if the subvol/snapshot is deleted.
> preview:
> ---------------------
> btrfs su show /btrfs/sv1
> ::
> 	Unshared space: 	89.09MiB

Useful information, but it takes time to calculate the number. The tree
search ioctl has significant overhead and seeking all over the extent
tree can be also lengthy. I've tried it on a random subvolume on a SSD
disk and it's been running 10 minutes already, one cpu is at 100%.

david
