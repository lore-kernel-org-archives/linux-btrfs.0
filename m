Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21492 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbbIKBiq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 21:38:46 -0400
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com>
 <160121092.hSkPuGCNnN@localhost.localdomain>
 <20150901021510.GE7642@thunk.org> <2500094.kBUgEuDpMB@localhost.localdomain>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <chandan@mykolab.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F230A3.2070300@cn.fujitsu.com>
Date: Fri, 11 Sep 2015 09:38:43 +0800
MIME-Version: 1.0
In-Reply-To: <2500094.kBUgEuDpMB@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chandan Rajendra wrote on 2015/09/01 08:03 +0530:
> On Monday 31 Aug 2015 22:15:10 Theodore Ts'o wrote:
>> On Tue, Sep 01, 2015 at 05:49:14AM +0530, Chandan Rajendra wrote:
>>> mkfs.btrfs when invoked on small filesystems by "not" specifying any block
>>> sizes (i.e. mkfs.btrfs -f /dev/sda1) will automatically create filesystem
>>> instance with "data block size" == "metadata block size". However in the
>>> subpagesize-blocksize scenario, we need to specify both data and metadata
>>> block size on the command line (For e.g. mkfs.btrfs -f -s 4096 -n 16384
>>> /dev/sda1). In this case, Since the user is forcing the block sizes and it
>>> is impossible to have mixed block groups with differing data and metadata
>>> block sizes, mkfs.btrfs will fail.
>>
>> Ok, so the issue is that for this particular test configuration, btrfs
>> has a minimum file system size.  What about changing
>> _scratch_mkfs_sized so that if MIN_FS_SIZE is set, the file system
>> created will be at least MIN_FS_SIZE in size.
>>
>> This way it sets the minimum file system size for all tests, not just
>> generic/224, and any test configuration, whether it be ext4, xfs, or
>> btrfs where the data and metadata block size are the same, don't have
>> to take extra time -- only the test configuration of btrfs with
>> data_block_size != metadata_block_size.
>>
> I agree with the approach you have suggested. I will write up a patch and send
> it across the mailing list. Thanks Ted.
>
Hi Chandan,

Although the reply may be a little late, but I think it's still better 
to fix the bug in mkfs.btrfs.

The core problem is, why mkfs.btrfs is insisting on make the fs into 
mixed-bg.

Auto detection for small device and make it into mixed-bg should be a 
"OPTIONAL" feature, not a "mandatory" one.

So IMHO, the best method is to disable mixed-bg when nodesize/sectorsize 
is given and differs and user doesn't force mkfs to create mixed-bg.

Thanks,
Qu
