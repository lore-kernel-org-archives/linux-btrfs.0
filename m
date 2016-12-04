Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64423 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750778AbcLDQCw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Dec 2016 11:02:52 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MTSKd-1c4WRZ1JwN-00SRYA for
 <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 17:02:50 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Date: Sun, 04 Dec 2016 17:02:48 +0100
Message-ID: <3405186.JXS0fWUK5s@thetick>
In-Reply-To: <CAJCQCtRUO1pByA3HXjbKRNVFmC9zcFvbLi22hAJS8VLafXnoew@mail.gmail.com>
References: <1776088.42rHLKPlSp@thetick> <4615776.dvopQOigxY@thetick> <CAJCQCtRUO1pByA3HXjbKRNVFmC9zcFvbLi22hAJS8VLafXnoew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1840480.HnM5js2kJX"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1840480.HnM5js2kJX
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

OK, so I tried a few things, to now avail, more below.

On Saturday 03 December 2016 15:56:45 Chris Murphy wrote:
> On Sat, Dec 3, 2016 at 2:46 PM, Marc Joliet <marcec@gmx.de> wrote:
> > On Saturday 03 December 2016 13:42:42 Chris Murphy wrote:
> >> On Sat, Dec 3, 2016 at 11:40 AM, Marc Joliet <marcec@gmx.de> wrote=
:
> >> > Hello all,
> >> >=20
> >> > I'm having some trouble with btrfs on a laptop, possibly due to
> >> > qgroups.
> >> > Specifically, some file system activities (e.g., snapshot creati=
on,
> >> > baloo_file_extractor from KDE Plasma) cause the system to hang f=
or up
> >> > to
> >> > about 40 minutes, maybe more.
> >>=20
> >> Do you get any blocked tasks kernel messages? If so, issue sysrq+w=

> >> during the hang, and then check the system log (dmesg may not cont=
ain
> >> everything if the command fills the message buffer). If it's a han=
g
> >> without any kernel messages, then issue sysrq+t.
> >>=20
> >> https://www.kernel.org/doc/Documentation/sysrq.txt
> >=20
> > As it's a rescue shell, I have only the one shell AFAIK, and it's o=
ccupied
> > by mount.  So I can't tell if there are dmesg entries, however, whe=
n this
> > happens during a normal running system, I never saw any dmesg entri=
es.=20
> > Anyway, I ran both.
>=20
> OK so this is root fs? I would try to work on it from another volume.=

> An advantage of openSUSE Tumbleweed is they claim to fully support
> qgroups, where upstream uses much more guarded language about its
> stability.
>=20
> Whereas last night's Fedora Rawhide has kernel 4.9-rc7 and btrfs-prog=
s
> 4.8.5.
> https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-201=
61203.
> n.0/compose/Workstation/x86_64/iso/Fedora-Workstation-netinst-x86_64-=
Rawhide
> -20161203.n.0.iso
>=20
> You can use dd to write the ISO to a USB stick, it supports BIOS and
> UEFI and Secure Boot.
>=20
> Troubleshooting > Rescue a Fedora system > option 3 to get to a shell=

> The sysrq+t and sysrq+w can be written out in their entirety with
> monotonic time using 'journalctl -b -k -o short-monotonic >
> kernelmessages.log'
>=20
> Unfortunately this is not a live system, so you can't (as far as I
> know) install script to more easily capture everything to a single
> file; 'btrfs check <dev> > btrfscheck.log' should capture most of the=

> output, but it misses a few early lines for some reason.
>=20
> And then scp those files to another system, or mount another stick an=
d
> copy locally.

That's a good idea, although I'll probably start with sysrescuecd (Linu=
x 4.8.5=20
and btrfs-progs 4.7.3), as I already have experience with it.

[After trying it]

Well, crap, I was able to get images of the file system (one sanitized)=
, but=20
mounting always fails with "device or resource busy" (with no correspon=
ding=20
dmesg output).  (Also, that drive's partitions weren't discovered on bo=
otup, I=20
had to run partprobe first.)  I never see that in the initramfs, so I'm=
 not=20
sure what's causing that.

Also, now the file system fails with the BUG I mentioned, see here:

