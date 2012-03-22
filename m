From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC PATCH 2/2] Btrfs: fix deadlock on umount by umount_prepare
 interface
Date: Thu, 22 Mar 2012 13:25:26 +0800
Message-ID: <4F6AB7C6.4020300@cn.fujitsu.com>
References: <4F6A98CD.5090701@cn.fujitsu.com> <20120322043936.GD3592@dastard>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	viro <viro@zeniv.linux.org.uk>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120322043936.GD3592@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 22 Mar 2012 15:39:36 +1100, Dave Chinner wrote:
> On Thu, Mar 22, 2012 at 11:13:17AM +0800, Miao Xie wrote:
>> The reason the deadlock is that:
>>   Task					Btrfs-cleaner
>>   umount()
>>     down_write(&s->s_umount)
>>     close_ctree()
>>       wait for the end of
>>       btrfs-cleaner
>> 					start_transaction
>> 					  reserve space
>> 					    shrink_delalloc()
>> 					      writeback_inodes_sb_nr_if_idle()
>> 						down_read(&sb->s_umount)
>> So, the deadlock has happened.
> 
> Every time a deadlock involving writeback_inodes_sb...if_idle()
> comes up, I give the same response. If the s_umount is write locked,
> then the sb is not idle. IOWs, writeback_inodes_sb...if_idle()
> should be doing down_read_trylock(), not down_read().

Someone did this work several months ago, but those patches have not been
applied until now, so...

https://lkml.org/lkml/2011/12/8/264

Thanks
Miao
