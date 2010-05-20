From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] btrfs: should add a permission check for setfacl
Date: Thu, 20 May 2010 04:33:40 -0400
Message-ID: <20100520083340.GC11920@infradead.org>
References: <4BF1E458.7060500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, "Yan, Zheng" <zheng.yan@oracle.com>,
	linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BF1E458.7060500@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 18, 2010 at 08:50:32AM +0800, Shi Weihua wrote:
> On btrfs, do the following
> ------------------
> # su user1
> # cd btrfs-part/
> # touch aaa
> # getfacl aaa
>   # file: aaa
>   # owner: user1
>   # group: user1
>   user::rw-
>   group::rw-
>   other::r--
> # su user2
> # cd btrfs-part/
> # setfacl -m u::rwx aaa
> # getfacl aaa
>   # file: aaa
>   # owner: user1
>   # group: user1
>   user::rwx           <- successed to setfacl
>   group::rw-
>   other::r--
> ------------------
> but we should prohibit it that user2 changing user1's acl.
> In fact, on ext3 and other fs, a message occurs:
>   setfacl: aaa: Operation not permitted

Can you add this as a new testcase to xfstests so that we can easiy
check for regressions and future filesystems implementing this
correctly?
