From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Fri, 18 Mar 2011 17:18:13 +0800
Message-ID: <4D832355.70200@cn.fujitsu.com>
References: <20110310000355.f225f0d0.kitayama@cl.bb4u.ne.jp>	<4D786DF2.7000104@cn.fujitsu.com>	<20110316184850.f25551a6.kitayama@cl.bb4u.ne.jp>	<4D82D35F.1060105@cn.fujitsu.com> <20110318175904.4e983b7f.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110318175904.4e983b7f.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 18 Mar 2011 17:59:04 +0900, Itaru Kitayama wrote:
> Hi Miao,
> 
> Your updated V4 patch no longer gives me a hang. Thank you.
> 
> In the latest V4, btrfs_remove_delayed_node() does just release
> a delayed node and returns for most of the time, but for space

Right.

> cache inodes, it takes trans_mutex and writes the delayed nodes 
> out to the tree. Is my understanding correct?

for space cache inodes, we just update them in time, don't delayed to
update them.

Thanks
Miao

> 
> On Fri, 18 Mar 2011 11:37:03 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> I find the inodes of free space information are updated when committing transaction,
>> and it will lead btrfs to hang.
>>
>> I have fixed this bug in the attached patch, could you test for me? I have tested it
>> on my machine with space_cache mount option, it worked well.
>>
>> Thanks
>> Miao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

