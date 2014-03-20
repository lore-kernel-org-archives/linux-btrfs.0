Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559AbaCTSV4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 14:21:56 -0400
Date: Thu, 20 Mar 2014 19:21:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: all super blocks of the replaced disk must be
 scratched
Message-ID: <20140320182154.GM29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1395057486-4341-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395057486-4341-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 17, 2014 at 07:58:06PM +0800, Anand Jain wrote:
> In a normal scenario when sys-admin replaces a disk, the
> expeted is btrfs will release the disk completely.
> 
> However the below test case gives a wrong impression that
> replaced disk is still is in use.
> 
> $ btrfs rep start /dev/sde /dev/sdg4 /btrfs
> $ mkfs.btrfs /dev/sde
> /dev/sde appears to contain an existing filesystem (btrfs).
> Error: Use the -f option to force overwrite.

(your signed-off is missing)

Reviewed-by: David Sterba <dsterba@suse.cz>

I've noticed that btrfs_rm_device also cleans only the first superblock
signature, so it should do the same.

I can't think of any drawback where all the superblocks are scratched,
should be safe.
