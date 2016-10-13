Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40558 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751195AbcJMHdC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 03:33:02 -0400
Subject: Re: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam and
 dump send stream
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
 <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
 <20160908094228.GK16983@twin.jikos.cz> <20160908095613.GL16983@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9e6d85ed-e9b7-0a7c-44d0-83f66f369692@cn.fujitsu.com>
Date: Thu, 13 Oct 2016 15:32:53 +0800
MIME-Version: 1.0
In-Reply-To: <20160908095613.GL16983@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Any updates?

If you're busy on these fix, I could fix these problem and send a new 
version.

Thanks,
Qu

At 09/08/2016 05:56 PM, David Sterba wrote:
> On Thu, Sep 08, 2016 at 11:42:29AM +0200, David Sterba wrote:
>> On Wed, Sep 07, 2016 at 08:29:34AM +0800, Qu Wenruo wrote:
>>> @@ -1265,19 +1274,37 @@ int cmd_receive(int argc, char **argv)
>>>  		}
>>>  	}
>>>
>>> -	ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
>>> +	if (dump) {
>>> +		struct btrfs_dump_send_args dump_args;
>>> +
>>> +		dump_args.root_path = malloc(PATH_MAX);
>>> +		dump_args.root_path[0] = '.';
>>> +		dump_args.root_path[1] = '\0';
>>> +		dump_args.full_subvol_path = malloc(PATH_MAX);
>>
>> Please always check malloc return values. I'm fixing this for now.
>
> Uh and the buffers are not freed either. Anyway, I'm switching it to an
> array, there's no reason to allocate the memory dynamically.
>
>


