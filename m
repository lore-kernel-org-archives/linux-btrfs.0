From: "Mitch Harder (aka DontPanic)" <mmharder@gmail.com>
Subject: Re: btrfs: warn_slowpath in clean_tree_block and others
Date: Wed, 25 Feb 2009 10:16:23 -0600
Message-ID: <89ed0c690902250816l519786c2m161df6f832ffa42f@mail.gmail.com>
References: <20090224230249.GA6859@vlad.carfax.org.uk>
	 <89ed0c690902242022u526bb9bn5e7a8682ac0c0a96@mail.gmail.com>
	 <49A4E4A5.7040103@cs.drexel.edu>
	 <89ed0c690902250603g2f6236d6q3be2f2f065ea0df@mail.gmail.com>
	 <20090225160558.GA10080@tux64-01>
	 <20090225161355.GA27760@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Lee Trager <lt73@cs.drexel.edu>,
	"Mitch Harder (aka DontPanic)" <mmharder@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090225161355.GA27760@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

The messages attached are only "WARNING" messages.

I have not been encountering a crash, nor does the data seem to get
corrupted in my case (as far as I can tell).

Btrfs seems to actually work fine, except for the large amount of log m=
essages.

On Wed, Feb 25, 2009 at 10:13 AM, Hugo Mills <hugo-lkml@carfax.org.uk> =
wrote:
> On Wed, Feb 25, 2009 at 11:05:58AM -0500, Lee Trager wrote:
>> But what are you doing to the filesystem when it crashes? How did yo=
u
>> mount it?
>
> =A0 In my case, it's mounted with this fstab entry:
>
> /dev/media/scratch =A0 =A0 =A0/media/vlad/video/video btrfs =A0 noati=
me,nosuid,nodev =A0 =A0 =A0 =A0 0 0
>
> and I can trigger hundreds (literally) of these backtraces with a
> single "touch /media/vlad/video/video/foo". If I encode a video to th=
e
> FS, the backtraces come in bursts at intervals of, say, 20 seconds
> (it's not perfectly regular).
>
> =A0 Hugo.
>
>> On Wed, Feb 25, 2009 at 08:03:01AM -0600, Mitch Harder (aka DontPani=
c) wrote:
>> > I've been creating a local git repository of full btrfs-unstable s=
ources.
>> >
>> > I'll create a new branch off the master branch, and apply the patc=
h
>> > supplied in the Feb. 11 message to the M/L.
>> >
>> > I then create a kernel module based on the results in /fs/btrfs/
>> >
>> > I have also tried replicating the experimental branch, and merging=
 the
>> > patch into that branch, but I get the same results.
>> >
>> > On Wed, Feb 25, 2009 at 12:26 AM, Lee Trager <lt73@cs.drexel.edu> =
wrote:
>> > > Mitch, I haven't seen any problems using BTRFS and my patch on 2=
=2E6.28 or
>> > > 2.6.27, what are you doing to cause this error? Are you using th=
e latest
>> > > sources from btrfs-unstable?
>> > >
>> > > Lee
>> > >
>> > > Mitch Harder (aka DontPanic) wrote:
>> > >> I have also been getting similar warnings filling up my logs.
>> > >>
>> > >> However, in my case, I have been experimenting with back-portin=
g btrfs
>> > >> to a 2.6.28 kernel. ?So I've been waiting for the back-porting =
efforts
>> > >> to get a little further along.
>> > >>
>> > >> But I thought I'd respond in case this information helps.
>> > >>
>> > >> Here's an example of the warnings I've been seeing:
>> > >>
>> > >> [80577.151167] ------------[ cut here ]------------
>> > >> [80577.151169] WARNING: at
>> > >> /var/tmp/portage/sys-fs/btrfs-9998/work/btrfs-9998/disk-io.c:86=
0
>> > >> clean_tree_block+0xa4/0xb0 [btrfs]()
>> > >> [80577.151172] Modules linked in: btrfs snd_pcm_oss snd_mixer_o=
ss
>> > >> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_de=
vice
>> > >> ipv6 ppdev snd_intel8x0 snd_ac97_codec parport_pc nvidia(P) ac9=
7_bus
>> > >> snd_pcm snd_timer ohci_hcd ssb shpchp pci_hotplug pcmcia i2c_nf=
orce2
>> > >> snd forcedeth sr_mod pcspkr parport i2c_core snd_page_alloc nvi=
dia_agp
>> > >> sl811_hcd pcmcia_core uhci_hcd ehci_hcd
>> > >> [80577.151190] Pid: 11503, comm: cp Tainted: P ? ? ? ?W ?2.6.28=
-sabayon-r10 #1
>> > >> [80577.151192] Call Trace:
>> > >> [80577.151195] ?[<c011e77f>] warn_on_slowpath+0x5f/0x90
>> > >> [80577.151203] ?[<c043c427>] rb_insert_color+0x77/0xe0
>> > >> [80577.151221] ?[<f8c28e9e>] alloc_extent_buffer+0x1fe/0x300 [b=
trfs]
>> > >> [80577.151238] ?[<f8c08d54>] clean_tree_block+0xa4/0xb0 [btrfs]
>> > >> [80577.151253] ?[<f8bf665d>] btrfs_init_new_buffer+0x7d/0x130 [=
btrfs]
>> > >> [80577.151269] ?[<f8bfb6f4>] btrfs_alloc_free_block+0x104/0x110=
 [btrfs]
>> > >> [80577.151285] ?[<f8bef3da>] __btrfs_cow_block+0x22a/0x8b0 [btr=
fs]
>> > >> [80577.151300] ?[<f8bed212>] generic_bin_search+0x162/0x1c0 [bt=
rfs]
>> > >> [80577.151315] ?[<f8bf00e6>] btrfs_cow_block+0x156/0x200 [btrfs=
]
>> > >> [80577.151330] ?[<f8bf3267>] btrfs_search_slot+0x1a7/0x910 [btr=
fs]
>> > >> [80577.151333] ?[<c01230e7>] irq_exit+0x27/0x60
>> > >> [80577.151336] ?[<c01052cb>] do_IRQ+0x6b/0x80
>> > >> [80577.151354] ?[<f8c24a55>] read_extent_buffer+0xd5/0x170 [btr=
fs]
>> > >> [80577.151369] ?[<f8bf3f7d>] btrfs_insert_empty_items+0x6d/0x41=
0 [btrfs]
>> > >> [80577.151385] ?[<f8bf8f4f>] btrfs_find_block_group+0xff/0x1a0 =
[btrfs]
>> > >> [80577.151402] ?[<f8c0fa1d>] btrfs_new_inode+0x18d/0x360 [btrfs=
]
>> > >> [80577.151420] ?[<f8c135a9>] btrfs_create+0x189/0x2a0 [btrfs]
>> > >> [80577.151423] ?[<c04162d9>] security_capable+0x9/0x10
>> > >> [80577.151427] ?[<c0197f3d>] vfs_create+0xcd/0x160
>> > >> [80577.151430] ?[<c019ad6f>] do_filp_open+0x5af/0x7d0
>> > >> [80577.151433] ?[<c01932e9>] cp_new_stat64+0xf9/0x110
>> > >> [80577.151436] ?[<c018e40e>] do_sys_open+0x4e/0xe0
>> > >> [80577.151439] ?[<c018e51c>] sys_open+0x2c/0x40
>> > >> [80577.151442] ?[<c0103165>] sysenter_do_call+0x12/0x21
>> > >> [80577.151444] ---[ end trace 79cdc48bc88dedf7 ]---
>> > >>
>> > >>
>> > >> On Tue, Feb 24, 2009 at 5:02 PM, Hugo Mills <hugo-lkml@carfax.o=
rg.uk> wrote:
>> > >>
>> > >>> ? This is essentially a repost of a mail I made last week, to =
which I
>> > >>> didn't get a reply.
>> > >>>
>> > >>> ? I'm getting huge numbers of kernel warnings whilst using
>> > >>> btrfs. They're all "warn_slowpath", and all seem to be in
>> > >>> fs/btrfs/disk-io.c. I've included one typical example at the e=
nd of
>> > >>> this mail.
>> > >>>
>> > >>> ? Kernel versions are 2.6.29-rc2, -rc4 and -rc6.
>> > >>>
>> > >>> ? If I do lots of writes to my btrfs filesystem (e.g. video
>> > >>> encoding), I end up with a syslog in the tens-of-megabytes ran=
ge. This
>> > >>> makes logcheck an unhappy bunny...
>> > >>>
>> > >>> ? I don't know if this behaviour is expected, and everyone usi=
ng
>> > >>> btrfs simply puts up with it for now, or if it's something unu=
sual
>> > >>> that needs investigating. On the chance that it's the latter, =
I'm
>> > >>> reporting it here.
>> > >>>
>> > >>> ? Hugo.
>> > >>>
>> > >>> Feb 23 21:45:42 vlad kernel: ------------[ cut here ]---------=
---
>> > >>> Feb 23 21:45:42 vlad kernel: WARNING: at fs/btrfs/disk-io.c:81=
5 clean_tree_block+0x9d/0xbb [btrfs]()
>> > >>> Feb 23 21:45:42 vlad kernel: Hardware name: System Product Nam=
e
>> > >>> Feb 23 21:45:42 vlad kernel: Modules linked in: tun ext3 jbd b=
trfs zlib_deflate tcp_diag inet_diag kqemu cpufreq_userspace ipv6 nfsd =
nfs lockd nfs_acl auth_rpcgss sunrpc af_packet bridge stp llc xfs expor=
tfs it87 hwmon_vid powernow_k8 sbp2 ieee1394 ide_generic ide_gd_mod ide=
_cd_mod pcspkr evdev k8temp hwmon i2c_viapro i2c_core button dm_mirror =
dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod usbhid usb_storag=
e libusual sg sr_mod cdrom via82cxxx floppy via_rhine mii ehci_hcd uhci=
_hcd usbcore pata_via ide_pci_generic ide_core sd_mod thermal processor=
 fan unix
>> > >>> Feb 23 21:45:42 vlad kernel: Pid: 27034, comm: hdparm Tainted:=
 G ? ? ? ?W ?2.6.29-rc4 #1
>> > >>> Feb 23 21:45:42 vlad kernel: Call Trace:
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff80228d7d>] warn_slowpat=
h+0xd8/0x111
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff80312f11>] radix_tree_i=
nsert+0xd7/0x19f
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff8024d55d>] add_to_page_=
cache_locked+0x52/0x9e
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff8024d5e9>] add_to_page_=
cache_lru+0x40/0x58
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff8024dbd0>] find_or_crea=
te_page+0x62/0x88
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03f992a>] alloc_extent=
_buffer+0x268/0x2ec [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03e1b18>] clean_tree_b=
lock+0x9d/0xbb [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d5eaf>] btrfs_init_n=
ew_buffer+0x99/0xf3 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d849e>] btrfs_alloc_=
free_block+0x83/0x8c [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03cb2f8>] __btrfs_cow_=
block+0x1ff/0x87e [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03cc125>] btrfs_cow_bl=
ock+0x1e7/0x1f6 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff80251d9e>] __alloc_page=
s_internal+0xd2/0x3ec
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d0915>] btrfs_search=
_slot+0x36f/0x99b [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d14ee>] btrfs_insert=
_empty_items+0x7f/0x49d [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d825d>] __btrfs_allo=
c_reserved_extent+0x19f/0x2bb [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d83f0>] btrfs_alloc_=
extent+0x77/0xa2 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d847f>] btrfs_alloc_=
free_block+0x64/0x8c [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03cb2f8>] __btrfs_cow_=
block+0x1ff/0x87e [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d7532>] finish_curre=
nt_insert+0x514/0x528 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03d7bf9>] del_pending_=
extents+0xa5/0x33d [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03cc125>] btrfs_cow_bl=
ock+0x1e7/0x1f6 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03e436d>] btrfs_commit=
_tree_roots+0x53/0x1ba [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff80403a3e>] schedule_tim=
eout+0xa1/0xbc
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03e55dd>] btrfs_commit=
_transaction+0x322/0x6e5 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff802385fb>] autoremove_w=
ake_function+0x0/0x2e
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03e4809>] join_transac=
tion+0x129/0x147 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffffa03c8788>] btrfs_sync_f=
s+0x70/0x78 [btrfs]
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff8026f332>] sync_filesys=
tems+0xa8/0xde
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff80287256>] do_sync+0x25=
/0x50
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff8028728f>] sys_sync+0xe=
/0x13
>> > >>> Feb 23 21:45:42 vlad kernel: [<ffffffff8020b25b>] system_call_=
fastpath+0x16/0x1b
>> > >>> Feb 23 21:45:42 vlad kernel: ---[ end trace a315082d564863a6 ]=
---
>> > >>>
>> > >>>
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org=
=2Euk
> =A0 =A0 =A0--- UNIX: British manufacturer of modular shelving units. =
---
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iD8DBQFJpW5DIKyzvlFcI40RAi7mAJwIdyU8ZhgEyDV3Djjh0v2HUNadOACfYC1S
> 9rWCtVLER/UfOKGGMGTl/yo=3D
> =3Dd/S6
> -----END PGP SIGNATURE-----
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
