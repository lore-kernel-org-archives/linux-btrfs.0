From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH 1/2] [Repost] btrfslabel - user space
Date: Mon, 4 Jan 2010 20:15:14 +0100
Message-ID: <201001042015.14647.kreijack@libero.it>
References: <201001041959.21312.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001041959.21312.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 04 January 2010, Goffredo Baroncelli wrote:
> Hi all,
> 
> recently I needed to change a label of a btrfs filesystem. After a 
> bit of googling I discovered the Morey patches (dated august 2008). 
> 
> So I update the patches to the latest btrfs source. The patches 
> creates a new command called btrfslabel which is able to change the
>  label of a btrfs filesystem.
> 
> The command differentiates two cases:
> - the filesystem is mounted: the change is done by the kernel (see 
> the second patch), btrfslabel uses an ioctl to start the label changing.
> - the filesystem is unmounted: the change is performed in user space.

I forgot to mention that even if the kernel isn't patched, it is still 
possible to change a label of an unmounted btrfs filesystem.

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
