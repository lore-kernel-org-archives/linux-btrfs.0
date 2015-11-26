Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46329 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbKZGH2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 01:07:28 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com>
Message-ID: <5656A18E.9050607@oracle.com>
Date: Thu, 26 Nov 2015 14:07:10 +0800
MIME-Version: 1.0
In-Reply-To: <5656683C.6060001@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/26/2015 10:02 AM, Qu Wenruo wrote:
>
>
> Anand Jain wrote on 2015/11/25 20:08 +0800:
>> Sometimes users may want to have a btrfs to be supported on multiple
>> kernel version. A simple example, USB drive can be used with multiple
>> system running different kernel versions. Or in a data center a SAN
>> LUN could be mounted on any system with different kernel version.
>>
>> Thanks for providing comments and feedback.
>> Further to it, here below is a set of patch which will introduce, to
>> specify a kernel version so that default features can be set based on
>> what features were supported at that kernel version.
>
> With the new -O comp= option, the concern on user who want to make a
> btrfs for newer kernel is hugely reduced.

NO!. actually new option -O comp= provides no concern for users who
want to create _a btrfs disk layout which is compatible with more
than one kernel_.  above there are two examples of it.

> But I still prefer such feature align to be done only when specified by
> user, instead of automatically. (yeah, already told for several times
> though)
> Warning should be enough for user, sometimes too automatic is not  good,

As said before.
We need latest btrfs-progs on older kernels, for obvious reasons of
btrfs-progs bug fixes. We don't have to back port fixes even on
btrfs-progs as we already do it in btrfs kernel. A btrfs-progs should
work on any kernel with the "default features as prescribed for that
kernel".

Let's say if we don't do this automatic then, latest btrfs-progs
with default mkfs.btfs && mount fails. But a user upgrading btrfs-progs
for fsck bug fixes, shouldn't find 'default mkfs.btfs && mount'
failing. Nor they have to use a "new" set of mkfs option to create all
default FS for a LTS kernel.

Default features based on btrfs-progs version instead of kernel
version- makes NO sense. And adding a warning for not using latest
features which is not in their running kernel is pointless. That's
_not_ a backward kernel compatible tool.

btrfs-progs should work "for the kernel". We should avoid adding too
much intelligence into btrfs-progs. I have fixed too many issues and
redesigned progs in this area. Too many bugs were mainly because of the
idea of copy and maintain same code on btrfs-progs and btrfs-kernel
approach for progs. (ref wiki and my email before). Thats a wrong
approach. I don't understand- if the purpose of both of these isn't
same what is the point in maintaining same code? It won't save in
efforts mainly because its like developing a distributed FS where
two parties has to be communicated to be in sync. Which is like using
the canon to shoo a crow.
But if the reason was fuse like kernel-free FS (no one said that
though) then its better to do it as a separate project.

> especially for tests.

It depends whats being tested kernel OR progs? Its kernel not progs.
Automatic will keep default feature constant for a given kernel
version. Further, for testing using a known set of options is even
better.

> A lot of btrfs-progs change, like recent disabling mixed-bg for small
> volume has already cause regression in generic/077 testcase.
> And Dave is already fed up with such problem from btrfs...

I don't know what's the regression about. But in my experience with
some xfstest test cases.. xfstests depend too much on cli output
strings which is easy thing to do but a wrong approach.
Those cli outputs and its format are NOT APIs, those are UIs. Instead
it should have used return code/ FS test interface. This will let
developers with free hands to change, otherwise you need to update the
test cases every time you change the cli _output_.

> Especially such auto-detection will make default behavior more unstable,
> at least not a good idea for me.

As above. We design with end-user and their use cases in mind. Not for
a test suite. If test suite breaks.. fix it.

Thanks, Anand

> Beside this, I'm curious how other filesystm user tools handle such
> kernel mismatch, or do they?

> Thanks,
> Qu
>
>
>>
>> First of all to let user know what features was supported at what kernel
>> version. Patch 1/7 updates -O list-all which will list the feature with
>> version.
>>
>> As we didn't maintain the sysfs and progs feature names consistent, so
>> to avoid confusion Patch 2/7 displays sysfs feature name as well again
>> in the list-all output.
>>
>> Next, Patch 3,4,5/7 are helper functions.
>>
>> Patch 6,7/7 provides the -O comp=<version> for mkfs.btrfs and
>> btrfs-convert respectively
>>
>> Thanks, Anand
>>
>> Anand Jain (7):
>>    btrfs-progs: show the version for -O list-all
>>    btrfs-progs: add kernel alias for each of the features in the list
>>    btrfs-progs: make is_numerical non static
>>    btrfs-progs: check for numerical in version_to_code()
>>    btrfs-progs: introduce framework version to features
>>    btrfs-progs: add -O comp= option for mkfs.btrfs
>>    btrfs-progs: add -O comp= option for btrfs-convert
>>
>>   btrfs-convert.c | 21 +++++++++++++++++++++
>>   cmds-replace.c  | 11 -----------
>>   mkfs.c          | 24 ++++++++++++++++++++++--
>>   utils.c         | 58
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>   utils.h         |  2 ++
>>   5 files changed, 98 insertions(+), 18 deletions(-)
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
