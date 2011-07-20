From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] stop using highmem for extent_buffers
Date: Wed, 20 Jul 2011 04:00:48 -0400
Message-ID: <1311148758-sup-6034@shiny>
References: <1311096700-sup-8175@shiny> <4E262ED3.1050609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E262ED3.1050609@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2011-07-19 21:26:43 -0400:
> 01:32, Chris Mason wrote:
> > I haven't yet tested this on x86-32, if someone is willing to try this
> > on non-critical test machines I'd appreciate it.
> > 
> 
> Great work!
> 
> I pulled the integration-test branch, and I got this when mounting
> a newly created btrfs:
> 
> [   65.544087] BUG: unable to handle kernel NULL pointer dereference at   (null)
> [   65.544176] IP: [<f98cdc52>] write_extent_buffer+0xad/0xcb [btrfs]
> [   65.544276] *pde = 00000000 
> [   65.544314] Oops: 0002 [#1] SMP 

Ok, so x86-32 isn't working at all ;)  I've got a VM I should be able to
reproduce on.

-chris
