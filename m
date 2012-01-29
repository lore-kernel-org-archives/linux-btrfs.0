From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Sun, 29 Jan 2012 08:55:55 +0100
Message-ID: <201201290855.55973.Martin@lichtvoll.de>
References: <pan.2012.01.26.15.41.32@cox.net> <201201281308.52291.Martin@lichtvoll.de> <pan.2012.01.29.05.40.16@cox.net> (sfid-20120129_082149_634051_64CA7E59)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Duncan <1i5t5.duncan@cox.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.29.05.40.16@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 29. Januar 2012 schrieb Duncan:
> Martin Steigerwald posted on Sat, 28 Jan 2012 13:08:52 +0100 as=20
excerpted:
> > Am Donnerstag, 26. Januar 2012 schrieb Duncan:
[=E2=80=A6]
> >> 2)  The wiki indicates that btrfs-raid1 and raid-10 only mirror da=
ta
> >> 2- way, regardless of the number of devices.  On my now aging
> >> disks, I really do NOT like the idea of only 2-copy redundancy.=20
> >> I'm far happier with the 4-way redundancy, twice for the important
> >> stuff since it's in both working and backup mds altho they're on
> >> the same 4-disk set (tho I do have an external drive backup as
> >> well, but it's not kept as current).
> >>=20
> >> If true that's a real disappointment, as I was looking forward to
> >> btrfs- raid1 with checksummed integrity management.
> >=20
> > I didn=C2=B4t see anything like this.
> >=20
> > Would be nice to be able to adapt the redundancy degree where
> > possible.
>=20
> I posted the wiki reference in reply to someone else recently.  Let's
> see if I can find it again...
>=20
> Here it is.  This is from the bottom of the RAID and data replication
> section (immediately above "Balancing") on the SysadminGuide page:
>=20
>=20
> With RAID-1 and RAID-10, only two copies of each byte of data are
> written, regardless of how many block devices are actually in use on
> the filesystem.
> <<<<<

Yes, I have seen that too sometime ago. What I meant I didn=C2=B4t see =
anything=20
like this, is that I didn=C2=B4t see and option to set the number of co=
pies=20
anywhere yet - just like you.

> > An idea might be splitting into a delayed synchronisation mirror:
> >=20
> > Have two BTRFS RAID-1 - original and backup - and have a cronjob wi=
th
> > rsync mirroring files every hour or so. Later this might be replace=
d
> > by btrfs send/receive - or by RAID-1 with higher redundancy.
>=20
> That's an interesting idea.  However, as I run git kernels and don't
> accumulate a lot of uptime in any case, what I'd probably do is set u=
p
> the rsync to be run after a successful boot or mount of the filesyste=
m
> in question.  That way, if it ever failed to boot/mount for whatever
> reason, I could be relatively confident that the backup version
> remained intact and usable.
>=20
> That's actually /quite/ an interesting idea.  While I have working an=
d
> backup partitions for most stuff now, the process remains a manual on=
e,
> when I think the system is stable enough and enough time has passed
> since the last one, so the backup tends to be weeks or months old as
> opposed to days or hours.  This idea, modified to do it once per boot
> or mount or whatever, would keep the backups far more current and be
> much less hassle than the manual method I'm using now.  So even if I
> don't immediately switch to btrfs as I had thought I might, I can
> implement those scripts on the current system now, and then they'll b=
e
> ready and tested, needing little modification when I switch to btrfs,
> later.
>=20
> Thanks for the ideas! =3D:^)

Well you may even through in a snapshot in-between.

During boot before backup first snapshot or just after mount before=20
applications / services are started snapshot the source device. That=20
should give you a fairly consistent backup source. Then do the rsync=20
backup. Then snapshot the backup drive.

This way you can access older backups in case the original has gone bad=
=20
and has been backuped nonetheless.

I suggest a cronjob deleting old snapshots after some time again in ord=
er=20
to save space.

I want to replace my backup by something like this. There is also=20
rsnapshot for this case, but its error reporting I find sub optimal (no=
=20
rsync error messages included unless you run it on the command line wit=
h=20
option -v) and it uses hardlinks. Maybe could be adapted to use snapsho=
ts?
=20
> > Although BTRFS received a lot of fixes for ENOSPC issues I would be=
 a
