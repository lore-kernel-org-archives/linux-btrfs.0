Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbbJFTmE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Oct 2015 15:42:04 -0400
Date: Tue, 6 Oct 2015 12:42:02 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com,
        david@fromorbit.com
Subject: Re: [RFC][PATCH] btrfs: add ioctl to monitor subvolume dropping
Message-ID: <20151006194202.GD1044@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20151001213047.GB1044@wotan.suse.de>
 <20151006082552.GA7734@twin.jikos.cz>
 <20151006170926.GC1044@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151006170926.GC1044@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 06, 2015 at 10:09:26AM -0700, Mark Fasheh wrote:
> On Tue, Oct 06, 2015 at 10:25:52AM +0200, David Sterba wrote:
> > On Thu, Oct 01, 2015 at 02:30:47PM -0700, Mark Fasheh wrote:
> > > At the moment, userspace has no way of knowing when a snapshot is finally
> > > removed. This has become a problem when writing tests for btrfs,
> > > 
> > > http://article.gmane.org/gmane.comp.file-systems.fstests/1239/
> > 
> > In the meantime the command 'btrfs subvolume sync /path id' has been
> > implemented which does what you need, without the new ioctl.
> 
> Ahh ok I didn't see that I'll take a look, thanks.

Hmm this isn't working for me, am I doing anything wrong? 

mkfs.btrfs -f  /dev/vdb1 
mount -t btrfs /dev/vdb1 /btrfs/
cd /btrfs/
btrfs quota enable /btrfs
btrfs su create sub1
cp -a /boot/* sub1/
btrfs su create sub2
cp -a /boot/* sub2
btrfs su de sub1 -c
btrfs su sy /btrfs/
cd /
umount /btrfs 
btrfsck --qgroup-report /dev/vdb1

The output of btrfsck (and btrfs-debug-tree) will show the subvolume still
existing on disk. I tried '-c' and '-C' with the 'btrfs su de' command and
neither made a difference.

This is on btrfs-progs v4.2.2+20151005.

Thanks,
	--Mark

--
Mark Fasheh
