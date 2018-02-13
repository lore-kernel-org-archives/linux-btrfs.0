Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58754 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934563AbeBMJaq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:30:46 -0500
Subject: Re: [PATCH] btrfs: verify max_inline mount parameter
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180212153546.19443-1-anand.jain@oracle.com>
 <20180212171314.GM3003@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ebb80598-bba6-a2a1-7d2c-d6af74093555@oracle.com>
Date: Tue, 13 Feb 2018 17:32:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180212171314.GM3003@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/13/2018 01:13 AM, David Sterba wrote:
> On Mon, Feb 12, 2018 at 11:35:46PM +0800, Anand Jain wrote:
>> We aren't verifying the parameter passed to the max_inline mount option,
>> so we won't report and fail the mount if a junk value is specified for
>> example, -o max_inline=abc.
>> This patch converts the max_inline option to %d and checks if it's a
>> number >= 0.
> 
> Oh right, the parser can verify that for us. As the %d gets stored to
> int, there's no reason to store fs_info::max_inline as u64.

  fixed this in the patch set sent out.

> Looking at the parser capabilities, it accepts %u and matches an
> unsigned type, which we use for all our options. It would be good to
> unify that too.

  fixed this too.

> Please update this patch and possibly send more cleaning up the rest of
> the match strings, and the max_inline type. Thanks.

  Sure. will do.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
