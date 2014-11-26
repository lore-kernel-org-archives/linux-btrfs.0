Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46312 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751508AbaKZAsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 19:48:23 -0500
Message-ID: <54752354.4010601@cn.fujitsu.com>
Date: Wed, 26 Nov 2014 08:48:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] btrfs-progs: New 'lost+found' infrastructrue with
References: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com> <20141125183215.GP26471@twin.jikos.cz>
In-Reply-To: <20141125183215.GP26471@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 0/6] btrfs-progs: New 'lost+found' infrastructrue with
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年11月26日 02:32
> On Mon, Nov 24, 2014 at 05:06:59PM +0800, Qu Wenruo wrote:
>> Introduce the new 'lost+found' dir and related infrastructure to create it
>> in btrfs-progs.
>>
>> [BUG]
>> With the new infrastructure, fix a bug that some people reported in both
>> kernel BZ and maillist, which there is some files' nlink is 1 but backref
>> points to non-exist parent.
>> The two reporters all report missing file(chrome config file), so we'd
>> better not to delete such files but use the 'lost+found' dir.
> Well, I don't like introducing the lost+found directory.
>
> My idea is to extend the rescue utilities to extract the unlinked and
> copy them to a user defined directory and do not touch the filesystem.
Personally, also mentioned by others (maybe Chris?), I think btrfs 
should only have two fsck facilities:
btrfsck for offline check and recovery, and scrub for online check and 
recovery.

So rescue may finally be merged into btrfsck and extending rescue may 
not be a good idea.

Also, such nlink mismatch is not such a huge bug destroying the whole fs 
or making it unable to mount,
end users may not be happy with the fact they need to extra command 
other than btrfsck to fix such
a small problem.
>
> Or, at least make the in-filesytem lost+found directory creation
> optional.
This seems better, but when user gives '--repair' option, they should be 
aware of the fact that the fs
maybe modified by btrfsck.

Still your idea about optional creation of 'lost+found' dir is indeed 
important for end users,
just like e2fsck's annoying but solid prompt.

What about try to prompt user that we are going to modify the fs and ask 
for y/n ?
> You've split the patches well so I'm going to pull 1-5
> directly. Patch 6 should be updated a bit, I'll look closer and will let
> you know.
0004 and 0005 have some small fixes, I'll send the v2 patches soon.

Thanks,
Qu
>
>> 2. Unify the repair framework.
>> When writing the 6th patch, I think it is better to build a frame work
>> that unify the check and repair framework.
>> In 6th patch, my patchset and Josef's commit 2dc4c001 in fact has some
>> similar function but do the repair in different time and functions.
>>
>> I will try to build a unified framework for repair, each repair will be
>> independent and have its own err number.
>> And each repair function should work like the following:
>> 1) Check the error number
>> 2) Do the repair
>> 3) Update the related btrfsck record(like newly created inode, deleted inode)
> The unification is most welcome, feel free to send me anything that could be
> merged as preparatory work (cleanups, safe changes, etc).

