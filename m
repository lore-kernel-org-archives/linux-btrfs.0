Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55188 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbbG3JA7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 05:00:59 -0400
From: Russell Coker <russell@coker.com.au>
To: james harvey <jamespharvey20@gmail.com>
Subject: Re: INFO: task btrfs-transacti:204 blocked for more than 120 seconds. (more like 8+min)
Date: Thu, 30 Jul 2015 19:00:54 +1000
Cc: linux-btrfs@vger.kernel.org
References: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
In-Reply-To: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201507301900.54530.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 24 Jul 2015 05:12:38 AM james harvey wrote:
> I started trying to run with a "-s 4G" option, to use 4GB files for
> performance measuring.  It refused to run, and said "file size should
> be double RAM for good results".  I sighed, removed the option, and
> let it run, defaulting to **64GB files**.  So, yeah, big files.  But,
> I do work with Photoshop .PSB files that get that large.

You can use the "-r0" option to stop it insisting on twice the RAM size.  
However if you have files that are less than twice the RAM then the test 
results will be unrealistic as read requests will be mostly satisfied from 
cache.

> During the first two lines ("Writing intelligently..." and
> "Rewriting..." the filesystem seems to be completely locked out for
> anything other than bonnie++.  KDE stops being able to switch focus,
> change tasks.  Can switch to tty's and log in, do things like "ls",
> but attempting to write to the filesystem hangs.  Can switch back to
> KDE, but screen is black with cursor until bonnie++ completes.  top
> didn't show excessive CPU usage.

That sort of problem isn't unique to BTRFS.  BTRFS has had little performance 
optimisation so it might be worse than other filesystems in that regard.  But 
on any filesystem you can expect situations where one process that is doing 
non-stop writes fills up buffers and starves other processes.

Note that when a single disk access takes 8000ms+ (more than 8 seconds) then 
high level operations involving multiple files will take much longer.

> I think the "Writing intelligently" phase is sequential, and the old
> references I saw were regarding many re-writes sporadically in the
> middle.

Intelligent writes is sequential, re-writes is reading and writing 
sequentially.

> What I did see from years ago seemed to be that you'd have to disable
> COW where you knew there would be large files.  I'm really hoping
> there's a way to avoid this type of locking, because I don't think I'd
> be comfortable knowing a non-root user could bomb the system with a
> large file in the wrong area.

Disabling CoW won't solve all issues related to sharing disk IO capacity 
between users.  Also disabling CoW will remove all BTRFS benefits apart from 
subvols, and subvols aren't that useful when snapshots aren't an option.

> IF I do HAVE to disable COW, I know I can do it selectively.  But, if
> I did it everywhere... Which in that situation I would, because I
> can't afford to run into many minute long lockups on a mistake... I
> lose compression, right?  Do I lose snapshots?  (Assume so, but hope
> I'm wrong.)  What else do I lose?  Is there any advantage running
> btrfs without COW anywhere over other filesystems?

I believe that when you disable CoW and make a snapshot there will be one CoW 
stage for each block until it's copied somewhere else.

> How would one even know where the division is between a file small
> enough to allow on btrfs, vs one not to?

http://doc.coker.com.au/projects/memlockd/

If a hostile user wrote a program that used fsync() they could reproduce such 
problems with much smaller files.  My memlockd program alleviates such problems 
by locking the pages of important programs and libraries into RAM.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
