Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35054 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751280AbcEXDT0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 23:19:26 -0400
Subject: Re: [RFC PATCH v2.1 16/16] btrfs-progs: fsck: Introduce low memory
 mode
To: <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1463477930-3925-17-git-send-email-quwenruo@cn.fujitsu.com>
 <fa6160a4-64d2-9ce6-1c0d-eaf6069ca2c5@fb.com>
 <827a9e93-f525-4a8b-edb1-a0ac90175716@cn.fujitsu.com>
 <20160519145112.GF29147@twin.jikos.cz>
 <23d061e0-06e8-3e81-7595-4fc76a5353a2@cn.fujitsu.com>
 <20160523110844.GJ29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9717767e-9c6a-2aaf-9ac8-0e213646ba0a@cn.fujitsu.com>
Date: Tue, 24 May 2016 11:19:13 +0800
MIME-Version: 1.0
In-Reply-To: <20160523110844.GJ29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/23 13:08 +0200:
> On Fri, May 20, 2016 at 10:33:55AM +0800, Qu Wenruo wrote:
>> We'll enrich the test cases for current low memory mode.
>
> I started something to add optional default options for a few basic
> commands (mkfs, fsck, convert) to extend the coverage. I'm not finished,
> the idea is to call the commands via some wrapper that will grab the
> defaults from a file or from environment.
>
>
Thank you a lot.

But that's still not enough for low memory fsck yet.

Even we can add --low-memory option for btrfsck to run on that images, 
we still have the following problems:

1) Lack of support for repair
    Repair support for low memory is quite tricky, as we need to do a
    lot of record work other than just calling btrfs_previous/next_item()

    This won't be implemented in a short time. And this will make almost
    all repair function test fails for low memory backend.

2) btrfs-image bug causing missing chunk stripe
    We're actively working on this before low memory mode for fs tree
    check.

    In fact the problem is already here for a long time, and another bug
    in btrfsck, which will ignore the error returned from dev_extent
    check, makes btrfsck can pass the fsck test images.

    Unfortunately (or fortunately?) low memory mode won't ignore such
    error and always report missing chunk for dev_extent.

    Unless we fix btrfs-image (only restore part is affected), low
    memory mode will always report error on btrfs-image restored image.

3) Extra images
    During the development of low memory mode, we found that current
    test images are all for some special fix case.

    No check on health images, not to mention test on all possible extent
    backrefs.

    We have build such images for internal low memory mode tests, and
    hopes to push it into current test.

    But since we don't have such check only test cases infrastructure
    and due to the bug of 2), we still needs some work for this.

So we still have to some work to do.

Thanks,
Qu


