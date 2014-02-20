Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaBTRbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 12:31:16 -0500
Date: Thu, 20 Feb 2014 18:31:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <chris@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
Message-ID: <20140220173112.GV16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52FD1AD6.50500@libero.it>
 <20140214012810.26297146@natsu>
 <52FD21B4.4050502@libero.it>
 <20140214030045.415e21da@natsu>
 <52FE58EF.1060901@libero.it>
 <20140215001110.76d8226f@natsu>
 <52FE602D.7060109@libero.it>
 <20140214183400.GA3351@carfax.org.uk>
 <08C5C865-03F9-413A-873A-995393E1FABD@colorremedies.com>
 <53025073.80709@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53025073.80709@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 17, 2014 at 07:09:55PM +0100, Goffredo Baroncelli wrote:
> I have to agree with Chris: looking at the output of "btrfs fi disk-usage"
> 
> $ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
>          Data   Data    Metadata Metadata System System             
>          Single RAID6   Single   RAID5    Single RAID5   Unallocated
>                                                                     
> /dev/vdb 8.00MB  1.00GB   8.00MB   1.00GB 4.00MB  4.00MB     97.98GB
> /dev/vdc      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
> /dev/vdd      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
> /dev/vde      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
>          ====== ======= ======== ======== ====== ======= ===========
> Total    8.00MB  2.00GB   8.00MB   3.00GB 4.00MB 12.00MB    391.97GB
> Used       0.00 11.25MB     0.00  36.00KB   0.00  4.00KB   
> 
> it is hard to tell that this can be named "filesystem usage". I think that 
> "details" or "examine" is a better name.
> 
> Regarding "btrfs device usage", it seems to me more coherent. But as 
> reported before consistency also matters, so now I am inclined to use
> "detail" (or examine) also for "btrfs device"

I'm for 'btrfs filesystem usage' and 'btrfs device usage', IMHO
intuitive, easy to type and remember.
