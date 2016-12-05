Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20103 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751100AbcLEHP1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 02:15:27 -0500
Subject: Re: [RFC PATCH 0/3] Add testcase for fundamental scrub recovery
To: Eryu Guan <eguan@redhat.com>, David Sterba <dsterba@suse.com>
References: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
 <20161205070716.GQ29149@eguan.usersys.redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b0499bcc-0983-932a-8f50-26476208390c@cn.fujitsu.com>
Date: Mon, 5 Dec 2016 15:15:21 +0800
MIME-Version: 1.0
In-Reply-To: <20161205070716.GQ29149@eguan.usersys.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/05/2016 03:07 PM, Eryu Guan wrote:
> On Tue, Nov 22, 2016 at 04:38:08PM +0800, Qu Wenruo wrote:
>> Despite the scrub test cases in fstests, there is not even one test case
>> which really checked if scrub can recover data.
>>
>> In fact, btrfs scrub for RAID56 will even corrupt correct data stripes.
>>
>> So let's start from the needed facilities and check scrub starting from RAID1.
>>
>> The main reason the patchset is RFC, is the method I take to corrupt/verify
>> btrfs data.
>>
>> unlike other stable fs, like ext* or xfs, which has good tool to
>> manipulate the fs.
>>
>> There used to be btrfs-corrupt-block, but it gets fewer and fewer
>> update, no man page nor installed by default.
>
> I really think that a tool manipulating btrfs should be developed first,
> especially it's greatly demanded now and there's already a prototype
> btrfs-corrupt-block available. Then this tool can act as a base &
> benefit all future tests that corrupt fs metadata. e.g. Darrick
> introduced blocktrash command to xfs_db and used it in many fuzz tests.
>
> IMO, let's build and/or fix the tools first. To me, this is just the
> right time to do this.

Thanks for the comment.

This idea really helps.
>
>>
>> Here I take the method I normally do in my scripts: use btrfs-dump-tree
>> (btrfs inspect-internal dump-tree) and use bash to corrupt btrfs
>> pinpointly.
>> It works quite fine for several different mount options which affects
>> how data lies on-disk.
>>
>> But the problem is also obvious, bash script is super hard to maintain,
>> and there is no promise that btrfs-dump-tree output won't change.
>> Such change will be destructive.
>
> Agreed, it's very hard to maintain, and, as you pointed out, the output
> format changing of btrfs-dump-tree makes the code even harder to read &
> maintain. And it's hard to extend to work with other profiles too.

It's really a nightmare debugging the bash script, so I'm quite happy 
that I don't need to bother this code anymore.

Add Cc to David to see if he has any better idea on this.

Thanks,
Qu

>
> I'd like to hear what other btrfs developers and fstests users think.
>
> Thanks,
> Eryu
>
>>
>> But IMHO it's still worthy, or btrfs scrub may break at any time.
>>
>> Qu Wenruo (3):
>>   fstests: common: rename _require_btrfs to _require_btrfs_subcommand
>>   fstests: common/ondisk.btrfs: Introduce function to get btrfs ondisk
>>       info
>>   fstests: btrfs: Add new test case to check scrub recovery and report
>>
>>  common/ondisk.btrfs | 113 ++++++++++++++++++++++++++
>>  common/rc           |   2 +-
>>  tests/btrfs/004     |   2 +-
>>  tests/btrfs/048     |   2 +-
>>  tests/btrfs/059     |   2 +-
>>  tests/btrfs/131     |   2 +-
>>  tests/btrfs/132     | 229 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/132.out | 111 +++++++++++++++++++++++++
>>  tests/btrfs/group   |   2 +
>>  9 files changed, 460 insertions(+), 5 deletions(-)
>>  create mode 100644 common/ondisk.btrfs
>>  create mode 100755 tests/btrfs/132
>>  create mode 100644 tests/btrfs/132.out
>>
>> --
>> 2.7.4
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


