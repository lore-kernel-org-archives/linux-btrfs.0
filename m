Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60965 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753461AbeF1Gbs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 02:31:48 -0400
Subject: Re: [PATCH] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
To: Eryu Guan <guaneryu@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20180601013448.22450-1-wqu@suse.com>
 <b99cbadf-6c03-6bd2-fed5-590a5a8ae840@suse.com>
 <20180628053420.GT2780@desktop>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fd4f2159-9f7c-e20a-f1d4-288e7fd3b2e6@suse.com>
Date: Thu, 28 Jun 2018 09:31:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180628053420.GT2780@desktop>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.06.2018 08:34, Eryu Guan wrote:
> On Thu, Jun 28, 2018 at 08:11:00AM +0300, Nikolay Borisov wrote:
>>
>>
>> On  1.06.2018 04:34, Qu Wenruo wrote:
>>> This is a long existing bug (from 2012) but exposed by a reporter
>>> recently, that when compressed extent without data csum get written to
>>> device-replace target device, the written data is in fact uncompressed data
>>> other than the original compressed data.
>>>
>>> And since btrfs still consider the data is compressed and will try to read it
>>> as compressed, it can cause read error.
>>>
>>> The root cause is located, and one RFC patch already sent to fix it,
>>> titled "[PATCH RFC] btrfs: scrub: Don't use inode pages for device replace".
>>> (The RFC is only for the extra possible way to fix the bug, the fix
>>> itself should work without problem)
>>>
>>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> Thanks for the review! I assume the v3 patch also passes your review :)
Yes, I just saw that you requested an ack from a btrfs developer some
time ago and this test didn't move forward, hence i replied. But yes,
it's a valid test for btrfs.
> 
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
