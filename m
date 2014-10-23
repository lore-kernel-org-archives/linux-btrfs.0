Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43824 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaJWIi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 04:38:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XhDud-0001Ay-BN
	for linux-btrfs@vger.kernel.org; Thu, 23 Oct 2014 10:38:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 10:38:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 10:38:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
Date: Thu, 23 Oct 2014 08:38:03 +0000 (UTC)
Message-ID: <pan$329c9$9586ec5f$d67b4e44$93123d00@cox.net>
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com>
	<pan$66073$b8603a2$c915bfb9$cd573e99@cox.net>
	<20141022200812.GA17395@hungrycats.org>
	<01D3E7DE-5420-4C97-98C4-BB0414C4972E@colorremedies.com>
	<54488F91.6070109@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 22 Oct 2014 22:18:09 -0700 as excerpted:

> On 10/22/2014 09:30 PM, Chris Murphy wrote:
>> Sure. So if Btrfs is meant to address scalability, then perhaps at the
>> moment it's falling short. As it's easy to add large drives and get
>> very large multiple device volumes, the snapshotting needs to scale
>> also.

I believe it's a fair statement to say that many aspects of btrfs in 
general simply don't scale well at this point.  Many of the features are 
there; we're now getting to the point where many of those features are 
reasonably bug-free, altho that's definitely an ongoing thing; but pretty 
much wherever you turn and whatever you look at, btrfs is in general not 
yet optimized.

* The raid1 device-read-selection algorithm is simply even/odd-PID-
based.  That's great for a first implementation, since it's simple enough 
to implement and it works well enough to know that reading from either 
copy works, but it's horrible for a final, scalable implementation, since 
too many use-cases will be nearly all even or all odd pids.

* Btrfs multi-device-writes are nearly all serialized, one at a time, 
instead of scheduling writes to all devices at once in ordered to 
maximize bandwidth over the individual-device-speed bottleneck.

* Btrfs snapshot-aware-defrag was introduced to much fanfare, and then 
disabled a couple kernel series later when it became very apparent it 
simply didn't scale, and the lack of scaling meant it didn't work
/at/ /all/ for many users.

* The quota implementation was just recently pretty much entirely 
rewritten due to serious corner-case breakage and lack of scaling (one of 
the contributors to the defrag and balance scaling issues, as it happens).

