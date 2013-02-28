Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56326 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab3B1AuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 19:50:14 -0500
Message-ID: <512EA9DD.9010003@cn.fujitsu.com>
Date: Thu, 28 Feb 2013 08:50:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [PATCH] btrfs: cleanup for open-coded alignment
References: <1361866222-5746-1-git-send-email-quwenruo@cn.fujitsu.com> <20130227115944.GA27541@twin.jikos.cz>
In-Reply-To: <20130227115944.GA27541@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

于 2013年02月27日 19:59, David Sterba 写道:
> On Tue, Feb 26, 2013 at 04:10:22PM +0800, Qu Wenruo wrote:
>> Though most of the btrfs codes are using ALIGN macro for page alignment,
>> there are still some codes using open-coded alignment like the
>> following:
>> ------
>>          u64 mask = ((u64)root->stripesize - 1);
>>          u64 ret = (val + mask) & ~mask;
>> ------
>> Or even hidden one:
>> ------
>>          num_bytes = (end - start + blocksize) & ~(blocksize - 1);
> It's unobvious but not a bug. The 'end' values are sometimes inclusive,
> sometimes not.  The range we want to align is
>
>     RANGE = end + start + 1
>
> then the alignment transformation does
>
>    (RANGE + ALIGNMENT - 1) & ~(ALIGNMENT - 1)
>
> where
>
>    RANGE + ALIGNMENT - 1 = end + start + 1 + ALIGNMENT - 1
>                          = end + start + ALIGNMENT
>
> I have covered all cases in my original patch with a coccinelle semantic
> patch http://www.spinics.net/lists/linux-btrfs/msg12750.html and also
> removed the useless stripe_align helper and updated it's callers (and it
> still applies after merging the raid56 code that updated the function
> with 2 unused arguments).
Thanks for pointing out the original rules.
The orginal rules is pretty good but can only
deal with the open-coded alignment in one line.

If there is something using varient "mask",
the rules seems no help like the following:
------

         u64 mask = ((u64)root->stripesize - 1);
         u64 ret = (val + mask) & ~mask;

------



>
>> Also there is a previous patch from David Sterba with similar changes,
>> but the patch is for 3.2 kernel and seems not merged.
>> http://www.spinics.net/lists/linux-btrfs/msg12747.html
> Yeah, amount of unmerged patches was high back then and I got no
> feedback whether such changes are desired not, moreover a few of them
> touched all sources likely to clash with every secnod patch in flight
> (eg. "Btrfs: kill key type helpers").
>
> If you used my patch I'd appreciate to keep the signed-off.
In fact, I just do all the check manually sine not familiar with spatch.
As also mentiond above, if some codes using mask in seperate line,
the rules seem not working.

And sorry for the wrong signed-off, it seems that I'm using one of your
deprecated mail address.
>
>> Cc: David Sterba <dave@jikos.cz>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>


-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

