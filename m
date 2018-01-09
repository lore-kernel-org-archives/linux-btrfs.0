Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.ord1d.emailsrvr.com ([184.106.54.97]:39164 "EHLO
        smtp97.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755465AbeAIOQb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 09:16:31 -0500
From: "Tom Worster" <fsb@thefsb.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Tue, 09 Jan 2018 09:16:18 -0500
Message-ID: <6A139191-C846-41DA-AE60-44115E0C17C6@thefsb.org>
In-Reply-To: <33ee8802-df5a-b153-6e24-2b38be597846@gmail.com>
References: <C11AC11F-C4CC-41B8-BE2F-52486E42C987@thefsb.org>
 <33ee8802-df5a-b153-6e24-2b38be597846@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 Jan 2018, at 7:23, Austin S. Hemmelgarn wrote:

> On 2018-01-08 16:43, Tom Worster wrote:
>>
>> Given the documentation and the usage stats, I did not know what 
>> options to use with balance. I spent some time reading and 
>> researching and trying to understand the filters and how they should 
>> relate to my situation. Eventually I abandoned that effort and ran 
>> balance without options.
> Hopefully the explanation I gave on the filters in the Github issue 
> helped some.  In this case though, it sounds like running a filtered 
> balance probably wouldn't have saved you much over a full one.

Yes, it helped. Hugo's email helped too. I now have a better 
understanding of balance filters.

At the same time, Hugo's email and others in this thread added to my 
belief that I'm now managing systems with a filesystem I'm unqualified 
to use.

Tom
