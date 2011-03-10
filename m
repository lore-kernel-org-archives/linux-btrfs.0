From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Thu, 10 Mar 2011 12:07:58 +0900
Message-ID: <20110310120758.ae3e1fd1.kitayama@cl.bb4u.ne.jp>
References: <4D6F2FE0.8020508@cn.fujitsu.com>
	<20110305160122.2d02f86f.kitayama@cl.bb4u.ne.jp>
	<4D7417FB.2020205@jp.fujitsu.com>
	<4D743B6F.2070708@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D743B6F.2070708@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


Thank you both for your help. I agree that we need to reserve 5 items for that operation. 

> > Miao's patch (http://marc.info/?l=linux-btrfs&m=129802068318176&w=2)
> > fixed this problem, maybe.
> 
> Yes, the above patch fixed this problem.
> I think this problem is a bug of btrfs_link(), and hope the fix patch can
> be received as early as possible. So I sent the above patch separately,
> not with the delayed inode items operation patch.
