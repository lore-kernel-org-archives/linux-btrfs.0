From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] vfs: make writeback_in_progress() inline
Date: Tue, 6 Dec 2011 04:55:02 -0500
Message-ID: <20111206095502.GA9138@infradead.org>
References: <4EDDA9B1.5050000@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Ito <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EDDA9B1.5050000@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2011 at 01:35:45PM +0800, Miao Xie wrote:
> writeback_in_progress() is very simple, and we will use writeback_in_progress()
> in the module, so make it inline.

Modules don't really have a business looking at this information.  I'd
prefer to keep it static in fs-writeback.c.

