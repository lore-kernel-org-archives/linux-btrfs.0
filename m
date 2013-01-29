Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41535 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3A2QJ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 11:09:27 -0500
Received: by mail-ob0-f176.google.com with SMTP id v19so581114obq.21
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 08:09:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC6BJd=0HL2mypZ87dWk_iB69BPXYku6HzBu0J_hoCZjxXgGiQ@mail.gmail.com>
References: <CAC6BJd=gbiV+14yk=ghyUozp99Q6QCE6ip_FAp2WoPZTNYNVvw@mail.gmail.com>
 <20130128220308.GI16977@twin.jikos.cz> <20130128232140.GA23893@shiny.globalsuite.net>
 <CAC6BJd=0HL2mypZ87dWk_iB69BPXYku6HzBu0J_hoCZjxXgGiQ@mail.gmail.com>
From: polack christian <baobab874@gmail.com>
Date: Tue, 29 Jan 2013 17:09:07 +0100
Message-ID: <CAC6BJdnMcno1nqyJRu8ktq0a_jRgptAGm0K1fr44TCrMFdKFAQ@mail.gmail.com>
Subject: Fwd: btrfsck and ctree version
To: mailing list linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i know that the proposed ctree.c file is from a kernel source but
btrfsck is user space only, since the btrfs-next is newer than
btrfs-prog i was hoping for a commit of this change for the user-space
version.

since this file-system have been created prior kernel 3.2 there is no
tree root backup

 i was hoping using  btrfsck to regenerate the  csum which are failing
during mount time (Input/output error)

/var/log/messages: btrfs csum failed ino 1048522 off 5124096 csum
1219517398 private 836806197

 i didn't find any way to deactivate csum check  with a mount option

or as chris mention is there a way to regenerate  the cache on the block device.

is there a solution ?

thanks for your responses

olivier


2013/1/29 Chris Mason <chris.mason@fusionio.com>
>
> On Mon, Jan 28, 2013 at 03:03:08PM -0700, David Sterba wrote:
> > On Mon, Jan 28, 2013 at 03:07:13PM +0100, polack christian wrote:
> > > i did use btrfsck to recover it
> > > i got the tool from
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> > >
> > > and i got this error message:
> > > ...
> > > Check tree block failed, want=294555648, have=0
> > > Check tree block failed, want=294559744, have=0
> > > Check tree block failed, want=294559744, have=0
> > > btrfsck: ctree.c:1690: leaf_space_used: Assertion `!(data_len < 0)' failed.
> > > Aborted (core dumped)
> > >
> > > looking at
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> >
> > but this is a kernel source repository, not progs, I wonder
> >
> > > this error in ctree.c have been corrected by this commit
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=commit;h=41be1f3b40b87de33cd2e7463dce88596dbdccc4
> >
> > how this could happen. I have looked at the whether it does not silently
> > fix a bug, nothing wrong I can see now.  How did you verify that the
> > patch fixes the fsck problem?
>
> It sounds much more like the reboot or remount cleared the cache on the
> block device.
>
> -chris
>
