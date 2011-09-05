From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Mon, 05 Sep 2011 14:47:17 +0100
Message-ID: <1315230442.2001.4.camel@picard>
References: <1314582311.2724.4.camel@picard>
	 <4E5C82E8.9090400@cn.fujitsu.com> <1314694069.29963.5.camel@picard>
	 <1314962312.1858.2.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-DipEOJUrLKY6Z19HkU5k"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314962312.1858.2.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>


--=-DipEOJUrLKY6Z19HkU5k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-09-02 at 12:18 +0100, Maciej Marcin Piechotka wrote:
> On Tue, 2011-08-30 at 09:47 +0100, Maciej Marcin Piechotka wrote:
> > On Tue, 2011-08-30 at 14:27 +0800, Miao Xie wrote:
> > > On mon, 29 Aug 2011 02:45:07 +0100, Maciej Marcin Piechotka wrote:
> > > > I receive the bug when I try to snapshot from fcron:
> > > >=20
> > > > 2011-08-29T02:00:46.529238+01:00 picard kernel: [ 4155.444476]
> > > > ------------[ cut here ]------------
> > > > 2011-08-29T02:00:46.529253+01:00 picard kernel: [ 4155.444490] kern=
el
> > > > BUG at fs/btrfs/inode.c:2299!
> > > > 2011-08-29T02:00:46.529256+01:00 picard kernel: [ 4155.444498] inva=
lid
> > > > opcode: 0000 [#1] PREEMPT SMP=20
> > > > 2011-08-29T02:00:46.529259+01:00 picard kernel: [ 4155.444506] CPU =
1=20
> > > > 2011-08-29T02:00:46.529264+01:00 picard kernel: [ 4155.444508] Modu=
les
> > > > linked in: microcode reiserfs btrfs zlib_deflate libcrc32c arc4
> > > > snd_hda_codec_conexant iwlagn mac80211 uvcvideo videodev
> > > > v4l2_compat_ioctl32 cfg80211 snd_hda_intel snd_hda_codec snd_hwdep
> > > > snd_pcm snd_timer snd thinkpad_acpi soundcore snd_page_alloc hwmon
> > > > rfkill nvram e1000e zram(C) rtc_cmos tp_smapi thinkpad_ec psmouse
> > > > fscache kvm_intel kvm configs ipv6 autofs4 usbhid uhci_hcd firewire=
_ohci
> > > > firewire_core sdhci_pci ehci_hcd crc_itu_t sdhci mmc_core sd_mod us=
bcore
> > > > sr_mod cdrom
> > > > 2011-08-29T02:00:46.529267+01:00 picard kernel: [ 4155.444569]=20
> > > > 2011-08-29T02:00:46.529270+01:00 picard kernel: [ 4155.444576] Pid:
> > > > 3167, comm: btrfs Tainted: P         C  3.0.3-gentoo #1 LENOVO
> > > > 2242CTO/2242CTO
> > > > 2011-08-29T02:00:46.529274+01:00 picard kernel: [ 4155.444586] RIP:
> > > > 0010:[<ffffffffa031339b>]  [<ffffffffa031339b>] btrfs_orphan_del
> > > > +0x8d/0xa9 [btrfs]
> > > > 2011-08-29T02:00:46.529276+01:00 picard kernel: [ 4155.444611] RSP:
> > > > 0000:ffff880111c21b58  EFLAGS: 00010282
> > > > 2011-08-29T02:00:46.529279+01:00 picard kernel: [ 4155.444619] RAX:
> > > > 00000000fffffffe RBX: ffff88011141bd60 RCX: 0000000000001000
> > > > 2011-08-29T02:00:46.529289+01:00 picard kernel: [ 4155.444626] RDX:
> > > > 000000000000000f RSI: ffff880110c8d250 RDI: ffff880134092d80
> > > > 2011-08-29T02:00:46.529292+01:00 picard kernel: [ 4155.444634] RBP:
> > > > 0000000000000000 R08: ffff880111c21a30 R09: 0000000000000011
> > > > 2011-08-29T02:00:46.529297+01:00 picard kernel: [ 4155.444642] R10:
> > > > 00000000000001dc R11: 0000000000000286 R12: ffff880136866300
> > > > 2011-08-29T02:00:46.529299+01:00 picard kernel: [ 4155.444650] R13:
> > > > ffff880130cac800 R14: 0000000000000001 R15: ffff880130cacb88
> > > > 2011-08-29T02:00:46.529302+01:00 picard kernel: [ 4155.444658] FS:
> > > > 00007f126715a740(0000) GS:ffff88013bc80000(0000) knlGS:000000000000=
0000
> > > > 2011-08-29T02:00:46.529304+01:00 picard kernel: [ 4155.444666] CS: =
 0010
> > > > DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > 2011-08-29T02:00:46.529307+01:00 picard kernel: [ 4155.444673] CR2:
> > > > 00007f5149eb7008 CR3: 000000009caca000 CR4: 00000000000406e0
> > > > 2011-08-29T02:00:46.529309+01:00 picard kernel: [ 4155.444681] DR0:
> > > > 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > 2011-08-29T02:00:46.529311+01:00 picard kernel: [ 4155.444689] DR3:
> > > > 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > 2011-08-29T02:00:46.529314+01:00 picard kernel: [ 4155.444697] Proc=
ess
> > > > btrfs (pid: 3167, threadinfo ffff880111c20000, task ffff88010b35a14=
0)
> > > > 2011-08-29T02:00:46.529316+01:00 picard kernel: [ 4155.444705] Stac=
k:
> > > > 2011-08-29T02:00:46.529318+01:00 picard kernel: [ 4155.444711]
> > > > 0000000000c369c5 ffff880130cac800 ffff880110c8dbe0 0000000000c369c5
> > > > 2011-08-29T02:00:46.529321+01:00 picard kernel: [ 4155.444720]
> > > > 0000000000000000 ffff880130cacb88 ffff880130cacb90 ffffffffa03173c4
> > > > 2011-08-29T02:00:46.562822+01:00 picard kernel: [ 4155.444730]
> > > > ffff880136866300 ffff88011141bd60 ffff880110c8dbe0 fffb000000000000
> > > > 2011-08-29T02:00:46.562959+01:00 picard kernel: [ 4155.444739] Call
> > > > Trace:
> > > > 2011-08-29T02:00:46.562964+01:00 picard kernel: [ 4155.444756]
> > > > [<ffffffffa03173c4>] ? btrfs_orphan_cleanup+0x196/0x2d9 [btrfs]
> > > > 2011-08-29T02:00:46.562966+01:00 picard kernel: [ 4155.444773]
> > > > [<ffffffffa0317862>] ? btrfs_lookup_dentry+0x35b/0x392 [btrfs]
> > > > 2011-08-29T02:00:46.562969+01:00 picard kernel: [ 4155.444790]
> > > > [<ffffffffa03178a2>] ? btrfs_lookup+0x9/0x1f [btrfs]
> > > > 2011-08-29T02:00:46.562971+01:00 picard kernel: [ 4155.444801]
> > > > [<ffffffff810ccf63>] ? d_alloc_and_lookup+0x3a/0x60
> > > > 2011-08-29T02:00:46.562973+01:00 picard kernel: [ 4155.444810]
> > > > [<ffffffff810ce356>] ? walk_component+0x210/0x3b7
> > > > 2011-08-29T02:00:46.562975+01:00 picard kernel: [ 4155.444818]
> > > > [<ffffffff810cea4a>] ? path_lookupat+0x7c/0x29e
> > > > 2011-08-29T02:00:46.562979+01:00 picard kernel: [ 4155.444827]
> > > > [<ffffffff810cfc34>] ? do_path_lookup+0x1c/0x87
> > > > 2011-08-29T02:00:46.562981+01:00 picard kernel: [ 4155.444835]
> > > > [<ffffffff810cffe2>] ? user_path_at+0x49/0x7b
> > > > 2011-08-29T02:00:46.562983+01:00 picard kernel: [ 4155.444843]
> > > > [<ffffffff810c8781>] ? vfs_fstatat+0x3c/0x6a
> > > > 2011-08-29T02:00:46.562986+01:00 picard kernel: [ 4155.444853]
> > > > [<ffffffff8102d38e>] ? sub_preempt_count+0x83/0x94
> > > > 2011-08-29T02:00:46.562988+01:00 picard kernel: [ 4155.444861]
> > > > [<ffffffff810c88ab>] ? sys_newstat+0x12/0x2b
> > > > 2011-08-29T02:00:46.562990+01:00 picard kernel: [ 4155.444870]
> > > > [<ffffffff81346d4f>] ? page_fault+0x1f/0x30
> > > > 2011-08-29T02:00:46.562992+01:00 picard kernel: [ 4155.444878]
> > > > [<ffffffff8134713b>] ? system_call_fastpath+0x16/0x1b
> > > > 2011-08-29T02:00:46.562995+01:00 picard kernel: [ 4155.444885] Code=
: 4d
> > > > 85 e4 74 28 48 8b 93 70 fe ff ff 48 81 fa 00 01 00 00 77 07 48 8b 9=
3 b0
> > > > 00 00 00 4c 89 ee 4c 89 e7 e8 af 28 02 00 85 c0 74 02 <0f> 0b 85 ed=
 74
> > > > 08 48 89 df e8 e0 ca fe ff 5d 31 c0 5b 5d 41 5c=20
> > > > 2011-08-29T02:00:46.563001+01:00 picard kernel: [ 4155.444926] RIP
> > > > [<ffffffffa031339b>] btrfs_orphan_del+0x8d/0xa9 [btrfs]
> > > > 2011-08-29T02:00:46.563004+01:00 picard kernel: [ 4155.444943]  RSP
> > > > <ffff880111c21b58>
> > > > 2011-08-29T02:00:46.563014+01:00 picard kernel: [ 4155.464057] ---[=
 end
> > > > trace 276655044a13c7af ]---
> > > >=20
> > > > Unfortunately it results in freeze of system and I cannot give more
> > > > details. Sometimes it happens not from fcron but then it does not r=
esult
> > > > in freeze (???).
> > >=20
> > > Could you give me the method to reproduce it?
> > >=20
> > > Thanks
> > > Miao
> > >=20
> >=20
> > Unfortunatly no. Today, when I haven't worked at 2 am, it happened at 5
> > am resulting in freeze of desktop except screensaver (which probably
> > don't issue I/O to $HOME). It happens at least once per day but I
> > neither know how to trigger it nor what is the underlying issue.
> >=20
> > HOWEVER, I did tried in the past to:
> >  - Backup the image on external harddrive
> >  - Loop-mount it
> >  - mkfs.btrfs /dev/my/partition
> >  - rsync -aHAXP back the contents
> >=20
> > and it didn't solved the problem.
> >=20
> > Additionally very often restarts result in known OOPS bug.
> >=20
> > I do have the old image but I've just tried 3.1 kernel when you sent
> > this message.
> >=20
> > > >=20
> > > > Regards
> > >=20
> >=20
> > Regards
>=20
> I reproduced it on 3.1 rc4. The behaviour is similar except it is
> trigger each time I log into account (NOT mount /home - log into
> account).
>=20
> It might have something in common with suspend.
>=20
> Regards
>=20

To keep up-to-date:

 - It happens at 2 am it results in freeze. To be more precise the
snapshot is scheduled at 2 am and the lock was 2:07 am. The after each
odd reboot the bug is triggered on boot and on each even boot the
computer hangs shortly after logging in. I can still rsync to separate
partition w/out problems in case of even boot.
 - If it happens at other time (for certain reasons I haven't reproduced
it with 3.1 - long story why not but I suspect it might correlate to
uptime) the bug may or may not freeze computer.

Regards


--=-DipEOJUrLKY6Z19HkU5k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOZNLqAAoJEJIdee2Vr4aPmj8P/3RCKE7RI0Kv1jg+ukFx7IcC
qkGCPm80RzdP7hnG7Y7qwVc249/90YLAQwQWu7GnqtmAu5Yet60IRYX0BMvIOgHM
K8C5CVN3v1qny7iiz72r/ChJo7wqoxVR8GXOetua5cXFKTyiYfJH8L1C5ziL+MZA
gXuIjRH2uS1EWDC8xIcWxg00aElz3hyLQ0R7ZL6P/3B00U/NlW0DGin3TZ/GBTZp
AyPuds+SjY9P9yf/Upy0PajFtBibEyBh43mObKm9NnVkXU/ZWBuMBVj+QREMoiJX
h2rntpJBitb4D/CgWxLju9wNrRkWlN9FKfKeiuyQroeiEiPTYP5v9Hot6ryPz1ue
a7rqvL5ldLH1X0s0cF96SWTFeLYVPr28XIAnXlzqls+/i8CXl1uCXePK+6I3iA5s
K89bLUQ76oLyXi8DRPJor2vWe7/hVeCRslTw1rX7P92bL1dMv8I/pLDzLlCLMChw
MdNR2UYXljfon8xRWzR9JTu2JBqxc99aR5SiC7xq8Bz0r3yWBqPOGakpURy2pKmD
4mS5ROUM4PUxxT+evY5kXyTc/rKGsFMKxrPR72WW2OpUv26z+iA9xl4HHAxX4zRE
/1S10en7FbE/wdmJ2d+hcjXoYNRqAEVB/VUe22ViFm9GMNYH/NASaBuNM3I8KINA
n+Zr8T029AQeMMpXC+je
=rono
-----END PGP SIGNATURE-----

--=-DipEOJUrLKY6Z19HkU5k--


