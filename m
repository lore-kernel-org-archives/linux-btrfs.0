Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36185 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961AbbDWPml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 11:42:41 -0400
Received: by wizk4 with SMTP id k4so221011742wiz.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 08:42:40 -0700 (PDT)
Message-ID: <553912EF.7010004@gmail.com>
Date: Thu, 23 Apr 2015 17:42:39 +0200
From: Marc Cousin <cousinmarc@gmail.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: snapshot destruction making IO extremely slow
References: <550E7917.5030602@gmail.com> <20150325011937.GB20767@twin.jikos.cz> <55129428.7090508@gmail.com> <20150330142532.GI32051@suse.cz> <55196740.1000705@gmail.com> <20150331170516.GD6821@suse.cz> <5534CC2F.4080109@gmail.com>
In-Reply-To: <5534CC2F.4080109@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/04/2015 11:51, Marc Cousin wrote:
> On 31/03/2015 19:05, David Sterba wrote:
>> On Mon, Mar 30, 2015 at 05:09:52PM +0200, Marc Cousin wrote:
>>>> So it would be good to sample the active threads and see where it's
>>>> spending the time. It could be the somewhere in the rb-tree representing
>>>> extents, but that's a guess.
>>>>
>>> I just need to be told how to do that :)
>>>
>>> Something like a perf top ?
>>
>> for i in `pgrep btrfs`; do
>>         ps $i
>> 	sudo cat /proc/$i/stack 2>/dev/null
>> done
>>
>> and capture samples every second.
>>
> 
> Sorry, it took me a while to reproduce this (I needed to be in front of the machine when it happens :) )

Hi,

Anything more I can provide on this issue ?

Regards

