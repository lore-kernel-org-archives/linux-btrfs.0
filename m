Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752667AbdLFH1x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 02:27:53 -0500
Subject: Re: [PATCH] btrfs: Handle btrfs_set_extent_delalloc failure
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <1512458959-20473-1-git-send-email-nborisov@suse.com>
 <638fd7c3-c805-dc78-17e9-3a4a648a2aae@gmx.com>
 <20171205175025.GM3553@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4caadfaa-d5ba-7825-c74f-a48adffa12d4@suse.com>
Date: Wed, 6 Dec 2017 09:27:50 +0200
MIME-Version: 1.0
In-Reply-To: <20171205175025.GM3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.12.2017 19:50, David Sterba wrote:
> On Tue, Dec 05, 2017 at 04:10:59PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年12月05日 15:29, Nikolay Borisov wrote:
>>> This function was introduced by 247e743cbe6e ("Btrfs: Use async helpers to deal
>>> with pages that have been improperly dirtied") and it didn't do any error
>>> handling then. This function might very well fail in ENOMEM situation, yet
>>> it's not handled, this could lead to inconsistent state. So let's handle the
>>> failure by setting the mapping error bit.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> Cc: stable@vger.kernel.org
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>
>> That's the only missing one. Nice catch.
> 
> You mean the only unhandled call of btrfs_set_extent_delalloc? There's
> one more in relocate_file_extent_cluster.

I'd prefer this call site be handled in a separate patch.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
