From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Date: Wed, 29 Sep 2010 16:40:16 +0300
Message-ID: <1285767616.2437.142.camel@localhost>
References: <4C9AA546.6050201@cesarb.net>
	 <20100923123849.8975fe47.akpm@linux-foundation.org>
	 <20100927222548.GG3610@quack.suse.cz> <20100927225452.GG4270@think>
	 <1285657549.2437.28.camel@localhost>  <20100929130056.GG3290@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
	linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
	linux-btrfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, stable@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?Q?Micha=C5=82?= Piotrowski <mkkp4x4@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	kernel@lists.fedoraproject.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929130056.GG3290@quack.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2010-09-29 at 15:00 +0200, Jan Kara wrote:
> On Tue 28-09-10 10:05:49, Artem Bityutskiy wrote:
> > On Mon, 2010-09-27 at 18:54 -0400, Chris Mason wrote:
> > > On Tue, Sep 28, 2010 at 12:25:48AM +0200, Jan Kara wrote:
> > > > [Added CCs for similar ecryptfs warning]
> > > > On Thu 23-09-10 12:38:49, Andrew Morton wrote:
> > > > > > This started appearing for me on v2.6.36-rc5-49-gc79bd89; i=
t did not=20
> > > > > > happen on v2.6.36-rc5-33-g1ce1e41, probably because it does=
 not have=20
> > > > > > commit 692ebd17c2905313fff3c504c249c6a0faad16ec which intro=
duces the=20
> > > > > > warning.
> > > > > > [...]
> > > > > > device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transi=
d 22342=20
> > > > > > /dev/mapper/vg_cesarbinspiro-lv_home
> > > > > > SELinux: initialized (dev dm-3, type btrfs), uses xattr
> > > > > > ------------[ cut here ]------------
> > > > > > WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
> > > > > > Hardware name: Inspiron N4010
> > > > > > Dirtiable inode bdi default !=3D sb bdi btrfs
> > > > > > Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb=20
> > > > > > snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hd=
a_intel=20
> > > > > > iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev =
snd_seq=20
> > > > > > snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl3=
2 btusb=20
> > > > > > cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi del=
l_laptop snd=20
> > > > > > pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_=
page_alloc=20
> > > > > > rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd=
 aes_x86_64=20
> > > > > > aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_=
helper drm=20
> > > > > > i2c_algo_bit i2c_core video output [last unloaded: scsi_wai=
t_scan]
> > > > > > Pid: 1073, comm: find Not tainted 2.6.36-rc5+ #8
> > > > > > Call Trace:
> > > > > >   [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
> > > > > >   [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
> > > > > >   [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
> > > > > >   [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
> > > > > >   [<ffffffff81127168>] touch_atime+0x107/0x12a
> > > > > >   [<ffffffff81122384>] ? filldir+0x0/0xd0
> > > > > >   [<ffffffff8112259b>] vfs_readdir+0x8d/0xb4
> > > > > >   [<ffffffff8112270b>] sys_getdents+0x81/0xd1
> > > > > >   [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> > > >   Thanks for the report. These bdi pointers are a mess. As Chri=
s pointed
> > > > out, btrfs forgets to properly initialize inode->i_mapping.back=
ing_dev_info
> > > > for directories and special inodes and thus these were previous=
ly attached
> > > > to default_backing_dev_info which probably isn't what Chris wou=
ld like to
> > > > see.
> > >=20
> > > There's no actual writeback for these, so it works fine for btrfs=
 either
> > > way.
> >=20
> > Side note: every time inode is marked as dirty, we wake up a bdi th=
read
> > or the default bdi thread. So if we have inodes which do not need
> > write-back, we should never mark them as dirty.
>   Are you sure? I think we wake up the thread only when it's the firs=
t
> dirty inode for the bdi...

Err, right. If no one ever marks it as clean then we won't wake-up the
thread. But I thought that marking it as dirty even once is bad because
this causes bdi thread creation, which consumes resources.

Sorry for my ignorance, I did not really follow the conversation, I jus=
t
remember that when I looked at bdi stuff, I noticed that during boot th=
e
kernel created many bdi threads which were never used then. They
eventually exited. But I thought that creating useless bdi threads it
about concuming resources and slowing down the boot.

As I remember, the reason was touch_atime() for some of the threads.

But really, I did not dig this, I just noticed this conversation and
wanted to let you know about the issue I noticed this summer.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
