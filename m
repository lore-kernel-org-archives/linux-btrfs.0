From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V2] btrfs: implement delayed inode items operation
Date: Sat, 5 Mar 2011 11:35:28 +0900
Message-ID: <20110305113528.326f21b6.kitayama@cl.bb4u.ne.jp>
References: <20110224230255.78496fc6.kitayama@cl.bb4u.ne.jp>
	<4D6F3210.3040104@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D6F3210.3040104@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

With the V3 patch applied, I was able to run dbench 50 without a problem.
Thanks,

On Thu, 03 Mar 2011 14:15:44 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> On Thu, 24 Feb 2011 23:02:55 +0900, Itaru Kitayama wrote:
> > I have applied the V2 patch on top of the next-rc branch of btrfs-unstable
> > and ran dbench 50. The run never finished and lots of stall messages recorded
> > in the log.
> > Looking at the stack trace, something wrong with the delayed item balancing?
> > Are you working on the similar problem for V3?
> 
> I have made the third version of this patch, could you test it for me to check
> whether this problem still happens or not?
> 
> Thanks
> Miao
