Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D53CC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 11:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220B62054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 11:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfAQLSM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:18:12 -0500
Received: from [195.159.176.226] ([195.159.176.226]:34414 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfAQLSM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 06:18:12 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gk5eO-0000kT-4w
        for linux-btrfs@vger.kernel.org; Thu, 17 Jan 2019 12:15:56 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: applications hang on a btrfs spanning two partitions
Date:   Thu, 17 Jan 2019 11:15:49 +0000 (UTC)
Message-ID: <pan$b1351$9e1f5c6d$ffd38bb8$2fa1b304@cox.net>
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de>
        <2486006.dzvMEKkTBt@thetick> <pan$cd3b7$50e825ef$b5f86324$c489b494@cox.net>
        <2671305.1QxYQ0Ocz6@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; edad96df2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Marc Joliet posted on Tue, 15 Jan 2019 23:40:18 +0100 as excerpted:

> Am Dienstag, 15. Januar 2019, 09:33:40 CET schrieb Duncan:
>> Marc Joliet posted on Mon, 14 Jan 2019 12:35:05 +0100 as excerpted:
>> > Am Montag, 14. Januar 2019, 06:49:58 CET schrieb Duncan:
>> > 
>> >> ... noatime ...
>> > 
>> > The one reason I decided to remove noatime from my systems' mount
>> > options is because I use systemd-tmpfiles to clean up cache
>> > directories, for which it is necessary to leave atime intact
>> > (since caches are often Write Once Read Many).
>> 
>> Thanks for the reply.  I hadn't really thought of that use, but it
>> makes sense...

I really enjoy these "tips" subthreads.  As I said I hadn't really 
thought of that use, and seeing and understanding other people's 
solutions helps when I later find reason to review/change my own. =:^)

One example is an ssd brand reliability discussion from a couple years 
ago.  I had the main system on ssds then and wasn't planning on an 
immediate upgrade, but later on, I got tired of the media partition and a 
main system backup being on slow spinning rust, and dug out that ssd 
discussion to help me decide what to buy.  (Samsung 1 TB evo 850s, FWIW.)

> Specifically, I mean ~/.cache/ (plus a separate entry for ~/.cache/
> thumbnails/, since I want thumbnails to live longer):

Here, ~/.cache -> tmp/cache/ and ~/tmp -> /tmp/tmp-$USER/, plus 
XDG_CACHE_HOME=$HOME/tmp/cache/, with /tmp being tmpfs.

So as I said, user cache is on tmpfs.

Thumbnails... I actually did an experiment with the .thumbnails backed up 
elsewhere and empty, and found that with my ssds anyway, rethumbnailing 
was close enough to having them cached that it didn't really matter to my 
visual browsing experience.  So not only do I not mind thumbnails being 
on tmpfs, I actually have gwenview, my primary images browser, set to 
delete its thumbnails dir on close.

> I haven't bothered configuring /var/cache/, other than making it a
> subvolume so it's not a part of my snapshots (overriding the systemd
> default of creating it as a directory).  It appears to me that it's
> managed just fine by pre- existing tmpfiles.d snippets and by the
> applications that use it cleaning up after themselves (except for
> portage, see below).

Here, /var/cache/ is on /, which remains mounted read-only by default.  
The only things using it are package-updates related, and I obviously 
have to mount / rw for package updates, so it works fine.  (My sync 
script mounts the dedicated packages filesystem containing the repos, 
ccache, distdir, and binpkgs, and remounting / rw, and that's the first 
thing I run doing an update, so I don't even have to worry about doing 
the mounts manually.)

>> FWIW systemd here too, but I suppose it depends on what's being cached
>> and particularly on the expense of recreation of cached data.  I
>> actually have many of my caches (user/browser caches, etc) on tmpfs and
>> reboot several times a week, so much of the cached data is only
>> trivially cached as it's trivial to recreate/redownload.
> 
> While that sort of tmpfs hackery is definitely cool, my system is,
> despite its age, fast enough for me that I don't want to bother with
> that (plus I like my 8 GB of RAM to be used just for applications and
> whatever Linux decides to cache in RAM).  Also, modern SSDs live long
> enough that I'm not worried about wearing them out through my daily
> usage (which IIRC was a major reason for you to do things that way).

16 gigs RAM here, and except for building chromium (in tmpfs), I seldom 
fill it even with cache -- most of the time several gigs remain entirely 
empty.  With 8 gig I'd obviously have to worry a bit more about what I 
put in tmpfs, but given that I have the RAM space, I might as well use it.

When I setup this system I was upgrading from a 4-core (original 2-socket 
dual-core 3-digit Opterons, purchased in 2003 and ran until the caps 
started dying in 2011), this system being a 6-core fx-series, and based 
on the experience with the quad-core, I figured 12 gig RAM for the 6-
core.  But with pairs of RAM sticks for dual-channel, powers of two 
worked better, so it was 8 gig or 16 gig.  And given that I had worked 
with 8 gig on the quad-core, I knew that would be OK, but 12 gig would 
mean less cache dumping, so 16 gig it was.

And my estimate was right on.  Since 2011, I've typically run up to ~12 
gigs RAM used including cache, leaving ~4 gigs of the 16 entirely unused 
most of the time, tho I do use the full 16 gig sometimes when doing 
updates, since I have PORTAGE_TMPDIR set to tmpfs.

Of course since my purchase in 2011 I've upgraded to SSDs and RAM-based 
storage cache isn't as important as it was back on spinning rust, so for 
my routine usage 8 gig RAM with ssds would be just fine, today.

But building chromium on tmpfs is the exception.

