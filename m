Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40477 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933011AbcJSBSS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 21:18:18 -0400
Subject: Re: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam and
 dump send stream
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
 <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
 <20160908094228.GK16983@twin.jikos.cz> <20160908095613.GL16983@twin.jikos.cz>
 <9e6d85ed-e9b7-0a7c-44d0-83f66f369692@cn.fujitsu.com>
 <20161018120749.GO11398@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ead991f8-710e-e865-7cdd-2a4390fec3dd@cn.fujitsu.com>
Date: Wed, 19 Oct 2016 09:18:09 +0800
MIME-Version: 1.0
In-Reply-To: <20161018120749.GO11398@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/18/2016 08:07 PM, David Sterba wrote:
> On Thu, Oct 13, 2016 at 03:32:53PM +0800, Qu Wenruo wrote:
>> Hi David,
>>
>> Any updates?
>>
>> If you're busy on these fix, I could fix these problem and send a new
>> version.
>
> I was about to add the series to merge but the output format needs work.
> At minimum, something that's parseable, so some commonly used format
> (yaml or json). The current way is ok for quick overview, but I'd really
> like to see more options of the output. The malloc/free problems are
> minor.
>

Thanks for the comment.

It makes sense. And it can be the first step to make all btrfs commands 
output parseable.

I could try to use json-c as our json library to add json output mode 
for send dump.

Meanwhile the original design for send-dump is only for human, and the 
json output support will be a huge work(not only for send-dump, but 
quite a lot of other sub-commands).

What about merge send dump first, and then add json support step-by-step?

Thanks,
Qu


