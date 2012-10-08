Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:56309 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2JHJ0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 05:26:43 -0400
Message-ID: <50729C4F.4010801@jan-o-sch.net>
Date: Mon, 08 Oct 2012 11:26:39 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Subject: Re: btrfs send/receive review by vfs folks
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>	<CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>	<50602781.9010009@jan-o-sch.net> <CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com>
In-Reply-To: <CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Thu, October 04, 2012 at 17:59 (+0200), Alex Lyakas wrote:
> as I promised, here is some code for you to look at.

And quite a lot of it. I hadn't thought of such a big change when I wrote
"preferably in form of a patch".

As a side note, your patch doesn't follow the general kernel coding style (but
read on before you rework this one).

> First I will describe the approach in general.
>
> # Get rid of the pipe. Instead, user-space passes a buffer and kernel
> fills the specified user-space buffer with commands.
> # When the buffer is full, kernel stops generating commands and
> returns a checkpoint to the user-space.
> # User-space does whatever it wants with the returned buffer, and then
> calls the kernel again, with a buffer and a checkpoint that was
> returned by the kernel from previous SEND ioctl().
> # Kernel re-arms itself to the specified checkpoint, and fills the
> specified buffer with commands, attaches a new checkpoint and so on.
> # Eventually kernel signals to the user that there are no more commands.

We had that in the very beginning of btrfs send. Having only a single ioctl
saves a whole lot of system calls.

> I realize this is a big change, and a new IOCTL has to be introduced
> in order not to break current user-kernel protocol.
> The pros as I see them:
> # One data-copy is avoided (no pipe). For WRITE commands two
> data-copies are avoided (no read_buf needed)

I'm not sure I understand those correctly. If you're talking about the user mode
part, we could simply pass stdout to the kernel, saving the unnecessary pipe and
copy operations in between without introducing a new buffer.

> # ERESTARTSYS issue disappears. If needed, ioctl is restarted, but
> there is no problem with that, it will simply refill the buffer from
> the same checkpoint.

This is the subject of this thread and the thing I'd like to focus on currently.

> Cons:
> # Instead of one ioctl(), many ioctls() are issued to finish the send.
> # Big code change

Two big cons. I'd like to quota Alexander's suggestions again:

On Wed, August 01, 2012 at 14:09 (+0200), Alexander Block wrote:
> I have two possible solutions in my mind.
> 1. Store some kind of state in the ioctl arguments so that we can
> continue where we stopped when the ioctl reenters. This would however
> complicate the code a lot.
> 2. Spawn a thread when the ioctl is called and leave the ioctl
> immediately. I don't know if ERESTARTSYS can happen in vfs_xxx calls
> if they happen from a non syscall thread.

What do you think about those two?

I like the first suggestion. Combining single-ioctl with signal handling
capabilities feels like the right choice. When we get ERESTARTSYS, we know
exactly how many bytes made it to user mode. To reach a comfortable state for a
restart, we can store part of the stream together with the meta information in
our internal state before returning to user mode. The ioctl will be restarted
sooner or later and our internal state tells us where to proceed.

Thanks,
-Jan
