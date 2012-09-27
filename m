Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61403 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2I0Tg0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 15:36:26 -0400
Received: by obbuo13 with SMTP id uo13so2160947obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2012 12:36:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50602781.9010009@jan-o-sch.net>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
	<CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>
	<50602781.9010009@jan-o-sch.net>
Date: Thu, 27 Sep 2012 21:36:26 +0200
Message-ID: <CAHf9xvbh1V0ySAd+6QX=heETFUwJBDZPUnShyvHQLU0YkN=N4Q@mail.gmail.com>
Subject: Re: btrfs send/receive review by vfs folks
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,
I hope to get my proposal working soon, then expect for some code from
me to look at.

Thanks!
Alex.


On Mon, Sep 24, 2012 at 11:27 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> Hi Alex,
>
> On Mon, September 24, 2012 at 11:13 (+0200), Alex Lyakas wrote:
>> Hi,
>>
>>> write_buf:
>>> Used to write the stream to a user space supplied pipe. Please note
>>> the ERESTARTSYS comment there, I need some help here as I don't know
>>> how to handle that correctly. If I ignore the return value, it loops
>>> forever. If I bail out to user space, it reenters the ioctl and starts
>>> from the beginning (which is really bad). I have two possible
>>> solutions in my mind.
>>> 1. Store some kind of state in the ioctl arguments so that we can
>>> continue where we stopped when the ioctl reenters. This would however
>>> complicate the code a lot.
>>> 2. Spawn a thread when the ioctl is called and leave the ioctl
>>> immediately. I don't know if ERESTARTSYS can happen in vfs_xxx calls
>>> if they happen from a non syscall thread.
>>
>> I am hitting the ERESTARTSYS issue also. To easiest way to repro this
>> is to stop the user process in gdb.
>> As Alexander mentioned, restarting the ioctl from the beginning is
>> really bad, because some commands were already sent to the pipe, and
>> possibly consumed by the user mode (dump_thread). Also the command, on
>> which vfs_write() hit ERESTARTSYS, might not have been pushed fully to
>> the pipe. So if the ioctl() restarts, it starts filling the pipe with
>> duplicate commands, and at least one command in the pipe might be
>> corrupted. So the receive part cannot process such stream successfully
>> (usually it hits crc error).
>>
>> In addition to what Alexander suggested, I have a third suggestion,
>> but I would like to know whether community believes this issue is
>> worth to fix.
>
> It's a must-fix in my opinion. As you mentioned, it's easy to hit. Second, code
> like this doesn't look like it should be in mainline at all:
>
>  391                 /* TODO handle that correctly */
>  392                 /*if (ret == -ERESTARTSYS) {
>  393                         continue;
>  394                 }*/
>
> I'm looking forward to your proposal, preferably in form of a patch :-)
>
> -Jan
