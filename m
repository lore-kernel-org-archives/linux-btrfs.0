Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f52.google.com ([209.85.216.52]:36217 "EHLO
	mail-vn0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbG3Rvm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 13:51:42 -0400
Received: by vnk197 with SMTP id 197so5640754vnk.3
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2015 10:51:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
References: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
Date: Thu, 30 Jul 2015 11:51:41 -0600
Message-ID: <CAJCQCtRvEU+2vt9vvkUSwPnEyP9ej_mxNOiY4wkWHSYHH1DM9Q@mail.gmail.com>
Subject: Re: INFO: task btrfs-transacti:204 blocked for more than 120 seconds.
 (more like 8+min)
From: Chris Murphy <lists@colorremedies.com>
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 1:12 PM, james harvey <jamespharvey20@gmail.com> wrote:
> Up to date Arch.  linux kernel 4.1.2-2.  Fresh O/S install 12 days
> ago.  No where near full - 34G used on a 4.6T drive.   32GB memory.
>
> Installed bonnie++ 1.97-1.
>
> $ bonnie++ -d bonnie -m btrfs-disk -f -b
>
> I started trying to run with a "-s 4G" option, to use 4GB files for
> performance measuring.  It refused to run, and said "file size should
> be double RAM for good results".  I sighed, removed the option, and
> let it run, defaulting to **64GB files**.  So, yeah, big files.  But,
> I do work with Photoshop .PSB files that get that large.
>
> During the first two lines ("Writing intelligently..." and
> "Rewriting..." the filesystem seems to be completely locked out for
> anything other than bonnie++.  KDE stops being able to switch focus,
> change tasks.  Can switch to tty's and log in, do things like "ls",
> but attempting to write to the filesystem hangs.  Can switch back to
> KDE, but screen is black with cursor until bonnie++ completes.  top
> didn't show excessive CPU usage.
>
> My dmesg is at http://www.pastebin.ca/3072384  Attaching it seemed to
> make the message not go out to the list.

I can't tell what actually instigates this, as there are several blocked tasks.

INFO: task btrfs-cleaner:203 blocked for more than 120 seconds.
 INFO: task btrfs-transacti:204 blocked for more than 120 seconds.

My suggestion, is to file a bug. Include all of the system specs and a
more concise set of reproduce steps from above; but then also include
sysrq-w output. This will dump into kernel messages, it it's too big
it might fill the kernel message buffer. So you can use log_buf_len=1M
boot parameter to increase it or if this is a systemd system, then all
of it is in journalctl -k and you don't need to worry about the buffer
size.

https://www.kernel.org/doc/Documentation/sysrq.txt

So that'd be

# echo 1 >/proc/sys/kernel/sysrq
## reproduce the problem
echo w > /proc/sysrq-trigger

I never know if a developer wants w or t output, but for blocked tasks
I do a w and post that as attachment; and then sometimes also a
separate cut/paste attachment of t output.



> IF I do HAVE to disable COW, I know I can do it selectively.

I don't think you need to worry about this for your use case. You're
talking about big Photoshop files, it's good to COW those because if
there's a crash of the file server while writing out a change, then
the old file is available and not corrupt, since the write didn't
finish. Of course you lost any chances since the last save, but that's
always true. What happens in addition to that with non-COW file
systems that overwrite, and if you set the files to nocow, is that a
crash or hang on overwrite damages the file often irrecoverably. So
here COW is good. And you should test with that too in order to have a
fair test.



-- 
Chris Murphy
