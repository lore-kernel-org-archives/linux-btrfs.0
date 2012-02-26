From: Fahrzin Hemmati <fahhem2@gmail.com>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sat, 25 Feb 2012 18:10:32 -0800
Message-ID: <4F499498.1040006@gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jic3e1$gpe$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs is horrible for small filesystems (like a 5GB drive). df -h says 
you have 967MB available, but btrfs (at least by default) allocates 1GB 
at a time to data/metadata. This means that your 10MB file is too big 
for the current allocation and requires a new data chunk, or another 
1GB, which you don't have.

Others might know of a way of changing the allocation size to less than 
1GB, but otherwise I recommend switching to something more stable like 
ext4/reiserfs/etc.

On 2/25/2012 5:55 PM, Brian J. Murrell wrote:
> I have a 5G /usr btrfs filesystem on a 3.0.0-12-generic kernel that is
> returning ENOSPC when it's only 75% full:
>
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/rootvol-mint_usr
>                        5.0G  2.8G  967M  75% /usr
>
> And yet I can't even unpack a linux-headers package on to it, which
> should be nowhere near 967MB.  dpkg says it will need 10MB:
>
> $ sudo apt-get install -f
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> Correcting dependencies... Done
> The following extra packages will be installed:
>    linux-headers-3.0.0-16-generic
> The following NEW packages will be installed:
>    linux-headers-3.0.0-16-generic
> 0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
> 264 not fully installed or removed.
> Need to get 0 B/851 kB of archives.
> After this operation, 10.8 MB of additional disk space will be used.
> Do you want to continue [Y/n]? y
> (Reading database ... 180246 files and directories currently installed.)
> Unpacking linux-headers-3.0.0-16-generic (from .../linux-headers-3.0.0-16-generic_3.0.0-16.28_i386.deb) ...
> dpkg: error processing /var/cache/apt/archives/linux-headers-3.0.0-16-generic_3.0.0-16.28_i386.deb (--unpack):
>   unable to install new version of `/usr/src/linux-headers-3.0.0-16-generic/include/config/dvb/tuner/dib0070.h': No space left on device
>
> And indeed, using dd I am able to create a 967MB file:
>
> $ sudo dd if=/dev/zero of=/usr/bigfile bs=1M count=10000000
> dd: writing `/usr/bigfile': No space left on device
> 967+0 records in
> 966+0 records out
> 1012924416 bytes (1.0 GB) copied, 16.1545 s, 62.7 MB/s
>
> strace yields this as the cause of the ENOSPC:
>
> 8213  rename("/usr/src/linux-headers-3.0.0-16-generic/include/config/dvb/tuner/dib0070.h.dpkg-new", "/usr/src/linux-headers-3.0.0-16-generic/include/config/dvb/tuner/dib0070.h"<unfinished ...>
> ...
> 8213<... rename resumed>  )            = -1 ENOSPC (No space left on device)
>
> So this starts to feel like some kind of inode count limitation.  But I
> didn't think btrfs had inode count limitations.  Here's the df stats on
> the filesystem:
>
> $ btrfs filesystem df /usr
> Data: total=3.22GB, used=3.22GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=896.00MB, used=251.62MB
> Metadata: total=8.00MB, used=0.00
>
> I don't know if that's useful or not.
>
> Any ideas?
>
> Cheers
> b.
>

