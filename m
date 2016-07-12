Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbcGLQGJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 12:06:09 -0400
Date: Tue, 12 Jul 2016 18:06:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V20 19/19] Btrfs: subpage-blocksize: Rate limit scrub
 error message
Message-ID: <20160712160618.GE10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1467606879-14181-20-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467606879-14181-20-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 04, 2016 at 10:04:39AM +0530, Chandan Rajendra wrote:
> btrfs/073 invokes scrub ioctl in a tight loop. In subpage-blocksize
> scenario this results in a lot of "scrub: size assumption sectorsize !=
> PAGE_SIZE " messages being printed on the console. To reduce the number
> of such messages this commit uses btrfs_err_rl() instead of
> btrfs_err().
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

I'll pick this one independently.
