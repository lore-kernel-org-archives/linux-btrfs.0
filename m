From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.31-rc
Date: Fri, 12 Jun 2009 20:18:02 -0400
Message-ID: <20090613001802.GM4808@think>
References: <20090611204456.GA3834@think> <alpine.LFD.2.01.0906121450530.3237@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0906121450530.3237@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 12, 2009 at 02:55:33PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Jun 2009, Chris Mason wrote:
> > 
> > Existing filesystems will be upgraded to the new format on the first
> > mount.  All of your old data will still be there and still work
> > properly, but I strongly recommend a full backup before going to the new
> > code.
> 
> Auugh.
> 
> This is horrible. I just screwed up my system by booting a kernel on this: 
> it worked beatifully, but due to other reasons I then wanted to bisect a 
> totally unrelated issue. While having _totally_ forgotten about this 
> issue, even if I was technically aware of it.
> 
> .. so I installed a new kernel, and now it won't boot due to "couldn't 
> mount because of unsupported optional features (1)". In fact, I have no 
> kernel available on that system that will boot, since my normal "safe" 
> fall-back kernels are all distro kernels that can't boot this either.
> 
> Ok, so I'll end up booting from a USB stick, and it will all work out in 
> the end, but this does essentially make it entirely impossible to do any 
> bisection on any btrfs system.

First off, I'm sorry.  I definitely knew this was going to happen to
some of the btrfs users.  I wanted to get it in as close as possible to
2.6.30 so that it would be close to the good end of the git bisecting.

My choices were:

1) No backward compatibility at all
2) Forward rolling (what we did)
3) Maintain the code to write the old and new formats the way Ted
suggests.

A number of people argued for #1.  The problem with #3 is that it
explodes our testing matrix even more, and this is already the most
complex part of the FS.  For the stage Btrfs is at, I think #2 was the
best option.

Our future format features will be what Ted is describing, explicitly
enabled and much more fined grained.

I'll try to find some livecd images for usb sticks that support Btrfs,
and make links on the btrfs homepage.

-chris

