From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Tue, 06 Dec 2011 14:52:31 +0800
Message-ID: <4EDDBBAF.9000305@cn.fujitsu.com>
References: <4EDDA9B3.60508@cn.fujitsu.com> <20111206054906.GG2203@ZenIV.linux.org.uk>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111206054906.GG2203@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 6 Dec 2011 05:49:06 +0000, Al Viro wrote:
> 
>> +void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
>> +				  unsigned long nr_pages)
>> +{
>> +	struct super_block *sb = root->fs_info->sb;
>> +
>> +	if (writeback_in_progress(sb->s_bdi))
>> +		return;
>> +
>> +	/*
>> +	 * If we can not get s_umount, it means the fs is on remounting or
>> +	 * umounting. At this time, we just sync all the delalloc file.
>> +	 */
>> +	if (down_read_trylock(&sb->s_umount)) {
>> +		writeback_inodes_sb_nr(sb, nr_pages);
>> +		up_read(&sb->s_umount);
>> +	} else {
>> +		btrfs_start_delalloc_inodes(root, 0);
>> +		btrfs_wait_ordered_extents(root, 0, 0);
>> +	}
>> +}
> 
> If that can race with umount, what prevents sb, its ->s_bdi et.al. being freed
> under you?

In fact, it happened. See the following mail.

   http://marc.info/?l=linux-btrfs&m=131495252725296&w=2

The above function is called when some one want to modify the meta-data.
Btrfs will wait until all the meta-data operations end, and then free ->s_bdi
and the other objects. So we needn't worry about those objects.
(Maybe I misunderstood what you said. If yes, I'm sorry)

Thanks
Miao

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

