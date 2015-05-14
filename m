Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51510 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964824AbbENBII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 21:08:08 -0400
Message-ID: <5553F572.9040100@cn.fujitsu.com>
Date: Thu, 14 May 2015 09:08:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Hugo Mills <hugo@carfax.org.uk>,
        Learner Study <learner.study@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: de-duplication algos
References: <CAP8+hKVLpwT7fFqMods0++SKqQSXF5Z1tXNcAgFw_i3utfFeVQ@mail.gmail.com> <20150513163553.GV18480@carfax.org.uk> <20150513164815.GT23255@twin.jikos.cz>
In-Reply-To: <20150513164815.GT23255@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: de-duplication algos
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Learner Study 
<learner.study@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, 
Mark Fasheh <mfasheh@suse.de>
Date: 2015年05月14日 00:48

> On Wed, May 13, 2015 at 04:35:53PM +0000, Hugo Mills wrote:
>> On Wed, May 13, 2015 at 09:24:17AM -0700, Learner Study wrote:
>>> Hello,
>>>
>>> I have been reading on de-duplication and how algorithms such as Bloom
>>> and Cuckoo filters are used for this purpose.
>>>
>>> Does BTRFS dedup use any of these, or are there plans to incorporate
>>> these in future?
>>
>>     There was a long discussion on IRC about different approaches that
>> could be taken. I think Mark Fasheh captured most of that somewhere --
>> I thought he'd put it on the duperemove github site somewhere, but I
>> can't see it right now.
>
> The bloom filter for duperemove has been implemented (as of commit
> b7c03422ea9fd11f915804df2b6598a6ed10dfce) and works fine, the memory
> footprint is much lower than before.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Zhao Lei and I are also trying to implement *in-band* de-duplication.
Our idea is to implement a memory pool to keep a csum<->extent map to do 
*PARTIAL* dedup.
As we consider de-duplication doesn't need to de-dup 100% of 
duplications, it's just a nice addition but not a fundamental function.

The memory pool bahaviors as last-recent-use, and user can adjust how 
big the memory pool is. (Yeah, put the dirty work to user)

Bloom filter seems quite interesting, but it also seems hard to remove 
items from them, so also hard to limit memory usage in kernel.
Since I'm not familiar with algorithms like Bloom filter, any advice on 
such algorithms available is welcomed.

Thanks,
Qu
