Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34570 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbJOOKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 10:10:36 -0400
Received: by lfaz124 with SMTP id z124so28681437lfa.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 07:10:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net>
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
 <561E6969.40500@oracle.com> <561EBAB1.6030600@gmail.com> <pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net>
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Date: Thu, 15 Oct 2015 16:10:13 +0200
Message-ID: <CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com>
Subject: Re: Recover btrfs volume which can only be mounded in read-only mode
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 October 2015 at 02:48, Duncan <1i5t5.duncan@cox.net> wrote:
> Dmitry Katsubo posted on Wed, 14 Oct 2015 22:27:29 +0200 as excerpted:
>
>> On 14/10/2015 16:40, Anand Jain wrote:
>>>> # mount -o degraded /var Oct 11 18:20:15 kernel: BTRFS: too many
>>>> missing devices, writeable mount is not allowed
>>>>
>>>> # mount -o degraded,ro /var # btrfs device add /dev/sdd1 /var ERROR:
>>>> error adding the device '/dev/sdd1' - Read-only file system
>>>>
>>>> Now I am stuck: I cannot add device to the volume to satisfy raid
>>>> pre-requisite.
>>>
>>>  This is a known issue. Would you be able to test below set of patches
>>>  and update us..
>>>
>>>    [PATCH 0/5] Btrfs: Per-chunk degradable check
>>
>> Many thanks for the reply. Unfortunately I have no environment to
>> recompile the kernel, and setting it up will perhaps take a day. Can the
>> latest kernel be pushed to Debian sid?

Duncan, many thanks for verbose answer. I appreciate a lot.

> In the way of general information...
>
> While btrfs is no longer entirely unstable (since 3.12 when the
> experimental tag was removed) and kernel patch backports are generally
> done where stability is a factor, it's not yet fully stable and mature,
> either.  As such, an expectation of true stability such that wishing to
> remain on kernels more than one LTS series behind the latest LTS kernel
> series (4.1, with 3.18 the one LTS series back version) can be considered
> incompatible with wishing to run the still under heavy development and
> not yet fully stable and mature btrfs, at least as soon as problems are
> reported.  A request to upgrade to current and/or to try various not yet
> mainline integrated patches is thus to be expected on report of problems.
>
> As for userspace, the division between btrfs kernel and userspace works
> like this:  Under normal operating conditions, userspace simply makes
> requests of the kernel, which does the actual work.  Thus, under normal
> conditions, updated kernel code is most important.  However, once a
> problem occurs and repair/recovery is attempted, it's generally userspace
> code itself directly operating on the unmounted filesystem, so having the
> latest userspace code fixes becomes most important once something has
> gone wrong and you're trying to fix it.
>
> So upgrading to a 3.18 series kernel, at minimum, is very strongly
> recommended for those running btrfs, with an expectation that an upgrade
> to 4.1 should be being planned and tested, for deployment as soon as it's
> passing on-site pre-deployment testing.  And an upgrade to current or
> close to current btrfs-progs 4.2.2 userspace is recommended as soon as
> you need its features, which include the latest patches for repair and
> recovery, so as soon as you have a filesystem that's not working as
> expected, if not before.  (Note that earlier btrfs-progs 4.2 releases,
> before 4.2.2, had a buggy mkfs.btrfs, so they should be skipped if you
> will be doing mkfs.btrfs with them, and any btrfs created with those
> versions should have what's on them backed up if it's not already, and
> the filesystems recreated with 4.2.2, as they'll be unstable and are
> subject to failure.)

Thanks for this information. As far as I can see, btrfs-tools v4.1.2
in now in experimental Debian repo (but you anyway suggest at least
4.2.2, which is just 10 days ago released in master git). Kernel image
3.18 is still not there, perhaps because Debian jessie was frozen
before is was released (2014-12-07).

