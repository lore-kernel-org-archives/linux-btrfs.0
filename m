Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33477 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbcAZT1x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 14:27:53 -0500
Received: by mail-ig0-f179.google.com with SMTP id z14so64640028igp.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 11:27:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTdDyv0PkkuHGrEpEnk5yzM1Fx1C0VUT8r7OAfU6i8Dfw@mail.gmail.com>
References: <56A230C3.3080100@netcologne.de>
	<CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
	<56A6082C.3030007@netcologne.de>
	<CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
	<CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
	<CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
	<CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
	<CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
	<56A73460.7080100@netcologne.de>
	<CAJCQCtTdDyv0PkkuHGrEpEnk5yzM1Fx1C0VUT8r7OAfU6i8Dfw@mail.gmail.com>
Date: Tue, 26 Jan 2016 12:27:52 -0700
Message-ID: <CAJCQCtQPtRTjvwCahMSLRDk7q8TQR6tcPnYXHv1FRig7hbAsNw@mail.gmail.com>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Christian Rohmann <crohmann@netcologne.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 26, 2016 at 12:26 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Jan 26, 2016 at 1:54 AM, Christian Rohmann
> <crohmann@netcologne.de> wrote:
>> Hey Chris and all,
>>
>> On 01/25/2016 11:13 PM, Chris Murphy wrote:
>>> Does anyone suspect a kernel regression here? I wonder if its worth it
>>> to suggest testing the current version of all fairly recent kernels:
>>> 4.5.rc1, 4.4, 4.3.4, 4.2.8, 4.1.16? I think going farther back to
>>> 3.18.x isn't worth it since that's before the major work since raid56
>>> was added. Quite a while ago I've done a raid56 rebuild and balance
>>> that was pretty fast but it was only a 4 or 5 device test.
>>
>> Problem is that this balance did not work before going to 4.4 kernel,
>> it's was simply crashing after about an hour or two of runtime.
>>
>> Currently I am using 4.4 kernel + btrfs-progs, so apart from 4.5rc1 I
>> can not get any more bleeding edge.
>>
>> 4.5 I am happy to try, but not RC1 as there are already some bugs
>> popping up regarding the BTRFS changes.
>>
>>
>> On 01/26/2016 07:14 AM, Chris Murphy wrote:
>>> Christian, what are you getting for 'iotop -d3 -o' or 'iostat -d3'. Is
>>> it consistent or is it fluctuating all over the place? What sort of
>>> eyeball avg/min/max are you getting?
>>
>> "1672.81 K/s 1672.81 K/s  0.00 %  6.99 % btrfs balance start -dstripes
>> 1..11 -mstripes 1..11 "
>>
>> but it's jumping up to 25MB/s for a few polls, but most of the time it's
>> at 1.3 to 1.7 MB/s
>
>
> That is really slow. The fact you can't balance without crashing prior
> to a 4.4 kernel makes me suspicious about the file system state. What
> about reading and writing files? What's the performance in that case?
> Is it just the balance that's this slow? Do you have the call traces
> for older kernel crashes with balance? What btrfs-progs was used to
> create the raid6 volume?
>
> Maybe the slowness is due to the -dstripes -mstripes filter. That's
> relatively new. And I didn't try that. And I also don't really
> understand the values you picked either. Seems to me if you've added
> four drives relatively recently, there won't be many chunks using
> 12-strip stripes, most of them will be 8-strip stripes. So I don't
> really know what you're limiting.

I guess the bottom line of what I'm suggesting before trying anything
else, is to stop the balance and start a normal one without filters
and see how that performs.


-- 
Chris Murphy
