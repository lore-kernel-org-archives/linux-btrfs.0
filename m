From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Thu, 24 Mar 2011 12:38:53 +0900
Message-ID: <20110324123853.a2d4e1c4.kitayama@cl.bb4u.ne.jp>
References: <4D8324DE.4010400@cn.fujitsu.com>
	<20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>
	<4D8813A5.1040604@cn.fujitsu.com>
	<20110322125051.222ccc5b.kitayama@cl.bb4u.ne.jp>
	<4D8873EC.1040702@cn.fujitsu.com>
	<20110322223324.ff6ee42a.kitayama@cl.bb4u.ne.jp>
	<4D894C91.5040302@cn.fujitsu.com>
	<20110323122409.6bc79eaf.kitayama@cl.bb4u.ne.jp>
	<4D897066.7090409@cn.fujitsu.com>
	<20110323131918.0feda83a.kitayama@cl.bb4u.ne.jp>
	<4D89C195.6020200@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89C195.6020200@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 Mar 2011 17:47:01 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> we found GFP_KERNEL was passed into kzalloc(), I think this flag trigger the above lockdep
> warning. the attached patch, which against the delayed items operation patch, may fix this
> problem, Could you test it for me?

The possible irq lock inversion dependency warning seems to go away.   

itaru   
