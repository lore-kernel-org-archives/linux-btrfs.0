From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: Resize command syntax wrong?
Date: Wed, 30 Nov 2011 21:48:37 +0100
Message-ID: <2642474.I5uc41HKUa@venice>
References: <20111201011547.66633b20@natsu> <ByrP+cZy1uB@helmut.hullen.de> <20111201020730.33980a5e@natsu>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: helmut@hullen.de, linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111201020730.33980a5e@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 01 December, 2011 02:07:30 you wrote:
[...]
> Resizing in both 'directions' seems to work very well on single-device BTRFS
> filesystems, and also it's very useful that BTRFS is almost the only modern
> FS (besides ext4) that can be shrinked. But with multi-device filesystems,
> don't you agree it's non-obvious how (or is not even possible) to resize
> the areas that BTRFS occupies on individual devices?

I agree that it is not so an obviously syntax, however it is definitely 
possible to shrink/grow a single disk in a multi disk scenario.

The full syntax is the following ([1])
-----------

filesystem resize [<devid>:][+/-]<size>[gkm]|max <path> 

Resize a filesystem identified by <path>. The <size> parameter specifies the new 
size of the filesystem. If the prefix + or - is present the size is increased or 
decreased by the quantity <size>. If no units are specified, the unit of the 
<size> parameter defaults to bytes. Optionally, the size parameter may be 
suffixed by one of the following the units designators: 'K', 'M', or 'G', 
kilobytes, megabytes, or gigabytes, respectively. 
If 'max' is passed, the filesystem will occupy all available space on the 
volume(s). 
The resize command does not manipulate the size of underlying partition. If 
you wish to enlarge/reduce a filesystem, you must make sure you can expand the 
partition before enlarging the filesystem and shrink the partition after 
reducing the size of the filesystem. 
<devid> is the id of the device which was grow or shrink, as show by the 
command btrfs filesystem show. If nothing is passed, the device devid=1 is 
used.
----------------------


IIRC I sent in the past a patch which added these further info in the man 
page, but I think that this patch was lost... I have to resubmit another time

BR
G.Baroncelli

[1] http://btrfs.ipv5.de/index.php?title=Btrfs(command)

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
