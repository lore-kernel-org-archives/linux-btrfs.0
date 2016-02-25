Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37097 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629AbcBYTx7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 14:53:59 -0500
Received: by mail-ig0-f169.google.com with SMTP id z8so21244845ige.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 11:53:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <nank09$nad$1@ger.gmane.org>
References: <nandur$4li$1@ger.gmane.org>
	<56CF3D78.90705@hsr.ch>
	<56CF4301.9090601@bouton.name>
	<nank09$nad$1@ger.gmane.org>
Date: Thu, 25 Feb 2016 12:53:58 -0700
Message-ID: <CAJCQCtRtcSFWAnauhMvLOvVjvuY+wNo1Qf5sd+pM_OdTE6cezw@mail.gmail.com>
Subject: Re: btrfs raid1 filesystem on sdcard corrupted
From: Chris Murphy <lists@colorremedies.com>
To: Hegner Robert <rhegner@hsr.ch>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2016 at 12:18 PM, Hegner Robert <rhegner@hsr.ch> wrote:
>The idea with the btrfs-raid1 came from
> (http://unix.stackexchange.com/a/186954) and it made perfect sense to me to
> use a filesystem which is designed with flash-memory in mind and to use
> raid1 to achieve some redundancy. But it looks like this was wrong
> thinking...

I'd say Lionel is right in that these cards have a lot of reliability
problems, but a big part of that is fake flash. You might test your
cards to see if they are looping on themselves, i.e. lying about how
big they really are and what happens is as they get only partly full
they're really totally full and start overwriting themselves.

If these two systems are essentially identically configured (same size
flash, even if they aren't both raid1 configurations; and were setup
on about the same day or week with the same kinds of workload being
done) then it's plausible they both ran out of real space at the same
time and face plant.

For a GUI app that can test the flash quickly:
https://blogs.gnome.org/hughsie/2015/01/28/detecting-fake-flash/

For CLI app that not as fast (it works differently, not sure if it's
better or not), look for the F3 package.
http://oss.digirati.com.br/f3/

I think if you find good quality flash your idea of using Btrfs raid1
either DUP or separate flash cards for embedded use is OK. I mean,
it's what we have, even if it's not ideal. If it turns out there's
some evidence a lot of flash out there totally face plants when the
write pattern is substantially different than FAT32/64 then that
suggests to me Btrfs needs a new (additional) ssd write allocator that
more closely mimics FAT32 while still of course being COW and all
that. But I suspect you've just got a bad batch of flash - I've got
some PNY, Lexar, Kingston flash here that I use with Btrfs (for years
now some of them) and don't have problems.

And for development depending on Btrfs, I really do think you should
consider a much newer kernel. Fedora 23 (current release) is on kernel
4.4.2 using the normal default stable updates repo. So it's not like
you have to be adding on separate repos or manually installing
packages to get new kernels.


-- 
Chris Murphy
