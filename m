Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a.wadns.net ([196.220.39.47]:60956 "EHLO fw5a.wadns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbbIIQAW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 12:00:22 -0400
Subject: Re: raid6 + hot spare question
To: Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?Peter_Ke=c5=a1e?= <peter.kese@viidea.com>,
        linux-btrfs@vger.kernel.org
References: <55EECD97.7090109@viidea.com>
 <20150908121258.GM23944@carfax.org.uk>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <55F054BB.8090109@swiftspirit.co.za>
Date: Wed, 9 Sep 2015 17:48:11 +0200
MIME-Version: 1.0
In-Reply-To: <20150908121258.GM23944@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Things can be a little more nuanced.

First off, I'm not even sure btrfs supports a hot spare currently. I 
haven't seen anything along those lines recently in the list - and don't 
recall anything along those lines before either. The current mention of 
it in the Project Ideas page on the wiki implies it hasn't been looked 
at yet.

Also, depending on your experience with btrfs, some of the tasks 
involved in fixing up a missing/dead disk might be daunting.

See further (queries for btrfs-devs too) inline below:

On 2015-09-08 14:12, Hugo Mills wrote:
> On Tue, Sep 08, 2015 at 01:59:19PM +0200, Peter Keše wrote:
>> <snip>
>> However I'd like to be prepared for a disk failure. Because my
>> server is not easily accessible and disk replacement times can be
>> long, I'm considering the idea of making a 5-drive raid6, thus
>> getting 12TB useable space + parity. In this case, the extra 4TB
>> drive would serve as some sort of a hot spare.
 From the above I'm reading one of two situations:
a) 6 drives, raid6 across 5 drives and 1 unused/hot spare
b) 5 drives, raid6 across 5 drives and zero unused/hot spare
>>
>> My assumption is that if one hard drive fails before the volume is
>> more than 8TB full, I can just rebalance and resize the volume from
>> 12 TB back to 8 TB essentially going from 5-drive raid6 to 4-drive
>> raid6).
>>
>> Can anyone confirm my assumption? Can I indeed rebalance from
>> 5-drive raid6 to 4-drive raid6 if the volume is not too big?
>     Yes, you can, provided, as you say, the data is small enough to fit
> into the reduced filesystem.
>
>     Hugo.
>
This is true - however, I'd be hesitant to build this up due to the 
current process not being very "smooth" depending on how unlucky you 
are. If you have scenario b above, will the filesystem still be 
read/write or read-only post-reboot? Will it "just work" with the only 
requirement being free space on the four working disks?

RAID6 is intended to be tolerant of two disk failures. In the case of 
there being a double failure and only 5 disks, the ease with which the 
user can balance/convert to a 3-disk raid5 is also important.

Please shoot down my concerns. :)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

