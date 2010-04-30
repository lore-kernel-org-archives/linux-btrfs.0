From: Josef Bacik <josef@redhat.com>
Subject: Re: Segmentation fault on partition mount
Date: Fri, 30 Apr 2010 14:41:48 -0400
Message-ID: <20100430184148.GD2223@localhost.localdomain>
References: <185920.66632.qm@web58307.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ilya Shestopalov <yast4ik@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <185920.66632.qm@web58307.mail.re3.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 30, 2010 at 11:26:16AM -0700, Ilya Shestopalov wrote:
> My distro: Archlinux
> Kernel: 2.6.34-rc5, 2.6.33.3
> I has 522 Gib btrfs partition and. While I was checking out chromium source, free space on my /home btrfs partition was about 20 Gib. Then I received message "not enough free space" (but there was enough of it). And even after btrfsck I always get segmentation fault. Even btrfs-debug-tree can't be done successfully.
> How can this bug be fixed?
> 
> P.S. 
> 
> I can't find btrfs-image in btrfs-progs-unstable from the Archlinux repo.
> 

So you may have run out of metadata space.  If you run btrfs filesystem df
/mnt/point it will tell you the block groups and how much space is in them.  You
may want to do a btrfs-vol -b /mnt/point.  Thanks,

Josef
