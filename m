Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39521 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbeIKQ2g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:28:36 -0400
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0Mb8MV-1gIjqj3aih-00Kgaw for
 <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 13:29:38 +0200
From: Stefan K <shadow_7@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Date: Tue, 11 Sep 2018 13:29:38 +0200
Message-ID: <2964682.kQZMURGi49@t460-skr>
In-Reply-To: <pan$3058a$74a39424$67b0d289$23de5876@cox.net>
References: <2685207.fCDoYgCM7x@t460-skr> <pan$3058a$74a39424$67b0d289$23de5876@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

wow, holy shit, thanks for this extended answer!

> The first thing to point out here again is that it's not btrfs-specific.  
so that mean that every RAID implemantation (with parity) has such Bug? I'm looking a bit, it looks like that ZFS doesn't have a write hole. And it _only_ happens when the server has a ungraceful shutdown, caused by poweroutage? So that mean if I running btrfs raid5/6 and I've no poweroutages I've no problems?

>  it's possible to specify data as raid5/6 and metadata as raid1
does some have this in production? ZFS btw have 2 copies of metadata by default, maybe it would also be an option or btrfs?
in this case you think 'btrfs fi balance start -mconvert=raid1 -dconvert=raid5 /path ' is safe at the moment?

> That means small files and modifications to existing files, the ends of large files, and much of the 
> metadata, will be written twice, first to the log, then to the final location. 
that sounds that the performance will go down? So far as I can see btrfs can't beat ext4 or btrfs nor zfs and then they will made it even slower?

thanks in advanced!

best regards
Stefan



