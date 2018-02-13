Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34626 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbeBMEVk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 23:21:40 -0500
Subject: Re: [PATCH] btrfs: fix extent_buffer_uptodate() return
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180212153456.19358-1-anand.jain@oracle.com>
 <20180212165519.GJ3003@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f57248e6-cab0-70a5-a8e8-7346f2e0f943@oracle.com>
Date: Tue, 13 Feb 2018 12:23:03 +0800
MIME-Version: 1.0
In-Reply-To: <20180212165519.GJ3003@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/13/2018 12:55 AM, David Sterba wrote:
> On Mon, Feb 12, 2018 at 11:34:56PM +0800, Anand Jain wrote:
>> extent_buffer_uptodate() returns from test_bit() which is of
>> type bool, so update extent_buffer_uptodate() to it.
> 
> The return value of test_bit differes by architecture, there are several
> that return int. You probably refer to x86 that uses some trickery to
> optimize for constants and that returns bool. While we can add more
> int/bool, I don't think it's wrong to have int here so I don't see what
> this patch fixes.

   Ah the other arch(s) I didn't go that deep, thanks for pointing out.
   Yes pls ignore this patch.

> In this particular case, extent_buffer_uptodate is a trivial wrapper
> around test_bit so it would be better to make it a static inline. This
> would remove the call indirection and reduce size of the code.

  Ok. Will fix that while here.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
