Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14495 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751406AbdKJJ6M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:58:12 -0500
Date: Fri, 10 Nov 2017 17:57:29 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs-progs: qgroup: cleanup __qgroup_search, no
 functional change
Message-ID: <20171110095729.GC30275@fnst.localdomain>
References: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
 <20171031091345.9325-4-lufq.fnst@cn.fujitsu.com>
 <20171109165148.GO27557@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20171109165148.GO27557@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 09, 2017 at 05:51:48PM +0100, David Sterba wrote:
>On Tue, Oct 31, 2017 at 05:13:45PM +0800, Lu Fengqi wrote:
>> 1. Use goto instead of while (1) to reduce the level of indentation
>
>I'd rather avoid this goto pattern in new code, using while is ok. If
>the indentation depth becomes problem, then the inner code should be
>moved to a helper.

Make sense.

>
>> 2. Replace the if statement with the switch statement
>
>This is good.
>
>> 3. move the BTRFS_IOC_TREE_SEARCH ioctl error handler to __qgroup_search
>
>This one as well, but please make them into separate patches, the code
>is being moved and changed at the same time. This makes the review
>harder.
>
>

Ok, I'll split the patch and resend it later.

-- 
Thanks,
Lu


