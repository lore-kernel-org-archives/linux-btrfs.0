Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:52909 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab2IXJ1a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 05:27:30 -0400
Message-ID: <50602781.9010009@jan-o-sch.net>
Date: Mon, 24 Sep 2012 11:27:29 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Anand jain <Anand.Jain@oracle.com>,
        Alexander Block <ablock84@googlemail.com>
Subject: Re: btrfs send/receive review by vfs folks
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com> <CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>
In-Reply-To: <CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Mon, September 24, 2012 at 11:13 (+0200), Alex Lyakas wrote:
> Hi,
> 
>> write_buf:
>> Used to write the stream to a user space supplied pipe. Please note
>> the ERESTARTSYS comment there, I need some help here as I don't know
>> how to handle that correctly. If I ignore the return value, it loops
>> forever. If I bail out to user space, it reenters the ioctl and starts
>> from the beginning (which is really bad). I have two possible
>> solutions in my mind.
>> 1. Store some kind of state in the ioctl arguments so that we can
>> continue where we stopped when the ioctl reenters. This would however
>> complicate the code a lot.
>> 2. Spawn a thread when the ioctl is called and leave the ioctl
>> immediately. I don't know if ERESTARTSYS can happen in vfs_xxx calls
>> if they happen from a non syscall thread.
> 
> I am hitting the ERESTARTSYS issue also. To easiest way to repro this
> is to stop the user process in gdb.
> As Alexander mentioned, restarting the ioctl from the beginning is
> really bad, because some commands were already sent to the pipe, and
> possibly consumed by the user mode (dump_thread). Also the command, on
> which vfs_write() hit ERESTARTSYS, might not have been pushed fully to
> the pipe. So if the ioctl() restarts, it starts filling the pipe with
> duplicate commands, and at least one command in the pipe might be
> corrupted. So the receive part cannot process such stream successfully
> (usually it hits crc error).
> 
> In addition to what Alexander suggested, I have a third suggestion,
> but I would like to know whether community believes this issue is
> worth to fix.

It's a must-fix in my opinion. As you mentioned, it's easy to hit. Second, code
like this doesn't look like it should be in mainline at all:

 391                 /* TODO handle that correctly */
 392                 /*if (ret == -ERESTARTSYS) {
 393                         continue;
 394                 }*/

I'm looking forward to your proposal, preferably in form of a patch :-)

-Jan
