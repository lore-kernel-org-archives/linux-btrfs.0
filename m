Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52273 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbeDDMRh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 08:17:37 -0400
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <8476c1ee-365a-bb0f-0d44-94cca28d09f3@gmx.com>
 <bc883776-3d68-b21c-bde1-edb6488cd1ed@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ade96fd3-3aae-d39b-cf3c-0461811c1042@gmx.com>
Date: Wed, 4 Apr 2018 20:17:22 +0800
MIME-Version: 1.0
In-Reply-To: <bc883776-3d68-b21c-bde1-edb6488cd1ed@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月04日 16:53, Nikolay Borisov wrote:
> 
> 
> On  3.04.2018 10:30, Qu Wenruo wrote:
>> Hi David,
>>
>> I didn't see this patch merged in your misc-next branch but only the
>> remaining patches.
>>
>> However without this patch, btrfs qgroup reserved space will get
>> obviously increased as prealloc metadata reserved space is never freed
>> until inode reserved space is freed.
>>
>> This would cause a lot of qgroup related test cases to fail.
>>
>> Would you please merge this patch with all qgroup patchset?
> 
> I'm seeing btrfs/022 and btrfs/099 fail as of today's misc-next. Both
> are qgroup related tests.

Exactly.

Wondering why this patch is left.

Thanks,
Qu

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
