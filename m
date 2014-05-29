Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbaE2Oty (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 10:49:54 -0400
Date: Thu, 29 May 2014 16:49:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH 2/4] btrfs: dev add should add its sysfs entry
Message-ID: <20140529144951.GE29992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
 <1401096626-13210-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401096626-13210-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 26, 2014 at 05:30:24PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> we would need the device links to be created,
> when device is added.

Looks good (plus the btrfs_ prefix mentioned before).

Reviewed-by: David Sterba <dsterba@suse.cz>

I was comparing it to Jeff's patch and I think Anand's version is
cleaner because it uses helpers that conveniently wrap the
bdev/part_to_dev trickery.

There's one difference in btrfs_init_new_device, where the
add_membership is called, but both locations look correct to me.
