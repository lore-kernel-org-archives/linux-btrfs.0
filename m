Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60336 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751788AbdA2E3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 23:29:08 -0500
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
To: Christoph Anton Mitterer <christoph.anton.mitterer@lmu.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
 <1485276845.12065.1.camel@scientia.net>
 <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
 <1485305208.12065.9.camel@scientia.net>
 <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
 <1485399036.23328.7.camel@scientia.net>
 <bb42c075-fcbd-2248-8e9f-ea5d2a836273@cn.fujitsu.com>
 <1485473476.7613.12.camel@lmu.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7125b67b-1b7e-c191-290d-cf60e63ee93e@gmx.com>
Date: Sun, 29 Jan 2017 12:27:56 +0800
MIME-Version: 1.0
In-Reply-To: <1485473476.7613.12.camel@lmu.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/27/2017 07:31 AM, Christoph Anton Mitterer wrote:
> On Thu, 2017-01-26 at 11:10 +0800, Qu Wenruo wrote:
>> Would you please try lowmem_tests branch of my repo?
>>
>> That branch contains a special debug output for the case you
>> encountered, which should help to debug the case.
>> pecial debug output for the case you encountered, which
>
> Here the output with your patches (again, not having applied the
> unnecessary fs-tests patches):
>
> In the output below I've replaced filenames with "[snip..snap]" and
> exchanged some of the xattr values.
> In case you should need their original values for testing, just tell me
> and I send them to you off-list.

Sorry for the late reply, in Chinese New Year vacation.

>
> btrfs-progs v4.9 WITH patches:
> ******************************
> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> ERROR: root 6031 EXTENT_DATA[277 524288] datasum missing, have: 36864, expect: 45056 ret: 0

Thanks a lot for your debug output!

This shows the full reason of the problem! And it can be fixed easily now.
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> === fs tree leaf dump: slot: 136 ===
> leaf 5960902508544 items 191 free space 60 generation 2775 owner 6031
> fs uuid 326d292d-f97b-43ca-b1e8-c722d3474719
> chunk uuid 5da7e818-7f0b-43c1-b465-fdfaa52da633
<snipped>
> 	item 136 key (277 EXTENT_DATA 524288) itemoff 8443 itemsize 53
> 		generation 2775 type 1 (regular)
> 		extent data disk byte 6805694144512 nr 36864
> 		extent data offset 0 nr 45056 ram 45056
> 		extent compression 1 (zlib)

I just forgot that, we must handle plain extent and compressed extent 
separately.

For compressed case, we should not use extent offset and nr_bytes, but 
use the full extent.

I'll update the patchset soon to address it.

Thanks again for your detailed output and patience,
Qu

> === csum tree dump ===
> leaf 4983028940800 items 22 free space 6853 generation 3093 owner 7
> fs uuid 326d292d-f97b-43ca-b1e8-c722d3474719
> chunk uuid 5da7e818-7f0b-43c1-b465-fdfaa52da633
> 	item 0 key (EXTENT_CSUM EXTENT_CSUM 6805691457536) itemoff 16279 itemsize 4
> 		extent csum item
> 	item 1 key (EXTENT_CSUM EXTENT_CSUM 6805691461632) itemoff 16275 itemsize 4
> 		extent csum item
> 	item 2 key (EXTENT_CSUM EXTENT_CSUM 6805691465728) itemoff 16263 itemsize 12
> 		extent csum item
> 	item 3 key (EXTENT_CSUM EXTENT_CSUM 6805691478016) itemoff 16231 itemsize 32
> 		extent csum item
> 	item 4 key (EXTENT_CSUM EXTENT_CSUM 6805691510784) itemoff 16223 itemsize 8
> 		extent csum item
> 	item 5 key (EXTENT_CSUM EXTENT_CSUM 6805691518976) itemoff 16199 itemsize 24
> 		extent csum item
> 	item 6 key (EXTENT_CSUM EXTENT_CSUM 6805691543552) itemoff 16183 itemsize 16
> 		extent csum item
> 	item 7 key (EXTENT_CSUM EXTENT_CSUM 6805691559936) itemoff 15159 itemsize 1024
> 		extent csum item
> 	item 8 key (EXTENT_CSUM EXTENT_CSUM 6805692608512) itemoff 15151 itemsize 8
> 		extent csum item
> 	item 9 key (EXTENT_CSUM EXTENT_CSUM 6805692616704) itemoff 15055 itemsize 96
> 		extent csum item
> 	item 10 key (EXTENT_CSUM EXTENT_CSUM 6805692715008) itemoff 14903 itemsize 152
> 		extent csum item
> 	item 11 key (EXTENT_CSUM EXTENT_CSUM 6805693132800) itemoff 14519 itemsize 384
> 		extent csum item
> 	item 12 key (EXTENT_CSUM EXTENT_CSUM 6805693526016) itemoff 14391 itemsize 128
> 		extent csum item
> 	item 13 key (EXTENT_CSUM EXTENT_CSUM 6805693919232) itemoff 14135 itemsize 256
> 		extent csum item
> 	item 14 key (EXTENT_CSUM EXTENT_CSUM 6805694443520) itemoff 12727 itemsize 1408
> 		extent csum item
> 	item 15 key (EXTENT_CSUM EXTENT_CSUM 6805695885312) itemoff 11811 itemsize 916
> 		extent csum item
> 	item 16 key (EXTENT_CSUM EXTENT_CSUM 6805696823296) itemoff 11007 itemsize 804
> 		extent csum item
> 	item 17 key (EXTENT_CSUM EXTENT_CSUM 6805697646592) itemoff 10211 itemsize 796
> 		extent csum item
> 	item 18 key (EXTENT_CSUM EXTENT_CSUM 6805698461696) itemoff 9799 itemsize 412
> 		extent csum item
> 	item 19 key (EXTENT_CSUM EXTENT_CSUM 6805698883584) itemoff 9259 itemsize 540
> 		extent csum item
> 	item 20 key (EXTENT_CSUM EXTENT_CSUM 6805699436544) itemoff 8827 itemsize 432
> 		extent csum item
> 	item 21 key (EXTENT_CSUM EXTENT_CSUM 6805699878912) itemoff 7403 itemsize 1424
> 		extent csum item
> ERROR: errors found in fs roots
> found 7519512838144 bytes used, error(s) found
> total csum bytes: 7330834320
> total tree bytes: 10902437888
> total fs tree bytes: 2019704832
> total extent tree bytes: 1020149760
> btree space waste bytes: 925714197
> file data blocks allocated: 7509228494848
>  referenced 7630551511040
> 1
>
>
> Cheers,
> Chris.
>
