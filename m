Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51894 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1034243AbcIZChy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 22:37:54 -0400
Subject: Re: Post ext3 conversion problems
To: Sean Greenslade <sean@seangreenslade.com>
References: <20160916192459.GA13514@coach.home>
 <CAJCQCtQutt6r2Jovr0jEbTk4W6HUaQpbGiipen97TH1C+k055g@mail.gmail.com>
 <17ca9019-836b-f4f1-f84c-f8c1edcd9925@cn.fujitsu.com>
 <20160919041247.GA32208@coach.home>
 <ae8fd0d5-0d38-aa8e-0114-36ef62b1a783@cn.fujitsu.com>
 <20160919151341.GA1431@coach.home>
 <5f07d365-1eec-7f90-7969-af761834ee48@cn.fujitsu.com>
 <20160920033933.GA13425@coach.home>
 <fbfb851d-34a7-62df-d24e-0fd5b3a2e5e4@cn.fujitsu.com>
 <20160920205121.GA23668@coach.home> <20160926021609.GA11493@coach.home>
CC: Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cb409caa-2fd4-cd89-9981-4373cc31127c@cn.fujitsu.com>
Date: Mon, 26 Sep 2016 10:37:48 +0800
MIME-Version: 1.0
In-Reply-To: <20160926021609.GA11493@coach.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/26/2016 10:16 AM, Sean Greenslade wrote:
> On Tue, Sep 20, 2016 at 04:51:21PM -0400, Sean Greenslade wrote:
>> On Tue, Sep 20, 2016 at 01:02:38PM +0800, Qu Wenruo wrote:
>>>> Glad to hear you've found the core of the issue.
>>>>
>>>> At this point, I can trigger it immediately. As soon as I log in and run
>>>> dmenu, it will attempt to rebuild its cache file (small text file that's
>>>> just a list of all executables in the PATH). Once that write happens,
>>>> the bug triggers and the fs goes read only.
>>>
>>> Rewrite? Or write into new inode?
>>>
>>> And is the same inode always causing the problem?
>>
>> It's not always the same. It seems like whatever triggers a write first
>> is what kills it. I went to test it, and this time it triggered on my
>> .bash_history file. I have bash set up with "history -a", so presumably
>> that was an append, not an overwrite.
>>
>> To cut down on the number of variables, I booted my system with the
>> "rescue" systemd target, then su'd to my user. Simply running a few
>> commands (with the history -a writes that bash triggered) was enough to
>> trigger the bug. This is on 4.8.0-rc6, with the following compile time
>> options enabled:
>>
>> CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
>> CONFIG_BTRFS_DEBUG=y
>> CONFIG_BTRFS_ASSERT=y
>>
>> If I run the stock Arch kernel (4.7.2 at the moment), the issue still
>> appears, but it takes longer. My most reliable trigger is Firefox, whose
>> constant DB writes will trigger it within minutes.
>
> Is there anything I can do to help this along? I can build experimental
> patches, set up long running scripts, run tests, whatever is necessary.

Unfortunately, I'm afraid that we need to dig the source to locate 
problem, not anytime soon to find the root cause.

Thanks,
Qu
>
> Thanks,
>
> --Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


