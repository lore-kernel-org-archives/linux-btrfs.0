Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:58142 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbJKM3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 08:29:31 -0400
From: covici@ccs.covici.com
To: Duncan <1i5t5.duncan@cox.net>
cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs says no errors, but booting gives lots of errors
In-reply-to: <pan$d2df6$3d7eab24$5c921ac6$dfe0f628@cox.net>
References: <8042.1444481164@ccs.covici.com> <56191CC2.9000505@googlemail.com> <11640.1444488108@ccs.covici.com> <561932EF.2090005@bouton.name> <5619385C.7040103@googlemail.com> <16953.1444496102@ccs.covici.com> <56198B7B.90806@bouton.name> <27402.1444518173@ccs.covici.com> <27611.1444518496@ccs.covici.com> <pan$d2df6$3d7eab24$5c921ac6$dfe0f628@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Date: Sun, 11 Oct 2015 08:29:27 -0400
Message-ID: <7505.1444566567@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> wrote:

> covici posted on Sat, 10 Oct 2015 19:08:16 -0400 as excerpted:
> 
> > covici@ccs.covici.com wrote:
> > 
> >> Lionel Bouton <lionel+ceph@bouton.name> wrote:
> >> 
> >> > Le 10/10/2015 18:55, covici@ccs.covici.com a écrit :
> >> > > [...]
> >> > > But do you folks have any idea about my original question, this
> >> > > leads me to think that btrfs is too new or something.
> >> > 
> >> > I've seen a recent report of a problem with btrfs-progs 4.2 confirmed
> >> > as a bug in mkfs. As you created the filesystem with it, it could be
> >> > the problem.
> > 
> > I do have 4.2.2, I could go to, would that be better?
> 
> btrfs-progs-4.2.2 does indeed have the mkfs.btrfs fixes for the bug in 
> question.  You should be fine remaking the filesystem with it.
> 
> If you created the filesystem with the buggy mkfs.btrfs, AFAIK, current 
> 4.2.2 btrfs check can detect the error, but can't fix it.  Blowing away 
> the filesystem and recreating is the only known fix at this time, and 
> filesystems created with the buggy version are not safe and could blow up 
> at any time, so it's best to be rid of them and onto something more 
> stable as soon as possible.
> 
> I can't help with the subvolumes bit, however, because while I'm on 
> gentoo/~amd64 here too, also with systemd...
> 
> I don't use subvolumes, as to me it's simply putting too many eggs in one 
> filesystem basket.  Instead, I prefer multiple separate btrfs 
> filesystems, each on their own partitions.  My / includes most of what 
> packages install, including /usr and /var but not /var/log.  It's 8 GiB 
> in size, under half used.  /home is separate, the repos tree (gentoo and 
> overlays) along with ccache, binpackages, the kernel tree, etc, are 
> together on a separate partition, /var/log is separate (and tiny, half a 
> GiB), etc.  I keep / mounted read-only by default, so have the parts of /
> var/lib that must be runtime-writable symlinked to subdirs of /home/var, 
> with /home of course mounted writable, but other than that and some /var/
> log/ subdirs, anything that's installed by a package is on /, a lesson I 
> learned the hard way when I had to recover from backups where /, /usr 
> and /var were from backups taken on different dates and thus not 
> synchronized with what portage /thought/ was installed based on /var/db/
> pkg.
> 
> Not saying that's best for you, but it's a solution that I've found works 
> very well for me, and the relative small 8 GiB size of / makes it easy to 
> have backup copies of it that I can boot, should my working / take a 
> dump.  But if it's all on the same filesystem, as it is with subvolumes, 
> and that filesystem takes a dump... it's all gone at once!  That's not 
> something I want to happen, so I vastly prefer the independent 
> filesystems, but with everything (but the limited exceptions mentioned 
> above) the package manager deals with on the same one, so it all stays 
> synced and is backed up as a single unit, which after all remains 
> reasonably small, 8 GiB, less than half used.

Thanks, in the ext4 world, I have lvm and lots of things using separate
lvm's.  I don't want to go back to partitions, if btrfs is that fragile,
maybe I should waita while yet.  Or, I could use lvm and put btrfs on
top of that, but it seems strange to me.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
