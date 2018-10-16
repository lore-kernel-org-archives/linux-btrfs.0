Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11B9C04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 08:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6834C20866
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 08:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BzHrl5I3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6834C20866
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbeJPQD2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 12:03:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbeJPQD2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 12:03:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G8DiUr083396;
        Tue, 16 Oct 2018 08:14:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=oeukSyMqhag6ZNEYgqcEb07MAn/aZrbOZRs19pRyAUQ=;
 b=BzHrl5I3RjjLRrGK2wO9AQv8J/54Hiud//GishM+Bgao9dQRc4V79OCf3DpwAX9P1Vc+
 1gNAA6xO5FnCkDMwCJaMAzNywPsVMUi2Bb+hRkpZiFXEQwADZG8UxKEoCKwhGOZfw4qG
 1tSG2WhyyDqZZs87/DBSovXjW3QJ01iRMQBKWqGKcqjFZbhYOUJ53kRwDfzw6BPPlY0o
 4uJpAK2Rk94VVD6HEdrheqHt0NgcR46/j93474RY48lyq9vK06PoVZJmZzzdP0F4Q3Xt
 DnreY6FWzSn8bmNGBW0k9MabeitsqKZsXz9hM36rY+EHzj34HYsjzUysrP1sRl6Q1HGc 2g== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2n38npxxcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 08:14:11 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G8EBtT003936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 08:14:11 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9G8EA0v017024;
        Tue, 16 Oct 2018 08:14:10 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Oct 2018 01:14:10 -0700
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
Message-ID: <11171664-790c-40ff-3925-1c179ab8e74b@oracle.com>
Date:   Tue, 16 Oct 2018 16:13:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/14/2018 06:28 AM, Chris Murphy wrote:
> Is it practical and desirable to make Btrfs based OS installation
> images reproducible? Or is Btrfs simply too complex and
> non-deterministic? [1]
> 
> The main three problems with Btrfs right now for reproducibility are:
> a. many objects have uuids other than the volume uuid; and mkfs only
> lets us set the volume uuid
> b. atime, ctime, mtime, otime; and no way to make them all the same
> c. non-deterministic allocation of file extents, compression, inode
> assignment, logical and physical address allocation
> 
> I'm imagining reproducible image creation would be a mkfs feature that
> builds on Btrfs seed and --rootdir concepts to constrain Btrfs
> features to maybe make reproducible Btrfs volumes possible:
> 
> - No raid
> - Either all objects needing uuids can have those uuids specified by
> switch, or possibly a defined set of uuids expressly for this use
> case, or possibly all of them can just be zeros (eek? not sure)
> - A flag to set all times the same
> - Possibly require that target block device is zero filled before
> creation of the Btrfs
> - Possibly disallow subvolumes and snapshots
> - Require the resulting image is seed/ro and maybe also a new
> compat_ro flag to enforce that such Btrfs file systems cannot be
> modified after the fact.
> - Enforce a consistent means of allocation and compression
> 
> The end result is creating two Btrfs volumes would yield image files
> with matching hashes.

> If I had to guess, the biggest challenge would be allocation. But it's
> also possible that such an image may have problems with "sprouts". A
> non-removable sprout seems fairly straightforward and safe; but if a
> "reproducible build" type of seed is removed, it seems like removal
> needs to be smart enough to refresh *all* uuids found in the sprout: a
> hard break from the seed.

Right. The seed fsid will be gone in a detached sprout.

> Competing file systems, ext4 with make_ext4 fork, and squashfs. At the
> moment I'm thinking it might be easier to teach squashfs integrity
> checking than to make Btrfs reproducible.  But then I also think
> restricting Btrfs features, and applying some requirements to
> constrain Btrfs to make it reproducible, really enhances the Btrfs
> seed-sprout feature.

 > Any thoughts? Useful? Difficult to implement?

Recently Nikolay sent a patch to change fsid on a mounted btrfs. However 
for a reproducible builds it also needs neutralized uuids, time, 
bytenr(s) further more though the ondisk layout won't change without 
notice but block-bytenr might.

One question why not reproducible builds get the file data extents from 
the image and stitch the hashes together to verify the hash. And there 
could be a vfs ioctl to import and export filesystem images for a better 
support-ability of the use-case similar to the reproducible builds.

For the seed sprout feature one thing I have in mind is to make it image 
and subvolume granular rather than the disk and fsid granular, and 
ability to transpire golden image (seed) updates, but I haven't checked 
the feasibility yet.

Thanks, Anand

> 
> Squashfs might be a better fit for this use case *if* it can be taught
> about integrity checking.

> It does per file checksums for the purpose
> of deduplication but those checksums aren't retained for later
> integrity checking.
> 
> [1] problems of reproducible system images
> https://reproducible-builds.org/docs/system-images/
> 
> [2] purpose and motivation for reproducible builds
> https://reproducible-builds.org/
> 
> [3] who is involved?
> https://reproducible-builds.org/who/#Qubes%20OS
> 
> 
> 
> 
