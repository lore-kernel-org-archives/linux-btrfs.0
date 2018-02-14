Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033317AbeBNRT3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 12:19:29 -0500
Subject: Re: [PATCH v2 2/2] btrfs: verify max_inline mount parameter
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180213094950.9412-1-anand.jain@oracle.com>
 <20180213094950.9412-2-anand.jain@oracle.com>
 <20180213162822.GW3003@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <74fb8a4b-24d7-7871-8050-2c4e3113580c@oracle.com>
Date: Thu, 15 Feb 2018 01:20:55 +0800
MIME-Version: 1.0
In-Reply-To: <20180213162822.GW3003@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/14/2018 12:28 AM, David Sterba wrote:
> On Tue, Feb 13, 2018 at 05:49:50PM +0800, Anand Jain wrote:
>> We aren't verifying the parameter passed to the max_inline mount option,
>> so we won't report and fail the mount if a junk value is specified for
>> example, -o max_inline=abc.
>> This patch converts the max_inline option to %d and checks if it's a
>> number >= 0.
> 
> As the max_inline is a size, the suffixes are allowed here and this is
> documented in the btrfs(5) page. I've checked all current options and
> max_inline should be the only one where we want the suffixes.

  Oh. I ran out of ideas how to fix this.
  One idea is ... step1: memparse() 4K (for example) so we would get
  4096, step2: convert obtained 4096 back to 4K and step3: do string cmp
  of step1 and step2. This way we eliminate other junk chars passed.
  But looks like there isn't any tool to do the step2.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
