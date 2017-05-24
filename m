Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:33625 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933663AbdEXIKJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 04:10:09 -0400
Received: by mail-ua0-f174.google.com with SMTP id e28so92471767uah.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2017 01:10:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <553912EF.7010004@gmail.com>
References: <550E7917.5030602@gmail.com> <20150325011937.GB20767@twin.jikos.cz>
 <55129428.7090508@gmail.com> <20150330142532.GI32051@suse.cz>
 <55196740.1000705@gmail.com> <20150331170516.GD6821@suse.cz>
 <5534CC2F.4080109@gmail.com> <553912EF.7010004@gmail.com>
From: Marc Cousin <cousinmarc@gmail.com>
Date: Wed, 24 May 2017 10:10:08 +0200
Message-ID: <CAKbZ4cK8-Fh6MvS1X4Tj-S9k6VBgaPEFj8x30de3NQf-UdZBrg@mail.gmail.com>
Subject: Re: snapshot destruction making IO extremely slow
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-04-23 17:42 GMT+02:00 Marc Cousin <cousinmarc@gmail.com>:
> On 20/04/2015 11:51, Marc Cousin wrote:
>> On 31/03/2015 19:05, David Sterba wrote:
>>> On Mon, Mar 30, 2015 at 05:09:52PM +0200, Marc Cousin wrote:
>>>>> So it would be good to sample the active threads and see where it's
>>>>> spending the time. It could be the somewhere in the rb-tree representing
>>>>> extents, but that's a guess.
>>>>>
>>>> I just need to be told how to do that :)
>>>>
>>>> Something like a perf top ?
>>>
>>> for i in `pgrep btrfs`; do
>>>         ps $i
>>>      sudo cat /proc/$i/stack 2>/dev/null
>>> done
>>>
>>> and capture samples every second.
>>>
>>
>> Sorry, it took me a while to reproduce this (I needed to be in front of the machine when it happens :) )
>
> Hi,
>
> Anything more I can provide on this issue ?
>
> Regards
>

Hi,

It took me a while (two years :) ), but I think I found what makees
this problem appear, as I just triggered it on a system after this
change. It occurs when enabling quotas on a volume. When there are a
lot of snapshots that are deleted, the system becomes extremely
unresponsive (IO often waiting for 30s on a SSD). When I don't have
quotas, removing snapshots is fast.
