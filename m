Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbbJSQxw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 12:53:52 -0400
Date: Mon, 19 Oct 2015 18:52:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, chandan@mykolab.com
Subject: Re: [PATCH V2] Btrfs-progs: Do not force mixed block group creation
 unless '-M' option is specified
Message-ID: <20151019165237.GC27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444844377-19776-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444844377-19776-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 11:09:37PM +0530, Chandan Rajendra wrote:
> When creating small Btrfs filesystem instances (i.e. filesystem size <= 1GiB),
> mkfs.btrfs fails if both sectorsize and nodesize are specified on the command
> line and sectorsize != nodesize, since mixed block groups involves both data
> and metadata blocks sharing the same block group. This is an incorrect behavior
> when '-M' option isn't specified on the command line.
> 
> This commit makes optional the creation of mixed block groups i.e. Mixed block
> groups are created only when -M option is specified on the command line.

Thanks, added to the devel branch, with a basic test.

> Since we now allow small filesystem instances with sectorsize != nodesize to
> be created, we can end up in the following situation,
> 
> [root@localhost ~]# mkfs.btrfs -f -n 65536 /dev/loop0
> Node size:          65536
> Sector size:        4096
> [root@localhost ~]# mount /dev/loop0 /mnt/
> mount: mount /dev/loop0 on /mnt failed: No space left on device
> 
> The ENOSPC occurs during the creation of the UUID tree. This is because of
> things like large metadata block size, DUP mode used for metadata and global
> reservation consuming space. Also, large nodesize does not make sense on small
> filesystems, hence this should not be an issue.

Understood and accepted. We may trip over other bugs, I haven't tested
it thoroughly but want to give this change more exposure.
