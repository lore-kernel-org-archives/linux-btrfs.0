Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab3KOPH5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 10:07:57 -0500
Date: Fri, 15 Nov 2013 16:07:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fusionio.com
Subject: Re: [PATCH v4 1/3] btrfs-progs: mechanism to fetch fsinfo from
 btrfs-control
Message-ID: <20131115150755.GB8035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384514735-24761-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384514735-24761-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 07:25:33PM +0800, Anand Jain wrote:
> need fsinfo from btrfs-control that is when mount path is
> not known.
> current method of going through each mount points isn't
> efficient, and multiple subvol of a fsid could be mounted
> means extra logic to handle that. Further this will help
> to revamp check_mounted() (planned)
> 
> check_mounted is heavily used in the btrfs-progs, it
> does full scan of all the disks in the system to confirm
> if a multi-disk btrfs is mounted it doesn't scalable well
> with few hundreds luns, check_mounted for sure needs a
> revamp. using this it can be done easily. which is planned.
> 
> This patch depends on the btrfs kernel patch
> btrfs: add framework to read fs info from btrfs-control
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added patches 1-3 to integration-next due to pending kernel support
(like dedup and properties).
