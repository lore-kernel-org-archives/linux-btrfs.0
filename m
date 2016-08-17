Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62797 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752867AbcHQAm5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 20:42:57 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: Introduce new send-dump object
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160801062944.25355-1-quwenruo@cn.fujitsu.com>
 <20160816143130.GO30795@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <22e65257-c864-aa4e-9e6b-59610aec347a@cn.fujitsu.com>
Date: Wed, 17 Aug 2016 08:42:48 +0800
MIME-Version: 1.0
In-Reply-To: <20160816143130.GO30795@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/16/2016 10:31 PM, David Sterba wrote:
> On Mon, Aug 01, 2016 at 02:29:42PM +0800, Qu Wenruo wrote:
>> Introduce send-dump.[ch] which implements a new btrfs_send_ops to
>> exam and output all operations inside a send stream.
>>
>> It has a better output format than the old and no longer compilable
>> send-test tool, but still tries to be script friendly.
>>
>> Provides the basis for later "inspect-internal dump-send" command.
>
> I'd rather put that into the receive subcommand, as it takes the stream
> as argument and it's closer to the send/receive commands, but that's
> a minor thing.
>
>
I'm OK to put it into receive command.

Although unlike normal receive usage, it doesn't need the <path> 
parameter, and make <path> to be optional.

If it's fine to you, then I can update the patchset to merge it into 
receive subcommand.

Thanks,
Qu


