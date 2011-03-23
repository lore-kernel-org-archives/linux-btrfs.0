From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Wed, 23 Mar 2011 22:20:21 +0800
Message-ID: <4D8A01A5.9040905@cn.fujitsu.com>
References: <4D8324DE.4010400@cn.fujitsu.com> <1300666966-sup-3510@think> <4D86DC92.40608@cn.fujitsu.com> <1300709085-sup-9849@think> <4D8953A4.4040008@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8953A4.4040008@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 23 Mar 2011 09:57:56 +0800, Miao Xie wrote:
> On Mon, 21 Mar 2011 08:08:17 -0400, Chris Mason wrote:
>>>> I also think that code is racing with the code that frees delayed nodes,
>>>> but haven't yet triggered my debugging printks to prove either one.
>>>
>>> We free delayed nodes when we want to destroy the inode, at that time, just one task,
>>> which is destroying inode, can access the delayed nodes, so I think ACCESS_ONCE() is
>>> enough. What do you think about?
>>
>> Great, I see what you mean.  The bigger problem right now is that we may do
>> a lot of operations in destroy_inode(), which can block the slab
>> shrinkers on our metadata operations.  That same stress.sh -n 50 run is
>> running into OOM.
>>
>> So we need to rework the part where the final free is done.  We could
>> keep a ref on the inode until the delayed items are complete, or we
>> could let the inode go and make a way to lookup the delayed node when
>> the inode is read.
> 
> I find the slab shrinkers just reclaim inodes which are in the inode_unused
> list, so if we free delayed nodes before moving the inode into the inode_unused
> list, we can avoid blocking the slab shrinker. Thus maybe we can fix the above
> problem by moving btrfs_remove_delayed_node() from btrfs_destroy_inode()
> to btrfs_drop_inode(). How do you think about?

This method is not good, because we may do delayed insertion/deletion and free
the delayed node when we release the inode, but we may access its delayed node
soon.

After reading the lockdep message reported by Kitayama, I guess the reason of the slab
shrinker block may not be that we do a lot of operations in destroy_inode(), maybe the
real reason is that we pass GFP_KERNEL into kzalloc()(in cache_block_group()), which makes
the slab shrinkers hang up. (I don't trigger OOM by running stress.sh till now, so I
can't locate this bug.)

Thanks
Miao

> 
>>
>> I'll read more today.
>>
>> -chris
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

