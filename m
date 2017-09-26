Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54889 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965823AbdIZNUH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 09:20:07 -0400
Subject: Re: [PATCH 0/4] btrfs-progs: subvol: fix del --commit-after
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ccb62e7b-8a1f-c515-8daf-f1d982fff32e@gmx.com>
Date: Tue, 26 Sep 2017 21:19:56 +0800
MIME-Version: 1.0
In-Reply-To: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月26日 13:44, Misono, Tomohiro wrote:
> Fix subvol del --commit-after to work properly:
>   - SYNC ioctl will be issued even when last delete is failed
>   - SYNC ioctl will be issued on each file system only once in the end
> 
> To achieve this, each deleted subvol's (parent's) fsid is checked each
> time. If the fsid is seen for the first time, its fd will be kept in order
> to issue SYNC ioctl in the end.
> 
> There already exists get_fsid() in cmds-property.c and seen_fsid which
> keeps fsid in hush function in cmds-filesystem.c. First three patches
> make them to common functions and last one is the main part.

Much more elegant than my expectation.
Clean and short fix.

Only small suggestion to use fd list other than using the last valid fd 
(for patch 3), and a possible patch split (for patch 4).

Looks good overall.
You can add my reviewed-by tag after splitting cleanup patch.

Good job.

Thanks,
Qu
> 
> Tomohiro Misono (4):
>    btrfs-progs: move get_fsid() to util.c
>    btrfs-progs: move seen_fsid to util.c
>    btrfs-progs: change seen_fsid to hold fd and DIR*
>    btrfs-progs: subvol: fix subvol del --commit-after
> 
>   cmds-filesystem.c |  88 +++------------------------------------------
>   cmds-property.c   |  30 ----------------
>   cmds-subvolume.c  |  77 ++++++++++++++++++++++++++++-----------
>   utils.c           | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   utils.h           |  15 ++++++++
>   5 files changed, 181 insertions(+), 134 deletions(-)
> 
