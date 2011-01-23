From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 00:58:48 +0100
Message-ID: <20110123235848.GB2560@scooter>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110123232720.GH29985@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	Felix Blanke <felixblanke@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110123232720.GH29985@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

losetup is part of "util-linux":

http://www.kernel.org/pub/linux/utils/util-linux/


I'm using 2.17.2. Don't know if that is some kind of revision. 


I tried the newest version 2.19-rc1. There seems to be some kind of "fix":

scooter ~ # /home/fame/tmp/util-linux-2.19-rc1/mount/losetup -a
/dev/loop0: [0010]:3154
(/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-pa*), encryption  (type
16)
/dev/loop1: [0010]:4552
(/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-pa*), encryption  (type
16)
/dev/loop2: [0010]:4623
(/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part*), encryption  (type
16)
/dev/loop3: [0010]:4604
(/dev/disk/by-id/ata-WDC_WD5000AAKS-65YGA0_WD-WCAS82035988-part*), encryption  (type
16)
/dev/loop4: [0010]:4586
(/dev/disk/by-id/ata-WDC_WD5000AAKS-65YGA0_WD-WCAS82030114-part*), encryption  (type
16)



If the path is to long they add a '*' :) Do you think that will solve the problem?


I'll try it tomorrow.


Regards,
Felix


On 23. January 2011 - 23:27, Hugo Mills wrote:
> Date: Sun, 23 Jan 2011 23:27:20 +0000
> From: Hugo Mills <hugo@carfax.org.uk>
> To: kreijack@inwind.it
> Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, Felix Blanke
>  <felixblanke@gmail.com>, linux-btrfs@vger.kernel.org
> Subject: Re: Bug in mkfs.btrfs?!
> Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it, Hugo
>  Mills <hugo-lkml@carfax.org.uk>, Felix Blanke <felixblanke@gmail.com>,
>  linux-btrfs@vger.kernel.org
> 
> On Sun, Jan 23, 2011 at 11:02:16PM +0100, Goffredo Baroncelli wrote:
> > On 01/23/2011 07:18 PM, Hugo Mills wrote:
> > >    Hi, Felix,
> > > 
> > > On Sat, Jan 22, 2011 at 04:56:12PM +0100, Felix Blanke wrote:
> > >> It was a simple:
> > >>
> > >> mkfs.btrfs -L backup -d single /dev/loop2
> > >>
> > >> But it also happens without the options, like:
> > >>
> > >> mkfs.btrfs /dev/loop2
> > >>
> > >>
> > >> /dev/loop2 is a loop device, which is aes encrypted. The output of "losetup /dev/loop2":
> > >>
> > >> /dev/loop2: [0010]:5324 
> > >> (/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3) encryption=AES128
> > >>
> > >>
> > >> Thanks you for looking into this!
> > >> While writing this I read your second mail. The strace output is attached.
> > > 
> > >    OK, I've traced through the functions being called, and I really
> > > can't see where it could be truncating the name, unless your system
> > > has a stupidly small value of PATH_MAX.
> > 
> > It seems that when mkfs.btrfs checks if the passed block device is
> > already mounted, uses the ioctl LOOP_GET_STATUS [1]. This ioctl has as
> > argument the struct loop_info.
> > 
> > This ioctl, should return the info about the back-end of the loop
> > device. The file name is returned via the "lo_name" field, which is an
> > array of 64 char...[2]
> 
>    Good catch, Goffredo. I completely missed that.
> 
>    Interestingly, on my system, lo_name is indeed defined as 64 chars,
> but I don't see Felix's problem. When I do losetup on the
> /dev/disk/by-id/... link, my version of losetup seems to be following
> the link:
> 
> # losetup /dev/loop1 /dev/disk/by-id/dm-uuid-LVM-XRQLHQNa0xEeIZL4ofuBGIcfkr1Dhry8YHhkjaw4bvZA4meDFQfEMy5elIsVNeWl 
> # losetup -a
> /dev/loop1: [0005]:1423915 (/dev/mapper/ruthven-btemp)
> 
>    I'm running Debian, and the mount package version 2.17.2-5 (losetup
> is part of mount, it seems).
> 
> > Felix, what is the output of the following command ?
> > 
> > 	/sbin/losetup -a
> > 
> > If my analysis is correct, this command should return the filename
> > trunked at the 64th character too.
> 
>    Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>            --- Sometimes, when I'm alone, I Google myself. ---           


---end quoted text---
