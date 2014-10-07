Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16595 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752709AbaJGUq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 16:46:28 -0400
Date: Tue, 7 Oct 2014 16:46:20 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: btrfs send and kernel 3.17
To: David Arendt <admin@prnet.org>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1412714780.2374.0@mail.thefacebook.com>
In-Reply-To: <543450DC.90504@prnet.org>
References: <543450DC.90504@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 7, 2014 at 4:45 PM, David Arendt <admin@prnet.org> wrote:
> On 10/07/2014 03:19 PM, Chris Mason wrote:
>> 
>> 
>>  On Tue, Oct 7, 2014 at 1:25 AM, David Arendt <admin@prnet.org> 
>> wrote:
>>>  I did a revert of this commit. After creating a snapshot, the
>>>  filesystem was no longer usable, even with kernel 3.16.3 (crashes 
>>> 10
>>>  seconds after mount without error message) . Maybe there was some
>>>  previous damage that just appeared now. This evening, I will 
>>> restore
>>>  from backup and report back.
>>> 
>>>  On October 7, 2014 12:22:11 AM CEST, Chris Mason <clm@fb.com> 
>>> wrote:
>>>>  On Mon, Oct 6, 2014 at 4:51 PM, David Arendt <admin@prnet.org> 
>>>> wrote:
>>>>>   I just tried downgrading to 3.16.3 again. In 3.16.3 btrfs send 
>>>>> is
>>>>>   working without any problem. Afterwards I upgraded again to 
>>>>> 3.17 and
>>>>>   the
>>>>>   problem reappeared. So the problem seems to be kernel version
>>>>>  related.
>>>> 
>>>>  [ backref errors during btrfs-send ]
>>>> 
>>>>  Ok then, our list of suspects is pretty short.  Can you easily 
>>>> build
>>>>  test kernels?
>>>> 
>>>>  I'd like to try reverting this commit:
>>>> 
>>>>  51f395ad4058883e4273b02fdebe98072dbdc0d2
>> 
>>  Oh no!  Reverting this definitely should not have caused 
>> corruptions,
>>  so I think the problem was already there.  Do you still have the
>>  filesystem image?
>> 
>>  Please let us know if you're missing files off the backup, we'll 
>> help
>>  pull them out.
>> 
> Due to space constraints, it was not possible to take an image of the
> corrupted filesystem. As I do backups daily, and the problems 
> occurred 5
> hours after backup, no file was lost. Thanks for offering your help. 
> In
> 4 days I will do some send tests on the newly created filesystem and
> report back.

Ok, if you have the kernel messages from the panic, please send them 
along.

-chris



