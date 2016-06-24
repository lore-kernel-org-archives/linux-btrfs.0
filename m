Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43565 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750831AbcFXEeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 00:34:12 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5O4TaNZ053804
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 00:34:11 -0400
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23ruex3wph-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 00:34:10 -0400
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 24 Jun 2016 14:34:08 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 074D52BB0055
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 14:34:06 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5O4Y6LC8585494
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 14:34:06 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5O4Y5W0027007
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 14:34:05 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Date: Fri, 24 Jun 2016 10:04:01 +0530
In-Reply-To: <023d6b07-2326-bc48-188e-21ff8a442304@cn.fujitsu.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com> <20160623121738.GZ4915@twin.jikos.cz> <023d6b07-2326-bc48-188e-21ff8a442304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <4970618.KX09nNxAau@reserved-192-168-1-6.rchland.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, June 24, 2016 10:50:41 AM Qu Wenruo wrote:
> Hi Chandan, David,
> 
> When I'm trying to rebase dedupe patchset on top of Chadan's sub page 
> size patchset (using David's for-next-test-20160620), although the 
> rebase itself is quite simple, but I'm afraid that I found some bugs for 
> sub page size patchset, *without* dedupe patchset applied.
> 
> These bugs seems to be unrelated to each other
> 1) state leak at btrfs rmmod time
> 2) bytes_may_use leak at qgroup EDQUOTA error time
> 3) selftest is run several times at modules load time
>     15 times, to be more exact
>     And since I didn't found any immediate number related to run it 15
>     times, I assume at least it's not designed to do it 15 times.
>

Ah, In btrfs_run_sanity_tests(), just after,

for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
        sectorsize = test_sectorsize[i];


I missed out on adding "if (sectorsize > PAGE_SIZE) break;". I will fix this
up in the next post of the patchset. Thanks for pointing this out.

> The reproducer for 1) and 2) is quite simple, extracted from btrfs/022 
> test case:
> ------
> dev=/dev/sdb5
> mnt=/mnt/test
> 
> umount $dev &> /dev/null
> 
> mkfs.btrfs $dev -f
> mount $dev $mnt -o nospace_cache
> btrfs dedupe enable $mnt
> btrfs sub create $mnt/sub
> btrfs quota enable $mnt
> 
> 
> # Just use small limit, making ftrace less noise.
> btrfs qgroup limit 512K 0/257 $mnt
> dd if=/dev/urandom of=$mnt/sub/test bs=1M count=1
> umount $mnt
> rmmod btrfs
> ------
> 
> At unmount time, kernel warning will happen due to may_use bytes leak.
> I could dig it further, as it looks like a bug in space reservation 
> failure case.
> ------
> BTRFS: space_info 1 has 8044544 free, is not full
> BTRFS: space_info total=8388608, used=344064, pinned=0, reserved=0, 
> may_use=409600, readonly=0
> ------
> 
> And at rmmod time, btrfs will detect extent_state leak, whose length is 
> always 4095 (page size - 1).
>

Qu, I will investigate and fix this issue. And thanks a lot for the
reproducer test.

-- 
chandan

