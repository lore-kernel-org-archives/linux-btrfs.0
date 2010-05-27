From: Josef Bacik <josef@redhat.com>
Subject: Re: raid1 not reporting the right size
Date: Thu, 27 May 2010 16:04:46 -0400
Message-ID: <20100527200446.GJ25333@dhcp231-156.rdu.redhat.com>
References: <alpine.DEB.1.10.1005271527320.19767@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: gmack@innerfire.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1005271527320.19767@mtl.rackplans.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 27, 2010 at 03:43:05PM -0400, gmack@innerfire.net wrote:
> I'm trying to create a raid1 (mirrored) raid using two 1 Tb disks.
> The result is something twice as large as it should be fore mirrored raid.
> 
> Any ideas? Linux version 2.6.34
> 
> # mkfs.btrfs -d raid1 -m raid1 /dev/sdb1 /dev/sdc1 -L fhome
> 
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> adding device /dev/sdc1 id 2
> fs created label fhome on /dev/sdb1
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 1.82TB
> Btrfs Btrfs v0.19
> 
> # mount /dev/sdb1 /mnt/
> # df -h /mnt/
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb1             1.9T   56K  1.9T   1% /mnt
> 
> # btrfs-show
> failed to read /dev/sr0
> Label: none  uuid: a2aa44b8-3168-480a-a155-d510e05853e7
>         Total devices 1 FS bytes used 617.45MB
>         devid    1 size 29.33GB used 6.79GB path /dev/sda2
> 
> Label: fhome  uuid: 128ddab5-224d-4f45-abc0-6a07d0f63d47
>         Total devices 2 FS bytes used 28.00KB
>         devid    2 size 931.51GB used 2.01GB path /dev/sdc1
>         devid    1 size 931.51GB used 2.03GB path /dev/sdb1
> 

Used will show up as twice the amount that is actually used, instead of looking
like you only have 1/2 the capacity.  Thanks,

Josef
