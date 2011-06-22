From: Josef Bacik <josef@redhat.com>
Subject: Re: Abysmal Performance
Date: Wed, 22 Jun 2011 11:39:27 -0400
Message-ID: <4E020CAF.6080705@redhat.com>
References: <7da312412980843ba746e4e8809060f8@localhost> <1308669852.2106.7.camel@ayu> <e5b85820126546a3369499aebb166c60@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Henning Rohlfs <x+btrfs@xehonk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e5b85820126546a3369499aebb166c60@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2011 10:15 AM, Henning Rohlfs wrote:
> On Tue, 21 Jun 2011 11:24:11 -0400, Calvin Walton wrote:
>> On Mon, 2011-06-20 at 23:51 +0200, Henning Rohlfs wrote:
>>> Hello,
>>>
>>>  I've migrated my system to btrfs (raid1) a few months ago. Since t=
hen
>>>  the performance has been pretty bad, but recently it's gotten
>>>  unbearable: a simple sync called while the system is idle can take
>>> 20 up
>>>  to 60 seconds. Creating or deleting files often has several second=
s
>>>  latency, too.
>>
>> I think I=E2=80=99ve been seeing a fairly similar, or possibly the s=
ame? issue
>> as well. It looks like it=E2=80=99s actually a regression introduced=
 in 2.6.39 -
>> if I switch back to a 2.6.38 kernel, my latency issues magically go
>> away! (I'm curious: does using the older 2.6.38.x kernel help with
>> anyone else that's seeing the issue?)
>>
>> Some hardware/configuration details:
>> btrfs on a single disc (Seagate Momentus XT hybrid), lzo compression=
 and
>> space cache enabled. Some snapshots in use.
>>
>> I notice that in latencytop I'm seeing a lot of lines with (cropped)
>> traces like
>>
>> sleep_on_page wait_on_page_bit read_extent_buffer_ 13.3 msec        =
=20
>> 0.5 %
>>
>> showing up that I didn't see with the 2.6.38 kernel. I occasionally =
see
>> latencies as bad as 20-30 seconds on operations like fsync or
>> synchronous writes.
>>
>> I think I can reproduce the issue well enough to bisect it, so I mig=
ht
>> give that a try. It'll be slow going, though.
>=20
> You are right. This seems to be a regression in the .39 kernel. I tes=
ted
> with 2.6.38.2 just now and the performance is back to normal.

Would you mind bisecting?  You can make it go faster by doing

git bisect start fs/

that way only changes in fs are used.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
