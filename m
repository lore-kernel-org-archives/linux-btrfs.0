Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23673 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754060AbcETCeE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 22:34:04 -0400
Subject: Re: [RFC PATCH v2.1 16/16] btrfs-progs: fsck: Introduce low memory
 mode
To: <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1463477930-3925-17-git-send-email-quwenruo@cn.fujitsu.com>
 <fa6160a4-64d2-9ce6-1c0d-eaf6069ca2c5@fb.com>
 <827a9e93-f525-4a8b-edb1-a0ac90175716@cn.fujitsu.com>
 <20160519145112.GF29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <23d061e0-06e8-3e81-7595-4fc76a5353a2@cn.fujitsu.com>
Date: Fri, 20 May 2016 10:33:55 +0800
MIME-Version: 1.0
In-Reply-To: <20160519145112.GF29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/19 16:51 +0200:
> On Wed, May 18, 2016 at 08:58:57AM +0800, Qu Wenruo wrote:
>> Josef Bacik wrote on 2016/05/17 11:29 -0400:
>>> On 05/17/2016 05:38 AM, Qu Wenruo wrote:
>>>
>> Thanks for the review.
>>
>> I'll add it to github branch to avoid unneeded mail bombing.
>
> Thanks.  I did one more pass and fixed the error messages and some minor
> formatting. Branch merged in devel, any fixups, please send as separate
> patches. I'd like to give enough time for testing, so ETA for 4.6 will
> be the end of the next week.

Thank you a lot, for all the work.

We'll enrich the test cases for current low memory mode.

And only until current extent tree part is completely OK, then we will 
try to implement later fs tree one.
(Currently fs tree check still eats a lot of memory, making the memory 
save in extent tree check a little meaningless)

Thanks,
Qu


