From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 1/5] btrfs: Make async snapshot ioctl more generic
Date: Mon, 29 Nov 2010 20:11:53 +0100
Message-ID: <201011292011.53426.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 29 November, 2010, Goffredo Baroncelli wrote:
> Why the unused fields ? What happens if you use a more recent btrfs-tools 
> which take advantage of these fields but the kernel is an old one ? At the 
> minimum please check the flags so
>         (flags^(BTRFS_SNAPSHOT_CREATE_ASYNC|BTRFS_SNAPSHOT_RDONLY)) == 0
> and
>         unused[0..3] == 0


Sorry, the check should be

(flags & (~(BTRFS_SNAPSHOT_CREATE_ASYNC|BTRFS_SNAPSHOT_RDONLY))) == 0
> 
> For future expansion I suggest to use a different ioctl. To me it seems a 
more 
> robust API.
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
