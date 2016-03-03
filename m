Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36137 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbcCCSd3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 13:33:29 -0500
Date: Thu, 3 Mar 2016 10:33:23 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Stray 4k extents with slow buffered writes
Message-ID: <20160303183322.GA16959@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <56D82DED.5030107@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <56D82DED.5030107@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 03, 2016 at 01:28:29PM +0100, Holger Hoffstätte wrote:
> 
> Here's an observation that is not a bug (as in data corruption), just
> somewhat odd and unnecessary behaviour. It could be considered  a
> performance or scalability bug.
> 
> I've noticed that slow slow buffered writes create a huge number of
> unnecessary 4k sized extents. At first I wrote it off as odd buffering
> behaviour of the application (a download manager), but it can be easily
> reproduced. For example:
> 
> holger>wget --limit-rate=1m https://cdn.kernel.org/pub/linux/kernel/v4.x/testing/linux-4.5-rc6.tar.xz
> (..downloads with 1 MB/s..)
> holger>sync
> holger>filefrag -ek linux-4.5-rc6.tar.xz 
> Filesystem type is: 9123683e
> File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks of 1024 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..   14219:  230807476.. 230821695:  14220:            
>    1:    14220..   14223:  230838148.. 230838151:      4:  230821696:
>    2:    14224..   29215:  230822324.. 230837315:  14992:  230838152:
>    3:    29216..   44207:  230838152.. 230853143:  14992:  230837316:
>    4:    44208..   44211:  230869576.. 230869579:      4:  230853144:
>    5:    44212..   59199:  230853968.. 230868955:  14988:  230869580:
>    6:    59200..   74191:  230869588.. 230884579:  14992:  230868956:
>    7:    74192..   74195:  230898332.. 230898335:      4:  230884580:
>    8:    74196..   86291:  230885620.. 230897715:  12096:  230898336: last,eof
> linux-4.5-rc6.tar.xz: 9 extents found
> 
> Slower writes will generate even more extents; another ~200MB file
> had >900 extents.
> 
> As expected defragment will collapse these stray extents with their
> successors:
> 
> holger>btrfs filesystem defragment linux-4.5-rc6.tar.xz                                              
> holger>sync
> holger>filefrag -ek linux-4.5-rc6.tar.xz           
> Filesystem type is: 9123683e
> File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks of 1024 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..   14219:  230807476.. 230821695:  14220:            
>    1:    14220..   29215:  230922128.. 230937123:  14996:  230821696:
>    2:    29216..   44207:  230838152.. 230853143:  14992:  230937124:
>    3:    44208..   59199:  230937124.. 230952115:  14992:  230853144:
>    4:    59200..   74191:  230869588.. 230884579:  14992:  230952116:
>    5:    74192..   86291:  230952116.. 230964215:  12100:  230884580: last,eof
> linux-4.5-rc6.tar.xz: 6 extents found
> 
> The obviously page-sized 4k extents happen to coincide with the 30s tx commit
> (2 * ~15 MB at 1 MB/s). It looks like a benign race, as if the last dirty page
> gets special treatment instead of being merged into wherever it should go.
> That just seems wasteful to me.
> 
> Anyone got an idea?

On a new fresh btrfs, I cannot reproduce the fragmented layout with "wget --limit-rate=1m",

[root@10-11-17-236 btrfs]# filefrag -v -b linux-4.5-rc6.tar.xz             
Filesystem type is: 9123683e
File size of linux-4.5-rc6.tar.xz is 88362576 (86292 blocks, blocksize
1024)
 ext logical physical expected length flags
   0       0   143744            5264 
   1    5264   149008           35884 
   2   41148   220848   184892      4 
   3   41152   184896   220852  35948 
   4   77100   220852   220844   9192 eof
linux-4.5-rc6.tar.xz: 4 extents found

My mount point has,
/dev/loop0 /mnt/btrfs btrfs rw,seclabel,relatime,space_cache,subvolid=5,subvol=/ 0 0

And I'm using 4.5.0-rc4.

# btrfs fi show /mnt/btrfs
Label: none  uuid: 599d68ae-b874-4db1-a3c3-33c4b783bfdd
        Total devices 1 FS bytes used 94.62MiB
        devid    1 size 2.00GiB used 436.75MiB path /dev/loop0

# btrfs fi df /mnt/btrfs
Data, single: total=216.00MiB, used=94.40MiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=102.38MiB, used=208.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

Can you gather your mount options and 'btrfs fi show/df' output?

Thanks,

-liubo
