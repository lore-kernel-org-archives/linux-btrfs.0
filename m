Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58892 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751283AbdIUCwz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 22:52:55 -0400
Subject: Re: btrfs-progs: suggestion of removing --commit-after option of
 subvol delete
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
 <20170919144836.GE29043@twin.jikos.cz>
 <18fc2d5c-de1a-7e0e-dd8f-bcae3fd24fef@gmx.com>
 <20170920140328.GJ29043@twin.jikos.cz>
 <a226d151-b9b7-39ab-253d-40885d7b0739@gmx.com>
 <e0aaf960-265a-a0fb-aece-8646a3757e9c@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <366b0add-9606-63e2-7557-a291eff15c3d@gmx.com>
Date: Thu, 21 Sep 2017 10:52:40 +0800
MIME-Version: 1.0
In-Reply-To: <e0aaf960-265a-a0fb-aece-8646a3757e9c@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月21日 10:49, Misono, Tomohiro wrote:
> On 2017/09/20 23:21, Qu Wenruo wrote:
>>
>>
>> On 2017年09月20日 22:03, David Sterba wrote:
>>> On Wed, Sep 20, 2017 at 08:22:54AM +0800, Qu Wenruo wrote:
>>>> The costly part will be tracking the filesystems of subvolumes.
>>>> We must do it for each subvolume and batch them to address the final
>>>> transaction commit for each fs.
>>>>
>>>> I didn't see any easy ioctl to get the UUID from fd, meaning (if didn't
>>>> miss anything) we need to iterate the path until reaching the mount
>>>> boundary and then refer to mountinfo to find the fs.
>>>
>>> The FS_INFO ioctl will tell you the fsid from a fd.  Iterating the paths
>>> will not work reliably, due to some potentially very creative use of
>>> mounts that could build up the path components.
>>
>> The biggest concern is about how to get fsid reliably.
>> And since FS_INFO ioctl solves this, I'm completely fine.
>> (I just search "UUID" for ioctls and get no hit, so I assume it may be a
>> problem)
>>
>>>
>>>> Not to mention that the possible softlink in the path may make things
>>>> more complex.
>>>>
>>>> Yes, this may be fixed with tons of code, but I don't think the
>>>> complexity worthy for a minor feature.
>>>
>>> So what if we fix it like that:
>>>
>>> - iterate over subvolumes
>>> - check if the fsid is same as for the previous subvolume
>>>     - if it is, continue
>>>     - if not, do the sync
>>
>> I prefer to maintain a subvolume <-> fs mapping, and only address
>> transaction commit after all subvolumes are iterated.
>>
>>>
>>> IOW, sync when we leave subvolumes of one filesystem. In the degenerate
>>> case, we can have subvolumes interleaved that we'd sync after each,
>>> effectively --commit-each.
>>
>> Since we have a subvolume <-> fs mapping, we can commit each fs after
>> iterating all subvolumes.
>>
>> AFAIK "--commit-after" user would like to introduce the minimal commits,
>> so each fs only get committed once seems better to me.
>>
>>>
>>> The simple tracking should avoid keeping all the filedescriptors open
>>> and I think this won't need tons of code to implement.
>>
>> Indeed, since there is reliable fs UUID ioctl.
>>
>> And above subvolume <-> fs mapping can also be used to resolve missing
>> fd problems.
>> Just adding a fds <-> fs mapping, and try to call commit ioctl on first
>> good fd.
>>
>>>
>>> The typical could be 'btrfs subvol delete -c path/*', ie. deleting from
>>> just one filesystem. If we happen to cross more filesystems, each of
>>> them will get the sync, but possibly more than one. I don't think this
>>> is too serious.
>>
>> Well, after we implemented above user case, some facility can be reused
>> for this case.
>>
>> Thanks,
>> Qu
> 
> OK, I understood the points and will try to make a patch.
> btw, by saying "some facility can be reused", do you mean we can reuse
> fds <-> fs mapping function to other than delete?

Yes, I think there may be some other use cases can benefit from such 
mapping.

Thanks,
Qu

> 
> Thanks,
> Tomohiro
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
