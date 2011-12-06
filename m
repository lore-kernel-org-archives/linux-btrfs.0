From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Tue, 06 Dec 2011 19:06:40 +0800
Message-ID: <4EDDF740.6060100@cn.fujitsu.com>
References: <4EDDA9B3.60508@cn.fujitsu.com> <20111206095923.GB9138@infradead.org>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	viro <viro@zeniv.linux.org.uk>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111206095923.GB9138@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 6 Dec 2011 04:59:23 -0500, Christoph Hellwig wrote:
> On Tue, Dec 06, 2011 at 01:35:47PM +0800, Miao Xie wrote:
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
>>
>> We fix it by trying to lock >s_umount, if _trylock_ fails, it means the fs
>> is on remounting or umounting. At this time, we will use the sync function of
>> btrfs to sync all the delalloc file. It may waste lots of time, but as a
>> corner case, we needn't care.
> 
> I can't see why you need the writeout when the trylocks fails.  Umount
> needs to take care of writing out all pending file data anyway, so doing
> it from the cleaner thread in addition doesn't sound like it would help.

umount invokes sync_fs() and write out all the dirty file data. For the
other file systems, its OK because the file system does not introduce dirty pages
by itself. But btrfs is different. Its automatic defragment will make lots of dirty
pages after sync_fs() and reserve lots of meta-data space for those pages.
And then the cleaner thread may find there is no enough space to reserve, it must
sync the dirty file data and release the reserved space which is for the dirty
file data.

> 
> So I'd rather suggest to move the trylock into
> writeback_inodes_sb_nr_if_idle, and while you're at it also rewrite
> writeback_inodes_sb_if_idle that ext4 is using to sit on top of
> writeback_inodes_sb_nr_if_idle to share that logic, and drop the
> unused writeback_inodes_sb_nr export.

It is a good way. I will try it.
(Someone is using this way to fix the other deadlock between freeze and writeback)


Thanks
Miao

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

