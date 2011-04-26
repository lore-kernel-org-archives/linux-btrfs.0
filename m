From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V6 3/3] btrfs: delay to insert the initial inode
Date: Tue, 26 Apr 2011 13:38:52 +0800
Message-ID: <4DB65A6C.9020402@cn.fujitsu.com>
References: <4DB15488.50005@cn.fujitsu.com> <1303764553-sup-8007@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303764553-sup-8007@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 25 Apr 2011 16:50:43 -0400, Chris Mason wrote:
> Excerpts from Miao Xie's message of 2011-04-22 06:12:24 -0400:
>> Since we have implemented the delayed update of the inode, we can also
>> delayed to insert the initial inode, then we can merge the inode update
>> and the initial inode insertions to one insertion.
> 
> Awesome.  With things separate from the inode this should solve our oom
> problems.  We might need to register a shrinker for the delayed inode
> operations too, but that shouldn't be a problem.

I think this shrinker may block the task which is reclaiming the memory, because
the shrinker need some free memory to do extent buffer cow when it does delayed item
insertion/deletion. So...

But don't worry about it, those delayed nodes will be freed after the transaction
is committed.

Thanks
Miao

> 
> -chris
> 

