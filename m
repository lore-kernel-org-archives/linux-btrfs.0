Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbbFENJx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 09:09:53 -0400
Date: Fri, 5 Jun 2015 15:09:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: btrfs_defrag_file: Fix calculation of
 max_to_defrag.
Message-ID: <20150605130951.GQ6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433323794-10045-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20150603104102.GL6761@twin.jikos.cz>
 <5453369.Yc0I2j2qX5@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5453369.Yc0I2j2qX5@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03, 2015 at 06:16:23PM +0530, Chandan Rajendra wrote:
> Consider a file having 10 4k blocks (i.e. blocks in the range [0 - 9]). If the
> defrag ioctl was invoked for the block range [3 - 6], then max_to_defrag
> should actually have the value 4. Instead in the current code we end up
> setting it to 6.
> 
> Now, this does not (yet) cause an issue since the first part of the while loop
> condition in btrfs_defrag_file() (i.e. "i <= last_index") causes the control
> to flow out of the while loop before any buggy behavior is actually caused. So
> the patch just makes sure that max_to_defrag ends up having the right value
> rather than fixing a bug. I did run the xfstests suite to make sure that no
> new regressions were introduced by this patch.

Thank, put that kind of detailed description into the changelog.
