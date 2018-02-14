Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out0-131.mail.aliyun.com ([140.205.0.131]:34126 "EHLO
        out0-131.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032019AbeBNXfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 18:35:02 -0500
Subject: Re: [PATCH 3/8] fs: btrfs: remove unused hardirq.h
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com>
 <1510959741-31109-3-git-send-email-yang.s@alibaba-inc.com>
 <20171120132516.GY28899@twin.jikos.cz>
From: "Yang Shi" <yang.s@alibaba-inc.com>
Message-ID: <c5675650-03e2-7b5d-0888-ed6702cc79eb@alibaba-inc.com>
Date: Thu, 15 Feb 2018 07:34:44 +0800
MIME-Version: 1.0
In-Reply-To: <20171120132516.GY28899@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

David acked this patch, but it looks nobody picked it up.

Thanks,
Yang


On 11/20/17 5:25 AM, David Sterba wrote:
> On Sat, Nov 18, 2017 at 07:02:16AM +0800, Yang Shi wrote:
>> Preempt counter APIs have been split out, currently, hardirq.h just
>> includes irq_enter/exit APIs which are not used by btrfs at all.
>>
>> So, remove the unused hardirq.h.
>>
>> Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
>> Cc: Chris Mason <clm@fb.com>
>> Cc: Josef Bacik <jbacik@fb.com>
>> Cc: David Sterba <dsterba@suse.com>
>> Cc: linux-btrfs@vger.kernel.org
> 
> Acked-by: David Sterba <dsterba@suse.com>
> 
