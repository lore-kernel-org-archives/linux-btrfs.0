From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2] btrfs: implement delayed inode items operation
Date: Fri, 18 Feb 2011 17:08:12 +0800
Message-ID: <4D5E36FC.2050401@cn.fujitsu.com>
References: <4D5CB6B8.2060804@cn.fujitsu.com> <1297991261-sup-6831@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Ito <t-itoh@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297991261-sup-6831@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris
CC Tsutomu Itoh

On Thu, 17 Feb 2011 20:09:00 -0500, Chris Mason wrote:
> Excerpts from Miao Xie's message of 2011-02-17 00:48:40 -0500:
>> Compare with Ext3/4, the performance of file creation and deletion on btrfs
>> is very poor. the reason is that btrfs must do a lot of b+ tree insertions,
>> such as inode item, directory name item, directory name index and so on.
>>
>> If we can do some delayed b+ tree insertion or deletion, we can improve the
>> performance, so we made this patch which implemented delayed directory name
>> index insertion/deletion and delayed inode update.
>
> This work is really cool, thanks for doing it.  I'm starting a run on
> this tonight and if all goes well I'll review in detail and try to queue
> it along with the per-subvolume storage bits for .39.

There is a hang-up problem in this patch, that is the task which does delayed item
balance and the task which commits the transaction will wait for each other, and
the filesystem will hang up. This is reported by Tsutomu Itoh.

I have made the third version of this patch, will post it later.

Thanks!
Miao

>
> Thanks!
>
> -chris
>

