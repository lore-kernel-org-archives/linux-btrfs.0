Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbaHSPo3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:44:29 -0400
Date: Tue, 19 Aug 2014 17:44:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/8] btrfs: replace seed device followed by unmount
 causes kernel WARNING
Message-ID: <20140819154428.GA1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>
 <1407911066-5363-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407911066-5363-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 13, 2014 at 02:24:20PM +0800, Anand Jain wrote:
> reproducer:
> mount /dev/sdb /btrfs
> btrfs dev add /dev/sdc /btrfs
> btrfs rep start -B /dev/sdb /dev/sdd /btrfs
> umount /btrfs
> 
> WARNING: CPU: 0 PID: 12661 at fs/btrfs/volumes.c:891 __btrfs_close_devices+0x1b0/0x200 [btrfs]()
> ::
> 
> __btrfs_close_devices()
> ::
>         WARN_ON(fs_devices->open_devices);
> 
> After the seed device has been replaced the new target device
> is no more a seed device. So we need to update the device
> numbers in the fs_devices as pointed by the fs_info.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

A formality: if you get a reviewed-by from somebody and the patch does
not change in the next iteration, add the tag to the patch as well. This
will ensure the review credit is not lost.
Otherwise, pinging the maintainer with a forgotten reviewed-by also works.
