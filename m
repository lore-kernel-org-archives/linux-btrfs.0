Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35200 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753855AbdKAMNV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 08:13:21 -0400
Subject: Re: Reasonable amount of snapshots
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1509534294.1662.91.camel@gmail.com>
 <fb1522f7-ffbe-cc5c-8a1d-bb3812b2e0f0@gmx.com>
 <1509535904.1662.93.camel@gmail.com>
 <22d4b909-124f-3f01-d99a-18e9596fc76e@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <231dbedf-4467-072a-8b31-bb6942211bc6@mendix.com>
Date: Wed, 1 Nov 2017 13:13:17 +0100
MIME-Version: 1.0
In-Reply-To: <22d4b909-124f-3f01-d99a-18e9596fc76e@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2017 01:07 PM, Qu Wenruo wrote:
> 
> 
> On 2017年11月01日 19:31, ST wrote:
>> On Wed, 2017-11-01 at 19:17 +0800, Qu Wenruo wrote:
>>>
>>> On 2017年11月01日 19:04, ST wrote:
>>>> Hello,
>>>>
>>>> I read in different places that one should keep amount of snapshots low
>>>> - around 15-20. My question - is this limitation on total number of
>>>> snapshots on the system or only on related (parent<->child) chain of
>>>> snapshots?
>>>
>>> Independent subvolume doesn't count, and it's filesystem based.
>>>
>>> So only snapshots (with source exists, and still shares a lot of trees
>>> with source) counts.
>>>
>>> And if you have multiple btrfs fses, then the count should be based on
>>> each fs.
>>>
>>>> What I want to do is the following: create (and then rotate) last 7
>>>> daily snapshots (and maybe 4 weekly) for each user in his /home dir.
>>>> For
>>>> around 100 users. So if limitation is only on related snapshots then I'm
>>>> OK since only each 7 (or maybe 7+4) of them are related which is well
>>>> under the 15-20 limit. However in total there could be 700 snapshots. So
>>>> what is true?
>>>
>>> You're OK since independent subvolumes won't cause too much stress for
>>> backref walk.
>>>
>>> The only thing you may need to consider is to limit the ability to
>>> reflink data between subvolumes.
>>> Like cp --reflink or even offline dedupe.
>>
>> Thank you very much! How can I limit this ability? (I'm on Debian9)
>>
>> All the best!
> 
> No way to limit, unfortunately.

Well, it can obviously be "limited" by just not using cp --reflink all
over the place and by not running dedupe on everything. The filesystem
won't just start doing that by its own. ;]


-- 
Hans van Kranenburg
