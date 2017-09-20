Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:26824 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdITACQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 20:02:16 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E6B85AC0136
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 09:02:01 +0900 (JST)
Subject: Re: btrfs-progs: suggestion of removing --commit-after option of
 subvol delete
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
 <20170919144836.GE29043@twin.jikos.cz>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <8dc33ed1-bd31-9ba8-b439-3cf623b530dc@jp.fujitsu.com>
Date: Wed, 20 Sep 2017 09:01:55 +0900
MIME-Version: 1.0
In-Reply-To: <20170919144836.GE29043@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/09/19 23:48, David Sterba wrote:
> On Tue, Sep 19, 2017 at 04:50:04PM +0900, Misono, Tomohiro wrote:
>> I read the code of "subvolume delete" and found that --commit-after option is
>> not working well.
>>
>> Since it issues BTRFS_IOC_START/WAIT_SYNC to the last fd (of directory
>> containing the last deleted subvolume),
>> 1. sync operation affects only the last fd's filesystem.
>>    ("subvolume delete" can take multiple subvolumes on different filesystems.)
> 
> You're right, though I don't think this is a common usecase.
> 
>> 2. if the last delete action fails to open the path (fd == -1),
>>    SYNC is not issued at all.
>>
>> One solution is to keep every fd for deleted subvolumes, but I think it takes
>> too much cost.
> 
> How do you evaluate the cost? We'd have to keep track of all the
> distinct filesystems of the subvolumes, so we issue sync on each of them
> in the end.

This potentially keep many fds long time. Since the number of open file descriptors
is limited, I don't think it is good to keep fds long time.

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
> 
> 

