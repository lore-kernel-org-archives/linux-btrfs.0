Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36847 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753180AbcIFCIS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 22:08:18 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: Introduce new send-dump object
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160801062944.25355-1-quwenruo@cn.fujitsu.com>
 <20160816143130.GO30795@twin.jikos.cz>
 <22e65257-c864-aa4e-9e6b-59610aec347a@cn.fujitsu.com>
 <20160824124940.GR16983@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f8f09829-4cac-051b-6f5a-099cd03e6250@cn.fujitsu.com>
Date: Tue, 6 Sep 2016 10:08:12 +0800
MIME-Version: 1.0
In-Reply-To: <20160824124940.GR16983@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/24/2016 08:49 PM, David Sterba wrote:
> On Wed, Aug 17, 2016 at 08:42:48AM +0800, Qu Wenruo wrote:
>>
>>
>> At 08/16/2016 10:31 PM, David Sterba wrote:
>>> On Mon, Aug 01, 2016 at 02:29:42PM +0800, Qu Wenruo wrote:
>>>> Introduce send-dump.[ch] which implements a new btrfs_send_ops to
>>>> exam and output all operations inside a send stream.
>>>>
>>>> It has a better output format than the old and no longer compilable
>>>> send-test tool, but still tries to be script friendly.
>>>>
>>>> Provides the basis for later "inspect-internal dump-send" command.
>>>
>>> I'd rather put that into the receive subcommand, as it takes the stream
>>> as argument and it's closer to the send/receive commands, but that's
>>> a minor thing.
>>>
>>>
>> I'm OK to put it into receive command.
>>
>> Although unlike normal receive usage, it doesn't need the <path>
>> parameter, and make <path> to be optional.
>
> That's a good point and would make the syntax work in two modes, but we
> do that in ohter commands and I hope it will not be confusing. Exmaples:
>
> Normal receive:
>
>  btrfs receive -f file /mount
>
> Dump the stream:
>
>  btrs receive --dump -f file

Sorry for the late reply.

I'm OK for the new syntax.

If no other problem I'll begin to change the syntax and rebase it to devel.

Thanks,
Qu


