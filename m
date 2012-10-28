Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:40476 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2J1LVO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 07:21:14 -0400
Date: Sun, 28 Oct 2012 11:20:52 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121028112052.GD2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <201210271843.40540.Martin@lichtvoll.de>
 <20121027195513.GS2381@yeono.kjorling.se>
 <6A71D3F9-28B4-4560-9FB8-75F8FC63264E@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6A71D3F9-28B4-4560-9FB8-75F8FC63264E@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27 Oct 2012 17:35 -0600, from lists@colorremedies.com (Chris Murphy):
> On Oct 27, 2012, at 1:55 PM, Michael Kjörling <michael@kjorling.se> wrote:
> 
>>          Data: RAID 0   System: RAID 1   Unused
>> /dev/vdb     307.25 MB                -        2.23 GB
>> /dev/vdc     307.25 MB             8 MB        2.69 GB
>> /dev/vdd     307.25 MB             8 MB        2.24 GB
>>          ============   ==============   ============
>> TOTAL        921.75 MB            16 MB        7.16 GB
> 
> I kinda like this arrangement a little better. If the top left
> corner could be the volume label, that might be nice?

I see no reason why that couldn't be done. It might be tricky if the
volume label is long, but then it could just as easily as the device
names be printed on a line of its own.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
