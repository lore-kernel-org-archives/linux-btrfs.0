Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60213 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbeEVREc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 13:04:32 -0400
Date: Tue, 22 May 2018 19:01:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Ethan Lien <ethanlien@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Skip some btrfs_cross_ref_exist() check in
 nocow path
Message-ID: <20180522170146.GW6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180517065829.24906-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180517065829.24906-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 02:58:29PM +0800, Ethan Lien wrote:
> In nocow path, we check if the extent is snapshotted in
> btrfs_cross_ref_exist(). We can do the similar check earlier and avoid
> unnecessary search into extent tree.
> 
> A fio test on a Intel D-1531, 16GB RAM, SSD RAID-5 machine as follows:
> 
> [global]
> group_reporting
> time_based
> thread=1
> ioengine=libaio
> bs=4k
> iodepth=32
> size=64G
> runtime=180
> numjobs=8
> rw=randwrite
> 
> [file1]
> filename=/mnt/nocow/testfile
> 
> IOPS result:   unpatched     patched
> 
> 1 fio round:     46670        46958
> snapshot
> 2 fio round:     51826        54498
> 3 fio round:     59767        61289
> 
> After snapshot, the first fio get about 5% performance gain. As we
> continually write to the same file, all writes will resume to nocow mode
> and eventually we have no performance gain.
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>
> ---
> 
> V2:
>  Add comment and performance test.

Thanks, I maybe edit the comments further as do not feel like I
understand why the shortcut can be safely taken just from reading it,
but the code looks ok otherwise. I'll add the patch to for-next.
