Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:37386 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab2JJU2Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 16:28:16 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so701194lag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2012 13:28:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5072D72F.5000907@jan-o-sch.net>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
	<CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>
	<50602781.9010009@jan-o-sch.net>
	<CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com>
	<50729C4F.4010801@jan-o-sch.net>
	<CAOcd+r2gbMRTfbUJXFrnzc3L_jf-Hpabsw9McNQ-b-c7toTyCQ@mail.gmail.com>
	<5072D72F.5000907@jan-o-sch.net>
Date: Wed, 10 Oct 2012 22:28:14 +0200
Message-ID: <CAOcd+r0aECuOrrpnR0xBd670C91Rq65mPhEZjUAcm1V-SRT9WA@mail.gmail.com>
Subject: Re: btrfs send/receive review by vfs folks
From: Alex Lyakas <alex@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

On Mon, Oct 8, 2012 at 3:37 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> On Mon, October 08, 2012 at 13:38 (+0200), Alex Lyakas wrote:
>>>> I realize this is a big change, and a new IOCTL has to be introduced
>>>> in order not to break current user-kernel protocol.
>>>> The pros as I see them:
>>>> # One data-copy is avoided (no pipe). For WRITE commands two
>>>> data-copies are avoided (no read_buf needed)
>>>
>>> I'm not sure I understand those correctly. If you're talking about the user mode
>>> part, we could simply pass stdout to the kernel, saving the unnecessary pipe and
>>> copy operations in between without introducing a new buffer.
>> What I meant is the following:
>> # For non-WRITE commands the flow is: put the command onto send_buf,
>> copy to pipe, then user-space copies it out from the pipe. With my
>> code: put command onto send_buf, then copy to user-space buffer
>> (copy_to_user). So one data-copy is avoided (2 vs 3).
>> # For WRITE commands: read data onto read_buf, then copy to send_buf,
>> then copy to pipe, then user-mode copies to its buffer. With my code:
>> read onto send_buf, then copy to user-space buffer. So 2 data-copies
>> are avoided (2 vs 4).
>> Does it make sense?
>
> I'd rather just focus on the ERESTARTSYS issue for now.
Agree.

>
>>> On Wed, August 01, 2012 at 14:09 (+0200), Alexander Block wrote:
>>>> I have two possible solutions in my mind.
>>>> 1. Store some kind of state in the ioctl arguments so that we can
>>>> continue where we stopped when the ioctl reenters. This would however
>>>> complicate the code a lot.
>>>> 2. Spawn a thread when the ioctl is called and leave the ioctl
>>>> immediately. I don't know if ERESTARTSYS can happen in vfs_xxx calls
>>>> if they happen from a non syscall thread.
>>>
>>> What do you think about those two?
>> I am not familiar enough with Linux kernel - will the second one work?
>
> I not an expert here, either. My uneducated guess is that even a spawned kernel
> thread can have signals pending, in which case we would be in the same trouble.
>
>>> I like the first suggestion. Combining single-ioctl with signal handling
>>> capabilities feels like the right choice. When we get ERESTARTSYS, we know
>>> exactly how many bytes made it to user mode. To reach a comfortable state for a
>>> restart, we can store part of the stream together with the meta information in
>>> our internal state before returning to user mode.
>> I thought that ERESTARTSYS never returns to user mode (this is what I
>> saw in my tests also).
>
> That error isn't returned to a user process, that's correct. From a kernel
> developer's perspective, we're returning to user space, though, waiting for the
> pending signal to be processed.
>
>>> The ioctl will be restarted sooner or later and our internal state tells us where to proceed.
>>
>> Ok, so you say that we should maintain checkpoint-like information and
>> use it if the ioctl is automatically restarted. This is quite close to
>> what I have done, I believe; we still need all the capabilities of
>> re-arming tree search, saving context, skipping commands etc, that I
>> have written. Did I understand your proposal correctly?
>
> In some way, yes. If possible, I'd like to (with decreasing priority)
> - stick with the stream format
> - maintain ioctl-compatibility
> - have a much smaller patch
> - store less state
> - stick with the pipe
>
> I haven't had time to completely understand your checkpoint concept, and
> one-big-chunk patches are hard to read. But the size of the added data
> structures scares me. Shouldn't we be able to do this with as little information
> as a single btrfs key and a buffer of generated but not yet pushed stream data?
> This would also save us skipping commands or output bytes.

# In case we are doing diff-send, we need to restore the state of
btrfs_compare_trees() call; we need to restore both left and right
tree positions. So we need two keys (this is what my struct
btrfs_compare_trees_checkpoint has).
# After compare trees state is restored, it will call changed_cb(), at
which point we need to restore our full state. So what I did, I saved
the fixed-size part of send_ctx (like cur_ino, cur_inode_gen etc.).
Perhaps some of this can be figured out on the first changed_cb call,
though, but I went the easy way to store everything. Since the
variable-size context (new_refs,deleted_refs) is cumbersome to store,
we cannot save our state between any two commands. That's why I needed
to save info on how many commands to skip and how many bytes to skip
inside a WRITE command.
At this point I don't see a straightforward way to store less than
that, but I can try to go deeper and see if I can.

So now the question is where to store that. Can we be sure that if we
return -ERESTARTSYS, we will be restarted in the same syscall? If yes,
then we can alloc and store a pointer in one of the reserved fields of
struct btrfs_ioctl_send_args. If not, then this memory might not be
freed. Otherwise, we need to embed this info in struct
btrfs_ioctl_send_args, which breaks the current protocol.

I see code like this in arch/x86/kernel/signal.c:
case -ERESTARTSYS:
     if (!(ka->sa.sa_flags & SA_RESTART)) {
              regs->ax = -EINTR;
              break;
}
And also: " If you use sigaction to establish a signal handler, you
can specify how that handler should behave. If you specify the
SA_RESTART flag, return from that handler will resume a primitive;
otherwise, return from that handler will cause EINTR."

So it looks like the user can disable the restarting and rather handle EINTR.

>
>> But tell me one thing: let's say we call vfs_write() and it returns
>> -ERESTARTSYS. Can we be sure that it wrote 0 bytes to the pipe in this
>> call?
>
> From the version of fs/pipe.c in my working directory: yes. If we rely on this,
> we'd better check if this is something to rely on, but I hope it is.
(I see that is calls pipe_iov_copy_from_user() before checking for
pending signals, actually, but maybe I am missing something)

So what we can do:
- stick with the stream format: YES
- maintain ioctl-compatibility: Probably no, since the user can
disable restarting.
- have a much smaller patch:  should be smaller, only the checkpoint
part goes in, not the buffer part
- store less state: not really
- stick with the pipe: YES

Thanks,
Alex.
