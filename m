Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53584 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdITAXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 20:23:10 -0400
Subject: Re: btrfs-progs: suggestion of removing --commit-after option of
 subvol delete
To: dsterba@suse.cz, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
 <20170919144836.GE29043@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <18fc2d5c-de1a-7e0e-dd8f-bcae3fd24fef@gmx.com>
Date: Wed, 20 Sep 2017 08:22:54 +0800
MIME-Version: 1.0
In-Reply-To: <20170919144836.GE29043@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月19日 22:48, David Sterba wrote:
> On Tue, Sep 19, 2017 at 04:50:04PM +0900, Misono, Tomohiro wrote:
>> I read the code of "subvolume delete" and found that --commit-after option is
>> not working well.
>>
>> Since it issues BTRFS_IOC_START/WAIT_SYNC to the last fd (of directory
>> containing the last deleted subvolume),
>> 1. sync operation affects only the last fd's filesystem.
>>     ("subvolume delete" can take multiple subvolumes on different filesystems.)
> 
> You're right, though I don't think this is a common usecase.
> 
>> 2. if the last delete action fails to open the path (fd == -1),
>>     SYNC is not issued at all.
>>
>> One solution is to keep every fd for deleted subvolumes, but I think it takes
>> too much cost.
> 
> How do you evaluate the cost? We'd have to keep track of all the
> distinct filesystems of the subvolumes, so we issue sync on each of them
> in the end.

The costly part will be tracking the filesystems of subvolumes.
We must do it for each subvolume and batch them to address the final 
transaction commit for each fs.

I didn't see any easy ioctl to get the UUID from fd, meaning (if didn't 
miss anything) we need to iterate the path until reaching the mount 
boundary and then refer to mountinfo to find the fs.

Not to mention that the possible softlink in the path may make things 
more complex.

Yes, this may be fixed with tons of code, but I don't think the 
complexity worthy for a minor feature.
(Remember how --rootdir get untested and buggy over time? And we even 
don't know how to make test case to verify --commit-after/each)

Thanks,
Qu

> 
>> Since we can just use "btrfs filesystem sync" after delete if
>> needed, I think it is ok to remove --comit-after option.
> 
> The point of the option is to allow the sync in the same command as the
> subvolume deletion. Even with the sync, the user would still have to
> know all the filesystems where the the subvolumes were, so some way of
> tracking them would need to be done.
> 
> I don't want to remove the option unless it's really not working as
> expected and could mislead the users. What you found are bugs that can
> be fixed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
