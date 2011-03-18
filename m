From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Fri, 18 Mar 2011 17:59:04 +0900
Message-ID: <20110318175904.4e983b7f.kitayama@cl.bb4u.ne.jp>
References: <20110310000355.f225f0d0.kitayama@cl.bb4u.ne.jp>
	<4D786DF2.7000104@cn.fujitsu.com>
	<20110316184850.f25551a6.kitayama@cl.bb4u.ne.jp>
	<4D82D35F.1060105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D82D35F.1060105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

Your updated V4 patch no longer gives me a hang. Thank you.

In the latest V4, btrfs_remove_delayed_node() does just release
a delayed node and returns for most of the time, but for space
cache inodes, it takes trans_mutex and writes the delayed nodes 
out to the tree. Is my understanding correct?

On Fri, 18 Mar 2011 11:37:03 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> I find the inodes of free space information are updated when committing transaction,
> and it will lead btrfs to hang.
> 
> I have fixed this bug in the attached patch, could you test for me? I have tested it
> on my machine with space_cache mount option, it worked well.
> 
> Thanks
> Miao