>> 1. Is there any way to recover btrfs at the moment? Or the easiest I can
>> do is to mount ro, copy all data to another drive, re-create btrfs
>> volume and copy back?
>
> Sysadmin's rule of backups:  If data isn't backed up, by definition you
> value the data less than the cost of time/hassle/resources to do the
> backup, so loss of a filesystem is never a big problem, because if the
> data was of any value, it was backed up and can be restored from that
> backup, and if it wasn't backed up, then by definition you have already
> saved the more important to you commodity, the hassle/time/resources you
> would have spent doing the backup.  Therefore, loss of a filesystem is
> loss of throw-away data in any case, either because it was backed up (and
> a would-be backup that hasn't been tested restorable isn't yet a
> completed backup, so doesn't count), or because the data really was throw-
> away data, not worth the hassle of backing up in the first place, even at
> risk of loss should the un-backed-up data be lost.
>
> No exceptions.  Any after-the-fact protests to the contrary simply put
> the lie to claims that the value was considered valuable, since actions
> spoke louder than words and actions defined the data as throw-away.
>
> Therefore, no worries.  Worst-case, you either recover the data from
> backup, or if it wasn't backed up, by definition, it wasn't valuable data
> in the first place.  Either way, no valuable data was, or can be, lost.
>
> (It's worth noting that this rule nicely takes care of the loss of both
> the working copy and N'th backup case, as well, since again, either it
> was worth the cost of N+1 levels of backup, or that N+1 backup wasn't
> made, which automatically defines the data as not worth the cost of the
> the N+1 backup, at least relative to the risk factor that it might
> actually be needed.  That remains the case, regardless of whether N=0 or
> N=10^1000, since even at N=10^1000, backup to level N+1 is either worth
> the cost vs. risk -- the data really is THAT valuable -- or it's not.)
>
> Thus, the easiest way is very possibly to blow away the filesystem,
> recreate and restore from backup, assuming the data was valuable enough
> to make that backup in the first place.  If it wasn't, then we already
> know the value of the data is relatively limited, and the question
> becomes one of whether the chance of recovery of the already known to be
> very limited value data is worth the hassle cost of trying to do that
> recovery.
>
> FWIW, here, I do have backups, but I don't always keep them as current as
> I might.  By doing so, I know my actions are defining the value of the
> data in the delta between the backups and current status as very limited,
> but that's the choice I'm making.
>
> Fortunately for me, btrfs restore (the actual btrfs restore command),
> working on the unmounted filesystem, can often restore the data from the
> filesystem even if it won't mount, so the risk of actual loss of that
> data is much lower than the risk of not actually being able to mount the
> filesystem, of course letting me get away with delaying backup updates
> even longer, as the risk of total loss of the data in the delta between
> the backup and current is much lower than it would be otherwise, thereby
> making the cost of backup updates relatively higher in comparison,
> meaning I can and do space them further apart.
>
> FWIW I've had to use btrfs restore twice, since I started using btrfs.
> Newer btrfs restore (from newer btrfs-progs) works better than older
> versions, too, letting you optionally restore ownership/permissions and
> symlinks, where previously both were lost, symlinks simply not restored,
> and ownership/permissions the default for the btrfs restore process
> (root, obviously, umask defaults).  See what I mean about current
> userspace being recommended. =:^)
>
> Since in your case you can mount, even if it must be read-only, the same
> logic applies, except that grabbing the data off the filesystem is easier
> since you can simply copy it off and don't need btrfs restore to do it.
>
> Of course the existence of those patches gives you another alternative as
> well, letting you judge the hassle cost of setting up the build
> environment and updating, against that of doing the copy off the read-
> only mounted filesystem, against that of simply declaring the filesystem
> a loss and blowing it away, to either restore from backup, or if it
> wasn't backed up, simply losing what is already defined as data of very
> limited value anyway.

Thanks for information concerning restore function. I would certainly
use your advise if I would need to use this function. I am using btrfs
mostly as playground, so I am ready that it can fail (partially the
data is synchronized with the cloud and the rest is not super
important). It is more just a challenge for me, if I can somehow
recover using btrfs only tools, provided that btrfs is designed to be
resistant against the failures.

If I may ask:

Provided that btrfs allowed to mount a volume in read-only mode – does
it mean that add data blocks are present (e.g. it has assured that add
files / directories can be read)?

Do you have any ideas why "btrfs balance" has pulled all data to two
drives (and not balanced between three)?

Does btrfs has the following optimization for mirrored data: if drive
is non-rotational, then prefer reads from it? Or it simply schedules
the read to the drive that performs faster (irrelative to rotational
status)?

>> 2. How to avoid such a trap in the future?
>
> Keep current. =:^)  At least to latest LTS kernel and last release of
> last-but-one userspace series (which would be 4.1.2 IIRC as I don't
> remember a 4.1.3 being released).
>
> Or at the bigger picture, ask yourself whether running btrfs is really
> appropriate for you until it further stabilizes, since it's not fully
> stable and mature yet, and running it is thereby incompatible with the
> conservative stability objectives of those who wish to run older tried
> and tested really stable versions.  Perhaps ext4 (or even ext3), or
> reiserfs (my previous filesystem of choice, with which I've had extremely
> good experience) or xfs are more appropriate choices for you, if you
> really need that stability and maturity.

