Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbbERPO0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 11:14:26 -0400
Message-ID: <555A01CF.3050904@redhat.com>
Date: Mon, 18 May 2015 10:14:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs and integration with GNU ++
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/17/15 2:33 PM, Roy Sigurd Karlsbakk wrote:
> Hi all

> Lastly - I just did a small test on a 6 drive RAID-6, turned on
> compression and started cat /proc/zero > testfile - let this run
> until the filesize was 500GB and stopped it. Made some other test
> files and a copy of these with --reflink=auto just for kicks. rm
> test* and waited. While waiting, did a 'echo b > /proc/sysrq-trigger'
> and fsck started on bootup and took a minute or so to complete. Since
> the filesystem is rather small (6x8GB VDEVs on top of ZFS with SSD
> caching, kvm as hypervisor), I wonder how long this fsck job would
> take if it were on a system with, say, 6 4TB drives. RHEL/CentOS7
> just moved to XFS to allow for system crashes without this hour-long
> fsck job, and I somewhat doubt that btrfs will be the chosen one if
> it requires the same amount of time as of ext4.

Others have mentioned this as well, but I'll say it more broadly:

echo b > /proc/sysrq-trigger should not require a fsck on any journaling
filesystem - xfs, ext3, ext4, or btrfs - that's the whole reason you pay
the slight overhead for metadata journaling at runtime, right?

Was it really running a fsck?

-Eric
