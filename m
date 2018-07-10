Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:37543 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750879AbeGJE4F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 00:56:05 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, Su Yue <Damenly_Su@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1b2d361-eb1a-f172-45d3-409abd131d2b@cn.fujitsu.com>
 <20180705153023.GA30566@merlins.org>
 <trinity-d028b6bd-31d9-41c0-a091-47bcb810cdc3-1530808069711@msvc-mesg-gmx023>
 <20180705165049.t56dvqpz7ljjan5c@merlins.org>
 <trinity-79578bdf-a849-4342-a082-f2b882f2251e-1530810500266@msvc-mesg-gmx024>
 <20180706160523.kxwxjzwneseaamnt@merlins.org>
 <20180706175636.53ebp7drifiqu5b7@merlins.org>
 <20180707172114.bfc26eoahullffgg@merlins.org>
 <4176efa9-0753-ed28-cf15-69f0b1f1a09b@cn.fujitsu.com>
 <4576731a-ce45-60f4-d409-decf77910cd2@gmx.com>
 <20180710035057.bdbilddtss5mcfhg@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <37008664-c181-c662-babb-9cf8bf65518e@gmx.com>
Date: Tue, 10 Jul 2018 12:55:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180710035057.bdbilddtss5mcfhg@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月10日 11:50, Marc MERLIN wrote:
> On Tue, Jul 10, 2018 at 09:34:36AM +0800, Qu Wenruo wrote:
>>>>>> Ok, this is where I am now:
>>>>>> WARNING: debug: end of checking extent item[18457780273152 169 1]
>>>>>> type: 176 offset: 2
>>>>>> checking extent items [18457780273152/18457780273152]
>>>>>> ERROR: errors found in extent allocation tree or chunk allocation
>>>>>> checking fs roots
>>>>>> ERROR: root 17592 EXTENT_DATA[25937109 4096] gap exists, expected:
>>>>>> EXTENT_DATA[25937109 4033]
>>
>> The expected end is not even aligned to sectorsize.
>>
>> I think there is something wrong.
>> Dump tree on this INODE would definitely help in this case.
>>
>> Marc, would you please try dump using the following command?
>>
>> # btrfs ins dump-tree -t 17592 <dev> | grep -C 40 25937109
>  
> Sure, there you go:
> gargamel:~# btrfs ins dump-tree -t 17592 /dev/mapper/dshelf2  | grep -C 40 25937109
[snip]
> 	item 30 key (25937109 INODE_ITEM 0) itemoff 13611 itemsize 160
> 		generation 137680 transid 137680 size 85312 nbytes 85953
> 		block group 0 mode 100644 links 1 uid 500 gid 500 rdev 0
> 		sequence 253 flags 0x0(none)
> 		atime 1529023177.0 (2018-06-14 17:39:37)
> 		ctime 1529023181.625870411 (2018-06-14 17:39:41)
> 		mtime 1528885147.0 (2018-06-13 03:19:07)
> 		otime 1529023159.138139719 (2018-06-14 17:39:19)
> 	item 31 key (25937109 INODE_REF 14354867) itemoff 13559 itemsize 52
> 		index 33627 namelen 42 name: thumb1024_112_DiveB-1_Oslob_Whaleshark.jpg
> 	item 32 key (25937109 EXTENT_DATA 0) itemoff 11563 itemsize 1996
> 		generation 137680 type 0 (inline)
> 		inline extent data size 1975 ram_bytes 4033 compression 2 (lzo)
> 	item 33 key (25937109 EXTENT_DATA 4033) itemoff 11510 itemsize 53
> 		generation 143349 type 1 (regular)
> 		extent data disk byte 0 nr 0
> 		extent data offset 0 nr 63 ram 63
> 		extent compression 0 (none)

OK this seems to be caused by btrfs check --repair.
(According to the generation difference).

So at least no data loss is caused in term of on-disk data.

However I'm not sure if kernel can handle it.
Please try to read it with caution, and see if kernel could handle it.
(I assume for the latest kernel, tree-checker would detect it and refuse
to read)

This needs some fix in btrfs check.

Thanks,
Qu

> 	item 34 key (25937109 EXTENT_DATA 4096) itemoff 11457 itemsize 53
> 		generation 137680 type 1 (regular)
> 		extent data disk byte 1286516736 nr 4096
> 		extent data offset 0 nr 4096 ram 4096
> 		extent compression 0 (none)
> 	item 35 key (25937109 EXTENT_DATA 8192) itemoff 11404 itemsize 53
> 		generation 137680 type 1 (regular)
> 		extent data disk byte 1286520832 nr 8192
> 		extent data offset 0 nr 12288 ram 12288
> 		extent compression 2 (lzo)
> 	item 36 key (25937109 EXTENT_DATA 20480) itemoff 11351 itemsize 53
> 		generation 137680 type 1 (regular)
> 		extent data disk byte 4199424000 nr 65536
> 		extent data offset 0 nr 65536 ram 65536
> 		extent compression 0 (none)
