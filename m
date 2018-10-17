Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBEEC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 04:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95649214AB
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 04:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YE0FVtJN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95649214AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbeJQMCM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 08:02:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41604 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbeJQMCM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 08:02:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9H4570R090149;
        Wed, 17 Oct 2018 04:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=kzbq2OG3TeZf3oim2K+lIn3157+W6jzGxRCQZ420nKo=;
 b=YE0FVtJNbsMylHhi+EPpvmMpO8QdcFA7EHOKyW6GsGzS024c7/N4bnvX4JWHg8wnpaJT
 wadNFxXm6+9Hn0sfqddKv6/Qgndh6NZMNuqHP1S4br9HZ5VgdciPb7G0AzeaAvfMzThZ
 ACITDbZQGSUxbl6f+oeCWjK13lxKWrp/Mw+JOs/iOKBdi2c8pCSTeiUmCOmHGxQZ5LOU
 w+HU+Rap/fX3qdVEv0uM1Wfd/m9GafsH3+yjNLqoTa6xYXlzcNgHFGRimMHYzWmqpvu4
 E/ERzVEk80p/EwBbykNcjGaqeedDpxAhRhqshK5IrpPb2zNq55bg3atAx4AwB0IcSH/8 mw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2n38nq4e2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 04:08:29 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9H48TEJ004344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 04:08:29 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9H48SnG023173;
        Wed, 17 Oct 2018 04:08:28 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Oct 2018 21:08:28 -0700
Subject: Re: reproducible builds with btrfs seed feature
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <11171664-790c-40ff-3925-1c179ab8e74b@oracle.com>
 <CAJCQCtSfuLTsxXfEkmz59PrOJ3LrXmGNG+_NKS_LPk9dHTgkug@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <d63839e6-6d76-2457-cbe5-7e5a60181d23@oracle.com>
Date:   Wed, 17 Oct 2018 12:08:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSfuLTsxXfEkmz59PrOJ3LrXmGNG+_NKS_LPk9dHTgkug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9048 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170035
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/17/2018 03:49 AM, Chris Murphy wrote:
> On Tue, Oct 16, 2018 at 2:13 AM, Anand Jain <anand.jain@oracle.com> wrote:
>>
>>
>> On 10/14/2018 06:28 AM, Chris Murphy wrote:
>>>
>>> Is it practical and desirable to make Btrfs based OS installation
>>> images reproducible? Or is Btrfs simply too complex and
>>> non-deterministic? [1]
>>>
>>> The main three problems with Btrfs right now for reproducibility are:
>>> a. many objects have uuids other than the volume uuid; and mkfs only
>>> lets us set the volume uuid
>>> b. atime, ctime, mtime, otime; and no way to make them all the same
>>> c. non-deterministic allocation of file extents, compression, inode
>>> assignment, logical and physical address allocation
>>>
>>> I'm imagining reproducible image creation would be a mkfs feature that
>>> builds on Btrfs seed and --rootdir concepts to constrain Btrfs
>>> features to maybe make reproducible Btrfs volumes possible:
>>>
>>> - No raid
>>> - Either all objects needing uuids can have those uuids specified by
>>> switch, or possibly a defined set of uuids expressly for this use
>>> case, or possibly all of them can just be zeros (eek? not sure)
>>> - A flag to set all times the same
>>> - Possibly require that target block device is zero filled before
>>> creation of the Btrfs
>>> - Possibly disallow subvolumes and snapshots
>>> - Require the resulting image is seed/ro and maybe also a new
>>> compat_ro flag to enforce that such Btrfs file systems cannot be
>>> modified after the fact.
>>> - Enforce a consistent means of allocation and compression
>>>
>>> The end result is creating two Btrfs volumes would yield image files
>>> with matching hashes.
>>
>>
>>> If I had to guess, the biggest challenge would be allocation. But it's
>>> also possible that such an image may have problems with "sprouts". A
>>> non-removable sprout seems fairly straightforward and safe; but if a
>>> "reproducible build" type of seed is removed, it seems like removal
>>> needs to be smart enough to refresh *all* uuids found in the sprout: a
>>> hard break from the seed.
>>
>>
>> Right. The seed fsid will be gone in a detached sprout.
> 
> I think already we get a new devid, volume uuid, and device uuid.

  Yes on the sprout.

> Open
> question is whether any other uuid's need to be refreshed, such as
> chunk uuid since that appears in every node and leaf.

  There are quite a number of uuid.

>>> Any thoughts? Useful? Difficult to implement?
>>
>> Recently Nikolay sent a patch to change fsid on a mounted btrfs. However for
>> a reproducible builds it also needs neutralized uuids, time, bytenr(s)
>> further more though the ondisk layout won't change without notice but
>> block-bytenr might.
> 
> Seems like the mkfs population method of such a seed,

> could be made
> very deterministic as to what the start logical address and physical
> address are.

  Can be. But it can change in future fixes as those aren't EXPORTED().

> The vast majority of non-deterministic behavior comes
> from the nature of kernel code having to handle so many complex inputs
> and outputs, and negotiate them.

> 
>> One question why not reproducible builds get the file data extents from the
>> image and stitch the hashes together to verify the hash. And there could be
>> a vfs ioctl to import and export filesystem images for a better
>> support-ability of the use-case similar to the reproducible builds.
> 
> Perhaps. I don't know the reproducible build requirements very well,
> if all they really care about is the hash of the data extents, and
> really how important fs metadata is.


> That is important when it comes
> to fuzzing file systems that have no metadata checksumming like
> squashfs; of course you'd have to checksum the whole file system
> image.


> Another feature the mkfs variety of seed image would need,
> deduplication.  As far as I know, deduplication is kernel code only.
> You'd want to be able to deduplicate, 


> as well as compress, to have the
> smallest distributed seed possible.

btrfs-image(8) already does compress.

I don't think mkfs is the right place to sanitize the uuid/fsid/time... 
it should be when we generate the btrfs-image.

  So a possible solution for the reproducible builds:
    usual mkfs.btrfs dev
    Write the data
    unmount; create btrfs-image with uuid/fsid/time sanitized; mark it 
as a seed (RO).
    check/verify the hash of the image.

   If the hash match. To use this btrfs-image.
    Rest the seed (RO) flag; mount and use it;
    OR
    Mount the seed device; add a RW sprout; detach the seed;
    OR
    Don't set the RO at all (above) and just mount and use it;

Thanks, Anand

> And mksquashfs does deduplication
> by default.


