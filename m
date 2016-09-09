Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58883 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753263AbcIIQfB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 12:35:01 -0400
Date: Fri, 9 Sep 2016 18:33:23 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Security implications of btrfs receive?
Message-ID: <20160909163323.GZ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net>
 <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
 <1473271679.24874.36.camel@scientia.net>
 <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 07, 2016 at 03:08:18PM -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-07 14:07, Christoph Anton Mitterer wrote:
> > On Wed, 2016-09-07 at 11:06 -0400, Austin S. Hemmelgarn wrote:
> >> This is an issue with any filesystem,
> > Not really... any other filesystem I'd know (not sure about ZFS) keeps
> > working when there are UUID collisions... or at least it won't cause
> > arbitrary corruptions, which then in the end may even be used for such
> > attacks as described in that thread.
> >
> > Even other multi-device containers (LVM, MD) don't at least corrupt
> > your data like it allegedly can happen with btrfs.
> >
> >
> >
> >>  it is just a bigger issue with
> >> BTRFS.
> > No corruption vs. possible arbitrary data corruption and leakage seems
> > to be more than "just bigger".
> > I'd call it unacceptable for a production system.
> So is refusing to boot.  In most cases, downtime is just as bad as data 
> corruption.
> >
> >
> >>   Take a system using ext4, or XFS, or almost any other Linux
> >> filesystem, running almost any major distro, create a minimum sized
> >> partition on the disk for that filesystem type, and create a
> >> filesystem
> >> there with the same UUID as the root filesystem.  Next time that
> >> system
> >> reboots, things will usually blow up (XFS will refuse to mount, ext4
> >> and
> >> most other filesystems will work sometimes and not others).
> > Well but that's something completely different.
> > It would be perfectly fine if, in case of an UUID collision, the system
> > simply denies mounting/assembly (actually that's one of the solutions
> > others and I've proposed in the aforementioned thread).
> >
> > But it's not acceptable if the system does *something* in such
> > situation,... or if such fs/container is already mounted/active and
> > another device with colliding UUID appears *then*, it's neither
> > acceptable that the already active fs/container wouldn't continue to
> > work properly.
> >
> > And that seems to my experience just how e.g. LVM handles this.
> >
> > "Not booting" is not really an issue in terms of data corruption.
> >
> >
> > At least I'm pretty sure to remember that one of the main developers
> > (was it Qu?) acknowledged these issues (both in terms of accidental
> > corruption and security wise) and that he was glad that these issues
> > were brought up and that they should be solved.
> >
> >
> >> It hasn't, because there's not any way it can be completely
> >> fixed.
> > Why not? As it was laid out by myself and others, the basic solution
> > would be:
> > - Refuse any mounting in case UUID collisions are detected.
> > - Generally don't do any auto-rebuilds or e.g. RAID assemblies unless
> >   specifically allowed/configured by the user (as this might also be
> >   used to extract data from a system).
> > - If there are any collisions (either by mounting or by processes like
> >   rebuilds/added devices) require the user to specify uniquely which
> >   device he actually wants (e.g. by path).
> > - And in case a filesystem is already mounted and UUID collisions
> >   happens then (e.g. a dd clone get's plugged in), continue to use the
> >   already active device... just as e.g. LVM does.
> >
> >>   This
> >> particular case is an excellent example of why it's so hard to
> >> fix.  To
> >> close this particular hole, BTRFS itself would have to become aware
> >> of
> >> whether whoever is running an ioctl is running in a chroot or not,
> >> which
> >> is non-trivial to determine to begin with, and even harder when you
> >> factor in the fact that chroot() is a VFS level thing, not a
> >> underlying
> >> filesystem thing, while ioctls are much lower level.
> > Isn't it simply enough to:
> > - know which blockdevices with a btrfs and with which UUIDs there are
> > - let userland tools deny any mount/assembly/etc. actions in case of
> >   collisions
> > - do the actual addressing of devices via the device path (so that
> >   proper devices will continued to be if the fs was already mounted
> >   when a collision occurs)
> > ?
> That's not the issue being discussed in this case.  The ultimate issue 
> is of course the same (the flawed assumption that some arbitrary bytes 
> will be globally unique), but the particular resultant issues are 
> different.  The problem being discussed is that receive doesn't verify 
> that subvolume UUID's it has been told to clone from are within the are 
> it's been told to work.  This can cause an information leak, but not 
> data corruption, and is actually an issue with the clone ioctl in 
> general.  Graham actually proposed a good solution to this particular 
> problem (require an open fd to a source file containing the blocks to be 
> passed into the ioctl in addition to everything else), but it's still 
> orthogonal to the symptoms you're talking about.
> >
> > And further, as I've said, security wise auto-assembly of multi-device
> > seems always prone to attacks at least in certain use cases, so for the
> > security conscious people:
> > - Don't do auto-assembly/rebuild/etc. based on scanning for UUID
> > - Let the user choose to do this manually via specifying the devices
> >   (via e.g. path).
> >   So a user could say something like
> >   mount -t btrfs -o device=/dev/disk/by-path/pci-0000\:00\:1f.2-ata-1,device=/dev/disk/by-path/pci-0000\:00\:2f.2-ata-2 /foo
> >   in order to be sure that just these devices would be *tried* to be
> >   used for the RAID1 btrfs, and not the one an attacker might have
> >   plugged into the USB.
> >
> >
> >> That said, nobody's really done any work on mitigating the issues
> >> either, although David Sterba has commented about having interest in
> >> fixing issues caused by crafted filesystem images, so hopefully
> >> things will start moving more in the direction of proper security.
> > Well that's good do hear... it's IMO one of the bigger potential issues
> > in btrfs, next to the ongoing stability problems[0] and still not
> > really working RAID.
> >
> > Anyone working on this should probably have a look at the thread I've
> > mentioned, cause there are really several tricky ways one could exploit
> > this... to me especially any auto-(i.e. based on scanning for UUIDs)-
> > assembly/rebuilding and that like seemed to pose quite a big surface.
> >
> I think I covered it already in the last thread on this, but the best 
> way I see to fix the whole auto-assembly issue is:
> 1. Stop the damn auto-scanning of new devices on hot-plug.  The scanning 
> should be done on mount or invoking something like btrfs dev scan, not 
> on hot-plug.  This is the biggest current issue, and is in theory the 
> easiest thing to fix.  The problem here is that it's udev sources we 
> need to change, not our own.

I see this as difficult to fix. Even if udev would be configured not to
do the scanning, we'd probably end up with systems that have kernel
expecting userspace scanning and udev not doing that. Possibly fixable.

> 2. Get rid of the tracking in the kernel.  If a filesystem isn't mounted 
> or requested to be mounted, then the kernel has no business worrying 
> about what what devices it's on.  If the filesystem is mounted, then the 
> only way to associate new devices should be from userspace.

> 3. When mounting, the mount helper should be doing the checking to 
> verify that the UUID's and everything else are correct.  Ideally, the 
> mount(2) call should require a list of devices to use, and mount should 
> be doing the discovery.

So 2 and 3 would be a job for the mount helper. We'd pondered that idea
in the past but I'm not sure why we did not want it in the end. (The
scanning part). What we could possibly do, let the mount helper verify
that there are no duplicate UUIDs at least, and refuse mount.

> This is at odds with how systemd handles BTRFS 
> mounts, but they're being stupid with that too (the only way to tell for 
> certain if a FS will mount is to try to mount it, if the mount(2) call 
> succeeds, then the filesystem was ready, regardless of whether or not 
> userspace thinks the device is).
> 4. The kernel should be doing a better job of validating filesystems. 
> It should be checking that all the devices agree on how many devices 
> there should be, as well as checking that they all have correct UUID's. 
> This is technically not necessary if item 3 is implemented, but is still 
> good practice from a hardening perspective.

Agreed.
