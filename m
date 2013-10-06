Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49890 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3JFFO0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Oct 2013 01:14:26 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so2547409eae.9
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 22:14:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2eb11$bbed6571$fb7d3108$4fff2a35@cox.net>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com>
	<pan$29f84$2a19071e$4190bce2$1629fe10@cox.net>
	<CAOMFOmWuEhqg4L18h+0BXo-=T7ur2dJF--FU8-=O6-zWAeDXhA@mail.gmail.com>
	<pan$2eb11$bbed6571$fb7d3108$4fff2a35@cox.net>
Date: Sat, 5 Oct 2013 22:14:25 -0700
Message-ID: <CAOMFOmVvhqGHxoqx1rGF-6cokhPLrP21AfwJ29prNhX1FR_cfw@mail.gmail.com>
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On Sat, Oct 5, 2013 at 7:44 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Anatol Pomozov posted on Sat, 05 Oct 2013 04:51:52 -0700 as excerpted:
>
>> Hi
>>
>> On Fri, Oct 4, 2013 at 9:42 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Anatol Pomozov posted on Fri, 04 Oct 2013 21:03:11 -0700 as excerpted:
>>>
>>>> Hi,
>>>>
>>>> I have a home server on Linux Arch (kernel 3.11.2) that uses
>>>> multi-device btrfs on root filesystem.
>>>>
>>>> Until recently it worked completely fine. And yesterday I rebooted it
>>>> and the machine did not wake up.
>>>>
>>>> I booted from a USB (kernel 3.10) and tried to mount the filesystem.
>>>> Here is OOPs I see
>>>
>>>> ------------[ cut here ]------------
>>>> [   68.126138] kernel BUG at fs/btrfs/inode.c:873!
>>>> [   68.126164] invalid opcode: 0000 [#1] PREEMPT SMP
>>>
>>>> The only thing that I did recently is defrag /var/log/journal files
>>>> (journalctl is very slow because of btrfs COW). Something like this
>>>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24878.html
>
> I forgot I was going to mention this in the previous reply...
>
> You can try setting the NOCOW attribute for that file or directory.
> There's instructions on the wiki (btrfs.wiki.kernel.org).  Virtual
> machine images also often work better with NOCOW.
>
> Meanwhile, thinking about systemd journal files there's also another
> patch that is too new to be in the mainline kernel, I think.  That bug
> was found on systemd journal files specifically, because systemd was
> allocating and then writing into them and btrfs wasn't doing the right
> thing with that.  There's a current thread about it.  Since I don't use
> systemd, however, I've not followed it that closely.

It is good to know that btrfs developers aware of the journald
performance issue. It is really annoying for those who uses
btrfs+systemd.

>
>>> I'm not a dev just a btrfs user and list regular myself, so the traces
>>> don't mean much to me.  However, the bit I retained in the quote above
>>> (especially the 0000 opcode) looks very much like a bug that should be
>>> fixed in kernel 3.12
>
>>> So the first thing I'd try is either cherrypicking the btrfs patches
>>> from 3.12 back to 3.11-stable, or wait for 3.11.5 and check for btrfs
>>> patches there, or try 3.12-rcX (rc3 is out and I guess rc4 should be
>>> out shortly now as I think it has been nearly a week).
>>
>> Could you please give me the patch SHA1 you are talking about?
>
> Sorry, I've not tracked it /that/ closely, as I'm not a dev so the real
> technical stuff is over my head, and I run rc kernels from about rc2
> anyway, so I have the fixes reasonably fast already.  I simply try to
> keep up with the general gist of things well enough to search the list
> for that thread I remembered if I need to, and you should be able to do
> that as well as I, now that you know the threads and patches are there.

Ok, so I still need a fix/workaround for the crash I have.

I booted from USB and ran btrfs-zero-log then mounted the filesystems
with "-orecovery". The files on the FS look fine. When I try to
unmount the fs it hangs in btrfs-transacti (see stacktrace above).
When I mount the FS as read-only it unmounts fine.

Actually I remembered that I set "chattr +C" on /var/log/journal
recursively (even for non-empty files) about a week ago, it might be
related to the crash. When I mount "-orw" and try to remove
/var/log/journal system hangs in btrfs-transacti thread.
