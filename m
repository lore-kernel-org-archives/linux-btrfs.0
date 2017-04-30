Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sn1nam01on0068.outbound.protection.outlook.com ([104.47.32.68]:7355
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1947453AbdD3WUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 18:20:46 -0400
From: Zach Aller <ZAller@iteris.com>
To: Zach Aller <ZAller@iteris.com>, Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How to fix these btrfs errors
Date: Sun, 30 Apr 2017 22:20:43 +0000
Message-ID: <D52BCC47.486A8%zaller@iteris.com>
References: <D52BBC8E.48696%zaller@iteris.com>
 <CAJCQCtTi+uOSrTvPMp+C22UdCwCNwtQWaZH4Lbr3vd_EBY_t4w@mail.gmail.com>
 <D52BC352.4869A%zaller@iteris.com>
In-Reply-To: <D52BC352.4869A%zaller@iteris.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Output of one more command.
-------
./btrfs inspect-internal dump-tree /dev/sda > dump.txt
parent transid verify failed on 15732050345984 wanted 73879 found 73881
parent transid verify failed on 15732050345984 wanted 73879 found 73881
parent transid verify failed on 15732050345984 wanted 73879 found 73881
parent transid verify failed on 15732050345984 wanted 73879 found 73881
Ignoring transid failure
WARNING: eb corrupted: item 0 eb level 3 next level 3, skipping the rest
-------



Here is the end of dump.txt after the above command failed.
-------

checksum tree key (CSUM_TREE ROOT_ITEM 0)
node 15732050329600 level 3 items 15 free 478 generation 73879 owner 7
fs uuid bdd89c26-038d-49fd-b895-52b8deb989cc
chunk uuid 2cf80f39-d64e-489f-acec-8411f5c1bb33
	key (EXTENT_CSUM EXTENT_CSUM 12582912) block 15732050345984 (960208151)
gen 73879
	key (EXTENT_CSUM EXTENT_CSUM 1036259938304) block 15732062109696
(960208869) gen 73879
	key (EXTENT_CSUM EXTENT_CSUM 2055219736576) block 22061012254720
(1346497330) gen 73796
	key (EXTENT_CSUM EXTENT_CSUM 3067616186368) block 15732273971200
(960221800) gen 72465
	key (EXTENT_CSUM EXTENT_CSUM 4125595508736) block 19670583918592
(1200597163) gen 71747
	key (EXTENT_CSUM EXTENT_CSUM 5160724217856) block 22060767379456
(1346482384) gen 73047
	key (EXTENT_CSUM EXTENT_CSUM 6225035022336) block 18786519695360
(1146638165) gen 71390
	key (EXTENT_CSUM EXTENT_CSUM 7317037834240) block 22060823707648
(1346485822) gen 73791
	key (EXTENT_CSUM EXTENT_CSUM 8520881180672) block 22061229129728
(1346510567) gen 72304
	key (EXTENT_CSUM EXTENT_CSUM 9556147200000) block 21773927448576
(1328975064) gen 72764
	key (EXTENT_CSUM EXTENT_CSUM 10643353645056) block 22061034897408
(1346498712) gen 73797
	key (EXTENT_CSUM EXTENT_CSUM 11886318727168) block 21773509066752
(1328949528) gen 73741
	key (EXTENT_CSUM EXTENT_CSUM 13041959669760) block 2532038983680
(154543395) gen 71958
	key (EXTENT_CSUM EXTENT_CSUM 14315004522496) block 21773773946880
(1328965695) gen 57898
	key (EXTENT_CSUM EXTENT_CSUM 16297194516480) block 22061036748800
(1346498825) gen 72864
uuid tree key (UUID_TREE ROOT_ITEM 0)
leaf 29376512 items 0 free space 16283 generation 6 owner 9
fs uuid bdd89c26-038d-49fd-b895-52b8deb989cc
chunk uuid 2cf80f39-d64e-489f-acec-8411f5c1bb33
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0)
leaf 29442048 items 2 free space 16061 generation 4 owner
18446744073709551607
fs uuid bdd89c26-038d-49fd-b895-52b8deb989cc
chunk uuid 2cf80f39-d64e-489f-acec-8411f5c1bb33
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		inode generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 0 flags 0x0(none)
		atime 1490407706.0 (2017-03-24 21:08:26)
		ctime 1490407706.0 (2017-03-24 21:08:26)
		mtime 1490407706.0 (2017-03-24 21:08:26)
		otime 1490407706.0 (2017-03-24 21:08:26)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		inode ref index 0 namelen 2 name: ..
