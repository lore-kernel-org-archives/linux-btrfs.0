Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56850 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2JHLil (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 07:38:41 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2868262lbo.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 04:38:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50729C4F.4010801@jan-o-sch.net>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
	<CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>
	<50602781.9010009@jan-o-sch.net>
	<CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com>
	<50729C4F.4010801@jan-o-sch.net>
Date: Mon, 8 Oct 2012 13:38:39 +0200
Message-ID: <CAOcd+r2gbMRTfbUJXFrnzc3L_jf-Hpabsw9McNQ-b-c7toTyCQ@mail.gmail.com>
Subject: Re: btrfs send/receive review by vfs folks
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,
thanks for taking time to look at the code.


On Mon, Oct 8, 2012 at 11:26 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> Hi Alex,
>
> On Thu, October 04, 2012 at 17:59 (+0200), Alex Lyakas wrote:
>> as I promised, here is some code for you to look at.
>
> And quite a lot of it. I hadn't thought of such a big change when I wrote
> "preferably in form of a patch".
>
> As a side note, your patch doesn't follow the general kernel coding style (but
> read on before you rework this one).
>
>> First I will describe the approach in general.
>>
>> # Get rid of the pipe. Instead, user-space passes a buffer and kernel
>> fills the specified user-space buffer with commands.
>> # When the buffer is full, kernel stops generating commands and
>> returns a checkpoint to the user-space.
>> # User-space does whatever it wants with the returned buffer, and then
>> calls the kernel again, with a buffer and a checkpoint that was
>> returned by the kernel from previous SEND ioctl().
>> # Kernel re-arms itself to the specified checkpoint, and fills the
>> specified buffer with commands, attaches a new checkpoint and so on.
>> # Eventually kernel signals to the user that there are no more commands.
>
> We had that in the very beginning of btrfs send. Having only a single ioctl
> saves a whole lot of system calls.
>
>> I realize this is a big change, and a new IOCTL has to be introduced
>> in order not to break current user-kernel protocol.
>> The pros as I see them:
>> # One data-copy is avoided (no pipe). For WRITE commands two
>> data-copies are avoided (no read_buf needed)
>
> I'm not sure I understand those correctly. If you're talking about the user mode
> part, we could simply pass stdout to the kernel, saving the unnecessary pipe and
> copy operations in between without introducing a new buffer.
What I meant is the following:
# For non-WRITE commands the flow is: put the command onto send_buf,
copy to pipe, then user-space copies it out from the pipe. With my
code: put command onto send_buf, then copy to user-space buffer
(copy_to_user). So one data-copy is avoided (2 vs 3).
# For WRITE commands: read data onto read_buf, then copy to send_buf,
then copy to pipe, then user-mode copies to its buffer. With my code:
read onto send_buf, then copy to user-space buffer. So 2 data-copies
are avoided (2 vs 4).
Does it make sense?

>
>> # ERESTARTSYS issue disappears. If needed, ioctl is restarted, but
>> there is no problem with that, it will simply refill the buffer from
>> the same checkpoint.
>
> This is the subject of this thread and the thing I'd like to focus on currently.
>
>> Cons:
>> # Instead of one ioctl(), many ioctls() are issued to finish the send.
>> # Big code change
>
> Two big cons. I'd like to quota Alexander's suggestions again:
>
> On Wed, August 01, 2012 at 14:09 (+0200), Alexander Block wrote:
>> I have two possible solutions in my mind.
>> 1. Store some kind of state in the ioctl arguments so that we can
>> continue where we stopped when the ioctl reenters. This would however
>> complicate the code a lot.
>> 2. Spawn a thread when the ioctl is called and leave the ioctl
>> immediately. I don't know if ERESTARTSYS can happen in vfs_xxx calls
>> if they happen from a non syscall thread.
>
> What do you think about those two?
I am not familiar enough with Linux kernel - will the second one work?

>
> I like the first suggestion. Combining single-ioctl with signal handling
> capabilities feels like the right choice. When we get ERESTARTSYS, we know
> exactly how many bytes made it to user mode. To reach a comfortable state for a
> restart, we can store part of the stream together with the meta information in
> our internal state before returning to user mode.
I thought that ERESTARTSYS never returns to user mode (this is what I
saw in my tests also).

> The ioctl will be restarted sooner or later and our internal state tells us where to proceed.

Ok, so you say that we should maintain checkpoint-like information and
use it if the ioctl is automatically restarted. This is quite close to
what I have done, I believe; we still need all the capabilities of
re-arming tree search, saving context, skipping commands etc, that I
have written. Did I understand your proposal correctly?

But tell me one thing: let's say we call vfs_write() and it returns
-ERESTARTSYS. Can we be sure that it wrote 0 bytes to the pipe in this
call? Otherwise, we don't know how many bytes it wrote, so we cannot
resume it correctly.

Thanks,
Alex.



>
> Thanks,
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