* The autodefrag mount option doesn't scale well beyond a few hundred MiB 
or with frag-triggering file updates coming in faster than the entire 
file can be rewritten (there's plans to make this better, but the time to 
code and test simply hasn't been available yet).

* This thread is about the balance scaling issues, a good portion of 
which boil down to extremely poorly optimized quota and snapshot 
handling, and another problem set to no choice but extent-based 
operations, which are great for some things but don't work well when all 
you want to do is duplicate chunks in a conversion to raid1 mode, for 
instance.

That's what I think of off the top of my head.  I'm sure there's more.

However, specifically addressing snapshotting, while optimizing for speed 
and scale will certainly help, I'm not sure btrfs will ever be what might 
be called a speed demon in the area.

If that is indeed the case, and I don't know but it's certainly possible, 
then for the future, and regardless of the future, definitely for the 
present, that means it's absolutely /critical/ for the human side to 
optimize things to keep things like number of snapshots from growing out 
of reasonable management range.

...

>> I'd say per user, it's reasonable to have 24 hourly (one snapshot per
>> hour for a day), 7 daily, 4 weekly, and 12 monthly snapshots, or 47
>> snapshots. That's 47,000 snapshots if it's sane for a single Btrfs
>> volume to host 1000 users. Arguably, such a system is better off with a
>> distributed fs: Gluster FS or GFS2 or Ceph.
> 
> Is one subvolume per user a rational expectation? Is it even
> particularly smart? Dooable, sure, but as a best practice it doesn't
> seem that useful because it multiplies the maintenace by the user base.
> 
> Presuming a linux standard base layout (which is very presumptive)
> having the 47 snapshots of /home instead of the 47,000 snapshots of
> /home/X(1000) is just as workable, if not moreso. A reflink recursive
> copy of /home/X(n) from /home_Backup_date/X(n) is only trivially longer
> than resnapshotting the individual user.
> 
> Again this gets into the question not of what exercises well to create
> the snapshot but what functions well during a restore.
> 
> People constantly create "backup solutions" without really looking at
> the restore path.
> 

... Which is where this discussion comes in.

FWIW, over more than a decade of fine tuning and experience with a number 
of disaster and recovery cases here, I've come up with what is for me a 
reasonably close to ideal multiple partition layout.  That's actually one 
of the big reasons I don't use subvolumes here; I don't need to because I 
already have a nearly perfect... for my use-case... independent 
partitions layout.

Here's my point.  Via trial and error I concluded almost the exact same 
point that Chris is making about subvolumes, only for independent 
partitions.

The discussed example is subvolumes for individual users in /home, vs. 
one big subvolume for /home itself (or arguably, if there's a convenient 
user-role-based separation, perhaps a subvolume for say teacher-home and 
another for student-home, or for user-home, group-leader-home, upper-
management-home, etc).

The same lesson, however, applies to say all distro-update storage, in my 
(gentoo) case, the main distro package ebuild tree, the overlays, binpkgs 
for my 64-bit builds, binpkgs for my 32-bit builds, 64-bit ccache, 32-bit 
ccache, the separate (mainstream git) kernel repo and individual build 
dirs for 32-bit and 64-bit kernels, etc.

Back when I first split things up, most of those were in individual 
partitions.  Now I just have one partition with all those components in 
it, in separate subdirs, and symlinks from the various other locations in 
my layout to the various components in this partition.

Why?  Because managing all of them separately was a pain, and I tended to 
mount and unmount most of them together anyway, when I did system updates.

Similarly, in my original setup I had the traditional small /, with /etc, 
but with an independent /usr and /var, and /var/log independent of /var.

I still have /var/log independent of the others since limiting a runaway 
logging scenario to an independent log partition makes very good sense 
and logging is its own logical task, but /usr is on / now, as is /var 
itself, but with individual subdirs of for instance /var/lib symlinked 
elsewhere.

Why?  Because at one point I had an A/C failure, here in Phoenix in the 
middle of the summer, when I was gone.  I came home to a a 50C+ house, a 
heat-induced head-crashed disk and a frozen CPU.

Recovering from that disaster was a nightmare, because while I had 
backups, I ended up with a root backup from one date, a /usr backup from 
a different date, and a /var, including the record of what packages and 
files were installed, from a third date.  So my record (in /var/db) of 
what was installed didn't match /usr, which didn't match /!

So everything that the distro actually installs, including the database 
of what is actually installed, with one limited exception, is now all on 
the same partition, root!  If I have to recover from backup, whether I'm 
recovering from yesterday's backup or one made a year ago, there's one 
thing I'll be sure of, the database of what's installed will match what's 
actually there, because it's on the same system root partition and thus 
the same backup!

And that system partition is now mounted read-only by default.  I only 
mount it writable in ordered to update, either packages or system 
configuration.  When I'm done with the update I sudo systemctl emergency, 
hit ctrl-d to get back to normal mode without logging into emergency mode 
and log back into normal mode, systemctl daemon-reexec if systemd itself 
was updated (thus restarting all programs including init/systemd itself, 
so no stale and deleted libs are still in use), and remount ro /.

Which brings me to the limited /var exception I mentioned earlier.  
While /var is supposed to be variable/writable, in practice, many system 
processes only need to write to their /var subdir if they're updated.  
These can stay on /var.  The few others, the ones that really need a 
writable /var subdir, have that subdir actually linked back to a 
similarly named subdir in /home/var/, which is mounted writable by 
default.  That lets me keep /, including the rest of /var (with the 
exception of /var/tmp, which is tmpfs), read-only by default.

As it happens, these writable-necessary /var/ subdirs aren't critical to 
early boot, and if for some reason /home is unmountable (as it was along 
with /var/log at one point recently when the writable at crash /home 
btrfs refused to mount, but /, being read-only at crash, wasn't harmed), 
I can either do without temporarily, or reconstruct an empty or default 
/var subdir for them in tmpfs or whatever.

One critical thing that makes this all work is the existence of symlinks 
in various locations, pointing to the real locations on the partition 
where logical function-grouping places them.

But all this simply reinforces the point.  Logically function-group 
subdirs on subvolumes much as I logically function-group subdirs on 
independent partitions, and you won't be /dealing/ with 47K snapshots, 47 
snapshots each of 1000 individual user subvolumes.  You might be dealing 
with 47 snapshots of /home, with 1000 users on it, or you might function-
group a bit further and have 47 snapshots each of mgmt-home, user-home, 
and teamldr-home, so 141 snapshots total for all of homedirs, but that's 
still reasonable with btrfs' current scaling, while 47K snapshots, forget 
it!

And take it from me, it makes it FAR easier to deal with backup and 
testing, with disaster recovery should it be necessary, and with other 
sysadmin level maintenance as well.

Tho of course I'd personally argue that for reliability and 
recoverability reasons, each of those function-groups should be an 
independent partition, not just a subvolume that should the filesystem go 
down, it'll take all the subvolumes with it.  But that's an entirely 
different argument to be had...  Regardless of whether it's subvolumes or 
independent partitions and filesystems, however, the same point applies.

> I can't get anybody here to answer the question about "btrfs fi li -s /"
> and setting/resetting the "snapshot" status of a subvolume.

I wish I knew the answer.  But as I said above, I don't do subvolumes, or 
for that matter, snapshots, myself, preferring fully independent 
partitions, and fully independent "snapshot" backups to same-size backup 
partitions located elsewhere, so I can simply point the mount at the 
backup and mount it in place of the previously working copy for recovery 
should it be necessary.  So I've not had to investigate that for personal 
reasons, and while I've an academic interest as well as an interest in 
knowing it simply to help others here, I've seen nobody else post a 
satisfactory answer, so...

I share your frustration, tho at the academic and help-others level, not 
the personal installation operations level.


> I've been
> told "snapshots are subvolumes" which is fine, but since there _is_ a
> classification mechanism things get all caca if you rely on the "-s" in
> your scripting and then promote a snapshot back into prime activity.
> (seriously compare the listing with and without -s, note its natural
> affinity for classifying subvolumes, then imagine the horror of needing
> to take /home_backup_date and make it /home.)

By all means explain to me how this won't work if so, but it seems to me 
the following is a reasonably effective workaround that shouldn't take 
/too/ much more time...

1) According to the wiki, cross-subvolume reflinks now (since 3.6) work.  
See the explanatory text for the following (watch the linkwrap):

https://btrfs.wiki.kernel.org/index.php/
UseCases#Can_I_take_a_snapshot_of_a_directory.3F

Note that based on the above link, reflinks won't work if the subvolumes 
are separately mounted, that is, across separate mount-points.  However, 
as long as it's a single common "parent" mount, with the subvolumes 
simply accessed under it as if they were subdirs, reflink-copying should 
"just work".

Based on that...

2) Mount a parent (which might be the root subvolume) to both the backup-
snapshot and the intended target subvolume, creating the new target 
subvolume as necessary.

