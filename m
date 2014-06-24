Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49146 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbaFXDNe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 23:13:34 -0400
Message-ID: <53A8EBEB.1030702@cn.fujitsu.com>
Date: Tue, 24 Jun 2014 11:09:31 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Mike Hartman <mike@hartmanipulation.com>
CC: Chris Murphy <lists@colorremedies.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com> <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <53A8E079.1060803@cn.fujitsu.com> <CAB=7dhm4wz7tXm7am0ezNvAiH+YjKBYrL53AQsn9DMQJwaus4Q@mail.gmail.com>
In-Reply-To: <CAB=7dhm4wz7tXm7am0ezNvAiH+YjKBYrL53AQsn9DMQJwaus4Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mike,

On 06/24/2014 11:04 AM, Mike Hartman wrote:
> I have no particular desire to use it. I just tried everything else
> first and thought it was worth a shot.
>
> If you think that version would help, can you point me to the git
> repo? The one I grabbed was
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git.
Of course,  You could pull from the following url:

https://github.com/kdave/btrfs-progs.git  integration-20140619

>
> On Mon, Jun 23, 2014 at 10:20 PM, Wang Shilong
> <wangsl.fnst@cn.fujitsu.com> wrote:
>> On 06/24/2014 09:17 AM, Chris Murphy wrote:
>>> On Jun 23, 2014, at 4:18 PM, Mike Hartman <mike@hartmanipulation.com>
>>> wrote:
>>>
>>>> Can anyone offer any suggestions? Is this data really unrecoverable? I
>>>> have no idea what could have gone so severely wrong.
>>> "btrfs check --repair /media/mint/usb_data/sda6_check.img
>>> "btrfs check --repair --init-csum-tree --init-extent-tree
>>> /media/mint/usb_data/sda6_check.img
>> My two cents:-)
>>
>> If you really want to use btrfs check  --init-csum-tree --init-extent-tree,
>> i'd suggest you use
>> David Latest btrfs-progs branch which includes some latest bug fixes.
>>
>>> I think these things are going too far on actual file system without
>>> guidance, so it's superb you imaged the original drive first. Too many
>>> people get aggressive writing to the actual drive without backup images. You
>>> have both a dd image as well as btrfs-image which is really great. Hopefully
>>> someone can help find out what happened, it seems abruptly catastrophic, but
>>> also mixes messages where some information is being found but this one:
>>>          * read block failed check_tree_block
>>> makes me think of partial media failure. It would be damn bad luck if your
>>> metadata is set to DUP, yet both copies are toast. Is this an HDD or SSD?
>>>
>>> Can you post the result from smartctl -x /dev/sdX   #for the disk in
>>> question, maybe from a live system?
>>>
>>>
>>> Chris Murphy
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> .
>

