From: Sander <btrfs@humilis.net>
Subject: Re: ENOSPC on file deletion with 3.1.6
Date: Tue, 3 Jan 2012 15:22:58 +0100
Message-ID: <20120103142258.GA22732@attic.humilis.net>
References: <24549767.TiRljH7Edl@a4>
 <20120103140643.GA18405@attic.humilis.net>
 <3462742.4OipIWmN91@a4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arie Peterson <ariep@xs4all.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3462742.4OipIWmN91@a4>
List-ID: <linux-btrfs.vger.kernel.org>

Arie Peterson wrote (ao):
> On Tuesday 03 January 2012 15:06:43 Sander wrote:
> > Maybe your snapshots take up space. Can you show 'btrfs filesystem df /' ?
> 
> Data, RAID1: total=22.72GB, used=14.73GB
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=2.25GB, used=1.88GB
> Metadata: total=8.00MB, used=0.00

Hm, not full.

> > FWIW, I also had a disk full just a few days ago. Removed all snapshots
> > and some big files, but to no avail. Likely the background cleanup took
> > too much time. A reboot fixed this.
> 
> OK, I'll keep this in mind. I'm a bit anxious to reboot, because I'm afraid 
> booting will fail if the root file system cannot be written to.

But you did already reboot as you said the old kernel exposed the same
behavior?

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
