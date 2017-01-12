Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62467 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbdALUFV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 15:05:21 -0500
MIME-Version: 1.0
Message-ID: <trinity-cdbe1c89-7f18-4b55-8267-334164bb60d9-1484251515606@3capp-mailcom-bs11>
From: "Aldo Davide" <aldodavide@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: Difference between BTRFS_IOC_SYNC and
 BTRFS_IOC_START_SYNC/BTRFS_IOC_WAIT_SYNC
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Jan 2017 21:05:15 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi *,

I was playing with the BTRFS_IOC_* ioctls and I noticed that there are 3 different ioctls related to syncing. So my question is, is the following

    ioctl(fd,BTRFS_IOC_SYNC);

equivalent to the following sequence:

    ioctl(fd,BTRFS_IOC_START_SYNC);
    ioctl(fd,BTRFS_IOC_WAIT_SYNC);

If not, what are their differences?

Thanks,
Aldo
