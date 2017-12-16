Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751142AbdLPGzz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Dec 2017 01:55:55 -0500
Subject: Re: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument
 optional
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171215034739.26090-1-anand.jain@oracle.com>
 <20171215034739.26090-5-anand.jain@oracle.com>
 <b3a90794-2186-8740-186f-ad84733595d3@suse.com>
 <ad4808f1-1ab4-df47-a45a-f3bf6837b813@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d6ac16e5-2f11-ae8f-b5cd-97ef71e94b2d@suse.com>
Date: Sat, 16 Dec 2017 08:55:53 +0200
MIME-Version: 1.0
In-Reply-To: <ad4808f1-1ab4-df47-a45a-f3bf6837b813@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.12.2017 04:14, Anand Jain wrote:
>         /*
>>> @@ -637,8 +632,11 @@ static void btrfs_free_stale_device(struct
>>> btrfs_device *cur_dev)
>>>                * either use mapper or non mapper path throughout.
>>>                */
>>>               rcu_read_lock();
>>> -            not_found = strcmp(rcu_str_deref(dev->name),
>>> -                        rcu_str_deref(cur_dev->name));
>>> +            if (cur_dev)
>>> +                not_found = strcmp(rcu_str_deref(dev->name),
>>> +                           rcu_str_deref(cur_dev->name));
>>> +            else
>>> +                not_found = 0;
>>
>> nit: Perhaps put a proper documentation header at the beginning of the
>> function detailing this behavior. I.e.
>>
>> /*
>>   * btrfs_free_stale_device
>>   * ....
>>
> 
>  Right. Will add.

I posted this comment before reading your other patches, having done
that I'd say it's best to add the documentation once all the cleanups
have been done, since you also add another semantics with the "path"
argument.


> 
> Thanks, Anand
> 
> 
