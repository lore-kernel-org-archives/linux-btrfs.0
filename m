Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0063.outbound.protection.outlook.com ([104.47.41.63]:53504
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1165405AbeBOQSZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 11:18:25 -0500
From: Alex Adriaanse <alex@oseberg.io>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Ongoing Btrfs stability issues
Date: Thu, 15 Feb 2018 16:18:22 +0000
Message-ID: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've been using Btrfs in production on AWS EC2 with EBS devices for over 2 years. There is so much I love about Btrfs: CoW snapshots, compression, subvolumes, flexibility, the tools, etc. However, lack of stability has been a serious ongoing issue for us, and we're getting to the point that it's becoming hard to justify continuing to use it unless we make some changes that will get it stable. The instability manifests itself mostly in the form of the VM completely crashing, I/O operations freezing, or the filesystem going into readonly mode. We've spent an enormous amount of time trying to recover corrupted filesystems, and the time that servers were down as a result of Btrfs instability has accumulated to many days.

We've made many changes to try to improve Btrfs stability: upgrading to newer kernels, setting up nightly balances, setting up monitoring to ensure our filesystems stay under 70% utilization, etc. This has definitely helped quite a bit, but even with these things in place it's still unstable. Take https://bugzilla.kernel.org/show_bug.cgi?id=198787 for example, which I created yesterday: we've had 4 VMs (out of 20) go down over the past week alone because of Btrfs errors. Thankfully, no data was lost, but I did have to copy everything over to a new filesystem.

Many of our VMs that run Btrfs have a high rate of I/O (both read/write; I/O utilization is often pegged at 100%). The filesystems that get little I/O seem pretty stable, but the ones that undergo a lot of I/O activity are the ones that suffer from the most instability problems. We run the following balances on every filesystem every night:

    btrfs balance start -dusage=10 <fs>
    btrfs balance start -dusage=20 <fs>
    btrfs balance start -dusage=40,limit=100 <fs>

We also use the following btrfs-snap cronjobs to implement rotating snapshots, with short-term snapshots taking place every 15 minutes and less frequent ones being retained for up to 3 days:

    0 1-23 * * * /opt/btrfs-snap/btrfs-snap -r <fs> 23
    15,30,45 * * * * /opt/btrfs-snap/btrfs-snap -r <fs> 15m 3
    0 0 * * * /opt/btrfs-snap/btrfs-snap -r <fs> daily 3

Our filesystems are mounted with the "compress=lzo" option.

Are we doing something wrong? Are there things we should change to improve stability? I wouldn't be surprised if eliminating snapshots would stabilize things, but if we do that we might as well be using a filesystem like XFS. Are there fixes queued up that will solve the problems listed in the Bugzilla ticket referenced above? Or is our I/O-intensive workload just not a good fit for Btrfs?

Thanks,

Alex