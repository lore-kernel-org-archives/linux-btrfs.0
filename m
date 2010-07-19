From: Xavier Nicollet <nicollet@jeru.org>
Subject: btrfs: unlinked X orphans messages
Date: Mon, 19 Jul 2010 11:01:51 +0200
Message-ID: <20100719090151.GF26516@jeru.org>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using btrfs for remote backups (via rsync), with daily and weekly
snapshots.

I see these messages in kern.log:

Jul 18 07:09:43 backup1 kernel: [3437126.458374] btrfs: unlinked 9 orphans
Jul 18 12:01:01 backup1 kernel: [3454604.905856] btrfs: unlinked 1 orphans
Jul 18 13:01:51 backup1 kernel: [3458254.990199] btrfs: unlinked 1 orphans
Jul 19 04:01:41 backup1 kernel: [3512244.236347] btrfs: unlinked 1 orphans

Is this something I have to be afraid of ?

Linux debian lenny, pure btrfs partition with no raid, vanilla kernel:
2.6.34.

Thanks,

-- 
Xavier Nicollet
