Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12097 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbeIKU4w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 16:56:52 -0400
Message-ID: <5B97E5BF.1030307@huawei.com>
Date: Tue, 11 Sep 2018 23:56:47 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <lufq.fnst@cn.fujitsu.com>, <suy.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs/extent_map: Remove unneeded variable "ret"
References: <1533474287-15049-1-git-send-email-zhongjiang@huawei.com> <5B7E9B1C.40404@huawei.com> <20180911154404.GD2154@twin.jikos.cz>
In-Reply-To: <20180911154404.GD2154@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/9/11 23:44, David Sterba wrote:
> On Thu, Aug 23, 2018 at 07:31:40PM +0800, zhong jiang wrote:
>> Hi,  dsterba
>>
>> Can you pick up the patch? Thanks
> Please send one patch per changed function with relevant changelog that
> the return value is not used and that no callees could potentially
> return an error that would need to be passed.
Will do in v3

Thanks,
zhong jiang
