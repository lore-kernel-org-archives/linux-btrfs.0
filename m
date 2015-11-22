Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40957 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbbKVGNX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Nov 2015 01:13:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a0Nth-0001hQ-Qt
	for linux-btrfs@vger.kernel.org; Sun, 22 Nov 2015 07:13:14 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2015 07:13:13 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2015 07:13:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: free space is missing after dist upgrade on lzo compressed vol
Date: Sun, 22 Nov 2015 06:12:58 +0000 (UTC)
Message-ID: <pan$4311b$f83b5a0f$e7ee4a74$4127ffa2@cox.net>
References: <CALuXmTBWN3_PLnm4uh7u1SmGA2+5_VvNou-BLtv4=+Jvjjdz1Q@mail.gmail.com>
	<20151113223816.GI24333@carfax.org.uk>
	<CALuXmTDsK6PbNNRV=tTcp+O0Fx-xAceAN3O1BqdjFSpno7KBow@mail.gmail.com>
	<CAGqmi779f9cEQJN4GtJ02pCW03DCB4SCX50arHY3kqK2bUNB1g@mail.gmail.com>
	<CALuXmTDKiQwBnGuGF5MsoD9d_wfv+LVyVxWbmnyEz_nCB-5qkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brenton Chapin posted on Sat, 21 Nov 2015 12:32:12 -0600 as excerpted:

> Thanks, snapshots, or subvolumes, was it.  (I'm not clear on the
> distinction between a snapshot and a subvolume.)

As Hugo says much more briefly, snapshots are a special kind of 
subvolume.  These are normally (copy-on-write, aka cow, based) 
"snapshots" of another subvolume at a the point they were taken, 
containing the same data, etc.  Snapshots can be read-only, in which case 
they lock in what the snapshotted subvolume looked like at that time, or 
writable, just like normal subvolumes, in which case they start out 
looking like the subvolume they snapshotted at that point in time, but 
both the original subvolume and its writable snapshot can be written to, 
so one or both can diverge from the "picture" that was taken by the 
snapshot.

Subvolumes (and thus snapshots, since snapshots are a special case of 
subvolume), meanwhile, look and work almost like directories, except they 
have a few extra features that normal directories don't have, the biggest 
of which is that subvolumes can be mounted separately, as if they were 
their own filesystems.  This is actually what's happening below, as it's 
not the "root" subvolume that's actually mounted at /, but rather, a 
subvolume below the root subvolume.  Knowing that should help make sense 
of the subvolume list output, below, and explains why you don't see the 
subvolumes in the filesystem, as what's mounted at / isn't actually the 
root subvolume, but a subvolume nested within the root subvolume.

More on that below, but while we're talking about subvolume features, let 
me repeat something I said above, now that you have a bit more context to 
put it in.  Snapshots are taken of specific subvolumes (again, if it 
helps, think subdirs), NOT of the whole filesystem including all 
subvolumes.  As such, snapshots stop at subvolume boundaries.  If for 
instance you take a snapshot of the root subvolume (ID 5 in the listing 
below, *NOT* the nested subvolume below it that happens to be mounted
at /), you get a picture/snapshot of only what's directly in it, not 
what's in subvolumes nested beneath it.  Nested subvolumes are 
snapshotted separately.

> btrfs subvolume list -p /
> ID 257 gen 16615 parent 5 top level 5 path @
> ID 262 gen 15857 parent 5 top level 5 path
> @apt-snapshot-release-upgrade-vivid-2015-11-12_15:49:30
> ID 266 gen 16544 parent 257 top level 257 path
> var/lib/machines
> ID 268 gen 16203 parent 5 top level 5 path
> @apt-snapshot-release-upgrade-wily-2015-11-13_04:10:00
> 
> Seems these subvolumes (snapshots?) are nowhere visible in the file
> system.  Now I'm trying to figure out the correct commands to delete
> them.  "btrfs subvolume delete @apt-snapshot..." gave "ERROR: error
> accessing '@apt-snapshot...", while "btrfs sbuvolume show " on
> variations of the name keep giving me "ERROR: finding real path for
> '...', No such file or directory."  No luck so far.  What am I missing?

As I said above, you won't see these subvolumes (including snapshots) 
visible in the filesystem, because what you have mounted at / is not the 
root level (ID 5) subvolume, but rather, a subvolume nested within it.

Visualizing the above listing as a tree, you have...

+-+--       ID 5  root subvolume, always ID 5 (not listed)
  |
  +-+--   ID 257  @ (this is what is mounted at /)
  | |
  | +--   ID 266	(@/)var/lib/machines (systemd generated)
  |
  +--     ID 262 @apt-snapshot-release-upgrade-vivid...
  |
  +--     ID 268 @apt-snapshot-release-upgrade-wily...

As mentioned, it's ID 257, @, that's mounted at /.  Your 4.2 kernel is 
actually new enough to print this information in the mount output, and 
indeed, from the mount output you posted upthread:

