Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35878 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbbGHCrG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 22:47:06 -0400
Date: Wed, 8 Jul 2015 10:45:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Weber <wb@munzinger.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: WARNING:  at /fs/btrfs/extent-tree.c:4029
 btrfs_free_reserved_data_space
Message-ID: <20150708024541.GA22583@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <6617728.KSCQs1dauk@o3-3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6617728.KSCQs1dauk@o3-3>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 29, 2015 at 11:35:12AM +0200, David Weber wrote:
> Hi,
> 
> we are testing Btrfs as a kvm storage system with 
> "defaults,space_cache,nodatacow" mount options and regular snapshots. While 
> testing we sometimes get these warnings:
> WARNING: CPU: 5 PID: 11335 at /home/kernel/COD/linux/fs/btrfs/extent-
> tree.c:4029 btrfs_free_reserved_data_space+0x102/0x110 [btrfs]()
> 
> Full log:
> https://gist.github.com/anonymous/5f672f72899a3d52c20c
> 
> Once they start, they flood dmesg with several messages per second. After a 
> reboot, it takes a while until they start to appear again. 
> We have seen them with Linux 4.0.6 and 4.1
> 
> This was already reported a few times:
> https://bugzilla.opensuse.org/show_bug.cgi?id=904023
> https://bugzilla.redhat.com/show_bug.cgi?id=1173937
> http://www.spinics.net/lists/linux-btrfs/msg39069.html
> https://lkml.org/lkml/2014/10/22/899
> 
> Always with no solution
> Is this a real problem or can we safely ignore this?

Didn't notice this mail but it looks like thia patch is promising to fix
your issue, worth giving a shot.

https://patchwork.kernel.org/patch/6623001/
Btrfs: fix warning of bytes_may_use

BTW, this's been queued for the next merge, so you can try the latest
btrfs from integration-4.2 of the offical btrfs repo[1].

[1]: https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git

Thanks,

-liubo

> 
> Cheers,
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
