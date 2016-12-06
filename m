Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50961 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753793AbcLFPnF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Dec 2016 10:43:05 -0500
Subject: Re: crc32c_le performance hit
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtTRXEcJmP8vu1uaJHME2UnosHPOP9vmQM3GBACoJDpLPA@mail.gmail.com>
 <51de09f3-f0e2-1e4d-f4a8-496d326d8d9c@fb.com>
 <CAJCQCtRHro5BtEObyhF=0CuPGroE+yFQCOoMoBKGhqbpuPBa7Q@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <ea1c02be-b7ae-dc60-6d72-8ac04d842ad5@fb.com>
Date: Tue, 6 Dec 2016 10:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRHro5BtEObyhF=0CuPGroE+yFQCOoMoBKGhqbpuPBa7Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2016 08:34 PM, Chris Murphy wrote:
> On Mon, Dec 5, 2016 at 8:46 AM, Chris Mason <clm@fb.com> wrote:
>> On 12/04/2016 04:28 PM, Chris Murphy wrote:
>>>
>>> 4.8.11-300.fc25.x86_64
>>>
>>> I'm currently doing a btrfs send/receive and I'm seeing a rather large
>>> hit for crc32c, bigger than aes-ni (the volume is on dm crypt), using
>>> perf top.
>>>
>>>   14.03%  btrfs                                    [.] __crc32c_le
>>>   10.50%  [kernel]                                 [k] _aesni_enc4
>>>
>>
>> This is surprising, although send/recv does do a lot of small crc runs. What
>> is the overall CPU usage?
>
> Before issuing btrfs send, btrfs receive:
> %Cpu(s):  0.2 us,  0.2 sy,  0.0 ni, 99.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
>
> During:
> %Cpu(s):  5.1 us, 18.2 sy,  0.0 ni, 35.0 id, 40.2 wa,  0.7 hi,  0.8 si,  0.0 st
>
> Full output
> https://urldefense.proofpoint.com/v2/url?u=https-3A__paste.fedoraproject.org_500097_&d=DgIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=svwboLaftKw8i8TJ7J-VEs1UtIBPsaEw6-H1ijzbrxQ&s=t64ReJkaNbpHAPdqzPcXS7rLlACNHhBOt2uJ8-fYjfU&e=
>
> Lots of waiting, but most of that 18% hit is coming from the two btrfs
> commands themselves. The same thing doesn't happen with a btrfs scrub,
> which also has to compute crc's albeit just once.
>
>> Maybe pin btrfs to a single CPU and use mpstat to
>> see how hot that one CPU is.  If we're 14% of a CPU running at 100%, that's
>> a big deal.  If we're 14% of a CPU running at 5%, we safely ignore it.
>
> I'm not sure how to do this, but if all btrfs processes were pinned to
> a single core, based on the more than dozen active processes I see in
> top during send/receive, it would definitely soak all of that core.

So what should be happening is the btrfs command triggering ioctls that 
assemble the send stream.  If we just pin the btrfs command, I'm hoping 
that will account for most of the crc32c cpu time.  We definitely do 
crcs as we read in data/metadata, but those won't be the teeny 
incrementals that send/recv causes.

Long way of saying that if we use "taskset -c 0 btrfs send", it should 
isolate the send/recv overhead from the normal FS.  We do love our 
helper threads, but it's part of the picture at least.

-chris
