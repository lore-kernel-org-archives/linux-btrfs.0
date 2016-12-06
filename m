Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35614 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbcLFBeD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 20:34:03 -0500
Received: by mail-yw0-f196.google.com with SMTP id b66so27528360ywh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 17:34:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51de09f3-f0e2-1e4d-f4a8-496d326d8d9c@fb.com>
References: <CAJCQCtTRXEcJmP8vu1uaJHME2UnosHPOP9vmQM3GBACoJDpLPA@mail.gmail.com>
 <51de09f3-f0e2-1e4d-f4a8-496d326d8d9c@fb.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 5 Dec 2016 18:34:02 -0700
Message-ID: <CAJCQCtRHro5BtEObyhF=0CuPGroE+yFQCOoMoBKGhqbpuPBa7Q@mail.gmail.com>
Subject: Re: crc32c_le performance hit
To: Chris Mason <clm@fb.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 5, 2016 at 8:46 AM, Chris Mason <clm@fb.com> wrote:
> On 12/04/2016 04:28 PM, Chris Murphy wrote:
>>
>> 4.8.11-300.fc25.x86_64
>>
>> I'm currently doing a btrfs send/receive and I'm seeing a rather large
>> hit for crc32c, bigger than aes-ni (the volume is on dm crypt), using
>> perf top.
>>
>>   14.03%  btrfs                                    [.] __crc32c_le
>>   10.50%  [kernel]                                 [k] _aesni_enc4
>>
>
> This is surprising, although send/recv does do a lot of small crc runs. What
> is the overall CPU usage?

Before issuing btrfs send, btrfs receive:
%Cpu(s):  0.2 us,  0.2 sy,  0.0 ni, 99.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

During:
%Cpu(s):  5.1 us, 18.2 sy,  0.0 ni, 35.0 id, 40.2 wa,  0.7 hi,  0.8 si,  0.0 st

Full output
https://paste.fedoraproject.org/500097/

Lots of waiting, but most of that 18% hit is coming from the two btrfs
commands themselves. The same thing doesn't happen with a btrfs scrub,
which also has to compute crc's albeit just once.




>Maybe pin btrfs to a single CPU and use mpstat to
> see how hot that one CPU is.  If we're 14% of a CPU running at 100%, that's
> a big deal.  If we're 14% of a CPU running at 5%, we safely ignore it.

I'm not sure how to do this, but if all btrfs processes were pinned to
a single core, based on the more than dozen active processes I see in
top during send/receive, it would definitely soak all of that core.


>
>>
>> Complete output is here for 1 month:
>>
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__paste.fedoraproject.org_498914_&d=DgIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=YXgqrDMWJP2u2reRh04tnYz4CrO5SPUhSHd1cF2OcR0&s=axoqoaw0ZkYXdDxlTODLOfzqEK7uIJHqMsBjpkyIw5o&e=
>>
>> I don't remember crc32's taking this much CPU before, so it seems like
>> a regression but offhand I don't know when it started.
>>
>> [chris@f25s ~]$ dmesg | grep crc32
>> [    4.226700] Btrfs loaded, crc32c=crc32c-intel
>
>
> At least we know you're using the intel accelerated one.  Every time someone
> posts this dmesg output to the list, I owe Jeff another beer.


Glad I can increase your beer liability. :-D



-- 
Chris Murphy
