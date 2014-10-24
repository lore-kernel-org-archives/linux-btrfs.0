Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42071 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJXCZu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 22:25:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XhUZU-0008SN-Ut
	for linux-btrfs@vger.kernel.org; Fri, 24 Oct 2014 04:25:44 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 04:25:44 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 04:25:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mounting(multiply)? Options(stored)? Options(barriers)?
Date: Fri, 24 Oct 2014 02:25:34 +0000 (UTC)
Message-ID: <pan$ce81d$b98a312d$87b2f050$bb8a9bd1@cox.net>
References: <544980BA.8080007@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Thu, 23 Oct 2014 15:27:06 -0700 as excerpted:

> I've got several questions about mount features that I've been unable to
> find definitive answers for.
> 
> ITEM: So there are some mount options that I'd like to be able to pin
> onto a media like compress=lzo on a thumb drive I expect to get crowded.
> Is there a feature equivalent to the -o option to tune2fs either present
> or planned?

Planned and already partially implemented, yes.  The infrastructure and a 
few options for it have already been implemented as btrfs properties -- 
via extended attributes.  See the btrfs-property (8) manpage in a recent 
btrfs-progs and play with the command a bit to see what's already 
available.  But AFAIK some planned properties remain to be implemented, 
and some that are already there are only partially implemented.

It's possible to set the compression attribute on an individual file, for 
instance, but last I knew, it wasn't yet possible to specify the type of 
compression, so the default (either the mount default or if that's not 
set either, the btrfs default, gzip) would be used.

And there has been some discussion of the semantics of specifically set 
no-compress, vs. the attribute/property not existing for the file at all, 
how inherited compression should work, etc.  I believe that's already 
hashed out, but last I knew, it wasn't yet coded up.  (But I've not 
upgraded since the progs 3.17 announcement and don't know if it changed 
anything in that regard, yet.)

Also, since these btrfs properties are normally recorded as extended 
attributes, the various non-btrfs utilities, chattr (from e2fsprogs), 
etc, that deal with extended attributes, will need to be updated to deal 
with the richer semantics, as well.

> ITEM: Is there a means (or a plan for a means) to use a subvol as a
> means to prevent/change active features from propigating to a
> subdirectory? An example would be a means to turn off autodefrag or
> compression for a subvolume full of virtual machine images, whilest
> having it active for the bulk of the filesystem.

The idea is to eventually have that set by mount.  If the subvolume is 
separately mounted, some mount options will be (and some already are) 
separately set for it.  If you're accessing it like a normal subdir on 
the parent subvolume, however, without separately mounting it, then the 
mount options for the parent will apply.

Which gets interesting since it's then possible to mount a subvolume 
separately in one location, with its own behavior, and access it from the 
parent subvolume mounted elsewhere, with entirely different options, both 
at the same time.  Tho of course the Linux VFS has been dealing with this 
to a limited extent for bind-mounts, where one view may be readonly and 
another writable, for instance, for some time now.

As to what mount options can be set separately already, see the 
discussion on the btrfs wiki.  (Watch the link-wrap.)

https://btrfs.wiki.kernel.org/index.php/
FAQ#Can_I_mount_subvolumes_with_different_mount_options.3F

> ITEM: If I make one file system and have subvols /__System /home and
> /VMs and mount those as / /home and /usr/local/VMs respectively, with
> differing feature options for each, will those options be separately
> honored or will the last-mounted or first-mounted subvolume's options
> take dominant effect? Compression, auto-defragment, and commit interval
> being of primary concern.

See the discussion above.  As for whether conflicting options error out, 
get ignored, or update the whole filesystem, there has been some 
discussion on the list but IDR the conclusion as it doesn't pertain to me 
since I don't use subvolumes like that, preferring fully independent 
filesystems on their own partitions, instead.  (If the filesystem 
metadata gets corrupted, it can easily mean the loss of all data on it.  
Subvolumes provide little if any protection in that regard.  I *STRONGLY* 
prefer not to put all my data eggs in one filesystem basket, in case its 
bottom falls out.)  I believe in some cases either the conflicting mount 
will error out or it'll mount but ignore the conflicts (IOW, it shouldn't 
arbitrarily rewrite the option for the entire filesystem, that's what 
remount is for!), but don't know if it actually works that way for 
everything yet.  Either watch for a response from someone with practical 
knowledge of the situation, or do your own testing, before you depend on 
it.

> ITEM: Is there a no-compress attribute (or something similar) for
> negating compress= mount options on specific files or directories? How
> about a no-autodefrag?

Yes for no-compress, at least after they get everything setup as 
discussed.  I don't believe so for autodefrag, as that's mount-option 
controlled only, AFAIK.  But the plan is to let different subvolumes 
mount with different autodefrag options, eventually.  But I don't believe 
it's implemented yet.

> (I'm about to set up a system and some standards that may last many
> years and I'm trying to find the reasonable bounds of where I need to do
> hard partitioning.)

I guess my view on that should be obvious from the above comment.  I 
strongly prefer hard partitioning as I don't want to risk all my data 
eggs being in the same filesystem basket when its bottom falls out! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

