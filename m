Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:39267 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab2ICQO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2012 12:14:57 -0400
Message-ID: <5044D704.4090905@codethink.co.uk>
Date: Mon, 03 Sep 2012 17:12:52 +0100
From: Sam Thursfield <sam.thursfield@codethink.co.uk>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Subject: Re: Advice on FS corruption
References: <5044BD53.5080106@codethink.co.uk> <CAE5mzvgwXks1+6q+tL=AJR7q1HvduQA6S2KMP36-AT40jTkhtQ@mail.gmail.com>
In-Reply-To: <CAE5mzvgwXks1+6q+tL=AJR7q1HvduQA6S2KMP36-AT40jTkhtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[I'm resending this mail to list instead of as a personal reply, sorry]

On 09/03/2012 03:35 PM, cwillu wrote:
> On Mon, Sep 3, 2012 at 8:23 AM, Sam Thursfield
> <sam.thursfield@codethink.co.uk> wrote:
>> Hi
>>
>> I've been running btrfs in various VMs for a while, and periodically I've
>> experienced corruption in the filesystems being used. None of the data is
>> important, but I'd like to track down how the corruption occurred in the
>> first place.
>>
>> Trying to mount any of the corrupt filesystems fails with an error of this
>> form:
>>
>> [   47.805146] device label baserock devid 1 transid 90 /dev/sdb1
>> [   47.810073] btrfs: disk space caching is enabled
>> [   47.817261] parent transid verify failed on 1636728832 wanted 76 found 95
>> [   47.818081] parent transid verify failed on 1636728832 wanted 76 found 95
>> [   47.818522] Failed to read block groups: -5
>> [   47.826103] btrfs: open_ctree failed
>
> Try mounting with -o recovery.
>

Thanks, this gets more interesting!

For two of the FS's I got the exact same error message.

For a much larger (40GB) filesystem the recovery silently succeeded. At 
this point I ran 'find' in the root directory, which gave frequent:

find: ./foo: Input/output error

messages for various small files. I aborted and found all this in dmesg:

[   29.498581] device fsid 7aaaea86-e354-46f7-aa9e-2278c858170a devid 1 
transid 35 /dev/sdb1
[   42.937330] parent transid verify failed on 31920128 wanted 9 found 26
[   42.961755] parent transid verify failed on 31920128 wanted 9 found 26
[   42.999560] parent transid verify failed on 31875072 wanted 9 found 26
[   43.035490] parent transid verify failed on 31875072 wanted 9 found 26
[   43.078782] parent transid verify failed on 31907840 wanted 9 found 26
[   43.079767] parent transid verify failed on 31907840 wanted 9 found 26
[   43.081685] parent transid verify failed on 31920128 wanted 9 found 26
[   43.082478] parent transid verify failed on 31920128 wanted 9 found 26
[   43.110576] parent transid verify failed on 31952896 wanted 9 found 27
[   43.112616] parent transid verify failed on 31952896 wanted 9 found 27

So, it seems to have improved matters, but am I correct in thinking this 
FS would now only be suitable for extracting as much of the data as 
possible and then discarding the whole thing? Or is the intention that 
an FS in such a state should be recovered to the point of being usable 
again?

Thanks
Sam