total bytes 24004303781888
bytes used 18737354412032
uuid bdd89c26-038d-49fd-b895-52b8deb989cc

-------




On 4/30/17, 4:39 PM, "linux-btrfs-owner@vger.kernel.org on behalf of Zach
Aller" <linux-btrfs-owner@vger.kernel.org on behalf of ZAller@iteris.com>
wrote:

>It is a recent filesystem the data was written with kernel 4.10, today I
>upgraded to 4.11rc8 to see if it helped anything which it did not.
>
>On 4/30/17, 4:35 PM, "chris@colorremedies.com on behalf of Chris Murphy"
><chris@colorremedies.com on behalf of lists@colorremedies.com> wrote:
>
>>On Sun, Apr 30, 2017 at 3:08 PM, Zach Aller <ZAller@iteris.com> wrote:
>>
>>> uname -a
>>> Linux server 4.11.0-041100rc8-generic #201704232131 SMP Mon Apr 24
>>> 01:32:55 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> ./btrfs --version
>>> btrfs-progs v4.10
>>>
>>> ./btrfs fi show
>>> Label: none  uuid: bdd89c26-038d-49fd-b895-52b8deb989cc
>>>         Total devices 1 FS bytes used 17.04TiB
>>>         devid    1 size 21.83TiB used 17.28TiB path /dev/sda
>>
>>
>>How old is the file system? Is this a recent problem with just
>>4.11rc8? Is most of the 17TB written with a particular kernel version,
>>which?
>>
>>
>>>
>>> Here is a dmesg snippet
>>>
>>>
>>> [    3.633295] BTRFS: device fsid bdd89c26-038d-49fd-b895-52b8deb989cc
>>> devid 1 transid 72387 /dev/sda
>>> [   12.907658] BTRFS info (device sda): disk space caching is enabled
>>> [   12.907659] BTRFS info (device sda): has skinny extents
>>> [   13.129140] BTRFS info (device sda): bdev /dev/sda errs: wr 0, rd 0,
>>> flush 0, corrupt 217, gen 19
>>> [20956.415076] BTRFS info (device sda): The free space cache file
>>> (9804365955072) is invalid. skip it
>>> [36292.358558] BTRFS warning (device sda): checksum error at logical
>>> 5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level
>>>0)
>>> in tree 7
>>> [36292.358563] BTRFS warning (device sda): checksum error at logical
>>> 5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level
>>>0)
>>> in tree 7
>>> [36292.358569] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd
>>>0,
>>> flush 0, corrupt 218, gen 19
>>> [36292.364717] BTRFS error (device sda): unable to fixup (regular)
>>>error
>>> at logical 5614914584576 on dev /dev/sda
>>
>>
>>Both copies of metadata are failing checksum, so it can't be fixed. It
>>suggests there's a hardware problem (memory or storage), or maybe a
>>new bug.
>>
>>Have there been any crashes while writing to the file system?
>>What is the storage stack configuration? 22TB for a single block
>>device means it's built up from something else.
>>
>>I'd dig around for any non-btrfs storage stack related errors in the
>>meantime, maybe a dev will have some idea what's going on from the
>>call traces, I'm not sure what they mean.
>>
>>-- 
>>Chris Murphy
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

