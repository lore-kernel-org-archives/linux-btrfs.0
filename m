Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55779 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751041AbdEaC1Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 22:27:16 -0400
Subject: Re: [PATCH 2/5] btrfs-progs: Enhance chunk item validation check
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <hurikhan77@gmail.com>
References: <20170515082742.21363-1-quwenruo@cn.fujitsu.com>
 <20170515082742.21363-2-quwenruo@cn.fujitsu.com>
 <20170529173931.GT14523@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <27d5406e-f29c-8373-25fb-2d742d5830d2@cn.fujitsu.com>
Date: Wed, 31 May 2017 10:18:46 +0800
MIME-Version: 1.0
In-Reply-To: <20170529173931.GT14523@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/30/2017 01:39 AM, David Sterba wrote:
> On Mon, May 15, 2017 at 04:27:39PM +0800, Qu Wenruo wrote:
>> btrfs_check_chunk_valid() doesn't check if
>> 1) chunk flag has conflicting flags
>>     For example chunk type DATA|METADATA|RAID1|RAID10 is completely
>>     invalid, while current check_chunk_valid() can't detect it.
>> 2) num_stripes is invalid for RAID10
>>     Num_stripes 5 is not valid for RAID10.
>>
>> This patch will enhance btrfs_check_chunk_valid() to handle above cases.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Most tests fail with this patch, mkfs or from restored images created.
> Simple test-check or test-misc fails in the first test. Have I missed
> some other patch or test update?
> 
> 
Sorry, I formatted patch based on an old branch, which doesn't have the 
extra fix for single profile.

I'll update the branch and add the needed test case in next branch, 
along with infrastructure update to make loop device setup more easy to use.

Thanks,
Qu


