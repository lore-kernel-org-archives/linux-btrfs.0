Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25639 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbcCCWKs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 17:10:48 -0500
Date: Thu, 3 Mar 2016 14:13:09 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Stray 4k extents with slow buffered writes
Message-ID: <20160303221309.GA8666@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <56D82DED.5030107@googlemail.com>
 <20160303183322.GA16959@localhost.localdomain>
 <56D89655.70504@googlemail.com>
 <56D8A2D4.2010907@gmail.com>
 <56D8B1C2.1040604@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56D8B1C2.1040604@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 03, 2016 at 10:50:58PM +0100, Holger Hoffstätte wrote:
> On 03/03/16 21:47, Austin S. Hemmelgarn wrote:
> >> $mount | grep sdf
> >> /dev/sdf1 on /mnt/usb type btrfs (rw,relatime,space_cache=v2,subvolid=5,subvol=/)
> > Do you still see the same behavior with the old space_cache format?
> > This appears to be an issue of space management and allocation, so
> > this may be playing a part.
> 
> I just did the clear_cache,space_cache=v1 dance. Now a download with
> bandwidth-limit=1M, dirty_expire=20s, commit=30 and *no* autodefrag
> first ended up looking like this:
> 
> $filefrag -ek linux-4.5-rc6.tar.xz 
> Filesystem type is: 9123683e
> File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks of 1024 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..    7427:  227197920.. 227205347:   7428:            
>    1:     7428..   33027:  227205348.. 227230947:  25600:            
>    2:    33028..   53011:  227271164.. 227291147:  19984:  227230948:
>    3:    53012..   72995:  227291148.. 227311131:  19984:            
>    4:    72996..   86291:  227311132.. 227324427:  13296:             last,eof
> linux-4.5-rc6.tar.xz: 2 extents found
> 
> Yay! But wait, there's more!
> 
> $sync
> $filefrag -ek linux-4.5-rc6.tar.xz
> Filesystem type is: 9123683e
> File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks of 1024 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..    7423:  227197920.. 227205343:   7424:            
>    1:     7424..    7427:  227169600.. 227169603:      4:  227205344:
>    2:     7428..   33023:  227205348.. 227230943:  25596:  227169604:
>    3:    33024..   33027:  227169604.. 227169607:      4:  227230944:
>    4:    33028..   53007:  227271164.. 227291143:  19980:  227169608:
>    5:    53008..   53011:  227230948.. 227230951:      4:  227291144:
>    6:    53012..   72991:  227291148.. 227311127:  19980:  227230952:
>    7:    72992..   72995:  227230952.. 227230955:      4:  227311128:
>    8:    72996..   86291:  227311132.. 227324427:  13296:  227230956: last,eof
> linux-4.5-rc6.tar.xz: 9 extents found
> 
> Now I'm like ¯\(ツ)/¯

Yeah, after sync, I also get this file layout.

> 
> With autodefrag the same happens, though it then eventually does the
> merging from 4k -> 256k. I went searching for that hardcoded 256k value
> and found it as default in ioctl.c:btrfs_defrag_file() when no threshold
> has been passed, as is the case for autodefrag. I'll try to increase that
> and see how much I can destroy.
> 
> Also, rsync with --bwlimit=1m does _not_ seem to create files like this:
> 
> $rsync (..)
> $filefrag -ek linux-4.4.4.tar.bz2 
> Filesystem type is: 9123683e
> File size of linux-4.4.4.tar.bz2 is 105008928 (102548 blocks of 1024 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..    4095:  227197920.. 227202015:   4096:            
>    1:     4096..   25599:  227202016.. 227223519:  21504:            
>    2:    25600..   51199:  227271164.. 227296763:  25600:  227223520:
>    3:    51200..   76799:  227296764.. 227322363:  25600:            
>    4:    76800..  102547:  227322364.. 227348111:  25748:             last,eof
> linux-4.4.4.tar.bz2: 2 extents found
> 
> Which looks exactly as one would expect, probably - as Chris' mail
> just explained - it doesn't use O_APPEND, whereas wget apparently does.

Interesting, my strace log shows wget doesn't open the file with O_APPEND.

open("linux-4.5-rc6.tar.xz", O_WRONLY|O_CREAT|O_EXCL, 0666) = 4

Thanks,

-liubo

> 
> > I'd be somewhat curious to see if something similar happens on other
> > filesystems with such low writeback timeouts.  My thought in this
> > case is that the issue is that BTRFS's allocator isn't smart enough
> > to try and merge new extents into existing ones when possible.
> 
> ext4 creates 1-2 extents, regardless of method.
> 
> Holger
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
