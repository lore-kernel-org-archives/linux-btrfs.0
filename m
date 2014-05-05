Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43404 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaEEG6S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 02:58:18 -0400
Date: Sun, 4 May 2014 23:50:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does Suse do live filesystem revert with btrfs?
Message-ID: <20140505065057.GN10159@merlins.org>
References: <20140504005257.GF9061@merlins.org>
 <20140504232645.GQ9061@merlins.org>
 <D087B454-AEEA-4555-8679-11A46B963975@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D087B454-AEEA-4555-8679-11A46B963975@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 04, 2014 at 09:23:12PM -0600, Chris Murphy wrote:
> 
> On May 4, 2014, at 5:26 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > Actually, never mind Suse, does someone know whether you can revert to
> > an older snapshot in place?
> 
> They are using snapper. Updates are not atomic, that is they
> are applied to the currently mounted fs, not the snapshot, and
> after update the system is rebooted using the same (now updated)
> subvolumes. The rollback I think creates another snapshot and an
> earlier snapshot is moved into place because they are using the top
> level (subvolume id 5) for rootfs.

Ok. If they are rebooting, then it's easy, I know how to do this myself
:)
 
> Production baremetal systems need well tested and safe update
> strategies that avoid update related problems, so that rollbacks
> aren't even necessary. Or such systems can tolerate rebooting.

I wasn't worried about rollbacks as much as doing a btrfs send to a new
snapshot and then atomically switching to it without rebooting.
I work at google where we do file level OS upgrades (not on btrfs since
this was designed over 10 years ago), and I was kind of curious how I
could re-implement that with btrfs send/receive.
While this is off topic here, if you're curious about our update system:
http://marc.merlins.org/linux/talks/ProdNG-LISA/html/
or
http://marc.merlins.org/linux/talks/ProdNG-LISA/Paper/ for the detailed
paper.

> If the use case considers rebooting a bit problem, then either a
> heavy weight virtual machine should be used, or something lighter
> weight like LXC containers. systemd-nspawn containers I think are
> still not considered for production use, but for testing and proof of
> concept you could see if it can boot arbitrary subvolumes - I think
> it can. And they boot really fast, like maybe a few seconds fast. For
> user space applications needing rollbacks, that's where application
> containers come in handy - you could either have two applications
> icons available (current and previous) and if on Btrfs the "previous"
> version could be a reflink copy.
 
1) containers/VMs and boots (even if fast) were not something I wanted
to involve in my design, but your point is well taken that in my cases
they work fine.
2) reflink seems like the way to update an existing volume with data
from another one you just btrfs received on, but can't atomically mount.


> Maybe there's some way to quit everything but the kernel and PID 1
> switching back to an initrd, and then at switch root time, use a new
> root with all new daemons and libraries. It'd be faster than a warm
> reboot. It probably takes a special initrd to do this. The other thin
> you can consider is kexec, but then going forward realize this isn't
> compatible with a UEFI Secure Boot world.

Secure boot is not a problem for me :)
But yes, kexec is basically my fallback for something better than a full
boot.

> Well I think the bigger issue with system updates is the fact they're not atomic right now. The running system has a bunch of libraries yanked out from under it during the update process, things are either partially updated, or wholly replaced, and it's just a matter of time before something up in user space really doesn't like that. This was a major motivation for offline updates in gnome, so certain updates require reboot/poweroff.

Gnome and ubuntu are lazy :)
(but seriously, they are)

We've been doing almost atomic live system upgrades at google for
about 12 years. It's not trivial, but it's very possible.
Mind you, when you something with a spaghetti library dependency like
gnome, that sure doesn't help though, but one could argue that gnome is
part of the problem :)
 
> To take advantage of Btrfs (and LVM thinp snapshots for that matter) what we
> ought to do is take a snapshot of rootfs and update the snapshot in a chroot
> or a container. And then the user can reboot whenever its convenient for them,
> and instead of a much, much longer reboot as the updates are applied, they get
> a normal boot. Plus there could be some metric to test for whether the update
> process was even successful, or likely to result in an unbootable system; and
> at that point the snapshot could just be obliterated and the reasons logged.

While this is not as good as the update system I'm currently working
with at work, I agree it's decent and simple way to do things.

> Already look at how Fedora does this. The file system at the top level
> of a Btrfs volume is not FHS. It's its own thing, and only via fstab
> do the subvolumes at the top level get mounted in accordance with
> the FHS. So that means you get to look at fstab to figure out how a
> system is put together when troubleshooting it, if you're not already
> familiar with the layout. Will every distribution end up doing their
> own thing? Almost certainly yes, SUSE does it differently still as a
> consequence of installing the whole OS to the top level, making every
> snapshot navigable from the always mounted top level. *shrug*

Right. Brave new world and all :)

That said, it's how natural selection works. Let's try different ideas
and hopefully the best one(s) will win.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
