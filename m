Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55807 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752416AbaFYG5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 02:57:02 -0400
Message-ID: <1403679104.8186.9.camel@localhost.localdomain>
Subject: Re: [PATCH 2/3] btrfs-progs: fix max mirror number error for
 chunk-recover
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 25 Jun 2014 14:51:44 +0800
In-Reply-To: <53AA5D46.4080203@redhat.com>
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1402539901-22779-2-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <53AA313C.9010802@redhat.com>
	 <1403662935.31177.3.camel@localhost.localdomain>
	 <53AA5ABF.1030102@redhat.com> <53AA5D46.4080203@redhat.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-06-25 at 00:25 -0500, Eric Sandeen wrote:
> On 6/25/14, 12:14 AM, Eric Sandeen wrote:
> > On 6/24/14, 9:22 PM, Gui Hecheng wrote:
> >> > On Tue, 2014-06-24 at 21:17 -0500, Eric Sandeen wrote:
> >>> >> On 6/11/14, 9:25 PM, Gui Hecheng wrote:
> >>>> >>> When run chunk-recover on a health btrfs(data profile raid0, with
> >>>> >>> plenty of data), the program has a chance to abort on the number
> >>>> >>> of mirrors of an extent.
> >>>> >>>
> >>>> >>> According to the kernel code, the max mirror number of an extent
> >>>> >>> is 3 not 2:
> >>>> >>> 	ctree.h: 		BTRFS_MAX_MIRRORS	3
> >>>> >>> 	chunk-recover.c :	BTRFS_NUM_MIRRORS	2
> >>>> >>> just change BTRFS_NUM_MIRRORS to 3, and everything goes well.
> >>> >>
> >>> >> Wouldn't it make a lot more sense, then, to change the userspace
> >>> >> macro to be called BTRFS_MAX_MIRRORS as well?
> >>> >>
> >>> >> -Eric
> >>> >>
> >> > Yes, Eric, unify the names between userspace and kernelspace is really a
> >> > good point. Also, I plan to move the macro into ctree.h, what do you
> >> > think?
> > It's only used in chunk-recover.c, so I don't see much point to moving it
> > to a new file.
> 
> Sorry, I take that back.  Actually -
> 
> Yes, I think it does make sense, just so that userspace moves slightly closer to
> kernelspace.
> 
> -Eric (who said long ago that he wanted to try to sync things up, but
> found himself daunted by the task, and failed)

Aha，it's really a huge work for one person to do the sync things.
But Rome was not built in one day by one guy. We have a long way to go
and let's take one more step now :)

-Gui

