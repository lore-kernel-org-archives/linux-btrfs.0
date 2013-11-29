Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3K2BfM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 20:35:12 -0500
Message-ID: <5297EF3F.4030400@cn.fujitsu.com>
Date: Fri, 29 Nov 2013 09:34:55 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Anand Jain <Anand.Jain@oracle.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org FILE SYSTEM list:BTRFS"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com> <525220DC.2030403@oracle.com> <20131008164951.GC12986@twin.jikos.cz> <237D022A-BBC2-412C-9E41-45EB4B299660@gmail.com> <5256206C.3080306@oracle.com> <52562019.4090508@cn.fujitsu.com> <CAOcd+r2OJAf1MfHeB46K7bbhPTwWiM6SKCpRVojFbY18SBWEKg@mail.gmail.com>
In-Reply-To: <CAOcd+r2OJAf1MfHeB46K7bbhPTwWiM6SKCpRVojFbY18SBWEKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On 11/29/2013 01:39 AM, Alex Lyakas wrote:
> Hello Anand,
> I have sent a similar comment to your email thread in
> http://www.spinics.net/lists/linux-btrfs/msg27547.html
>
> I believe this approach of calculating freeable space is incorrect.
> Try this:
> - create a fresh btrfs
> - create a regular file
> - write some data into it in such a way, that it was, say 4000
> EXTENT_DATA items, so that file tree and extent tree get deep enough
> - run btrfs-debug-tree and verify that all EXTENT_ITEMs of this file
> (in the extent tree) have refcnt=1
> - create a snapshot of the subvolume
> - run btrfs-debug-tree again
>
> You will see that most (in my case - all) of EXTENT_ITEMs still have
> refcnt=1. Reason for this is as I mentioned in
> http://www.spinics.net/lists/linux-btrfs/msg27547.html
>
> But if you delete the subvolume, no space will be freed, because all
> these extents are also shared by the snapshot. Although it seems that
> your tool will report that all subvolume's space is freeable (based on
> refcnt=1).
>
> Can you pls try that experiment and comment on it? Perhaps I am
> missing something here?
I think you are right here, the only way we can make sure whether
a extent_item is shared by many roots is to walk backref to find
all roots, and if number of roots is 1, we know it's sole space.

If so, i don't think this should be implemented in user space, Btrfs quota
implement such function in kernel space, but it also face a problem that
deleting a subvolume will break space accounting(because subvolume deletion
won't iterate the whole fs tree).

Thanks,
Wang
>
> Thanks!
> Alex.
>
>
>
> On Thu, Oct 10, 2013 at 6:33 AM, Wang Shilong
> <wangsl.fnst@cn.fujitsu.com> wrote:
>> On 10/10/2013 11:35 AM, Anand Jain wrote:
>>>
>>>   If 'btrfs_file_extent_item' can contain the ref count it would
>>>   solve the current problem quite easily.  (problem is that, its
>>>   of n * n searches to know data extents with its ref for a given
>>>   subvol).
>> Just considering btrfs_file_extent_item is not enough, because
>> we should consider metadata(as i have said before).
>>
>>>   But what'r the challenge(s) to have ref count in the
>>>   btrfs_file_extent_item ? any thoughts ?
>> Haven't thought a better idea yet.
>>
>>
>>> Thanks, Anand
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

