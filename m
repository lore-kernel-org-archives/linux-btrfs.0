Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50288 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbcLEJAZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 04:00:25 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M6RmV-1ccVzj1VQR-00yRXs for
 <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 10:00:21 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Date: Mon, 05 Dec 2016 10:00:13 +0100
Message-ID: <1959752.x5si3bfagL@thetick>
In-Reply-To: <CAJCQCtQsDCxtMujcutk=+fJauzfoKaE+GAMRtObPpZ4ukJE2UQ@mail.gmail.com>
References: <1776088.42rHLKPlSp@thetick> <3405186.JXS0fWUK5s@thetick> <CAJCQCtQsDCxtMujcutk=+fJauzfoKaE+GAMRtObPpZ4ukJE2UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart52891152.YSkCZCMNWP"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart52891152.YSkCZCMNWP
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Sunday 04 December 2016 11:52:40 Chris Murphy wrote:
> On Sun, Dec 4, 2016 at 9:02 AM, Marc Joliet <marcec@gmx.de> wrote:
> > Also, now the file system fails with the BUG I mentioned, see here:=

> >=20
> > [Sun Dec  4 12:27:07 2016] BUG: unable to handle kernel paging requ=
est at
> > fffffffffffffe10
> > [Sun Dec  4 12:27:07 2016] IP: [<ffffffff8131226f>]
> > qgroup_fix_relocated_data_extents+0x1f/0x2a0
> > [Sun Dec  4 12:27:07 2016] PGD 1c07067 PUD 1c09067 PMD 0
> > [Sun Dec  4 12:27:07 2016] Oops: 0000 [#1] PREEMPT SMP
> > [Sun Dec  4 12:27:07 2016] Modules linked in: crc32c_intel serio_ra=
w
> > [Sun Dec  4 12:27:07 2016] CPU: 0 PID: 370 Comm: mount Not tainted =
4.8.11-
> > gentoo #1
> > [Sun Dec  4 12:27:07 2016] Hardware name: FUJITSU LIFEBOOK A530/FJN=
BB06,
> > BIOS Version 1.19   08/15/2011
> > [Sun Dec  4 12:27:07 2016] task: ffff8801b1d90000 task.stack:
> > ffff8801b1268000 [Sun Dec  4 12:27:07 2016] RIP:
> > 0010:[<ffffffff8131226f>]
> > [<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x2a0
> > [Sun Dec  4 12:27:07 2016] RSP: 0018:ffff8801b126bcd8  EFLAGS: 0001=
0246
> > [Sun Dec  4 12:27:07 2016] RAX: 0000000000000000 RBX: ffff8801b10b3=
150
> > RCX:
> > 0000000000000000
> > [Sun Dec  4 12:27:07 2016] RDX: ffff8801b20f24f0 RSI: ffff8801b2790=
800
> > RDI:
> > ffff8801b20f2460
> > [Sun Dec  4 12:27:07 2016] RBP: ffff8801b10bc000 R08: 0000000000020=
340
> > R09:
> > ffff8801b20f2460
> > [Sun Dec  4 12:27:07 2016] R10: ffff8801b48b7300 R11: ffffea0005dd0=
ac0
> > R12:
> > ffff8801b126bd70
> > [Sun Dec  4 12:27:07 2016] R13: 0000000000000000 R14: ffff8801b2790=
800
> > R15:
> > 00000000b20f2460
> > [Sun Dec  4 12:27:07 2016] FS:  00007f97a7846780(0000)
> > GS:ffff8801bbc00000(0000) knlGS:0000000000000000
> > [Sun Dec  4 12:27:07 2016] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033 [Sun Dec  4 12:27:07 2016] CR2: fffffffffffffe10 C=
R3:
> > 00000001b12ae000 CR4: 00000000000006f0
> > [Sun Dec  4 12:27:07 2016] Stack:
> > [Sun Dec  4 12:27:07 2016]  0000000000000801 0000000000000801
> > ffff8801b20f2460 ffff8801b4aaa000
> > [Sun Dec  4 12:27:07 2016]  0000000000000801 ffff8801b20f2460
> > ffffffff812c23ed ffff8801b1d90000
> > [Sun Dec  4 12:27:07 2016]  0000000000000000 00ff8801b126bd18
> > ffff8801b10b3150 ffff8801b4aa9800
> > [Sun Dec  4 12:27:07 2016] Call Trace:
> > [Sun Dec  4 12:27:07 2016]  [<ffffffff812c23ed>] ?
> > start_transaction+0x8d/0x4e0
> > [Sun Dec  4 12:27:07 2016]  [<ffffffff81317913>] ?
> > btrfs_recover_relocation+0x3b3/0x440
> > [Sun Dec  4 12:27:07 2016]  [<ffffffff81292b2a>] ?
> > btrfs_remount+0x3ca/0x560 [Sun Dec  4 12:27:07 2016]=20
> > [<ffffffff811bfc04>] ? shrink_dcache_sb+0x54/0x70 [Sun Dec  4 12:27=
:07
> > 2016]  [<ffffffff811ad473>] ? do_remount_sb+0x63/0x1d0 [Sun Dec  4
> > 12:27:07 2016]  [<ffffffff811c9953>] ? do_mount+0x6f3/0xbe0 [Sun De=
c  4
> > 12:27:07 2016]  [<ffffffff811c918f>] ?
> > copy_mount_options+0xbf/0x170
> > [Sun Dec  4 12:27:07 2016]  [<ffffffff811ca111>] ? SyS_mount+0x61/0=
xa0
> > [Sun Dec  4 12:27:07 2016]  [<ffffffff8169565b>] ?
> > entry_SYSCALL_64_fastpath+0x13/0x8f
> > [Sun Dec  4 12:27:07 2016] Code: 66 90 66 2e 0f 1f 84 00 00 00 00 0=
0 41 57
> > 41 56 41 55 41 54 55 53 48 83 ec 50 48 8b 46 08 4c 8b 6e 10 48 8b a=
8 f0
> > 01 00 00 31 c0 <4d> 8b a5 10 fe ff ff f6 85 80 0c 00 00 01 74 09 80=
 be b0
> > 05 00 [Sun Dec  4 12:27:07 2016] RIP  [<ffffffff8131226f>]
> > qgroup_fix_relocated_data_extents+0x1f/0x2a0
> > [Sun Dec  4 12:27:07 2016]  RSP <ffff8801b126bcd8>
> > [Sun Dec  4 12:27:07 2016] CR2: fffffffffffffe10
> > [Sun Dec  4 12:27:07 2016] ---[ end trace bd51bbcfd10492f7 ]---
>=20
> I can't parse this. Maybe someone else can. Do you get the same thing=
,
> or a different thing, if you do a normal mount rather than a remount?=


The call trace is of course a bit different, but in both cases the RIP =
line is=20
almost identical (if that even matters?).  Compare the line from my fir=
st=20
message:

"RIP [<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x2a8"=


with the newest line:

"RIP [<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x2a0"=


But I just remembered, I have one from trying to mount the top-level su=
bvolume=20
on my desktop:

[So Dez  4 18:45:19 2016] BUG: unable to handle kernel paging request a=
t=20
fffffffffffffe10
[So Dez  4 18:45:19 2016] IP: [<ffffffff812f1103>]=20
qgroup_fix_relocated_data_extents+0x33/0x2e0
[So Dez  4 18:45:19 2016] PGD 1a07067 PUD 1a09067 PMD 0=20
[So Dez  4 18:45:19 2016] Oops: 0000 [#1] PREEMPT SMP
[So Dez  4 18:45:19 2016] Modules linked in: joydev dummy iptable_filte=
r=20
ip_tables x_tables hid_logitech_hidpp hid_logitech_dj snd_hda_codec_hdm=
i=20
snd_hda_codec_analog snd_hda_codec_generic uvcvideo videobuf2_vmalloc=20=

videobuf2_memops videobuf2_v4l2 videobuf2_core videodev snd_usb_audio=20=

snd_hwdep snd_usbmidi_lib radeon i2c_algo_bit drm_kms_helper cfbfillrec=
t=20
syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea kvm=
_amd=20
kvm ttm irqbypass evdev drm k8temp backlight snd_ice1724 snd_ak4113 snd=
_pt2258=20
snd_hda_intel snd_i2c snd_ak4114 snd_hda_codec snd_ac97_codec snd_hda_c=
ore=20
ac97_bus snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_rawmidi snd_seq_device =
snd_pcm=20
forcedeth snd_timer snd rtc_cmos asus_atk0110 i2c_nforce2 i2c_core sg s=
r_mod=20
cdrom xhci_pci ata_generic ohci_pci xhci_hcd pata_amd pata_acpi ohci_hc=
d=20
ehci_pci
[So Dez  4 18:45:19 2016]  ehci_hcd
[So Dez  4 18:45:19 2016] CPU: 1 PID: 8545 Comm: mount Not tainted 4.8.=
12-
gentoo #1
[So Dez  4 18:45:19 2016] Hardware name: System manufacturer System Pro=
duct=20
Name/M2N-E, BIOS ASUS M2N-E ACPI BIOS Revision 1701 10/30/2008
[So Dez  4 18:45:19 2016] task: ffff88003d0a2100 task.stack: ffff88011a=
5e0000
[So Dez  4 18:45:19 2016] RIP: 0010:[<ffffffff812f1103>]  [<ffffffff812=
f1103>]=20
qgroup_fix_relocated_data_extents+0x33/0x2e0
[So Dez  4 18:45:19 2016] RSP: 0018:ffff88011a5e3a38  EFLAGS: 00010246
[So Dez  4 18:45:19 2016] RAX: 0000000000000000 RBX: ffff88007d3d8690 R=
CX:=20
0000000000000000
[So Dez  4 18:45:19 2016] RDX: ffff880138be2ef0 RSI: ffff88007c3e3800 R=
DI:=20
ffff880138be2e60
[So Dez  4 18:45:19 2016] RBP: ffff88007b69a000 R08: 000000000001f0d0 R=
09:=20
ffff880138be2e60
[So Dez  4 18:45:19 2016] R10: ffff88007d3d82a0 R11: ffffea0001f4f600 R=
12:=20
ffff88011a5e3ad0
[So Dez  4 18:45:19 2016] R13: 0000000000000000 R14: ffff88007c3e3800 R=
15:=20
0000000038be2e60
[So Dez  4 18:45:19 2016] FS:  00007fe24229c780(0000)=20
GS:ffff88013fc80000(0000) knlGS:0000000000000000
[So Dez  4 18:45:19 2016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005=
0033
[So Dez  4 18:45:19 2016] CR2: fffffffffffffe10 CR3: 000000010b3e8000 C=
R4:=20
00000000000006e0
[So Dez  4 18:45:19 2016] Stack:
[So Dez  4 18:45:19 2016]  0000000000000801 0000000000000801 ffff880138=
be2e60=20
ffff88005b94f000
[So Dez  4 18:45:19 2016]  0000000000000801 ffff880138be2e60 ffffffff81=
29dd8c=20
ffff88003d0a2100
[So Dez  4 18:45:19 2016]  0000000000000000 00ff88011a5e3a78 ffff88007d=
3d8690=20
ffff88005b94a800
[So Dez  4 18:45:19 2016] Call Trace:
[So Dez  4 18:45:19 2016]  [<ffffffff8129dd8c>] ? start_transaction+0x8=
c/0x4e0
[So Dez  4 18:45:19 2016]  [<ffffffff812f69df>] ?=20
btrfs_recover_relocation+0x3bf/0x440
[So Dez  4 18:45:19 2016]  [<ffffffff8129a562>] ? open_ctree+0x2182/0x2=
6a0
[So Dez  4 18:45:19 2016]  [<ffffffff81383769>] ? snprintf+0x39/0x40
[So Dez  4 18:45:19 2016]  [<ffffffff8126d362>] ? btrfs_mount+0xd32/0xe=
40
[So Dez  4 18:45:19 2016]  [<ffffffff81132e41>] ? pcpu_alloc+0x321/0x61=
0
[So Dez  4 18:45:19 2016]  [<ffffffff81179915>] ? mount_fs+0x45/0x180
[So Dez  4 18:45:19 2016]  [<ffffffff811941e1>] ? vfs_kern_mount+0x71/0=
x130
[So Dez  4 18:45:19 2016]  [<ffffffff8126c7c2>] ? btrfs_mount+0x192/0xe=
40
[So Dez  4 18:45:19 2016]  [<ffffffff81132e41>] ? pcpu_alloc+0x321/0x61=
0
[So Dez  4 18:45:19 2016]  [<ffffffff81179915>] ? mount_fs+0x45/0x180
[So Dez  4 18:45:19 2016]  [<ffffffff811941e1>] ? vfs_kern_mount+0x71/0=
x130
[So Dez  4 18:45:19 2016]  [<ffffffff81196df5>] ? do_mount+0x1e5/0xc00
[So Dez  4 18:45:19 2016]  [<ffffffff8117264f>] ?=20
__check_object_size+0x13f/0x1ed
[So Dez  4 18:45:19 2016]  [<ffffffff8112eaa3>] ? memdup_user+0x53/0x80=

[So Dez  4 18:45:19 2016]  [<ffffffff81197af5>] ? SyS_mount+0x75/0xc0
[So Dez  4 18:45:19 2016]  [<ffffffff8160275b>] ?=20
entry_SYSCALL_64_fastpath+0x13/0x8f
[So Dez  4 18:45:19 2016] Code: 50 48 89 6c 24 58 4c 89 64 24 60 4c 89 =
6c 24=20
68 4c 89 74 24 70 4c 89 7c 24 78 48 8b 46 08 4c 8b 6e 10 48 8b a8 f0 01=
 00 00=20
31 c0 <4d> 8b a5 10 fe ff ff f6 85 80 0c 00 00 01 74 09 80 be b0 05 00=20=

[So Dez  4 18:45:19 2016] RIP  [<ffffffff812f1103>]=20
qgroup_fix_relocated_data_extents+0x33/0x2e0
[So Dez  4 18:45:19 2016]  RSP <ffff88011a5e3a38>
[So Dez  4 18:45:19 2016] CR2: fffffffffffffe10
[So Dez  4 18:45:19 2016] ---[ end trace 5c46f8b4f82b998c ]---

> > Ah, but what does work is mounting a snapshot, in the sense that mo=
unt
> > doesn't fail.  However, it seems that the balance still continues, =
so I'm
> > back at square one.
>=20
> Interesting that mounting a subvolume directly works, seeing as that'=
s
> just a bind mount behind the scene. But maybe there's something wrong=

> in the top level subvolume that's being skipped when mounting a
> subvolume directly.

Yeah, however, just to be clear, that's a new problem, and one that mig=
ht be=20
temporary (I had the same subvolume fail, too, only to "work" the next =
try).

> Are you mounting with skip_balance mount option?

When I try that, I get the BUGs mentioned above.  When I'm at the point=
 where=20
mount "works", but hangs, I do *not* use it.

> And how do you know
> that it's a balance continuing? What do you get for 'btrfs balance
> status' for this volume? Basically I'm asking if you're sure there's =
a
> balance happening.

I'm not 100% positive, but the behaviour I'm seeing matches my previous=
=20
experience.  At least, I vaguely remember being in a similar situation =
with=20
the laptop back when I first noticed the performance issues, but I can'=
t=20
remember any details.  I *think* the balance finished in a rescue shell=
, too,=20
after an hour or so (it was only a data balance, I think).

> The balance itself is not bad, it's just that it
> slows everything down astronomically. That's the main reason why you'=
d
> like to skip it or cancel it. Instead of balancing it might be doing
> some sort of cleanup. Either 'top' or 'perf top' might give a clue
> what's going on if 'btrfs balance status' doesn't show a balance is
> happening, and yet the drive is super busy as if a balance is
> happening.

Sadly, "balance status" won't work, because it operates on mounted file=
=20
systems, and mount never finishes.  So "balance cancel" won't work, eit=
her.

Also, I can't just watch drive activity, because the symptom of the=20
performance issue is that there is none for a long time, with one or mo=
re=20
intermittent bursts of activity, during which the system becomes (parti=
ally)=20
responsive, at least temporarily.

But thanks for reminding me of perf top.  Is there any particularly=20
recommended invocation, e.g., specific events it should watch?

Actually, I just randomly tried "perf top -e btrfs:*", which actually w=
orks :D=20
.  I see, amongst others:

253 btrfs:btrfs_qgroup_release_data
1K btrfs:btrfs_qgroup_free_delayed_ref

Sadly, there do not seem to be any balance related events.

Also, I've been running "dstat -df" the entire time, and it shows *no*=20=

activity whatsoever going on.

> Also, if you boot from alternate media, scrub resuming should not
> happen because the progress file for scrub is in /var/lib/btrfs, ther=
e
> is no metadata on the Btrfs volume itself that indicates it's being
> scrubbed or what the progress is.
>
> > Well, btrfs check came back clean.  And as mentioned above, I was a=
ble to
> > get two images, but with btrfs-progs 4.7.3 (the version in sysrescu=
ecd).=20
> > I can get different images from the initramfs (which I didn't think=
 of
> > earlier, sorry).
>=20
> 'btrfs check' using btrfs-progs 4.8.2 or higher came back clean? That=

> sounds like a bug. You're having quota related problems (at least it'=
s
> a contributing factor) but btrfs check says clean, while the kernel i=
s
> getting confused. So either 'btrfs check' is correct that there are n=
o
> problems, and there's a kernel bug resulting in confusion; or the
> check is missing something, and that's why the kernel is mishandling
> it. In either case, there's a kernel bug.

Yeah, I was sure it was a bug when I first had the laptop hang for 30 m=
inutes=20
for no apparent reason ;) .  But I see what you mean.  Whether it's a b=
alance=20
or not, *something* is going on, though, as per the perf events shown a=
bove=20
(none of my other btrfs file systems have quota support enabled, so it =
must be=20
from=20the laptop drive).

> So yeah for sure you'll want a sanitized btrfs-image captured for the=

> developers to look at; put it somewhere like Google Drive or wherever=

> they can grab it. And put the URL in this thread, and/or also file a
> bug about this problem with the URL to the image included.

OK, I'll post the URLs once the images are uploaded.  (I had Dropbox pu=
blic=20
URLs right before my desktop crashed -- see below -- but now dropbox-cl=
i=20
doesn't want to create them.)

> Looking at 4.9 there's not many qgroup.c changes, but there's a pile
> of other changes, per usual. So even though the problem seems like
> it's qgroup related, it might actually be some other problem that the=
n
> also triggers qgroup messages.

Yeah, Qu responded in the meantime, and there are fixes available, but =
not=20
merged yet.

Also: I would have sent this mail yesterday, but my desktop hung in the=
 same=20
way my laptop hangs, but it never recovered.  I waited until this morni=
ng, but=20
it was still unresponsive.  After forcing a reboot, the logs showed not=
hing,=20
i.e., they stopped around the time of the hang.  But this time, running=
 "mount=20
=2Do subvol=3D/.snapshots/rootfs.201611260202,skip_balance /dev/sdd1 /mnt=
/tmp"=20
eventually resulted in a recursive fault (I didn't have a camera with m=
e,=20
sorry).  Now I've rebooted normally, and my Email draft was still intac=
t=20
*phew*.

=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup
--nextPart52891152.YSkCZCMNWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYRSydAAoJEL/Q5oYsiHj0zh4P/j5lKS7k220RUQt7RFLueZpl
56n3ct9ednDV5Cos9JzazrjPci4xzHEycAkws2SK2GdYDGcBT8c+BwGo74HSMYoz
qf/I8Iap7zQ7nmBHGnsLDYp5H1e7umKrZZ8XPlnsBeJ298364H02gtbx5mAqrcmC
Tl+iy5NXPhYL1tfBZBr4BtLLXef/irO781kIiRCRSymJDPIMoXi4uvoaeBkDB6kN
4RQMJnSufGR6Ez7rWfJEZuBVpf4g1t5LDQjCwC7QX1U8xtRyMCJxsm8lVNlgJFHm
qOjeJumXMWM3Uxmds8iCTbYYEIJMySNVdCTJYrsq1//4flsDFfOib7O17fNzZOeR
K0taXvE8hPQwM6zl8zqnnKb83m1hCVmydbukx6QXeotirPfv3CbhJrkQCMes7WWd
KbKQNkZ3gbV8f3ZEsRrpamR2rMMhJl9f1/z62Wy3/2e36CV4N3XO5ypVn8jjOp2j
wYbEhLB9AdnUXkiUKEK2bwx08yqjMJiaATv0efBn988tmdyLexZEaIyZxWtUEGm0
96OVPf/+5Le5Xhom/UeV/p89Z3jP3RAJFWsNT6CfPqGADqo9asATJtTO8vPj/ary
dsGWpkM6oGnun3ztfMZI7rnKqMKTFCvWj0LwmHnV/zJPyQB6V4M7+OphxoYB6Cno
la0Yb1XbSApr4X9wN3yp
=cig9
-----END PGP SIGNATURE-----

--nextPart52891152.YSkCZCMNWP--

