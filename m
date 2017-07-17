Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpgw02.sap-ag.de ([155.56.66.97]:44633 "EHLO smtpgw.sap-ag.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdGQISh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 04:18:37 -0400
From: "Brennecke, Simon" <simon.brennecke@sap.com>
To: "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
Subject: btrfs-cleaner causing heavy load
Date: Mon, 17 Jul 2017 08:03:33 +0000
Message-ID: <64e68f94963a441db087e660e167a2f4@sap.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

We are facing some issues with a btrfs filesystem on one of our department filers.
The problem started pretty much one week ago, when I decided to purge old snapshots.
Until then we were doing daily btrfs snapshots to have a quick backup.
What then happened was that btrfs-cleaner kicked in, and is now slowing things down very badly.
It is consuming 100% CPU and also a lot of IOP/s.
I tried reducing its CPU priority, but that was pretty much without effect.
Beside that we tried restarting the machine, but that also did not mitigate the problem.

I understand that purging snapshots is a complex operation, but we somehow need to reduce the load this causes during working hours.
Are there any ways to tell btrfs-cleaner to suspend or reduce its operations?

Background:
	The file-server runs inside a XEN domU
	The backing disk is a Ceph RDB with 50TiB capacity
	We employ a bcache with a local SSD to improve latency
	Files are served via NFS and Samba to a couple of hundred clients.

Thanks & regards
Simon

uname -a
	Linux v2-fs 4.1.42-xen #2 SMP Wed Jul 12 14:06:37 CEST 2017 x86_64 GNU/Linux

btrfs --version
	Btrfs v3.17

btrfs fi show
	Label: 'v2-fs-data'  uuid: f2bad13d-8b02-4325-8c4a-31b0cafb1549
	        Total devices 1 FS bytes used 6.98TiB
	        devid    1 size 50.00TiB used 7.48TiB path /dev/bcache0

	Btrfs v3.17

btrfs fi df /mnt/ceph/
	Data, single: total=7.10TiB, used=6.93TiB
	System, DUP: total=8.00MiB, used=864.00KiB
	System, single: total=4.00MiB, used=0.00B
	Metadata, DUP: total=194.00GiB, used=54.93GiB
	Metadata, single: total=8.00MiB, used=0.00B
	GlobalReserve, single: total=512.00MiB, used=0.00B

dmesg did not contain any recent (2 days) events.
The older ones were about NFSd being stuck for more than 30 seconds while reading from disk.


