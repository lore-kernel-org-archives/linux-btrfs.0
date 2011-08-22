From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: bonnie triggers and endless numbers of stack traces
Date: Mon, 22 Aug 2011 10:17:30 +0200
Message-ID: <4E52109A.3090403@itwm.fraunhofer.de>
References: <j2m3ud$u8e$1@dough.gmane.org> <4E4EBB57.3040209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4EBB57.3040209@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2011 09:36 PM, Josef Bacik wrote:
> On 08/19/2011 12:45 PM, Bernd Schubert wrote:
>> Just for performance tests I run:
>>
>> ./bonnie++ -d /mnt/btrfs -s0 -n 1:256:256:1 -r 0
>>
>> and this causes and endless number of stack traces. Those seem to
>> come from:
>>
>> use_block_rsv()
>>
>> 	ret = block_rsv_use_bytes(block_rsv, blocksize);
>> 	if (!ret)
>> 		return block_rsv;
>> 	if (ret) {
>> 		WARN_ON(1);
>> 		ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,
>>
>>
>> Why is there a WARN_ON(1)? Running the bonnie benchmark is basically impossible
>> that.
>
> This is being worked on, if you really don't like it pull my git tree
> and test it out and see if the errors go away
>
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git

Do you plan to fix it for 3.1? If not, any chance to at least update it 
to WARN_ON_ONCE?


Thanks,
Bernd
