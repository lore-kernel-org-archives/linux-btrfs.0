Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbaAGD57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 22:57:59 -0500
Message-ID: <52CB7B96.2020701@cn.fujitsu.com>
Date: Tue, 07 Jan 2014 11:59:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/6] Btrfs: use flags instead of the bool variants
 in delayed node
References: <1388034426-4935-1-git-send-email-miaox@cn.fujitsu.com> <1388034426-4935-5-git-send-email-miaox@cn.fujitsu.com> <20140102174955.GO6498@twin.jikos.cz> <52C68297.80707@cn.fujitsu.com> <20140103183610.GU6498@twin.jikos.cz>
In-Reply-To: <20140103183610.GU6498@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 3 Jan 2014 19:36:10 +0100, David Sterba wrote:
> On Fri, Jan 03, 2014 at 05:27:51PM +0800, Miao Xie wrote:
>> On Thu, 2 Jan 2014 18:49:55 +0100, David Sterba wrote:
>>> On Thu, Dec 26, 2013 at 01:07:05PM +0800, Miao Xie wrote:
>>>> +#define BTRFS_DELAYED_NODE_IN_LIST	0
>>>> +#define BTRFS_DELAYED_NODE_INODE_DIRTY	1
>>>> +
>>>>  struct btrfs_delayed_node {
>>>>  	u64 inode_id;
>>>>  	u64 bytes_reserved;
>>>> @@ -65,8 +68,7 @@ struct btrfs_delayed_node {
>>>>  	struct btrfs_inode_item inode_item;
>>>>  	atomic_t refs;
>>>>  	u64 index_cnt;
>>>> -	bool in_list;
>>>> -	bool inode_dirty;
>>>> +	unsigned long flags;
>>>>  	int count;
>>>>  };
>>>
>>> What's the reason to do that? Replacing 2 bools with a bitfield
>>> does not seem justified, not from saving memory, nor from a performance
>>> gain side.  Also some of the bit operations imply the lock instruction
>>> prefix so this affects the surrounding items as well.
>>>
>>> I don't think this is needed, unless you have further plans with the
>>> flags item.
>>
>> Yes, I introduced a flag in the next patch.
> 
> That's still 3 bool flags that are quite independent and consume less
> than the unsigned long anyway. Also the bool flags are something that
> compiler understands and can use during optimizations unlike the
> obfuscated bit access.

I made a mistake at the beginning, I though the size of boolean data type
in the kernel was 4 bytes because I saw it was implemented by the enumeration
type several years ago. But it has been changed for many years. So you are right.

But I read a discuss about the use of boolean type, some developers suggested
us to use bitfields instead of bool, because the bitfields can work better,
and they are more flexible, less misuse than bool.
  https://lkml.org/lkml/2013/9/1/154

Furthermore, we may introduce more flags in the future though I have no plan now.
So this patch makes sense I think.

Thanks
Miao

> I don't mind using bitfields, but it imo starts to make sense to use
> them when there are more than a few, like BTRFS_INODE_* or
> EXTENT_BUFFER_*. The point of my objections is to establish good coding
> patterns to follow.
> 
> david
> 

