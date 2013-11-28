Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55995 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3K1Rjw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 12:39:52 -0500
Received: by mail-wi0-f177.google.com with SMTP id cc10so1141216wib.10
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 09:39:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52562019.4090508@cn.fujitsu.com>
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com>
	<1380468336-5170-1-git-send-email-anand.jain@oracle.com>
	<20131001133919.GE18291@twin.jikos.cz>
	<C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com>
	<525220DC.2030403@oracle.com>
	<20131008164951.GC12986@twin.jikos.cz>
	<237D022A-BBC2-412C-9E41-45EB4B299660@gmail.com>
	<5256206C.3080306@oracle.com>
	<52562019.4090508@cn.fujitsu.com>
Date: Thu, 28 Nov 2013 19:39:50 +0200
Message-ID: <CAOcd+r2OJAf1MfHeB46K7bbhPTwWiM6SKCpRVojFbY18SBWEKg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could free
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org FILE SYSTEM list:BTRFS"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand,
I have sent a similar comment to your email thread in
http://www.spinics.net/lists/linux-btrfs/msg27547.html

I believe this approach of calculating freeable space is incorrect.
Try this:
- create a fresh btrfs
- create a regular file
- write some data into it in such a way, that it was, say 4000
EXTENT_DATA items, so that file tree and extent tree get deep enough
- run btrfs-debug-tree and verify that all EXTENT_ITEMs of this file
(in the extent tree) have refcnt=1
- create a snapshot of the subvolume
- run btrfs-debug-tree again

You will see that most (in my case - all) of EXTENT_ITEMs still have
refcnt=1. Reason for this is as I mentioned in
http://www.spinics.net/lists/linux-btrfs/msg27547.html

But if you delete the subvolume, no space will be freed, because all
these extents are also shared by the snapshot. Although it seems that
your tool will report that all subvolume's space is freeable (based on
refcnt=1).

Can you pls try that experiment and comment on it? Perhaps I am
missing something here?

Thanks!
Alex.



On Thu, Oct 10, 2013 at 6:33 AM, Wang Shilong
<wangsl.fnst@cn.fujitsu.com> wrote:
> On 10/10/2013 11:35 AM, Anand Jain wrote:
>>
>>
>>  If 'btrfs_file_extent_item' can contain the ref count it would
>>  solve the current problem quite easily.  (problem is that, its
>>  of n * n searches to know data extents with its ref for a given
>>  subvol).
>
> Just considering btrfs_file_extent_item is not enough, because
> we should consider metadata(as i have said before).
>
>>
>>  But what'r the challenge(s) to have ref count in the
>>  btrfs_file_extent_item ? any thoughts ?
>
> Haven't thought a better idea yet.
>
>
>>
>> Thanks, Anand
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
