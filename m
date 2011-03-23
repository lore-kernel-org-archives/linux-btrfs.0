From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Wed, 23 Mar 2011 13:19:18 +0900
Message-ID: <20110323131918.0feda83a.kitayama@cl.bb4u.ne.jp>
References: <4D8324DE.4010400@cn.fujitsu.com>
	<20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>
	<4D8813A5.1040604@cn.fujitsu.com>
	<20110322125051.222ccc5b.kitayama@cl.bb4u.ne.jp>
	<4D8873EC.1040702@cn.fujitsu.com>
	<20110322223324.ff6ee42a.kitayama@cl.bb4u.ne.jp>
	<4D894C91.5040302@cn.fujitsu.com>
	<20110323122409.6bc79eaf.kitayama@cl.bb4u.ne.jp>
	<4D897066.7090409@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D897066.7090409@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 Mar 2011 12:00:38 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> I is testing the new version, in which I fixed the slab shrinker problem reported by
> Chris. In the new version, the delayed node is removed before the relative inode is
> moved into the unused_inode list(the slab shrinker will reclaim inodes in this list).
> Maybe this method can also fix this bug. So could you tell me the reproduce step
> or the options of mkfs and mount? I will check if the new patch can fix this bug or not.

I used the default mkfs options for $TEST_DEV and enabled the space_cache and the
compress=lzo options upon mounting the partition.

itaru
