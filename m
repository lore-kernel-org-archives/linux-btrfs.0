From: Arne Jansen <sensille@gmx.net>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Mon, 24 Oct 2011 23:37:08 +0200
Message-ID: <4EA5DA84.9040600@gmx.net>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>	<CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>	<Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>	<20111024195147.GB31264@dhcp231-156.rdu.redhat.com>	<20111024203509.GG5458@shiny.Mikenopa.local> <CAO47_-_nkU4=ixMKhT5-PhLDhCkprNt3nN7+DfmWgbLH8qrQiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Sage Weil <sage@newdream.net>,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chb@muc.de
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-_nkU4=ixMKhT5-PhLDhCkprNt3nN7+DfmWgbLH8qrQiA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 24.10.2011 23:34, Christian Brunner wrote:
> 2011/10/24 Chris Mason<chris.mason@oracle.com>:
>> On Mon, Oct 24, 2011 at 03:51:47PM -0400, Josef Bacik wrote:
>>> On Mon, Oct 24, 2011 at 10:06:49AM -0700, Sage Weil wrote:
>>>> [adding linux-btrfs to cc]
>>>>
>>>> Josef, Chris, any ideas on the below issues?
>>>>
>>>> On Mon, 24 Oct 2011, Christian Brunner wrote:
>>>>> Thanks for explaining this. I don't have any objections against btrfs
>>>>> as a osd filesystem. Even the fact that there is no btrfs-fsck doesn't
>>>>> scare me, since I can use the ceph replication to recover a lost
>>>>> btrfs-filesystem. The only problem I have is, that btrfs is not stable
>>>>> on our side and I wonder what you are doing to make it work. (Maybe
>>>>> it's related to the load pattern of using ceph as a backend store for
>>>>> qemu).
>>>>>
>>>>> Here is a list of the btrfs problems I'm having:
>>>>>
>>>>> - When I run ceph with the default configuration (btrfs snaps enabled)
>>>>> I can see a rapid increase in Disk-I/O after a few hours of uptime.
>>>>> Btrfs-cleaner is using more and more time in
>>>>> btrfs_clean_old_snapshots().
>>>>
>>>> In theory, there shouldn't be any significant difference between taking a
>>>> snapshot and removing it a few commits later, and the prior root refs that
>>>> btrfs holds on to internally until the new commit is complete.  That's
>>>> clearly not quite the case, though.
>>>>
>>>> In any case, we're going to try to reproduce this issue in our
>>>> environment.
>>>>
>>>
>>> I've noticed this problem too, clean_old_snapshots is taking quite a while in
>>> cases where it really shouldn't.  I will see if I can come up with a reproducer
>>> that doesn't require setting up ceph ;).
>>
>> This sounds familiar though, I thought we had fixed a similar
>> regression.  Either way, Arne's readahead code should really help.
>>
>> Which kernel version were you running?
>>
>> [ ack on the rest of Josef's comments ]
>
> This was with a 3.0 kernel, including all btrfs-patches from josefs
> git repo plus the "use the global reserve when truncating the free
> space cache inode" patch.
>
> I'll try the readahead code.

The current readahead code is only used for scrub. I plan to extend it
to snapshot deletion in a next step, but currently I'm afraid it can't
help.

-Arne

>
> Thanks,
> Christian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

