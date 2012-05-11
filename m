From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: do not do balance in readonly mode
Date: Fri, 11 May 2012 10:50:19 -0400
Message-ID: <20120511145018.GB3847@localhost.localdomain>
References: <1336731086-26077-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336731086-26077-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2012 at 06:11:26PM +0800, Liu Bo wrote:
> In normal cases, we would not be allowed to do balance in RO mode.
> However, when we're using a seeding device and adding another device to sprout,
> things will change:
> 
> $ mkfs.btrfs /dev/sdb7
> $ btrfstune -S 1 /dev/sdb7
> $ mount /dev/sdb7 /mnt/btrfs -o ro
> $ btrfs fi bal /mnt/btrfs   -----------------------> fail.
> $ btrfs dev add /dev/sdb8 /mnt/btrfs
> $ btrfs fi bal /mnt/btrfs   -----------------------> works!
> 
> It should not be designed as an exception, and we'd better add another check for
> mnt flags.
> 

Added to btrfs-next and added my Reviewed-by.  Thanks,

Josef
