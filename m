Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933257AbdAIPbl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jan 2017 10:31:41 -0500
Subject: Re: [RFC] Converging userspace and kernel code
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        David Sterba <dsterba@suse.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4d1d233a-1002-169e-ec9b-14df3b1af86c@redhat.com>
Date: Mon, 9 Jan 2017 09:31:39 -0600
MIME-Version: 1.0
In-Reply-To: <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/8/17 8:11 PM, Qu Wenruo wrote:
> 
> 
> At 01/08/2017 09:16 PM, Goldwyn Rodrigues wrote:
>>
>> 1. Motivation
>> While fixing user space tools for btrfs-progs, I found a couple of bugs
>> which are already solved in kernel space but were not ported to user
>> space. User space is a little ignored when it comes to fixing bugs in
>> the core functionality. XFS developers have already performed this and
>> the userspace and kernel code walks in lockstep for libxfs.
> 
> Personally speaking, I'm not a fan of re-using kernel code in btrfs-progs.

But it already does re-use kernel code, it's just that the re-use is
extremely stale, with unfixed bugs in both directions as a result
(at least last time I looked.)

> In fact, in btrfs-progs, we don't need a lot of kernel facilities,
> like page/VFS/lock(btrfs-progs works in single thread under most
> case).
> 
> And that should make btrfs-progs easier to maintain.

But as Goldwyn already pointed out, many bugs have gone un-fixed
in userspace, in code which was forked long ago from kernelspace.

For things like locking it's trivial to define that away.

xfsprogs does i.e. -

/* miscellaneous kernel routines not in user space */
#define down_read(a)            ((void) 0)
#define up_read(a)              ((void) 0)
#define spin_lock_init(a)       ((void) 0)
#define spin_lock(a)            ((void) 0)
#define spin_unlock(a)          ((void) 0)
#define likely(x)               (x)
#define unlikely(x)             (x)
#define rcu_read_lock()         ((void) 0)
#define rcu_read_unlock()       ((void) 0)
#define WARN_ON_ONCE(expr)      ((void) 0)


> Furthermore, there are cases while kernel is doing things wrong while
> btrfs-progs does it right.

All the more reason to sync it up, fixes should always be in both
places, right?

I had looked at this a few years ago, and started trying to sync things
up, but got daunted and busy and never completed anything.  :(  I sent
a few fixups back in April 2013 to get things /slightly/ closer.

The libxfs sync in xfs has borne fruit; I'm of the opinion that similar
work would help btrfs too, though it can be a long road.

(e2fsprogs has gone the other way, and has a completely separate
re-implementation in userspace; it works, I guess, but I have to say
that I really like the code commonality in xfs.)

Thanks,
-Eric

