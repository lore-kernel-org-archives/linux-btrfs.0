Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:33083 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753979AbdHDXzT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 19:55:19 -0400
Received: by mail-yw0-f170.google.com with SMTP id p68so18428025ywg.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Aug 2017 16:55:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za> <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
From: Wang Shilong <wangshilong1991@gmail.com>
Date: Sat, 5 Aug 2017 07:55:18 +0800
Message-ID: <CAP9B-QmCP69iY7Ug1ey6N-H7sZQbz8RBV17y1mSbkXvzC8mnSg@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

On Fri, Aug 4, 2017 at 10:05 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年08月02日 16:38, Brendan Hide wrote:
>>
>> The title seems alarmist to me - and I suspect it is going to be
>> misconstrued. :-/
>>
>>  From the release notes at
>> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/7.4_Release_Notes/chap-Red_Hat_Enterprise_Linux-7.4_Release_Notes-Deprecated_Functionality.html
>>
>> "Btrfs has been deprecated
>>
>> The Btrfs file system has been in Technology Preview state since the
>> initial release of Red Hat Enterprise Linux 6. Red Hat will not be moving
>> Btrfs to a fully supported feature and it will be removed in a future major
>> release of Red Hat Enterprise Linux.
>>
>> The Btrfs file system did receive numerous updates from the upstream in
>> Red Hat Enterprise Linux 7.4 and will remain available in the Red Hat
>> Enterprise Linux 7 series. However, this is the last planned update to this
>> feature.
>>
>> Red Hat will continue to invest in future technologies to address the use
>> cases of our customers, specifically those related to snapshots,
>> compression, NVRAM, and ease of use. We encourage feedback through your Red
>> Hat representative on features and requirements you have for file systems
>> and storage technology."
>
>
> Personally speaking, unlike most of the btrfs supporters, I think Red Hat is
> doing the correct thing for their enterprise use case.
>
> (To clarify, I'm not going to Red Hat, just in case anyone wonders why I'm
> not supporting btrfs)
>
> [Good things of btrfs]
> Btrfs is indeed a technic pioneer in a lot of aspects (at least in linux
> world):
>
> 1) Metadata CoW instead of traditional journal
> 2) Snapshot and delta-backup
>     I think this is the killer feature of Btrfs, and why SUSE is using it
> for root fs.
> 3) Default data CoW
> 4) Data checksum and scrubbing
> 5) Multi-device management
> 6) Online resize/balancing
> And a lot of more.
>
> [Bad things of btrfs]
> But for enterprise usage, it's too advanced and has several problems
> preventing them being widely applied:
>
> 1) Low performance from metadata/data CoW
>     This is a little complicated dilemma.
>     Although Btrfs can disable data CoW, nodatacow also disables data
> checksum, which is another main feature for btrfs.
>     So Btrfs can't default to nodatacow, unlike XFS.
>
>     And metadata CoW causes extra metadata write along with superblock
> update (FUA), further degrading the performance.
>
>     Such pioneered design makes traditional performance-intense use case
> very unhappy.
>     Especially for almost all kind of databases. (Note that nodatacow can't
> always solve the performance problem).
>     Most performance intense usage is still based on tradtional fs design
> (journal with no CoW)
>
> 2) Low concurrency caused by tree design.
>      Unlike traditional one-tree-for-one-inode design, btrfs uses
> one-tree-for-one-subvolume.
>      The design makes snapshot implementation very easy, while makes tree
> very hot when a lot of modifiers are trying to modify any metadata.
>
>      Btrfs has a lot of different way to solve it.
>      For extent tree (the most busy tree), we are using delayed-ref to speed
> up extent tree update.
>      For fs tree fsync, we have log tree to speed things up.
>      These approaches work, at the cost of complexity and bugs, and we still
> have slow fs tree modification speed.
>
> 3) Low code reusage of device-mapper.
>      I totally understand that, due to the unique support for data csum,
> btrfs can't use device-mapper directly, as we must verify the data read out
> from device before passing it to higher level.
>     So Btrfs uses its own device-mapper like implementation to handle
> multi-device management.
>
>     The result is mixed. For easy to handle case like RAID0/1/10 btrfs is
> doing well.
>     While for RAID5/6, everyone knows the result.
>
>     Such btrfs *enhanced* re-implementation not only makes btrfs larger but
> also more complex and bug-prune.
>
> In short, btrfs is too advanced for generic use cases (performance) and
> developers (bugs), unfortunately.
>
> And even SUSE is just pushing btrfs as root fs, mainly for the snapshot
> feature.
> But still ext4/xfs for data or performance intense use case.
>
>
> [Other solution on the table]
> On the other hand, I think RedHat is pushing storage technology based on LVM
> (thin) and Xfs.
>
> For traditional LVM, it's stable but its snapshot design is old-fashion and
> low-performance.
> While new thin-provision LVM solves the problem using a method just like
> Btrfs, but at block level.
>
> And for XFS, it's still traditional designed, journal based,
> one-tree-for-one-inode.
> But with fancy new features like data CoW.
>
> Even XFS + LVM-thin lacks ability to shrink fs or scrub data or delta
> backup, it can do a lot of things just like Btrfs.
> From snapshot to multi-device management.
>
> And more importantly, has better performance for things like DB.
>
> So, for old use cases, the performance stays almost the same.
> For developers, guys are still focusing on their old fields, less to concern
> and more focused to debug. The old UNIX method still works here, do one
> thing and do it well.
>
> It provides some of the fancy features from btrfs, but not too fancy.
> It's a compromising move, but a good move for enterprise usage.
>
> [The future]
> When btrfs is almost as good as traditional solutions for both performance
> and stability, I think it will be widely applied no matter whether RedHat
> uses it or not, especially since btrfs still has features which LVM-thin +
> XFS can't provide.
>
> But the future is still full of challenges.
> 1) Complexity of btrfs makes development slow.
>     Developers are already doing their work well, but the numbers of lines
> are twice of traditional fs.
>
> 2) New device-mapper based solution may come out fast
>     Dm-thin is already here, and I won't be surprised that one day there
> will be hooks/API for device-mapper to communicate with higher levels.
>
>     For example, if one day there is some dm-csum to support verify csum of
> given ranges (and skip unrelated ones specified by higher levels), btrfs
> support for data csum is no longer an exclusive feature.


Fair enough and good conclusion, I think most of reasons come to btrfs stability
and RedHat could not have some good developers for Btrfs like you.

I think for the future, the most difficult thing for Btrfs comes to
performance, Btrfs could
not scale with CPU numbers increased, that is bad for metadata heavy load
or even small io random read/write.

Thanks,
Shilong


>
> Thanks,
> Qu
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
