From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [Btrfs-Progs] Update for lzo support
Date: Tue, 16 Nov 2010 22:15:57 +0100
Message-ID: <201011162215.58385.kreijack@libero.it>
References: <4CE226CF.70907@cn.fujitsu.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE226CF.70907@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Tuesday, 16 November, 2010, Li Zefan wrote:
> - Add incompat flag, otherwise btrfs-progs will report error
>   when operating on btrfs filesystems mounted with lzo option.
> 
> - Allow to turn on lzo compression for defrag operation:
> 
>   # btrfs filesystem defragment -c[zlib, lzo] <file>
> 
>   Note: "-c zlib" will fail, because that's how getopt() works
>   for optional arguments.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> The lzo patchset for kernel code can be found here:
> 
> http://marc.info/?l=linux-btrfs&m=128799063215123&w=2
> 
> ---
>  btrfs.c      |    2 +-
>  btrfs_cmds.c |   24 ++++++++++++++++++++----
>  ctree.h      |   18 +++++++++++-------
>  ioctl.h      |    9 ++++++++-
>  4 files changed, 40 insertions(+), 13 deletions(-)

Please update the man page too.
Rehgards
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
