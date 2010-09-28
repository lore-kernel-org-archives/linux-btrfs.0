From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached to a filesystem
Date: Wed, 29 Sep 2010 00:28:51 +0200
Message-ID: <201009290028.52133.kreijack@libero.it>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1285707196-16268-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

what about using your ioctl to exporting also other info ? For example devid, 
size, bytes, uuid ...

I know that btrfs filesystem-show does the same, but it reads the partition 
(the disk) instead of query the filesystem. That means:
- It work even for unmounted filesystem (which is good)
- The results are inaccurate for a mounted filesystem, because the read data 
is not valid until a flush of the pages (which is bad.. very bad).

All the data are enclosed in the struct btrfs_device, so is very easy to 
extract.

Regards
G.Baroncelli


On Tuesday, 28 September, 2010, Josef Bacik wrote:
> This was a request from the systemd guys.  They need a quick and easy way to 
get
[...]



-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
