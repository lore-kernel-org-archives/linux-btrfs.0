Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:53057 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751012AbbEDVZW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 May 2015 17:25:22 -0400
Message-ID: <5547E3BF.4090901@inwind.it>
Date: Mon, 04 May 2015 23:25:19 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: TheJay <obiwantje@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
References: <mi8452$i00$1@ger.gmane.org>
In-Reply-To: <mi8452$i00$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-05-04 17:44, TheJay wrote:
> $ uname -a
> Linux thejay-srv03 4.0.0-040000-generic #201504121935 SMP Sun Apr 12 
> 23:36:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> $ btrfs --version
> btrfs-progs v3.19.1
> 
> $ sudo btrfs fi show
> Label: 'roms03'  uuid: b0025417-4045-4c63-a432-0625b7cc41ea
> 	Total devices 4 FS bytes used 2.67TiB
> 	devid    1 size 1.36TiB used 1.36TiB path /dev/sdz
> 	devid    3 size 1.36TiB used 1.36TiB path /dev/sdaa
> 	devid    4 size 1.36TiB used 1.36TiB path /dev/sdab
> 	*** Some devices missing
> 
> This pool is a btrfsraid6 pool
> 
> when trying to mount I get:
> 
> $ sudo mount -t btrfs -o recovery,ro /dev/sdaa /mnt/roms03
> mount: wrong fs type, bad option, bad superblock on /dev/sdaa,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> $ dmesg -T|tail
> [Mon May  4 08:35:08 2015] BTRFS info (device sdz): enabling auto recovery
> [Mon May  4 08:35:08 2015] BTRFS info (device sdz): disk space caching is 
> enabled
> [Mon May  4 08:35:08 2015] BTRFS: has skinny extents
> [Mon May  4 08:35:08 2015] BTRFS: failed to read chunk tree on sdz
> [Mon May  4 08:35:08 2015] BTRFS: open_ctree failed
> 
> What could I try to see if I can mount this pool and gain access to the 
> data?

A disk is missing, in this case you should use the "degraded" mount option:

mount -o degraded /dev/sdaa /mnt/roms03



> 
> While I have a backup of the data, next time I may not, and I am trying 
> to learn how to go about. 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
