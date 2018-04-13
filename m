Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:60481 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbeDMEbG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 00:31:06 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A8BB6AC018F
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Apr 2018 13:30:59 +0900 (JST)
Subject: Re: [PATCH v3 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
To: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cef1bb9a-5a32-066b-e9f6-b0010803c8bf@jp.fujitsu.com>
 <20180410182354.GH2817@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <5da3d35f-92a3-a9fa-d145-ca108757a8dc@jp.fujitsu.com>
Date: Fri, 13 Apr 2018 13:30:11 +0900
MIME-Version: 1.0
In-Reply-To: <20180410182354.GH2817@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/04/11 3:23, David Sterba wrote:
> On Mon, Mar 19, 2018 at 04:27:09PM +0900, Misono, Tomohiro wrote:
>> changelog:
>>
>> v2-> v3
>>  - fix kbuild test bot warning
>> v1 -> v2
>>   - completely reimplement 1st/2nd ioctl to have user friendly api
>>   - various cleanup, remove unnecessary goto
>> ===
>>
>> This adds three new unprivileged ioctls:
>>
>> 1st patch: ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKREF
>> 2nd patch: ioctl which returns subvolume information of ROOT_REF (without subvolume name)
>> 3rd patch: user version of ino_lookup ioctl which also peforms permission check.
> 
> The overall approach to listing subvolumes looks good. We can enumerate
> them, get the relations and the details. Making some sense of that in
> the userspace is a whole different and maybe more difficult topic.
> 
> I hope we could use the opportunity to clean up the listing commandline
> interface and output at the same time, as there's going to be possibly
> some incompatibility introduced.
> 
> We need to start with current usecases and how they're implemented or
> mis-implemented (ie. leading to confusion). The discussions I've read so
> far cover a good part of that.

So, I'd like to continue working on progs part based on these ioctls
but there are some things I want to confirm.

I think current problems of "sub list" are:
  - printed path is ambiguous (the output may differ when specified different path in the fs)
  - -a or -o options do not work well
  - top level filed is meaningless

My idea of new list is (as in [1]):
  - (default, use new ioctls for normal user)
     list the subvolumes under the specified path, including subvolumes mounted
     below the specified path. Any user can do this (with appropriate permission checks).
     The path to be printed is the relative from the specified path.
  - (-a option, use TREE_SEARCH ioctl)
     list all the subvolmumes in the filesystem. Only root can do this.
     The path to be printed is the absolute path from the toplevel subvolume.
  - (-o option)
     deprecated

and also cleanups of some fields.
For root, TREE_SEARCH ioctl still can be used so that new progs works with old kernels.

Do you have any comments about this?

Also, are you going to merge the omitted libbtrfsuitl patch which refactor "sub list" [2]?
This patch actually does two things:
 1. remove subvol print function from libbtrfs (abi break) and 
 2. refactor "sub list" by using libbtrfsutil.

Is the first part the reason this patch was omitted?

However, by this change subvolume information will be stored in an array instead of rb tree.
In order to implement proposed default behavior, this is a preferred way;
we can't use rb tree because there may exist the subvolume with the same id in different path.

In any case, I'd like to know which version of btrfs-progs I should use to implement the features.

Regards,
Tomohiro Misono

[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg75119.html
[2] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg73601.html

> 
> I'll review and add the kernel patches to misc-next to get some testing
> coverage. As this is a non-restricted ioctl full of pointers and bytes
> shuffled around, we will have to do an extra security-oriented review.
> 
> 