>>>>> /dev/sda6 on / type btrfs
>>>>> (rw,relatime,compress=lzo,space_cache,subvolid=257,subvol=/@)

See that subvolid=257,subvol=/@ ?  That's the same ID 257 @ as shown in 
your subvolume list, and as I diagrammed in the tree layout.

IDs 262 and 268 are snapshots of the state of ID 257 @, at the time you 
did the upgrades.  ID 5 is of course the root subvolume, in which the 
others are nested, and ID 257 @, has ID 266 nested within it.  Of course 
this information can be easily seen from the tree layout I did, but it's 
there in the listing as well, with the parent/top-level ID in the listing 
being the direct parent subvolume.

OK, so how do you delete those snapshots and recover the space they claim?

As with normal directories in filesystems, to work with subvolumes/
snapshots in btrfs, you need a subvolume from which they're descended 
mounted.

Since ID 257 (@) is mounted, ID 266, var/lib/machines, nested within it, 
is visible in its tree, and for most purposes will look and behave like 
an ordinary directory, except that you won't be able to rmdir it, because 
it's actually a subvolume.  As long as it's not actually mounted as its 
own subvolume, however, you could btrfs subvolume delete it, if you 
wanted to.

But the two snapshots, ID 262 and 268, are not within the mounted tree 
and you can't directly work with them as a result, tho you _can_ btrfs 
subvolume list them, as you did.  To work with them, in this case, to 
btrfs subvolume delete them, you'll need to mount their parent subvolume 
somewhere.

Tho here's where I start going out beyond my own personal working 
knowledge, as I neither run Ubuntu (I'm a Gentooer), so don't know what 
specific mount points it might provide for that, nor do I actually use 
the btrfs subvolumes/snapshots features here, tho I did play with them 
just a bit when I was first setting things up here, before deciding they 
didn't actually fit my use-case very well, and my life was simpler 
without trying to use them.  So while I can read the btrfs-subvolume 
manpage and the subvolume documentation on the btrfs wiki, so can you, 
and with limited personal experience, I don't have the benefit of that 
experience to pass on many hints or warnings based on it.  So the actual 
command details are going to be a bit vague/theoretical/handwavy.

But here what I'd do would be:

1) Create a mountpoint for the purpose, say /mnt/rootfsrootsubvol/

(That lets you create other mountpoints, say /mnt/homefsrootsubvol/, if 
you want to do the same thing for your home filesystem, since I noticed 
in your mount output that it's a separate btrfs, also using subvolumes.)

2) (Optional)  Create an fstab entry with my desired device, mount point 
and mount options, specifically including subvolid=5, and probably noauto, 
unless you want it mounted all the time, something like this:

/dev/sda6 /mnt/rootfsrootsubvol btrfs subvolid=5,noauto

3) Mount the root subvolume, either using the options from the fstab 
entry you created in step 2, or manually adding the -o subvolid=5 option.

4) /Now/ do your deletion using the path, much as you'd delete a 
directory, except of course using btrfs subvolume delete instead of rmdir 
or rm -r.

(Obviously untested because as I said I don't use the subvolume 
functionality here, but /something/ like this...)

btrfs subvolume delete [-c|-C] /mnt/rootfsrootsubvol/@apt-snapshot...

Hint: Use tab-completion to avoid having to type in the whole path. =:^)

The -c/-C options are described in the manpage, but...  without them, the 
command will return, but btrfs will still be working on doing the actual 
delete in the background.  So you get a prompt back pretty fast, but 
because the delete will be ongoing, you won't see the full result in your 
btrfs fi df/show/usage or in normal df, for awhile.  If you prefer that 
the delete command not return until the delete is actually done, use the
-c option.  If you're deleting several snapshots/subvolumes at once, -c 
will delete them all and then do a commit before returning, while -C will 
do a commit after each one, of course returning only after the last one.  
Thus, with these options the command will continue running for longer, 
but when it /does/ return, you should be able to see the properly final 
subvolume deletion results in your btrfs filesystem show/df/usage 
commands and in regular df.

5) Don't forget to umount the root subvolume, again. =:^)


Tip/Recommendation:  Don't keep the root subvolume mounted all the time.  
Mount it to work with subvolumes.  Unmount it when you're done working 
with them.  Besides being generally good practice, there's a security 
dimension to consider.  Snapshots in particular will have old copies of 
various executables and libraries around, some of which will be still 
vulnerable versions of executables and libraries that have had security 
updates since then.  Should someone with ill intent get access to your 
system and these security-vulnerable executables and libraries are 
accessible via mounted snapshot or root subvolume, these old binaries 
with known security issues could well make it far easier for them to get 
root access than it would be were these old snapshots not accessible 
because neither they nor the root subvolume are mounted.

Of course keeping the root subvolume unmounted keeps you or others from 
accidentally (or deliberately, as an attack) deleting subvolumes and 
snapshots not immediately nested in your working system, as well.

So just keep the root subvolume unmounted unless you're actually working 
with it, for much the same reasons you don't run as root unless you're 
actually doing something that needs it. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

