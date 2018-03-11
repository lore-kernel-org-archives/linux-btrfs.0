Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:54193 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932173AbeCKRvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Mar 2018 13:51:24 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Ongoing Btrfs stability issues
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Nikolay Borisov <nborisov@suse.com>, Alex Adriaanse <alex@oseberg.io>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
 <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
 <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
 <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
 <5a12a7b7-6cf3-82f8-d5fa-2915fc3d6680@suse.com>
 <1520692153.24363.15.camel@scientia.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <01ddb562-f1e2-25cf-0a8a-ffaa43b867d3@libero.it>
Date: Sun, 11 Mar 2018 18:51:19 +0100
MIME-Version: 1.0
In-Reply-To: <1520692153.24363.15.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2018 03:29 PM, Christoph Anton Mitterer wrote:
> On Sat, 2018-03-10 at 14:04 +0200, Nikolay Borisov wrote:
>> So for OLTP workloads you definitely want nodatacow enabled, bear in
>> mind this also disables crc checksumming, but your db engine should
>> already have such functionality implemented in it.
> 
> Unlike repeated claims made here on the list and other places... I
> woudln't now *any* DB system which actually does this per default and
> or in a way that would be comparable to filesystem lvl checksumming.
> 

I agree with you, also nobody warn that without checksum in case of RAID filesystem BTRFS is not capable anymore to check if a stripe is correct or not

> 
> Look back in the archives... when I've asked several times for
> checksumming support *with* nodatacow, I evaluated the existing status
> for the big ones (postgres,mysql,sqlite,bdb)... and all of them had
> this either not enabled per default, not at all, or requiring special
> support for the program using the DB.
> 
> 
> Similar btw: no single VM image type I've evaluated back then had any
> form of checksumming integrated.
> 
> 
> Still, one of the major deficiencies (not in comparison to other fs,
> but in comparison to how it should be) of btrfs unfortunately :-(

COW is needed to properly checksum the data. Otherwise is not possible to ensure the coherency between data and checksum (however I have to point out that BTRFS fails even in this case [*]).
We could rearrange this sentence, saying that: if you want checksum, you need COW...

> 
> 
> Cheers,
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

[*] https://www.spinics.net/lists/linux-btrfs/msg69185.html

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
