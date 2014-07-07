Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:59267 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaGGM0I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 08:26:08 -0400
Received: by mail-ie0-f176.google.com with SMTP id at1so3594723iec.35
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 05:26:07 -0700 (PDT)
Message-ID: <53BA91DE.8080802@gmail.com>
Date: Mon, 07 Jul 2014 07:26:06 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: qgroup destroy / assign
References: <53B7185F.4040307@gmail.com> <53B9FE9A.7030205@cn.fujitsu.com>
In-Reply-To: <53B9FE9A.7030205@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang,

Yes that certainly helps me make more sense of it. I was able to get the
qgroup assigning to work properly.
I guess the next question would be if it would be a valid feature to
implement automatic qgroup deletion
when a subvolume is destroyed. I suppose in order to help alleviate
issues with that perhaps it may also be useful to
require user created qgroups to be at least level 1. that way it would
be trivial to detect qgroups that were created for subvolumes, as they
would all be level 0. I don't think this would cause any issues since
you can't assign a subvolume to another qgroup from what I can tell,
only a qgroup to another qgroup.

-Kevin

On 07/06/2014 08:57 PM, Wang Shilong wrote:
> Hi Kevin,
>
> On 07/05/2014 05:10 AM, Kevin Brandstatter wrote:
>> how are qgroups accounted for? Are they specifially tied to one
>> subvolume on creation?
> Qgroup implementation is aslo a little confusing for me at first:-) .
>
> Yes, a qgroup is created automatically tied to one subvolume on creation
> with the same objectid.
>
> To implement qgroup group, you may want to do something like following:
>
>                     [1/1]
>                     /       \
>                    /         \
>              sub1(5)   subv2(257)
>
>>        
>> If so, is it possible to auto delete relavant qgroups on deletion of the
>> subvolume?
> I supposed so, according to latest qgroup patches flighting on, a
> subvolume
> qgroup should be destroyed safely, when it finished sub-tree space
> accounting.
>
>>
>> also, how exactly does qgroup assign work? I havent been able to get it
>> to work at all.
>> in btrfsprogs cmds-cgroup.c
>> if ((args.src >> 48) >= (args.dst >> 48)) {
>>        fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
>>        return 1;
>>     }
> Oh, this is to implement a strict level qgroup group, which means a
> u64 is
> divided into two parts, 16bits for level and the rest for id.
>
> So we ask parent qgroup's level must be greater than child's qgroup.that
> is the code you see above.
>
> You could create a qgroup relation like this:
>
> # btrfs qgroup assign 256 1/1 <mnt>
>
> Hopely, this could help you.
>> always seems to fail. I tried creating another qgroup id 1000, and
>> assigning it to as sub, and vice versa, as well as assigning the sub to
>> the root, and vice versa, as well as one subvol to another.
>> The fixme comment leads me to believe that the src should be a path not
>> a qgroup ("FIXME src should accept subvol path")
>> but the progs let me create a qgroup without a subvol, which makes sense
>> if you want to be able to have some meta-qgroup for a bunch of subvols.
>> Further on noticing that a sub create also creates a qgroup with the
>> same id as the subvol, it would seem that the qgroup is tied to the
>> subvol via this shared id.
>>
>> -Kevin Brandstatter
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

