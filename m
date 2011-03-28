From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: add initial tracepoint support for btrfs
Date: Sun, 27 Mar 2011 20:59:41 -0400
Message-ID: <1301273942-sup-2832@think>
References: <4D8B28A3.7050105@cn.fujitsu.com> <1301141505-sup-3679@think>
Content-Type: text/plain; charset=UTF-8
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1301141505-sup-3679@think>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-03-26 08:12:04 -0400:
> Excerpts from liubo's message of 2011-03-24 07:18:59 -0400:
> > 
> > Tracepoints can provide insight into why btrfs hits bugs and be greatly
> > helpful for debugging, e.g
> 
> This is really neat, I've queued it up.

Whoops, it has a lot of warnings when compiled on 32 bit machines.
Please take a look:

include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:68:1: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144:1: warning: large integer implicitly truncated to unsigned type

-chris
