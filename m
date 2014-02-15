Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50223 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaBOCBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 21:01:41 -0500
From: Russell Coker <russell@coker.com.au>
To: dsterba@suse.cz
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: user creation/deletion of snapshots permissions bug
Date: Sat, 15 Feb 2014 13:01:33 +1100
Message-ID: <2965402.xRhQxFUr69@russell.coker.com.au>
In-Reply-To: <20140214172627.GY16073@twin.jikos.cz>
References: <2524068.SeylZtQnKR@russell.coker.com.au> <20140214172627.GY16073@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Feb 2014 18:26:27 David Sterba wrote:
> On Fri, Feb 07, 2014 at 03:41:09PM +1100, Russell Coker wrote:
> > $ /sbin/btrfs subvol create /tmp/test
> > Create subvolume '/tmp/test'
> > $ /sbin/btrfs subvol delete /tmp/test
> > Delete subvolume '/tmp/test'
> > ERROR: cannot delete '/tmp/test' - Operation not permitted
> > 
> > The above is when running Debian kernel 3.12 based on Linux upstream
> > 3.12.8. I believe that the BTRFS kernel code should do a capabilities
> > check for CAP_SYS_ADMIN (which is used for mount/umount among many other
> > things) before creating a snapshot.  Currently it appears that the only
> > access control is write access to the parent directory.
> 
> This is going to be partially fixed in 3.14 and the patch backported to
> older stable trees
> 
> http://www.spinics.net/lists/linux-btrfs/msg30815.html

Great, thanks for that information.

> the user has to own the snapshot source, or be capable to do so. The
> requirement of admin capabilities to delete a subvolume is still there,
> but I guess it can go away under same checks (ie. owner or capable).
> 
> The admin capability requirement to create a subvolume/snapshot seems
> too restrictive. Although a subvolume is not as lightweight as a
> directory, it allows some convenience to do "reflink" copy of a deep
> directory structure in one go, followed by small changes (eg. git trees).

If you have hostile local users then a script to create a large number of 
subvolumes or snapshots is going to be really annoying as long as there's no 
tool to automatically delete them.  Something conceptually equivalent to rm -
rf but for subvols would be good.

> > There is some possibility of debate about the access control needed for
> > creating a subvol.  I want to use capabilities set by SE Linux policy to
> > prevent unwanted actions by hostile root processes and I think that such
> > use of capabilities (which is used by more than just SE Linux) should be
> > supported.  I don't think that there is any downside to such checks.
> I agree, making this tunable whom to allow to manipulate with subvolumes
> is a good thing. However there's no separate operation regarding
> subvolumes (like mkdir/rmdir), so this needs to add them so SElinux and
> the like can hook into there.

Are you suggesting that we have an option to determine whether a capability is 
needed to create a subvol or that we have a separate hook?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

