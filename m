From: Arie Peterson <ariep@xs4all.nl>
Subject: Re: ENOSPC on file deletion with 3.1.6
Date: Tue, 03 Jan 2012 15:12:22 +0100
Message-ID: <3462742.4OipIWmN91@a4>
References: <24549767.TiRljH7Edl@a4> <20120103140643.GA18405@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120103140643.GA18405@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 03 January 2012 15:06:43 Sander wrote:

> Maybe your snapshots take up space. Can you show 'btrfs filesystem df /' ?

Data, RAID1: total=22.72GB, used=14.73GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=2.25GB, used=1.88GB
Metadata: total=8.00MB, used=0.00

> FWIW, I also had a disk full just a few days ago. Removed all snapshots
> and some big files, but to no avail. Likely the background cleanup took
> too much time. A reboot fixed this.

OK, I'll keep this in mind. I'm a bit anxious to reboot, because I'm afraid 
booting will fail if the root file system cannot be written to.

> 	Sander

Thanks,

Arie