No, it was particular my decision to use btrfs on various reasons.
First of all, I am using raid1 on all data. Second, I benefit from
transparent compression. Third I need CRC consistency: some of the
drives (like /dev/sdd in my case) seem to fail, also once I have a
buggy DIMM so btrfs helps me not to loose the data "silently". Anyway,
it much better then md-raid.

>> 3. How can I know what version of kernel the patch "Per-chunk degradable
>> check" is targeting?
>
> It may be worth (re)reading the btrfs wiki page on sources.  Generally
> speaking, there's an integration branch, where patches deemed mostly
> ready (after on-list review) are included, before they're accepted into
> the mainline Linus kernel.  Otherwise, patches are generally based on
> mainline, currently 4.3-rcX, unless otherwise noted.  If you follow the
> list, you'll see the pull requests as they are posted, and for the Linus
> kernel, pulls are usually accepted within a day or so, if you're
> following Linus kernel git, as I am.
>
> For userspace, git master branch is always the current release.  There's
> a devel branch that's effectively the same as current integration, except
> that it's no longer updated on the kernel.org mirrors.  The github mirror
> or .cz mirrors (again, as listed on the wiki) have the current devel
> branch, however, and that's what gentoo's "live" ebuild now points at,
> and what I'm running here (after I filed a gentoo bug because the live
> ebuild was pointed at the stale devel branch of the kernel.org kdave
> mirror and thus was no longer updating, that got the live ebuild pointed
> at the current devel branch on the .cz mirrors).
>
> So you can either run current release and cherry-pick patches you want/
> need as they are posted to the list, or if you want something live but a
> bit more managed than that, run the integration branches and/or for
> userspace, the devel branch.
>
>> 4. What is the best way to express/vote for new features or suggestions
>> (wikipage "Project_ideas" / bugzilla)?
>
> Well, the wiki page is user-editable, if you register.  (Tho last I knew,
> there was some problem with at least some wiki user registrations,
> requiring admin intervention in some cases as posted to the list.)
> Personally, I'm more a list person, however, and have never registered on
> the wiki.

I would be happy to add to wiki, but first it' better to check with
maillist, because as you noted below, some of the features / bugs have
already been fixed.

> In general, however, there's only a few btrfs devs, and between bug
> tracking and fixing and development of the features they're already
> working on or have already roadmapped as their next project, with each
> feature typically taking a kernel cycle and often several kernel cycles
> to develop and stabilize, they don't so often pick "new" features to work
> on.
>
> There are independent devs that sometimes pick a particular feature
> they're interested in, and submit patches for it, but those features may
> or may not be immediately integrated, depending on maturity of the patch
> set, how it meshes with the existing roadmap, whether the dev intends to
> continue to support that feature or leave it to existing devs to support
> after development, and in general, how well that dev works with existing
> longer-term btrfs devs.  In general, a dev interested in such a project
> should either be prepared to carry and maintain the patches as an
> independent patch set for some time if they're not immediately
> integrated, or should plan on a one-time "proof of concept" patch set
> that will then go stale if it's not integrated, tho it may still be
> better than starting from scratch, should somebody later want to pick up
> the set and update it for integration.
>
> So definitely, I'd say add it to the wiki page, so it doesn't get lost
> and can be picked up when it fits into the roadmap, but be prepared for
> it to sit there, unimplemented, for some years, as there's simply way
> more ideas than resources to implement them, and the most in-demand
> features will obviously be already listed by now.
>
> For more minor suggestions, tweaks to current functionality or output,
> etc, run current so you're suggestions are on top of a current base, and
> either post the suggestions here, or where they fit, add them as comments
> to proposed patches as they are posted.  Of course, if you're a dev and
> can code them up as patches yourself, so much the better! =:^)
> (I'm not, FWIW. =:^( )
>
> Many of your suggestions above fit this category, minor improvements to
> current output. However, in some cases the wording in current is already
> better than what you were running, so your suggestions read as stale, and
> in others, they don't quite read (to me at least, tho I already said I'm
> not a dev) as practical.
>
> In particular, tracking last seen device doesn't appear practical to me,
> since in many instances, device assignment is dynamic, and what was
> /dev/sdc3 a couple boots ago may well be /dev/sde3 this time around, in
> which case listing /dev/sdc3 could well only confuse the user even more.

