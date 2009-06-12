From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.31-rc
Date: Fri, 12 Jun 2009 14:55:33 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0906121450530.3237@localhost.localdomain>
References: <20090611204456.GA3834@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090611204456.GA3834@think>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 11 Jun 2009, Chris Mason wrote:
> 
> Existing filesystems will be upgraded to the new format on the first
> mount.  All of your old data will still be there and still work
> properly, but I strongly recommend a full backup before going to the new
> code.

Auugh.

This is horrible. I just screwed up my system by booting a kernel on this: 
it worked beatifully, but due to other reasons I then wanted to bisect a 
totally unrelated issue. While having _totally_ forgotten about this 
issue, even if I was technically aware of it.

.. so I installed a new kernel, and now it won't boot due to "couldn't 
mount because of unsupported optional features (1)". In fact, I have no 
kernel available on that system that will boot, since my normal "safe" 
fall-back kernels are all distro kernels that can't boot this either.

Ok, so I'll end up booting from a USB stick, and it will all work out in 
the end, but this does essentially make it entirely impossible to do any 
bisection on any btrfs system.

Double-plus-ungood.

		Linus
