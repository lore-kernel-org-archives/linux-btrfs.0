Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30275 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751913AbcLSExy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Dec 2016 23:53:54 -0500
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
To: <bepi@adria.it>, <linux-btrfs@vger.kernel.org>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <83dbcf2c-df10-5628-fc46-9d33a7bf78af@cn.fujitsu.com>
Date: Mon, 19 Dec 2016 12:53:45 +0800
MIME-Version: 1.0
In-Reply-To: <1479730155.5832e3eb3fde8@webmail.adria.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/21/2016 08:09 PM, bepi@adria.it wrote:
> Hi.
>
> My system: Fedora 23, kernel-4.7.10-100.fc23.x86_64 btrfs-progs-4.4.1-1.fc23.x86_64
>
> Testing the remote differential receive (via ssh and in local network) of 24
> sequential snapshots, and simultaneously deleting the snapshot, (in the same
> file system, but in a different subvolume), there has been an file access error,
> and the file system has corrupt.

Are you using qgroup?

IIRC, Filipe fixed a problem which could cause backref corruption which 
only happens if quota is enabled.

Thanks,
Qu

>
> Both scrub, both recovery and clear_cache mount options, both btrfsck, have
> failed, the file system is left in a state unusable.
>
> After reformatting the filesystem, remote receive of 24 snapshots worked properly.
>
> The file system is used exclusively for receive the snapshot, it is composed of
> a single device.
> The initial snapshot is a linux installation of 50Gb.
>
>
> I think that there was a race condition between the receive and deletion of
> snapshots (that were performed on two different subvolume).
>
>
> Best regards.
>
> gdb
>
> ----------------------------------------------------
> This mail has been sent using Alpikom webmail system
> http://www.alpikom.it
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


