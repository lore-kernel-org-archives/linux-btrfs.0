Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54699 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaD3IBO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 04:01:14 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id DCA0720901
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 18:01:07 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Reply-To: russell@coker.com.au
Subject: Re: SELinux on btrfs
Date: Wed, 30 Apr 2014 18:01:07 +1000
Message-ID: <3219639.10M590kytU@russell.coker.com.au>
In-Reply-To: <4DB89922-7B01-405A-9E63-0CCBBB6481B3@colorremedies.com>
References: <4DB89922-7B01-405A-9E63-0CCBBB6481B3@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 12 Apr 2014 10:15:25 Chris Murphy wrote:
> >  I'm already aware that SELinux's automatic labelling of files is not
> >  aware of subvolumes[*].> 
> > [*] https://wiki.debian.org/SELinux/Setup#btrfs
> 
> I'm not sure exactly what it means since there is always a subvolume (ID 5),
> and I don't understand why autorelabel behavior would differ from manually
> running fixfiles or restorecon.

When you initially setup SE Linux on Debian you run the command "selinux-
activate" which configures GRUB and creates a 0 byte file named /.autorelabel .

On boot if /.autorelabel is detected (as it will on a first install of SE Linux 
or any time you have a serious labelling problem you want to fix) then a script 
will run that labels all files and reboots the system (to make daemons run with 
the correct context).  The script in question is not aware of subvolumes, so 
if you have writable subvolumes they won't be labelled.  So you just run 
"restorecon -R /subvol" to fix it.

I'm not sure whether fixfiles stops at "mount points" which includes subvols, 
restorecon -R shouldn't.

Note that I gave the full explanation for the lurkers.

> > I already have quite a few read-only snapshots that I don't want to
> > forfeit, however, I'm not at all sure how SELinux would interact with
> > them.
> If the default policy mismatches with the file context, the relabel or
> restorecon will want to change the context to the default, but won't be
> able to because it's a read-only subvolume. I merely get a non-fatal:
> 
> restorecon set context /boot/.bootsnap/grub2->system_u:object_r:boot_t:s0
> failed:'Read-only file system'
> 
> And it proceeds to the next file.

Those read-only files should have the type file_t and be readable by the 
sysadmin.  If you want a read-only filesystem that is correctly labelled you 
can make a read-write snapshot, label it, and then make a read-only snapshot 
of the new snapshot.


As an aside, BTRFS and SE Linux work really well together for me.  Much better 
than ZFS and SE Linux.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

