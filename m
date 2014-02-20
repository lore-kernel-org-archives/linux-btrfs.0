Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34417 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbaBTMjt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 07:39:49 -0500
Message-ID: <5305F72F.9050109@cn.fujitsu.com>
Date: Thu, 20 Feb 2014 20:38:07 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
CC: linux-btrfs@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>
Subject: Re: Meaning of \"no_csum\" field when scrubbing with -R option
References: <5305DE1E.8080302@cn.fujitsu.com> <5305E63B.4000405@informatik.uni-bonn.de>
In-Reply-To: <5305E63B.4000405@informatik.uni-bonn.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/20/2014 07:25 PM, Sebastian Ochmann wrote:
> Hello,
>
>>     Sebastian Ochmann posted on Wed, 19 Feb 2014 13:58:17 +0100 as 
>> excerpted:
>>
>>
>>         So my question is, why does scrub show a high (i.e. non-zero) 
>> value for
>>         no_csum? I never enabled nodatasum or a similar option.
>>
>> Did you enable nodatacow option? if  nodatacow option is enabled,
>> data checksums will be also disabled at the same time.
[SNIP]

So i have found why we have such strange things from debugging, you can 
have a try as the
following steps:

# mkfs.btrfs -f /dev/sda9
# mount /dev/sda9 /mnt
# btrfs scrub start -BR /mnt

scrub done for 02dd3326-959f-4602-9baa-aa9ed99ac2e5
     scrub started at Thu Feb 20 20:31:46 2014 and finished after 0 seconds
     data_extents_scrubbed: 1
     tree_extents_scrubbed: 16
     data_bytes_scrubbed: 65536
     tree_bytes_scrubbed: 262144
     read_errors: 0
     csum_errors: 0
     verify_errors: 0
     no_csum: 16 ---------------------->not equal 0 for a newly mkfs.
     csum_discards: 0
     super_errors: 0
     malloc_errors: 0
     uncorrectable_errors: 0
     unverified_errors: 0
     corrected_errors: 0
     last_physical: 467140608

# btrfs-debug-tree /dev/sda9

By debuging tree, we found there is a EXTENT_ITEM in extent tree for newly
mkfs filesystem which we have written anything yet.

  item 2 key (12582912 EXTENT_ITEM 65536) itemoff 16182 itemsize 53
                 extent refs 1 gen 5 flags 1
                 extent data backref root 1 objectid 256 offset 0 count 1
item 3 key (12582912 BLOCK_GROUP_ITEM 8388608) itemoff 16158 itemsize 24

At the same time, Let's see Csum tree debug output:

checksum tree key (CSUM_TREE ROOT_ITEM 0)
leaf 29425664 items 0 free space 16283 generation 4 owner 7
fs uuid 02dd3326-959f-4602-9baa-aa9ed99ac2e5

So there is not corresponding checksum item for that DATA extent item..
This can explain why scrub output no_sum count!

For reasons, It may be reserved data space without checksum for other 
purpose!
So if this is true, i don't think this is harm for common users unless 
it is designed
unexpectedly!

Thanks,
Wang
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

