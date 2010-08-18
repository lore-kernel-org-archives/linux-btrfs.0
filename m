From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: RE: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 18:26:48 +0200
Message-ID: <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5C7@mail.corp.imt-systems.com>
References: <4C6BB21E.3000809@cn.fujitsu.com>
 <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5C5@mail.corp.imt-systems.com>
 <20100818142541.GP5854@think>
 <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5C6@mail.corp.imt-systems.com>
 <20100818153931.GT5854@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100818153931.GT5854@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I'm using a standard fedora 13 kernel.
Linux fc13.corp.imt-systems.com 2.6.33.6-147.2.4.fc13.x86_64 #1 SMP Fri=
 Jul 23 17:14:44 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux

If you like, I can rerun these benchmarks with 2.6.36-rc1.

My Storage:

2x Western Digital WD5000AAKS SATA Disks with hardware raid 0 on a LSI =
1068e controller.

Best regards,

Morten

On Wed, Aug 18, 2010 at 5:39 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Wed, Aug 18, 2010 at 05:28:44PM +0200, Morten P.D. Stevens wrote:
>> Hi Chris,
>>
>> Your compilebench results are very interesting.
>>
>> Here are my results with exactly the same benchmark:
>>
>> Btrfs:
>>
>> [root@fc13 compilebench-0.6]# ./compilebench -D /mnt/btrfs -i 30 --m=
akej
>> using working directory /mnt/btrfs, 30 intial dirs 100 runs
>> native unpatched native-0 222MB in 3.14 seconds (70.82 MB/s)
>> native patched native-0 109MB in 0.69 seconds (158.94 MB/s)
>> native patched compiled native-0 691MB in 1.86 seconds (371.83 MB/s)
>> create dir kernel-0 222MB in 2.28 seconds (97.53 MB/s)
>> create dir kernel-1 222MB in 3.45 seconds (64.46 MB/s)
>
> You'll probably find the btrfs create and delete speeds improve if yo=
u
> mount with -o max_inline=3D0. =A0Please confirm which kernel you were
> running?
>
> Also btrfs hammers on slab/slub very hard, so a kernel with slab/slub
> debugging on will tend to be slower on btrfs than the other filesyste=
ms.
>
> [ btrfs results for the compile phase ]
>> compile dir kernel-29 680MB in 2.93 seconds (232.30 MB/s)
>> compile dir kernel-11 680MB in 3.24 seconds (210.07 MB/s)
>> compile dir kernel-22 680MB in 3.12 seconds (218.15 MB/s)
>> compile dir kernel-15 680MB in 3.25 seconds (209.43 MB/s)
>> compile dir kernel-13 680MB in 3.23 seconds (210.72 MB/s)
>
>>
>> Ext4:
>>
>> [root@fc13 compilebench-0.6]# ./compilebench -D /mnt/ext4 -i 30 --ma=
kej
>> using working directory /mnt/ext4, 30 intial dirs 100 runs
>> native unpatched native-0 222MB in 2.34 seconds (95.03 MB/s)
>> native patched native-0 109MB in 0.60 seconds (182.78 MB/s)
>> native patched compiled native-0 691MB in 2.00 seconds (345.80 MB/s)
>> create dir kernel-0 222MB in 2.16 seconds (102.95 MB/s)
>> create dir kernel-1 222MB in 2.37 seconds (93.83 MB/s)
>> create dir kernel-2 222MB in 3.11 seconds (71.50 MB/s)
>> create dir kernel-3 222MB in 3.71 seconds (59.94 MB/s)
>> create dir kernel-4 222MB in 3.55 seconds (62.64 MB/s)
>> create dir kernel-5 222MB in 3.61 seconds (61.60 MB/s)
>> create dir kernel-6 222MB in 3.34 seconds (66.58 MB/s)
>> create dir kernel-7 222MB in 3.72 seconds (59.78 MB/s)
>> create dir kernel-8 222MB in 2.66 seconds (83.60 MB/s)
>
> Wow, much better than my drive. =A0What kind of storage is this?
>
>> compile dir kernel-29 680MB in 4.10 seconds (166.01 MB/s)
>> compile dir kernel-11 680MB in 4.35 seconds (156.47 MB/s)
>> compile dir kernel-22 680MB in 4.42 seconds (153.99 MB/s)
>> compile dir kernel-15 680MB in 4.59 seconds (148.29 MB/s)
>
> Much lower than btrfs. =A0Strictly speaking this could be a layout
> decision. =A0Ext4 could be trying to place the new .o files close to =
the
> rest of the files in that subdirectory. =A0Btrfs tries harder to maxi=
mize
> writeback speeds because COW causes fragmentation anyway.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
