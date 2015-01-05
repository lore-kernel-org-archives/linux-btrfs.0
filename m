Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44584 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEIEC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 03:04:02 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 99EF93EE0BD
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 17:04:00 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 95D34AC036C
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 17:03:59 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4035BE08003
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 17:03:59 +0900 (JST)
Message-ID: <54AA4551.9010900@jp.fujitsu.com>
Date: Mon, 5 Jan 2015 17:03:29 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <chris@colorremedies.com>
Subject: Re: [PATCH] btrfs: suppress a build warning on building 32bit kernel
References: <CAJCQCtQWS9j0g44c5VKp0Cv=PRC=GAJwpspF5eeRk0siibGXKg@mail.gmail.com> <549BD725.8040603@jp.fujitsu.com> <20141229150903.GH6490@twin.jikos.cz>
In-Reply-To: <20141229150903.GH6490@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 2014/12/30 0:09, David Sterba wrote:
> On Thu, Dec 25, 2014 at 06:21:41PM +0900, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2190,7 +2190,7 @@ void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
>>
>>    		next = next_state(state);
>>
>> -		failrec = (struct io_failure_record *)state->private;
>> +		failrec = (struct io_failure_record *)(unsigned long)state->private;
>
> We're always using the 'private' data to store a pointer to
> 'struct io_failure_record *', please change the defintion in
> 'struct extent_state' instead of the typecasting.

Current definition is as follow.

===============================================================================
struct extent_state {
...
         /* for use by the FS */
         u64 private;
};
===============================================================================

It it OK to changing "u64 private" to "struct io_failure_record *failrec"
and change "{set,get}_state_private()" to "{set,get}_state_failrec()?
Or is it better to keep the name "private" as is and just change its type
to "unsigned long" or "(void *)"?

Thanks,
Satoru

>
>>    		free_extent_state(state);
>>    		kfree(failrec);

