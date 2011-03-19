From: Gal Buki <buki@torus.ch>
Subject: btrfs fi df gives only the total size that is currently allocated
Date: Sat, 19 Mar 2011 21:16:48 +0200
Message-ID: <4D850120.9030701@torus.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I made a test RAID 10 with several old disks with various sizes.
I copied some files (~800MB)
When using btrfs fi df /mountpoint I get
Data: total=1.00GB, used=800.00MB
When I copy another ~800MB I get a total size of 2GB.

This goes on and on until I hit the max size of the RAID.
e.g.
Data: total=5.00GB, used=4.97GB

Is there a way to see what the max size will be without having to fill 
the RAID first?

Thanks,
Gal

P.S. df -h doesn't help either because of the different disk sizes.
