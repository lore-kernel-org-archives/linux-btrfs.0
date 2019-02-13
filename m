Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABE6C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63326222C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391178AbfBMPDD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 10:03:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:33342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfBMPDD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 10:03:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3E6FFAE52;
        Wed, 13 Feb 2019 15:03:01 +0000 (UTC)
Subject: Re: [PATCH] btrfs: ensure that a DUP block group has exactly two
 stripes
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Liu Bo <obuil.liubo@gmail.com>
References: <20190213142602.20436-1-jthumshirn@suse.de>
 <cbc103a1-3558-fac1-a45b-dcaf5d4d72ea@mendix.com>
 <74e12497-9d05-43c7-f2bb-213710cfbc85@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <cf19bdd5-91a8-b783-84c5-89111c3cbe25@suse.com>
Date:   Wed, 13 Feb 2019 17:02:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <74e12497-9d05-43c7-f2bb-213710cfbc85@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 13.02.19 г. 16:37 ч., Johannes Thumshirn wrote:
> On 13/02/2019 15:32, Hans van Kranenburg wrote:
> [...]
> 
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 03f223aa7194..b40cc7c830f4 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -6794,7 +6794,7 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
>>>  	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
>>>  	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
>>>  	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
>>> -	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
>>> +	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
>>>  	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
>>>  	     num_stripes != 1)) {
>>>  		btrfs_err(fs_info,
>>>
>>
>> It looks like the RAID1 check has a similar problem. Shouldn't that
>> check also be != 2 ?
> 
> Hmm I guess a degraded RAID1 can have only 1 stripe, doesn't it?

It depends on the POV. 

root@ubuntu-virtual:~# fallocate -l 2g /media/scratch/disk1.img
root@ubuntu-virtual:~# fallocate -l 2g /media/scratch/disk2.img
root@ubuntu-virtual:~# losetup -f /media/scratch/disk1.img 
root@ubuntu-virtual:~# losetup -f /media/scratch/disk2.img 
root@ubuntu-virtual:~# mkfs.btrfs -draid1 /dev/loop0 /dev/loop1
root@ubuntu-virtual:~# losetup -d /dev/loop1
root@ubuntu-virtual:~# mount -odegraded /dev/loop0 /media/test/

 btrfs inspect-internal dump-tree -t chunk /dev/loop0  | grep -B1 -A5 DATA\|RAID1
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863 itemsize 112
		length 214695936 owner 2 stripe_len 65536 type METADATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 9437184
			dev_uuid adb924e5-830b-4eb0-b28a-f5bee6b709ca
			stripe 1 devid 1 offset 30408704
--
	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 245104640) itemoff 15751 itemsize 112
		length 214695936 owner 2 stripe_len 65536 type DATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 224133120
			dev_uuid adb924e5-830b-4eb0-b28a-f5bee6b709ca
			stripe 1 devid 1 offset 245104640



DMESG: 
[78623.920424] BTRFS warning (device loop0): devid 2 uuid adb924e5-830b-4eb0-b28a-f5bee6b709ca is missing

> 
> 
