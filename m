Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60028 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932117AbdIYIE6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 04:04:58 -0400
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
To: Hugo Mills <hugo@carfax.org.uk>, Marat Khalili <mkh@rqc.ru>,
        Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
Date: Mon, 25 Sep 2017 16:04:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170925075250.GC25529@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月25日 15:52, Hugo Mills wrote:
> On Mon, Sep 25, 2017 at 03:46:15PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年09月25日 15:42, Marat Khalili wrote:
>>> On 25/09/17 10:30, Nikolay Borisov wrote:
>>>> On 19.09.2017 10:41, Misono, Tomohiro wrote:
>>>>> "btrfs subvolume create/delete" outputs the message of "Create/Delete
>>>>> subvolume ..." even when an operation fails.
>>>>> Since it is confusing, let's outputs the message only when an
>>>>> operation succeeds.
>>>> Please change the verb to past tense, more strongly signaling success -
>>>> i.e. "Created subvolume"
>>> What about recalling some UNIX standards and returning to NOT
>>> outputting any message when operation succeeds? My scripts are
>>> full of grep -v calls after each btrfs command, and this sucks
>>> (and I don't think I'm alone in this situation).
>>
>> Isn't the correct way to catch the return value instead of grepping
>> the output?
> 
>     It is, but if, for example, you're using the command in a cron
> script which is expected to work, you don't want it producing output
> because then you get a mail every time the script runs. So you have to
> grep -v on the "success" output to make the successful script silent.

What about redirecting stdout to /dev/null and redirecting stderr to 
mail if return value is not 0?
As for expected-to-work case, the stdout doesn't has much meaning and 
return value should be good enough to judge the result.

> 
>> If it's some command not returning value properly, would you please
>> report it as a bug so we can fix it.
> 
>     It's not the return value that's problematic (although those used
> to be a real mess). It's the fact that a successful run of the command
> produces noise on stdout, which most commands don't.

Yes, a lot of tried-and-true tools don't output anything for successful 
run, but also a lot of other tools do output something by default, 
especially for complex tools like LVM.

Maybe we can introduce a global --quite option to silent some output.

Thanks,
Qu
> 
>     Hugo.
>   
>> Thanks,
>> Qu
>>
>>> If you change the message a lot of scripts will have to be
>>> changed, at least make it worth it.
>>>
>>>   --
>>>
>>> With Best Regards,
>>> Marat Khaliili
>>>
> 
