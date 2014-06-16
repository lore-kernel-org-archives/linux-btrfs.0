Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15414 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754024AbaFPHNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 03:13:53 -0400
Message-ID: <539E9841.8040108@cn.fujitsu.com>
Date: Mon, 16 Jun 2014 15:09:53 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>
CC: <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>
Subject: Re: Transaction commit: none (default)
References: <20140614160554.GP6584@merlins.org> <539E49DB.80305@cn.fujitsu.com> <20140616014739.GB19071@merlins.org> <pan.2014.06.16.07.06.08@googlemail.com>
In-Reply-To: <pan.2014.06.16.07.06.08@googlemail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/16/2014 03:06 PM, Holger Hoffstätte wrote:
> On Sun, 15 Jun 2014 18:47:39 -0700, Marc MERLIN wrote:
>
>> On Mon, Jun 16, 2014 at 09:35:23AM +0800, Wang Shilong wrote:
>>> On 06/15/2014 12:05 AM, Marc MERLIN wrote:
>>>> Taking snapshots is now output this in addition of the snapshot
>>>> operation.
>>>>
>>>> Transaction commit: none (default)
>>>>
>>>> 1) Is that expected/normal? It looks kind of spamming/useless to me?
>>>> 2) If it's useful, what's the use I'm not getting?
>>> Addressed a issue that subvolumes reappear after deletetion if poweroff
>>> happen.
>>>
>>> http://www.spinics.net/lists/linux-btrfs/msg29547.html
>> I see, thank you for the pointer.
>> In the case of my script, it's console spam that I wish I could make go
>> away, but grep -v will do that for me :)
>>
>> If it annoys other people, maybe having a -q (quiet) that removes this
>> message would be useful?
> IMHO it should be the reverse: be quiet by default and require -v, just
> as more explicit behaviour also requires additional options.
> With default options I expect default behaviour. Telling me that the
> default behaviour happened is just noise.
Fair point, Another question is that current default output has been there.
Let's Cc David, and see what is his opinion.

>
> cheers
> Holger
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

