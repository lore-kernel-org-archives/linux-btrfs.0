Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i2.italiaonline.it ([212.48.25.204]:48503 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750780AbbHRMe0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 08:34:26 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [survey] sysfs layout for btrfs
References: <55CE7C78.1020509@oracle.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <55D3264F.6020002@inwind.it>
Date: Tue, 18 Aug 2015 14:34:23 +0200
MIME-Version: 1.0
In-Reply-To: <55CE7C78.1020509@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
On 2015-08-15 01:40, Anand Jain wrote:
> Hello,
> 
> as of now btrfs sysfs does not include the attributes for the volume manager part in its sysfs layout, so its being developed and there are two types of layout here below, so I have a quick survey to know which will be preferred. contenders are:
> 1. FS and VM (volume manager) attributes[1] merged sysfs layout
> 2. FS and VM attributes separated sysfs layout.
> 
> These two choices differ whether the VM attributes are amalgamate with existing FS attributes or if VM attributes are put under a kobject named "pools/volumes" under /sys/fs/btrfs. More in the below example. which would highlight the trade off between these two.
> 
> Eg for #1 (above):
> The existing sysfs for btrfs, has the top kobject <fsid>
> 
>   /sys/fs/btrfs/<fsid> <-- holds FS attr, VM attr will be added here.
>   /sys/fs/btrfs/<fsid>/devices/<uuid [2] > <-- btrfs_devices attr here
>   /sys/fs/btrfs/<fsid>/devices/<uuid>/state
>   /sys/fs/btrfs/<fsid>/devices/<uuid>/offline
> 
> we won't be able to change the sysfs entries which is already there. However we could change the context in which they are created and destroyed that is, from mount and unmount, to device scan and module unload respectively. And so this will enable us to implement the # 1 (above).
> 
> Eg for #2 (above):
> For the 2nd choice, a new 'pools or volumes' kobject will be created under existing /sys/fs/btrfs/ which will hold the VM attributes. (however note that: there will be duplicate kobjects like <fsid> both under FS and VM in this choice #2).
> 
>  /sys/fs/btrfs/<fsid> <--- as is, will continue to hold fs attributes.
>  /sys/fs/btrfs/pools/<fsid>/ <-- will hold VM attributes
>  /sys/fs/btrfs/pools/<fsid>/devices/<sdx> <-- btrfs_devices attr here
>  /sys/fs/btrfs/pools/<fsid>/devices/<sdx>/state
>  /sys/fs/btrfs/pools/<fsid>/devices/<sdx>/offline
> 
> There is certainly a small trade-off between these two. Your comments / feedback are kindly appreciated.

If the info "VM attributes" are per filesystem, I don't see any reason to put these under another subdirectory. So for this I vote #1

However I find more interesting to discuss where put the <uuid> entries.
What confusing me is that under <fsid>/devices/ there are both a link to the devices, and a directory <uuid> with disk-information..

It could be possible to get rid of the <devX> link ? I know that the official answer is "the backward compatibility must be preserved"; but who use these link today ? 
Otherwise it could be possible to create another directory (called dev-uuid/ for example) where put the <dev-uuid> ? My rationale is: if there is a collection of homogeneous entries (like a list of disk-uuid or filesystem-uuid), this collection (and only this collection) must be put in a dedicated directory.

BR
G.Baroncelli

> 
> Thanks, Anand
> 
> [1] attributes will be of the btrfs_fs_devices structure. And few newly introduced attributes like 'state', to state the volume current state.
> 
> [2] note that we can not use <sdx> here since a link to the block device already exists with that name.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
