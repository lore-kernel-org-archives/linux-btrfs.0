Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55037 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751242AbdIQXdw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 19:33:52 -0400
Subject: Re: cp --reflink and qgroup limit
To: Antoine Belvire <antoine.belvire@laposte.net>, linux-btrfs@vger.kernel.org
References: <d424bbbb-3c11-e874-9b12-4bae12e3d07e@laposte.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7eeb31e6-0145-2923-443e-e1e2b3bef79c@gmx.com>
Date: Mon, 18 Sep 2017 07:33:46 +0800
MIME-Version: 1.0
In-Reply-To: <d424bbbb-3c11-e874-9b12-4bae12e3d07e@laposte.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月17日 22:45, Antoine Belvire wrote:
> Hello,
> 
> The behavior of 'cp --reflink' puzzles me from the quota point of view.
> 
> It looks like it's possible to easily exceeds a qgroup's max_rfer limit 
> like this:
> 
> ~# # Create '/test' and '/test/a' subvolumes
> ~# btrfs subvolume create /test
> ~# btrfs subvolume create /test/a
> ~#
> ~# # Set limits
> ~# btrfs qgroup limit 10m (qgroupid) /
> ~# btrfs qgroup limit -e 5m (qgroupid) /
> ~#
> ~# # Limits are set
> ~# btrfs qgroup show -erF /test/a/
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> (the id)     16.00KiB     16.00KiB     10.00MiB      5.00MiB
> ~#
> ~# # Write a big file in '/test'
> ~# dd if=/dev/urandom of=/test/bigfile bs=1M count=50
> ~#
> ~# # Copy it to '/test/a' using cp --reflink
> ~# cp --reflink /test/bigfile /test/a
> ~#
> ~# # No EDQUOT error, quota limit is exceeded
> ~# btrfs qgroup show --sync -erF /test/a/
> qgroupid         rfer         excl     max_rfer     max_excl
> --------         ----         ----     --------     --------
> (the id)     50.02MiB     16.00KiB     10.00MiB      5.00MiB
> ~#
> 
> However, now the limit is exceeded, EDQUOT is raised upon a new 'cp 
> --reflink':
> 
> ~# touch /test/nothing
> ~# cp --reflink /test/nothing /test/a
> cp: cannot create regular file 'a/nothing': Disk quota exceeded
> ~#
> 
> As far as I understand the code, btrfs_clone doesn't try to reserve data 
> it clones. It only reserves metadata through btrfs_start_transaction.

That's a bug, and should be fixed.

But it's a little complicated to fix.
The biggest problem is, until reflink is done and we commit a 
transaction, we don't know if the the reflink operation will increase 
"rfer" or not.
(Considering a case where both reflink source and destination is inside 
the same subvolume)

Yes, we can always try to reserve the size of the data, and cause false 
alert, but the handling of reserved data range will be another problem.

I'll check if we can solve it.

Thanks,
Qu
> 
> Is it an expected behavior?
> 
> Regards,
> 
> -- 
> Antoine
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
