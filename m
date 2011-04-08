From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs-progs: add support for mixed data+metadata block
 groups
Date: Fri, 08 Apr 2011 09:15:48 -0400
Message-ID: <4D9F0A84.8010600@redhat.com>
References: <1291919468-17802-1-git-send-email-josef@redhat.com> <4D9EB9D9.5060005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9EB9D9.5060005@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2011 03:31 AM, liubo wrote:
> On 12/10/2010 02:31 AM, Josef Bacik wrote:
>> So alot of crazy people (I'm looking at you Meego) want to use btrfs on phones
>> and such with small devices.  Unfortunately the way we split out metadata/data
>> chunks it makes space usage inefficient for volumes that are smaller than
>> 1gigabyte.  So add a -M option for mixing metadata+data, and default to this
>> mixed mode if the filesystem is less than or equal to 1 gigabyte.  I've tested
>> this with xfstests on a 100mb filesystem and everything is a-ok.
>>
>
> Hi, Josef,
>
> While using this mix metadata+data option, I noticed the following from btrfs-debug-tree's print:
>
> ===
> chunk tree
> leaf 143360 items 4 free space 3557 generation 4 owner 3
> fs uuid 77d78a87-a886-4bfa-be3b-0dd052213a17
> chunk uuid e64148d6-8267-4ff1-aafd-4266f74afbb2
>          item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 3897 itemsize 98
>                  dev item devid 1 total_bytes 4999610368 bytes used 20971520
>          item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 3817 itemsize 80
>                  chunk length 4194304 owner 2 type 2 num_stripes 1
>                          stripe 0 devid 1 offset 0
>          item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 3737 itemsize 80
>                  chunk length 8388608 owner 2 type 5 num_stripes 1
>                          stripe 0 devid 1 offset 4194304
>          item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 3657 itemsize 80<== THIS ONE
>                  chunk length 8388608 owner 2 type 4 num_stripes 1		<==
>                          stripe 0 devid 1 offset 12582912			<==
> ===
>
> you see, there exists another metadata chunk (type 4) after "mkfs.btrfs -M /dev/xxx".
> So I was wondering that _IS_ this chunk what we want, or a spare one?
>

Hmm that shouldn't be there, thanks for catching that, we should only be 
creating a system block_group and a mixed block_group, not another 
metadata one.  I will fix that up.

Josef
