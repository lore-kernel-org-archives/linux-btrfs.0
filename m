Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754049AbcIAVtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 17:49:20 -0400
Subject: Re: [PATCH] btrfs: do not decrease bytes_may_use when replaying
 extents
To: <dsterba@suse.cz>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>, <clm@fb.com>, <dsterba@suse.com>
References: <1472182394-7785-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20160901153629.GT16983@twin.jikos.cz>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <a06cbb7f-4337-9ecc-9ba7-fe3cb990110c@fb.com>
Date: Thu, 1 Sep 2016 13:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <20160901153629.GT16983@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/2016 11:36 AM, David Sterba wrote:
> CC Josef. It's a followup of patch that went to 4.8-rc4 so we'd better
> get it to 4.8.
>
> On Fri, Aug 26, 2016 at 11:33:14AM +0800, Wang Xiaoguang wrote:
>> When replaying extents, there is no need to update bytes_may_use
>> in btrfs_alloc_logged_file_extent(), otherwise it'll trigger a
>> WARN_ON about bytes_may_use.
>>
>> Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

