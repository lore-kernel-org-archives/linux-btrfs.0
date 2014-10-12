Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44891 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaJLLLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 07:11:49 -0400
Message-ID: <543A61EE.7070200@prnet.org>
Date: Sun, 12 Oct 2014 13:11:42 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send and kernel 3.17
References: <543450DC.90504@prnet.org> <1412714780.2374.0@mail.thefacebook.com>
In-Reply-To: <1412714780.2374.0@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This weekend I finally had time to try btrfs send again on the newly
created fs. Now I am running into another problem:

btrfs send returns: ERROR: send ioctl failed with -12: Cannot allocate
memory

In dmesg I see only the following output:

parent transid verify failed on 21325004800 wanted 2620 found 8325


On 10/07/2014 10:46 PM, Chris Mason wrote:
> On Tue, Oct 7, 2014 at 4:45 PM, David Arendt <admin@prnet.org> wrote:
>> On 10/07/2014 03:19 PM, Chris Mason wrote:
>>>
>>>
>>>  On Tue, Oct 7, 2014 at 1:25 AM, David Arendt <admin@prnet.org> wrote:
>>>>  I did a revert of this commit. After creating a snapshot, the
>>>>  filesystem was no longer usable, even with kernel 3.16.3 (crashes 10
>>>>  seconds after mount without error message) . Maybe there was some
>>>>  previous damage that just appeared now. This evening, I will restore
>>>>  from backup and report back.
>>>>
>>>>  On October 7, 2014 12:22:11 AM CEST, Chris Mason <clm@fb.com> wrote:
>>>>>  On Mon, Oct 6, 2014 at 4:51 PM, David Arendt <admin@prnet.org>
>>>>> wrote:
>>>>>>   I just tried downgrading to 3.16.3 again. In 3.16.3 btrfs send is
>>>>>>   working without any problem. Afterwards I upgraded again to
>>>>>> 3.17 and
>>>>>>   the
>>>>>>   problem reappeared. So the problem seems to be kernel version
>>>>>>  related.
>>>>>
>>>>>  [ backref errors during btrfs-send ]
>>>>>
>>>>>  Ok then, our list of suspects is pretty short.  Can you easily build
>>>>>  test kernels?
>>>>>
>>>>>  I'd like to try reverting this commit:
>>>>>
>>>>>  51f395ad4058883e4273b02fdebe98072dbdc0d2
>>>
>>>  Oh no!  Reverting this definitely should not have caused corruptions,
>>>  so I think the problem was already there.  Do you still have the
>>>  filesystem image?
>>>
>>>  Please let us know if you're missing files off the backup, we'll help
>>>  pull them out.
>>>
>> Due to space constraints, it was not possible to take an image of the
>> corrupted filesystem. As I do backups daily, and the problems occurred 5
>> hours after backup, no file was lost. Thanks for offering your help. In
>> 4 days I will do some send tests on the newly created filesystem and
>> report back.
>
> Ok, if you have the kernel messages from the panic, please send them
> along.
>
> -chris
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