On Saturday, September 8, 2018 8:40:50 AM CEST Duncan wrote:
> Stefan K posted on Fri, 07 Sep 2018 15:58:36 +0200 as excerpted:
> 
> > sorry for disturb this discussion,
> > 
> > are there any plans/dates to fix the raid5/6 issue? Is somebody working
> > on this issue? Cause this is for me one of the most important things for
> > a fileserver, with a raid1 config I loose to much diskspace.
> 
> There's a more technically complete discussion of this in at least two 
> earlier threads you can find on the list archive, if you're interested, 
> but here's the basics (well, extended basics...) from a btrfs-using-
> sysadmin perspective.
> 
> "The raid5/6 issue" can refer to at least three conceptually separate 
> issues, with different states of solution maturity:
> 
> 1) Now generally historic bugs in btrfs scrub, etc, that are fixed (thus 
> the historic) in current kernels and tools.  Unfortunately these will 
> still affect for some time many users of longer-term stale^H^Hble distros 
> who don't update using other sources for some time, as because the raid56 
> feature wasn't yet stable at the lock-in time for whatever versions they 
> stabilized on, they're not likely to get the fixes as it's new-feature 
> material.
> 
> If you're using a current kernel and tools, however, this issue is 
> fixed.  You can look on the wiki for the specific versions, but with the 
> 4.18 kernel current latest stable, it or 4.17, and similar tools versions 
> since the version numbers are synced, are the two latest release series, 
> with the two latest release series being best supported and considered 
> "current" on this list.
> 
> Also see...
> 
> 2) General feature maturity:  While raid56 mode should be /reasonably/ 
> stable now, it remains one of the newer features and simply hasn't yet 
> had the testing of time that tends to flush out the smaller and corner-
> case bugs, that more mature features such as raid1 have now had the 
> benefit of.
> 
> There's nothing to do for this but test, report any bugs you find, and 
> wait for the maturity that time brings.
> 
> Of course this is one of several reasons we so strongly emphasize and 
> recommend "current" on this list, because even for reasonably stable and 
> mature features such as raid1, btrfs itself remains new enough that they 
> still occasionally get latent bugs found and fixed, and while /some/ of 
> those fixes get backported to LTS kernels (with even less chance for 
> distros to backport tools fixes), not all of them do and even when they 
> do, current still gets the fixes first.
> 
> 3) The remaining issue is the infamous parity-raid write-hole that 
> affects all parity-raid implementations (not just btrfs) unless they take 
> specific steps to work around the issue.
> 
> The first thing to point out here again is that it's not btrfs-specific.  
> Between that and the fact that it *ONLY* affects parity-raid operating in 
> degraded mode *WITH* an ungraceful-shutdown recovery situation, it could 
> be argued not to be a btrfs issue at all, but rather one inherent to 
> parity-raid mode and considered an acceptable risk to those choosing 
> parity-raid because it's only a factor when operating degraded, if an 
> ungraceful shutdown does occur.
> 
> But btrfs' COW nature along with a couple technical implementation 
> factors (the read-modify-write cycle for incomplete stripe widths and how 
> that risks existing metadata when new metadata is written) does amplify 
> the risk somewhat compared to that seen with the same write-hole issue in 
> various other parity-raid implementations that don't avoid it due to 
> taking write-hole avoidance countermeasures.
> 
> 
> So what can be done right now?
> 
> As it happens there is a mitigation the admin can currently take -- btrfs 
> allows specifying data and metadata modes separately, and even where 
> raid1 loses too much space to be used for both, it's possible to specify 
> data as raid5/6 and metadata as raid1.  While btrfs raid1 only covers 
> loss of a single device, it doesn't have the parity-raid write-hole as 
> it's not parity-raid, and for most use-cases at least, specifying raid1 
> for metadata only, while raid5 for data, should strictly limit both the 
> risk of the parity-raid write-hole as it'll be limited to data which in 
> most cases will be full-stripe writes and thus not subject to the 
> problem, and the size-doubling of raid1 as it'll be limited to metadata.
> 
> Meanwhile, arguably, for a sysadmin properly following the sysadmin's 
> first rule of backups, that the true value of data isn't defined by 
> arbitrary claims, but by the number of backups it is considered worth the 
> time/trouble/resources to have of that data, it's a known parity-raid 
> risk specifically limited to the corner-case of having an ungraceful 
> shutdown *WHILE* already operating degraded, and as such, it can be 
> managed along with all the other known risks to the data, including admin 
> fat-fingering, the risk that more devices will go out than the array can 
> tolerate, the risk of general bugs affecting the filesystem or other 
> storage-function related code, etc.
> 
> IOW, in the context of the admin's first rule of backups, no matter the 
> issue, raid56 write hole or whatever other issue of the many possible, 
> loss of data can *never* be a particularly big issue, because by 
> definition, in *all* cases, what was of most value was saved, either the 
> data if it was defined as valuable enough to have a backup, or the time/
> trouble/resources that would have otherwise gone into making that backup, 
> if the data wasn't worth it to have a backup.
> 
> (One nice thing about this rule is that it covers the loss of whatever 
> number of backups along with the working copy just as well as it does 
> loss of just the working copy.  No matter the number of backups, the 
> value of the data is either worth having one more backup, just in case, 
> or it's not.  Similarly, the rule covers the age of the backup and 
> updates nicely as well, as that's just a subset of the original problem, 
> with the value of the data in the delta between the last backup and the 
> working copy now being the deciding factor, either the risk of losing it 
> is worth updating the backup, or not, same rule, applied to a data 
> subset.)
> 
> So from an admin's perspective, in practice, while not entirely stable 
> and mature yet, and with the risk of the already-degraded crash-case 
> corner-case that's already known to apply to parity-raid unless 
> mitigation steps are taken, btrfs raid56 mode should now be within the 
> acceptable risk range already well covered by the risk mitigation of 
> following an appropriate backup policy, optionally combined with the 
> partial write-hole-mitigation strategy of doing data as raid5/6, with 
> metadata as raid1.
> 
> 
> OK, but what is being done to better mitigate the parity-raid write-hole 
> problem for the future, and when might we be able to use that mitigation?
> 
> There are a number of possible mitigation strategies, and there's 
> actually code being written using one of them right now, tho it'll be (at 
> least) a few kernel cycles until it's considered complete and stable 
> enough for mainline, and as mentioned in #2 above, even after that it'll 
> take some time to mature to reasonable stability.
> 
> The strategy being taken is partial-stripe-write logging.  Full stripe 
> writes aren't affected by the write hole and (AFAIK) won't be logged, but 
> partial stripe writes are read-modify-write and thus write-hole 
> succeptible, and will be logged.  That means small files and 
> modifications to existing files, the ends of large files, and much of the 
> metadata, will be written twice, first to the log, then to the final 
> location.  In the event of a crash, on reboot and mount, anything in the 
> log can be replayed, thus preventing the write hole.
> 
> As for the log, it'll be written using a new 3/4-way-mirroring mode, 
> basically raid1 but mirrored more than two ways (which current btrfs 
> raid1 is limited to, even with more than two devices in the filesystem), 
> thus handling the loss of multiple devices.
> 
> That's actually what's being developed ATM, the 3/4-way-mirroring mode, 
> which will be available for other uses as well.
> 
> Actually, that's what I'm personally excited about, as years ago, when I 
> first looked into btrfs, I was running older devices in mdraid's raid1 
> mode, which does N-way mirroring.  I liked the btrfs data checksumming 
> and scrubbing ability, but with the older devices I didn't trust having 
> just two-way-mirroring and wanted at least 3-way-mirroring, so back at 
> that time I skipped btrfs and stayed with mdraid.  Later I upgraded to 
> ssds and decided btrfs-raid1's two-way-mirroring was sufficient, but when 
> one of the ssds ended up prematurely bad and needed replaced, I would 
> have sure felt a bit better before I got the replacement done, if I still 
> had good two-way-mirroring even with the bad device.
> 
> So I'm still interested in 3-way-mirroring and would probably use it for 
> some things now, were it available and "stabilish", and I'm eager to see 
> that code merged, not for the parity-raid logging it'll also be used for, 
> but for the reliability of 3-way-mirroring.  Tho I'll probably wait at 
> least 2-5 kernel cycles after introduction and see how it stabilizes 
> before actually considering it stable enough to use myself, because even 
> tho I do follow the backups policy above, just because I'm not 
> considering the updated-data delta worth an updated backup yet, doesn't 
> mean I want to unnecessarily risk having to redo the work since the last 
> backup, which means choosing the newer 3-way-mirroring over the more 
> stable and mature existing raid1 2-way-mirroring isn't going to be worth 
> it to me until the 3-way-mirroring has at least a /few/ kernel cycles to 
> stabilize.
> 
> And I'd recommend the same caution with the new raid5/6 logging mode 
> built on top of that multi-way-mirroring, once it's merged as well.  
> Don't just jump on it immediately after merge unless you're deliberately 
> doing so to help test for bugs and get them fixed and the feature 
> stabilized as soon as possible.  Wait a few kernel cycles, follow the 
> list to see how the feature's stability is coming, and /then/ use it, 
> after factoring in its remaining then still new and less mature 
> additional risk into your backup risks profile, of course.
> 
> Time?  Not a dev but following the list and obviously following the new 3-
> way-mirroring, I'd say probably not 4.20 (5.0?) for the new mirroring 
> modes, so 4.21/5.1 more reasonably likely (if all goes well, could be 
> longer), probably another couple cycles (if all goes well) after that for 
> the parity-raid logging code built on top of the new mirroring modes, so 
> perhaps a year (~5 kernel cycles) to introduction for it.  Then wait 
> however many cycles until you think it has stabilized.  Call that another 
> year.  So say about 10 kernel cycles or two years.  It could be a bit 
> less than that, say 5-7 cycles, if things go well and you take it before 
> I'd really consider it stable enough to recommend, but given the 
> historically much longer than predicted development and stabilization 
> times for raid56 already, it could just as easily end up double that, 4-5 
> years out, too.
> 
> But raid56 logging mode for write-hole mitigation is indeed actively 
> being worked on right now.  That's what we know at this time.
> 
> And even before that, right now, raid56 mode should already be reasonably 
> usable, especially if you do data raid5/6 and metadata raid1, as long as 
> your backup policy and practice is equally reasonable.
> 
> 