Until recently I was running firefox, but for various reasons including 
firefox upstream requiring pulse-audio now so I can't just run upstream 
firefox binaries, and gentoo's firefox updates unfortunately sometimes 
being uncomfortably late for a security-minded user aware that their 
primary browser is the single most security-exposed application they run, 
and often build or run problems after gentoo /did/ have a firefox build, 
making reliably running a secure-as-possible firefox even *more* of a 
problem, a few months ago I switched to chromium.

And chromium is over a half-gig of compressed sources that expands to 
several gigs of build dir.  Put that in tmpfs along with the memory 
requirements of a multi-threaded build, with USE=jumbo-build and a couple 
gigs of other stuff (an X/kde-plasma session, building in a konsole 
window, often with chromium and minitube running) in memory too, and...

That 16 gig RAM isn't enough for that sort of chromium build. =:^(

So for the first time on the ssds, I reconfigured and rebuilt the kernel 
with swap support, and added a pair of 16-gig each swap partitions on the 
ssds, for now 16 gig RAM and 32 gig swap.

With the parallel-jobs cut down slightly via a package.env setting to 
better control memory usage, to -j7 from the normal -j8, and with 
PORTAGE_TMPDIR still pointed at tmpfs, I run about 16 gig into swap 
building chromium now.  So for that I could now use 32 gig of RAM.

Meanwhile, it's 2019, and this 2011 system's starting to feel a bit dated 
in other ways too, now, and I'm already at the ~8 years my last system 
lasted, so I'm thinking about upgrading.  I've upgraded to SSDs and to 
big-screen monitors (a 65-inch/165cm 4K TV as primary) on this system, 
but I've not done the CPU or memory upgrades on it that I did on the last 
one, and having to enable swap to build chromium just seems so last 
century.

So I'm thinking about upgrading later this year, probably to a zen-2-
based system with hardware spectre mitigations.

And I want at least 32-gig RAM when I do, depending on the number of 
cores/threads.  I'm figuring 4-gig/thread now, 4-core/8-thread minimum, 
which would be the 32-gig.  But 8-core/16-thread, 64-gig RAM, would be 
nice.

But I'm moving this spring and am busy with that first.  When that's done 
and I'm settled in the new place I'll see what my financials look like 
and go from there.

>> OTOH, running gentoo, my ccache and binpkg cache are seriously
>> CPU-cycle expensive to recreate, so you can bet those are _not_ tmpfs,
>> but OTTH, they're not managed by systemd-tmpfiles either.  (Ccache
>> manages its own cache and together with the source-tarballs cache and
>> git-managed repo trees along with binpkgs, I have a dedicated packages
>> btrfs containing all of them, so I eclean binpkgs and distfiles
>> whenever the 24-gigs space (48-gig total, 24-gig each on pair-device
>> btrfs raid1) gets too close to full, then btrfs balance with -dusage=
>> to reclaim partial chunks to unallocated.)
> 
> For distfiles I just have a weekly systemd timer that runs "eclean-dist
> -d" (I stopped using the buildpkg feature, so no eclean-pkg), and have
> moved both $DISTDIR and $PKGDIR to their future default locations in
> /var/cache/.  (They used to reside on my desktops HDD RAID1 as distinct
> subvolumes, but I recently bought a larger SSD, so I set up the above
> and got rid of two fstab entries.)

I like short paths.

So my packages filesystem mountpoint is /p, with /p/gentoo and /p/kde 
being my main repos, DISTDIR=/p/src, PKGDIR=/p/pkw (w=workstation, back 
when I had my 32-bit netbook and 32-bit chroot build image on the 
workstation too, I had its packages in pkn, IIRC), /p/linux for the linux 
git tree, /p/kpatch for local kernel patches, /p/cc for ccache, and /p/
initramfs for my (dracut-generate) initramfs.

And FWIW, /h is the home mountpoint, /lg the log mountpoint (with
/var/log -> /lg) /l the system-local dir (with /var/local -> /l) on /, 
/mnt for auxiliary mounts, /bk the root-backup mountpoint, etc.


You stopped using binpkgs?  I can't imagine doing that.  Not only does it 
make the occasional downgrade easier, older binpkgs come in handy for 
checking whether a file location moved in recent versions, looking up 
default configs and seeing how they've changed, checking the dates on 
them to know when I was running version X or whether I upgraded package Y 
before or after package Z, etc.

Of course I could use btrfs snapshotting for most of that and could get 
the other info in other ways, but I had this setup working and tested 
long before btrfs, and it seems less risky and easier to quantify and 
manage than btrfs snapshotting.  But surely that's because I /did/ have 
it up, running and tested, before btrfs, so it's old hat to me now.  If I 
were starting with it now, I imagine I might well find the btrfs 
snapshotting thing simpler to manage, and covering a broader use-case too.

>> tho I'd still keep the atime effects in mind and switch to noatime if
>> you end up in a recovery situation that requires writable mounting.
>> (Losing a device in btrfs raid1 and mounting writable in ordered to
>> replace it and rebalance comes to mind as one example of a
>> writable-mount recovery scenario where noatime until full
>> replace/rebalance/scrub completion would prevent unnecessary writes
>> until the raid1 is safely complete and scrub-verified again.)
> 
> That all makes sense.  I was going to argue that I can't imagine
> randomly reading files in a recovery situation, but eventually realized
> that "ls" would be enough to trigger a directory atime update.  So yeah,
> one should keep the above mind.

Not just ls, etc, either.  Consider manpage access, etc, as well.  Plus 
of course any executable binaries you run, the libs they load, 
scripts...  If atime's on, all those otherwise read-only accesses will 
trigger atime-update writes, and with btrfs, updating that bit of 
metadata copies and writes the entire updated metadata block, triggering 
an update and thus a COW of the metadata block tracking the one just 
written... all the way up the metadata tree.  In a recovery situation 
where every write is an additional risk, that's a lot of additional risk, 
all for not-so-necessary atime updates!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