[Sun Dec  4 12:27:07 2016] BUG: unable to handle kernel paging request =
at=20
fffffffffffffe10
[Sun Dec  4 12:27:07 2016] IP: [<ffffffff8131226f>]=20
qgroup_fix_relocated_data_extents+0x1f/0x2a0
[Sun Dec  4 12:27:07 2016] PGD 1c07067 PUD 1c09067 PMD 0=20
[Sun Dec  4 12:27:07 2016] Oops: 0000 [#1] PREEMPT SMP
[Sun Dec  4 12:27:07 2016] Modules linked in: crc32c_intel serio_raw
[Sun Dec  4 12:27:07 2016] CPU: 0 PID: 370 Comm: mount Not tainted 4.8.=
11-
gentoo #1
[Sun Dec  4 12:27:07 2016] Hardware name: FUJITSU LIFEBOOK A530/FJNBB06=
, BIOS=20
Version 1.19   08/15/2011
[Sun Dec  4 12:27:07 2016] task: ffff8801b1d90000 task.stack: ffff8801b=
1268000
[Sun Dec  4 12:27:07 2016] RIP: 0010:[<ffffffff8131226f>] =20
[<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x2a0
[Sun Dec  4 12:27:07 2016] RSP: 0018:ffff8801b126bcd8  EFLAGS: 00010246=

[Sun Dec  4 12:27:07 2016] RAX: 0000000000000000 RBX: ffff8801b10b3150 =
RCX:=20
0000000000000000
[Sun Dec  4 12:27:07 2016] RDX: ffff8801b20f24f0 RSI: ffff8801b2790800 =
RDI:=20
ffff8801b20f2460
[Sun Dec  4 12:27:07 2016] RBP: ffff8801b10bc000 R08: 0000000000020340 =
R09:=20
ffff8801b20f2460
[Sun Dec  4 12:27:07 2016] R10: ffff8801b48b7300 R11: ffffea0005dd0ac0 =
R12:=20
ffff8801b126bd70
[Sun Dec  4 12:27:07 2016] R13: 0000000000000000 R14: ffff8801b2790800 =
R15:=20
00000000b20f2460
[Sun Dec  4 12:27:07 2016] FS:  00007f97a7846780(0000)=20
GS:ffff8801bbc00000(0000) knlGS:0000000000000000
[Sun Dec  4 12:27:07 2016] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
[Sun Dec  4 12:27:07 2016] CR2: fffffffffffffe10 CR3: 00000001b12ae000 =
CR4:=20
00000000000006f0
[Sun Dec  4 12:27:07 2016] Stack:
[Sun Dec  4 12:27:07 2016]  0000000000000801 0000000000000801 ffff8801b=
20f2460=20
ffff8801b4aaa000
[Sun Dec  4 12:27:07 2016]  0000000000000801 ffff8801b20f2460 ffffffff8=
12c23ed=20
ffff8801b1d90000
[Sun Dec  4 12:27:07 2016]  0000000000000000 00ff8801b126bd18 ffff8801b=
10b3150=20
ffff8801b4aa9800
[Sun Dec  4 12:27:07 2016] Call Trace:
[Sun Dec  4 12:27:07 2016]  [<ffffffff812c23ed>] ?=20
start_transaction+0x8d/0x4e0
[Sun Dec  4 12:27:07 2016]  [<ffffffff81317913>] ?=20
btrfs_recover_relocation+0x3b3/0x440
[Sun Dec  4 12:27:07 2016]  [<ffffffff81292b2a>] ? btrfs_remount+0x3ca/=
0x560
[Sun Dec  4 12:27:07 2016]  [<ffffffff811bfc04>] ? shrink_dcache_sb+0x5=
4/0x70
[Sun Dec  4 12:27:07 2016]  [<ffffffff811ad473>] ? do_remount_sb+0x63/0=
x1d0
[Sun Dec  4 12:27:07 2016]  [<ffffffff811c9953>] ? do_mount+0x6f3/0xbe0=

[Sun Dec  4 12:27:07 2016]  [<ffffffff811c918f>] ?=20
copy_mount_options+0xbf/0x170
[Sun Dec  4 12:27:07 2016]  [<ffffffff811ca111>] ? SyS_mount+0x61/0xa0
[Sun Dec  4 12:27:07 2016]  [<ffffffff8169565b>] ?=20
entry_SYSCALL_64_fastpath+0x13/0x8f
[Sun Dec  4 12:27:07 2016] Code: 66 90 66 2e 0f 1f 84 00 00 00 00 00 41=
 57 41=20
56 41 55 41 54 55 53 48 83 ec 50 48 8b 46 08 4c 8b 6e 10 48 8b a8 f0 01=
 00 00=20
31 c0 <4d> 8b a5 10 fe ff ff f6 85 80 0c 00 00 01 74 09 80 be b0 05 00=20=

[Sun Dec  4 12:27:07 2016] RIP  [<ffffffff8131226f>]=20
qgroup_fix_relocated_data_extents+0x1f/0x2a0
[Sun Dec  4 12:27:07 2016]  RSP <ffff8801b126bcd8>
[Sun Dec  4 12:27:07 2016] CR2: fffffffffffffe10
[Sun Dec  4 12:27:07 2016] ---[ end trace bd51bbcfd10492f7 ]---

The main difference is that I remounted rw instead of unmounting and mo=
unting=20
again.  In any case, my hope was to mount the file system from the live=
=20
medium, then cancel the scrub from another terminal window.

Ah, but what does work is mounting a snapshot, in the sense that mount =
doesn't=20
fail.  However, it seems that the balance still continues, so I'm back =
at=20
square one.

> > Should I take photos?  That'll be annoying to do with all the scrol=
ling,
> > but I can do that if need be.
>=20
> I can't decipher it anyway, it's mainly for a dev who wanders across
> this thread or if you file a bug report. But you can get the complete=

> output using the method above.

Alright, I can try the fedora image now that sysrescuecd is a dead end.=
  I can=20
also try to insert the SSD in my desktop (it's a SATA device IIRC).

Oh, and I was wrong: the initramfs rescue shell *does* show dmesg outpu=
t as it=20
comes along, as I witnessed when inserting a USB stick.

> >> > After I next turned on the laptop, the balance resumed, causing =
bootup
> >> > to
> >> > fail, after which I remembered about the skip_balance mount opti=
on,
> >> > which
> >> > I
> >> > tried in a rescue shell from an initramfs.
> >>=20
> >> The file system is the root filesystem? If so, skip_balance may no=
t be
> >> happening soon enough. Use kernel parameter rootflags=3Dskip_balan=
ce
> >> which will apply this mount option at the very first moment the fi=
le
> >> system is mounted during boot.
> >=20
> > Yes, it's the root file system (there's that plus a swap partition)=
.  I
> > believe I tried rootflags, but I think it also failed, which is why=
 I'm
> > using a rescue shell now.  I can try it again, though, if anybody t=
hinks
> > that there's no point in waiting, especially if btrfs_scrub_pause i=
n the
> > btrfs- transaction call trace is significant.
>=20
> It sounds like it's resuming a scrub. That won't happen if you boot
> from an alternate volume. There's a scrub file found at
> /var/lib/btrfs/ that tracks the progress of scrubs for each btrfs
> volume - that directory with an inprogress scrub for your file system=

> is actually in the directory on that file system. If you haven't had
> luck with btrfs scrub cancel, you can just remove the files in that
> directory when you get a chance to rw mount the volume.

OK, I did try again with rootflags=3Dskip_balance, then remounting=20
rw,skip_balance, but that also fails, as expected.  If mount ever retur=
ned I=20
probably wouldn't have to remove those files, though ;) .

> >> > Since I couldn't use skip_balance, and logically can't destroy q=
groups
> >> > on
> >> > a
> >> > read-only file system, I decided to wait for a regular mount to =
finish.
> >> > That has been running since Tuesday, and I am slowly growing imp=
atient.
> >>=20
> >> Haha, no kidding! I think that's very patient.
> >=20
> > Heh :) . I've still got my main desktop (as ancient as it may be), =
so I'm
> > content with waiting for now, but I don't want to wait forever, esp=
ecially
> > if there might not even be a point.
>=20
> How big is the file system? Sounds like it's a single device volume o=
n
> a laptop so I'm guessing at most 1TB, and that'd mean at most 100GiB
> of metadata, which should mean around 15 minutes max to completely
> read and process all the metadata, and maybe a few hours to do a
> scrub. I'd bail after a few hours for sure.

It's only 108 GB.  I'm tolerating this low performance because it seems=
 to me=20
that it is tied to the same hangs I get at regular system run-time.

[...]
> >> > Also, should I be able to avoid reformatting: how do I properly =
disable
> >> > quota support?
> >>=20
> >> 'btrfs quota disable' is the only command that applies to this and=
 it
> >> requires rw mount; there's no 'noquota' mount option.
> >=20
> > OK, thanks.
> >=20
> > So what should I try next?  I'm sick at home, so I can spend more t=
ime on
> > this than usual.
>=20
> Well if it were me I'd use btrfs check to see what state it thinks th=
e
> file system is in. And then I'd do btrfs image to make a copy of the
> filesystem metadata both for the devs and also in case the next thing=
s
> make the problem worse, in theory the fs can be restored (or you can
> setup an overlay  if you prefer).

Well, btrfs check came back clean.  And as mentioned above, I was able =
to get=20
two images, but with btrfs-progs 4.7.3 (the version in sysrescuecd).  I=
 can=20
get different images from the initramfs (which I didn't think of earlie=
r,=20
sorry).

> And then I'd mount normally, possibly with skip_balance. Capture
> sysrq+t or +w or both. And then see if things get more sane if you
> disable quotas. If not, then I'd see if it'll tolerate 'btrfs qgroup
> destroy' on a few subvolumes. I'd basically use destroy and remove to=

> wipe away all the quotas - I don't know off hand if quotas needs to b=
e
> enabled for qgroup remove/destroy to work so you'll have to figure
> that out. And it might take a while for the command to complete, but
> I'd like to believe as you wipe away the qgroups, whatever qgroup
> related kernel accounting is happening will eventually stop.

skip_balance always fails.  The rest sounds good, though, but I'll have=
 to get=20
a live system to mount the FS.

> It sounds to me like there may be some legacy qgroup confusion going
> on, but I haven't tested this much at all, so you're kinda on the
> bleeding edge.

OK

I think I'll try mounting the SSD in my desktop first, then I'll try th=
e=20
fedora image.  Perhaps its newer kernel will help.

Thanks
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1840480.HnM5js2kJX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRD4oAAoJEL/Q5oYsiHj06kwP/0/vR/43yXHd8PyUw49WO4cC
qIQjxS4wc46Eb+TzbWL02MQY0D9mV7fy69BoyhNqvkSH4GTCBe/o9ukKjmpvnB9U
i0X+yuPdbwAJBXM+4YKO2Iv2sij6v1gT4ILEI6jZssVnjAmqzBENefY71XjHJs6a
/Kel5HeTXJ2Vq/BaBTqc/RxeNChc5poi8Lr9B6xaWsyfM+TvVsH4Dea2gHepH2Qc
xvAUs2j9tXvuVN1dceyYzmC4oSxGcWX2vRETL2bKGlqHEBUvm3opZVPirkejTkUE
H8KFA3Q45a6VixXBrD5y7j3vT5KGRyX4PpeEHj4WqEFi7JkbRLOGNwJpKrXiKT05
pQ56nEfOUTcDrjzu9QD5MGhHaEOlhCi9jTh4FvVL2vFOkEHj00OGI5tBTd/9cON5
Vmzy0UtT06pACOZnjG82iJ9ZTRb/val9f0HGc+Bu+XVU4El7K0d7dpYcAdZoA8Y1
YcJzZmsUnO3y63Os9lpArusM5bPo6pGQ9HrwBXsLgbWdk2lpjMvBZgq75DIm6BJ2
Xbt+KJnSlSMdOY+ZTFV49X4q4SjlMMofIcNhHTU1jdbtBgYhjdkoq/SAr8wOC9hx
405RZygUi0wxyliUzB552MhM39pogeu8bC8mA8HX5Z+Ifb8LJeApU1CtbuDt38AI
RasR0SFeDkIJWoKj3Pgh
=aXW0
-----END PGP SIGNATURE-----

--nextPart1840480.HnM5js2kJX--

