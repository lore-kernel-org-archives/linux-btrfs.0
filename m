Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38263 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752587AbcGSGk3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jul 2016 02:40:29 -0400
Subject: Re: [PATCH v12.1 01/15] btrfs: expand cow_file_range() to support
 in-band dedup and subpage-blocksize
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <20160711030543.30115-1-quwenruo@cn.fujitsu.com>
 <20160711030543.30115-2-quwenruo@cn.fujitsu.com>
 <20160711164129.GA13336@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <de3481c3-154b-4e0e-d489-b1d1076d7cb1@cn.fujitsu.com>
Date: Tue, 19 Jul 2016 14:40:11 +0800
MIME-Version: 1.0
In-Reply-To: <20160711164129.GA13336@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/12/2016 12:41 AM, David Sterba wrote:
> On Mon, Jul 11, 2016 at 11:05:29AM +0800, Qu Wenruo wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> Extract cow_file_range() new parameters for both in-band dedupe and
>> subpage sector size patchset.
>>
>> This should make conflict of both patchset to minimal, and reduce the
>> effort needed to rebase them.
>
> Great, thanks. I did a test merge, there are still conflicts but they
> seem to be resolvable more easily, picking the changes from the right
> patchset. I haven't tested it so there's more work, but the point was to
> get the conflict surface down.
>
> There's another candidate, btrfs_set_extent_delalloc as it adds a
> parameter, can you please send a similar patch for that?
>
>
It seems that due to my fault, the mail didn't reach mail list.

Resend the reply just in case.

Of cource, I'll add a new patch for btrfs_set_extent_delalloc().

Thanks,
Qu


