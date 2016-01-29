Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbcA2Nau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 08:30:50 -0500
Date: Fri, 29 Jan 2016 14:30:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: Re: [PATCH V10 00/12]  Btrfs: Pre subpagesize-blocksize cleanups
Message-ID: <20160129133037.GC31992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453371964-4917-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 03:55:52PM +0530, Chandan Rajendra wrote:
> The patches posted along with this cover letter are cleanups made
> during the development of subpagesize-blocksize patchset. I have
> tested the patchset by running fstests on ppc64 and x86_64 machines.

FYI, I've added this patchset to my for-next queue, scheduled fro 4.6.
Please let me know of further fixups.

More reviews appreciated, there are still some non-trivial patches
without a reviewed-by.
