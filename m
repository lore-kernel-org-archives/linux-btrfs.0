From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:6164!
Date: Tue, 07 Jun 2011 11:46:37 -0400
Message-ID: <1307461229-sup-9822@shiny>
References: <4DEC90CB.4050609@jp.fujitsu.com> <4DEDB7AF.2060308@cn.fujitsu.com> <4DEDBE4B.2020403@jp.fujitsu.com> <4DEDC293.30105@jp.fujitsu.com> <4DEDE03B.9050907@jp.fujitsu.com> <4DEDE328.5060405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DEDE328.5060405@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-06-07 04:36:56 -0400:
> On 06/07/2011 04:24 PM, Tsutomu Itoh wrote:
> > (2011/06/07 15:17), Tsutomu Itoh wrote:
> >> (2011/06/07 14:59), Tsutomu Itoh wrote:
> >>> Hi liubo,
> >>>
> >>> (2011/06/07 14:31), liubo wrote:
> >>>> On 06/06/2011 04:33 PM, Tsutomu Itoh wrote:
> >>>>> Hi,
> >>>>>
> >>>>> I encountered following panic using 'btrfs-unstable + for-linus'
> >>>>> kernel.
> >>>>>
> >>>>> I ran "btrfs fi bal /test5" command, and mount option of /test5
> >>>>> is as follows:
> >>>>>
> >>>>>  /dev/sdc3 on /test5 type btrfs (rw,space_cache,compress=lzo,inode_cache)
> >>>>>
> >>>> So, just a "btrfs fi bal" would lead to the bug?
> >>> I think so.

It should be specific to the inode caching code.  The balancing code is
finding the inode map cache extents, but it doesn't know how to relocate
them.

I think we need to switch the inode map cache over to regular extents
that are not preallocated.  It will fix the overflow problem and it will
fix the balancing.

There are a lot of special cases for the free extent cache that don't
apply to the inode map cache, and I think sharing the extent
preallocation is hurting us.

-chris