> > bit reluctant with very small filesystems. But that is just a gut
> > feeling. So I do not know whether the option -M from above is teste=
d
> > widely. I doubt it.
>=20
> The only real small filesystem/raid I have is /boot, the 128 MB
> mentioned.  But in thinking it over a bit more since I wrote the
> initial post, I realized that given the 9-ish gigs of unallocated
> freespace at the end of the drives and the fact that most of the
> partitions are at a quarter-gig offset due to the 128 MB /boot and th=
e
> combined 128 MB BIOS and UEFI reserved partitions, I have room to
> expand both by several times, and making the total of all 3 (plus the
> initial few sectors of unpartitioned boot area) at the beginning of
> the drive an even 1 gig would give me even gig offsets for all the
> other partitions/raids as well.
>=20
> So I'll almost certainly expand /boot from 1/8 gig to 1/4 gig, and
> maybe to half or even 3/4 gig, just so the offsets for everything els=
e
> end up at even half or full gig boundaries, instead of the quarter-gi=
g
> I have now.  Between that and mixed-mode, I think the potential sizin=
g
> issue of /boot pretty much disappears.  One less problem to worry
> about. =3D:^)

About /boot: I do not see any specific need to convert boot to BTRFS as=
=20
well. Since kernels have version number attached to seem and can be=20
installed side by side, snapshotting /boot does not appear that importa=
nt=20
to me.

So you can just use Ext3 or with GRUB 2 or a patched GRUB 1, some distr=
os=20
do it, Ext4 for /boot in case BTRFS would not work out.
=20
> So the big sticking point now is two-copy-only data on btrfs-raid1,
> regardless of the number of drives, and sticking that on top of
> md/raid's a workaround, tho obviously I'd much rather a btrfs that
> could mirror both data and metadata an arbtrary number of ways instea=
d
> of just two. (There's some hints that metadata at least gets mirrored
> to all drives in a btrfs-raid1, tho nothing clearly states it one way
> or another.  But without data mirrored to all drives as well, I'm jus=
t
> not comfortable.)

I am with you there. Would be a nice feature.

The distributed filesystem Ceph which likes to be based on BTRFS volume=
s=20
has something like that, but Ceph might be overdoing it for your case ;=
).
=20
> OTOH, in general as I've looked closer, I've found btrfs to be rather
> farther away from exiting experimental than the prominent adoption by
> various distros had led me to believe, and without N-way mirroring
> raid, one of the two big features that I was looking forward to (the
> other being the data integrity checking) just vaporized in front of m=
y
> eyes, so I may well hold off on upgrading until, potentially, late
> this year instead of early this year, even if there are workarounds.=20
> I'm just not sure it's worth the cost of dealing with the still
> experimental aspects.

I decided for a partial approach.

My Amarok machine - an old ThinkPad T23 - is fully upgraded. On my main=
=20
laptop - a ThinkPad T520 with Intel SSD 320 - I have BTRFS as / and /ho=
me=20
still sits on Ext4.

I like this approach, cause I can gain experience with BTRFS, while not=
=20
putting to important data at risk. I can afford to loose /, since I hav=
e a=20
backup. But even with a backup of /home, I=C2=B4d rather not loose it, =
since I=20
only do it all 2-3 weeks cause its a manual thing for me at the moment.

At work I have a scratch data partition for Debian package development,=
=20
compiling stuff and other stuff I do not want to do within the NFS expo=
rt,=20
on BTRFS - that I backup to an Ext4 partition.

> And now that I'm here, I'll probably stay on the list as well, as I'v=
e
> already answered a number of questions posted by others, based on the
> material in the wiki and manpages, so I think I have something to
> contribute, and keeping up with developments will be far easier if I
> stay involved.

I encourage you, to start by putting something you can afford to loose =
on=20
BTRFS to gather practical experiences.

> Meanwhile, again and overall, thanks for the answer.  I did have most

You are welcome.

I do not know a definitve answer to the number of copies question, but =
I=20
believe that its not possible yet to set it.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
