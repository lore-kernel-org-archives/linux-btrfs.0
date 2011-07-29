From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs hung tasks
Date: Fri, 29 Jul 2011 09:05:42 -0400
Message-ID: <4E32B026.8020906@redhat.com>
References: <20110728062343.GA4656@yahoo.fr> <20110728142253.GA3524@dhcp231-156.rdu.redhat.com> <20110729122921.GA11526@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110729122921.GA11526@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/29/2011 08:29 AM, Stephane Chazelas wrote:
> 2011-07-28 10:22:54 -0400, Josef Bacik:
>> On Thu, Jul 28, 2011 at 07:23:43AM +0100, Stephane Chazelas wrote:
>>> Hiya, I got below those last night. That was 3 minutes after a
>>> bunch of rsync and ntfsclone processes started.
>>>
>>> It's the first time it happens. I upgraded from 3.0rc6 to 3.0
>>> yesterday.
>>>
>>
>> Ok I fixed that recently and Chris just sent it to Linus.  The patch you are
>> looking for is
>>
>> Btrfs: use a worker thread to do caching
> [...]
>
> Thanks a lot Josef,
>
> That seems to have done the trick. I've not reproduced the issue
> yet with that patch applied. Strange that I only get the issue
> with 3.0 and not 3.0rc6  though....
>

Just bad luck really.  Thanks,

Josef