Well, in that case btrfs can remember UUID of drives and translate
them to devices (if they are present) or display UUIDs. I think this
will help administrators that manage dozens of btrfs volumes in one
system, each volume consisting of several drives. What is two or more
drives are kicked off? Administrator at least should remember what
devices formed what volumes.

And dynamic assignment is not a problem since udev was introduced (so
one can add extra persistent symlinks):

https://wiki.debian.org/Persistent_disk_names

> Tho that isn't to say that the suggestions don't have some merit,
> pointing out where some change of wording, if not to your suggested
> wording, might be useful.
>
> In particular, btrfs filesystem show, should work with both mounted and
> unmounted filesystems, and would have perhaps given you some hints about
> what devices should have been in the filesystem.  The assumption seems to
> be implicit that a user will know to run that, now, but perhaps an
> explicit suggestion to run btrfs filesystem show, would be worthwhile.
> The case can of course be argued that such an explicit suggestion isn't
> appropriate for dmesg, as well, but at least to my thinking, it's at
> least practical and could be debated on the merits, where I don't
> consider the tracking of last seen device as practical at all.
>
> Anyway, btrfs filesystem show, should work for unmounted as well as
> mounted filesystems, and is already designed to do what you were
> expecting btrfs device scan to do, in terms of output.  Meanwhile, btrfs
> device scan is designed purely to update the btrfs-kernel-module's idea
> of what btrfs filesystems are available, and as such, it doesn't output
> anything, tho if there was some change that the kernel module didn't know
> about, a btrfs filesystem show, followed by a btrfs device scan and
> another btrfs filesystem show, would produce different results for the
> two show outputs.  (Meanwhile, show's --mounted and --all-devices options
> can change what's listed as well, and if you're interested in just one
> filesystem, you can feed that to show as well, to get output for just it,
> instead of for all btrfs the system knows about.  See the manpage...)

If "btrfs device scan" is user-space, then I think doing some output
is better then outputting nothing :) (perhaps with "-v" flag). If it
is kernel-space, then I agree that logging to dmesg is not very
evident (from perspective that user should remember where to look),
but I think has a value.

> Similarly, your btrfs scrub "was aborted after X seconds" issue is known,
> and I believe fixed in something that's not effectively ancient history,
> in terms of btrfs development.  So remarking on it simply highlights the
> fact that you're running ancient versions and complaining about long
> since fixed issues, instead of running current versions where at least
> your complaints might still have some validity.  And if you were running
> current and still had the problem, well at least I'd know that while I
> remember it being discussed, the fix could not have made it into current
> yet, since the bad output (which I don't recall seeing in older versions
> either, possibly because I run multiple small btrfs on partitioned ssds,
> so the other scrubs completed fast enough I didn't have a chance to see
> the aborted after one completed/aborted but before the others did) would
> then still be reported in current, tho I /think/ it has been fixed since
> it was discussed, but I didn't actually track that individual fix to see
> if it's in current or not, since I never saw the problem in my case
> anyway.

Thanks. I have carefully read changelog wiki page and found that:

btrfs-progs 4.2.2:
scrub: report status 'running' until all devices are finished

Idea concerning balance is listed on wiki page "Project ideas":

balance: allow to run it in background (fork) and report status periodically

So you're right: most of the issues are already recorded.
