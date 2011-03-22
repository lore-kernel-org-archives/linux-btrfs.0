From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Tue, 22 Mar 2011 12:50:51 +0900
Message-ID: <20110322125051.222ccc5b.kitayama@cl.bb4u.ne.jp>
References: <4D8324DE.4010400@cn.fujitsu.com>
	<20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>
	<4D8813A5.1040604@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8813A5.1040604@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Mar 2011 11:12:37 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> We can't fix it by this way, because the work threads may do insertion or deletion at the same time,
> and we may lose some directory items.

Ok.
 
> Maybe we can fix it by adding a reference for the delayed directory items, we can do read dir just
> like this:
> 1. hold the node lock
> 2. increase the directory items' reference and put all the directory items into a list
> 3. release the node lock
> 4. read dir
> 5. decrease the directory items' reference and free them if the reference is zero.
> What do you think about?

Sounds doable to me.

itaru
