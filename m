Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56351 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2IXJNA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 05:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com>
Date: Mon, 24 Sep 2012 11:13:00 +0200
Message-ID: <CAHf9xvaH6HoapVVqdTAXdFAZsEfvN7-xjoGtj31Lw=fUbY3LXA@mail.gmail.com>
Subject: Re: btrfs send/receive review by vfs folks
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Anand jain <Anand.Jain@oracle.com>
Cc: Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> write_buf:
> Used to write the stream to a user space supplied pipe. Please note
> the ERESTARTSYS comment there, I need some help here as I don't know
> how to handle that correctly. If I ignore the return value, it loops
> forever. If I bail out to user space, it reenters the ioctl and starts
> from the beginning (which is really bad). I have two possible
> solutions in my mind.
> 1. Store some kind of state in the ioctl arguments so that we can
> continue where we stopped when the ioctl reenters. This would however
> complicate the code a lot.
> 2. Spawn a thread when the ioctl is called and leave the ioctl
> immediately. I don't know if ERESTARTSYS can happen in vfs_xxx calls
> if they happen from a non syscall thread.

I am hitting the ERESTARTSYS issue also. To easiest way to repro this
is to stop the user process in gdb.
As Alexander mentioned, restarting the ioctl from the beginning is
really bad, because some commands were already sent to the pipe, and
possibly consumed by the user mode (dump_thread). Also the command, on
which vfs_write() hit ERESTARTSYS, might not have been pushed fully to
the pipe. So if the ioctl() restarts, it starts filling the pipe with
duplicate commands, and at least one command in the pipe might be
corrupted. So the receive part cannot process such stream successfully
(usually it hits crc error).

In addition to what Alexander suggested, I have a third suggestion,
but I would like to know whether community believes this issue is
worth to fix.

Thanks!
Alex.
