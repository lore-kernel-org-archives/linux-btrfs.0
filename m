Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58108 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdISIcG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 04:32:06 -0400
Subject: Re: btrfs-progs: suggestion of removing --commit-after option of
 subvol delete
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <46ffdb8c-025c-9557-6f0a-d9e10dd3e834@gmx.com>
Date: Tue, 19 Sep 2017 16:31:55 +0800
MIME-Version: 1.0
In-Reply-To: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月19日 15:50, Misono, Tomohiro wrote:
> Hello,
> 
> I read the code of "subvolume delete" and found that --commit-after option is
> not working well.
> 
> Since it issues BTRFS_IOC_START/WAIT_SYNC to the last fd (of directory
> containing the last deleted subvolume),
> 1. sync operation affects only the last fd's filesystem.
>     ("subvolume delete" can take multiple subvolumes on different filesystems.)
> 2. if the last delete action fails to open the path (fd == -1),
>     SYNC is not issued at all.
> 
> One solution is to keep every fd for deleted subvolumes, but I think it takes
> too much cost. Since we can just use "btrfs filesystem sync" after delete if
> needed, I think it is ok to remove --comit-after option.

Personally speaking I'm OK removing --commit-after, as implementing a 
full working --commit-after seems too complex for a minor feature.
(Need to finding the same fs of multiple subvolume and doing commit for 
each fs, and fallback to other fd if open failed)

Since --commit-after is a relatively lightweight solution compared to 
--commit-each, and both can only ensure subvolume doesn't show up, while 
"fi sync" can do a "deeper" sync to ensure the whole subvolume get 
removed on disk.

But instead of deleting the option, it would be better to keep it 
deprecated for a while.
Showing a message informing user this option is deprecated and falling 
back to --commit-each seems to be a better solution.

Thanks,
Qu
> 
> Regards,
> Tomohiro Misono
> (misono.tomohiro@jp.fujitsu.com)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