3) Reflink-copy recursively from the backup to the target, as if you were 
traditionally backup-restoring from a backup mounted elsewhere, except 
using the parent-subvolume mount paths so you don't cross mount-points, 
and using reflink-copying to dramatically speed the process.

4) When you are done, you should have a non-snapshot subvolume restored 
and ready for use, almost as if you were able to directly mount the 
snapshot in place of the non-snapshot original, removing its snapshot 
property in the process.

5) If desired, delete the backup snapshot, thus completing the parallel.  
Alternatively, keep it where it is.  After all, you needed to restore 
from it once, what's to say something else won't happen to kill the 
restored version, thus triggering the need for another restore?  Surely 
that'd be bad juju, but better to still have that backup snapshot on 
hand, then to have just moved it to production, and then lost it too.
=:^)

> Similar problems obtain as soon as you consider the daunting task of
> shuffling through 47,000 snapshots instead of just 47.
> 
> And if you setup each user on their own snapshot what happens the first
> time two users want to hard-link a file betwixt them?

See the above cross-subvol reflink discussion...

> Excessive segmentation of storage is an evil unto itself.

... But never-the-less, absolutely agreed. =:^)

> YMMV, of course.
> 
> An orthoginal example:
> 
> If you give someone six disks and tell them to make an encrypted raid6
> via cryptsetup and mdadm, at least eight out of ten will encrypt the
> drives and then raid the result. But it's _massivly_ more efficent to
> raid the drives and then encrypt the result. Why? Because writing a
> block with the latter involves only one block being encrypted/decrypted.
> The former, if the raid is fine involves several encryptions/decryptions
> and _many_ if the raid is degraded.
> 
> The above is a mental constraint, a mistake, that is all to common
> because people expect encrytion to be "better" the closer you get to the
> spinning rust.

This totally unexpected but useful jewel is part of why I'm addicted to 
newsgroups and mailing lists. (FWIW, I do this list as a newsgroup via 
gmane.org's list2news service.)  Totally unexpected "orthogonal 
examples", which can be immensely useful all on their own. =:^)

FWIW I haven't gotten much into encrypted storage here, but I keep 
thinking about it, and were I to have done so before reading this, I 
might have made exactly that mistake myself.

OTOH, with btrfs raid replacing mdraid, individually encrypted block 
devices are (currently) necessary, because btrfs merges the filesystem 
and raid levels.  Tho direct btrfs encryption support is apparently 
planned, and if/when that's implemented, one could expect they'll address 
your point and internally layer the encryption over the raid.  Tho I 
expect that'd be a weaker encryption implementation if done that way, 
because part of the advantage of btrfs raid is that the filesystem 
structures work down thru the raid level as well, so individual chunk 
structures appear at the device level below the raid.  If encryption is 
then built over the raid, that would mean the encryption would need to 
pass the individual chunk structures thru so btrfs raid could still use 
them, and that would be a critical information leak to the encrypted side.

So if btrfs does implement encryption, one would hope they'd either have 
a config option for above or below the raid level, or that they'd do it 
the less efficient multi-encryption way below the raid, thus not having 
to pass that information thru the encryption to the raid, leaking it in 
the process.

> So while the natural impulse is to give each user its own subvolume it's
> not likely to be that great an idea in practice because... um... 47,000
> snapshots dude, and so on.

Agreed. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

