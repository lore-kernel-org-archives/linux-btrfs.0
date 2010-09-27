From: Jan Kara <jack@suse.cz>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Date: Tue, 28 Sep 2010 00:25:48 +0200
Message-ID: <20100927222548.GG3610@quack.suse.cz>
References: <4C9AA546.6050201@cesarb.net>
 <20100923123849.8975fe47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Jens Axboe <jaxboe@fusionio.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, stable@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	=?utf-8?Q?Micha=C5=82?= Piotrowski <mkkp4x4@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	kernel@lists.fedoraproject.org
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100923123849.8975fe47.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

[Added CCs for similar ecryptfs warning]
On Thu 23-09-10 12:38:49, Andrew Morton wrote:
> > This started appearing for me on v2.6.36-rc5-49-gc79bd89; it did not 
> > happen on v2.6.36-rc5-33-g1ce1e41, probably because it does not have 
> > commit 692ebd17c2905313fff3c504c249c6a0faad16ec which introduces the 
> > warning.
> > [...]
> > device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342 
> > /dev/mapper/vg_cesarbinspiro-lv_home
> > SELinux: initialized (dev dm-3, type btrfs), uses xattr
> > ------------[ cut here ]------------
> > WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
> > Hardware name: Inspiron N4010
> > Dirtiable inode bdi default != sb bdi btrfs
> > Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb 
> > snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hda_intel 
> > iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev snd_seq 
> > snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl32 btusb 
> > cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi dell_laptop snd 
> > pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_page_alloc 
> > rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd aes_x86_64 
> > aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_helper drm 
> > i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
> > Pid: 1073, comm: find Not tainted 2.6.36-rc5+ #8
> > Call Trace:
> >   [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
> >   [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
> >   [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
> >   [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
> >   [<ffffffff81127168>] touch_atime+0x107/0x12a
> >   [<ffffffff81122384>] ? filldir+0x0/0xd0
> >   [<ffffffff8112259b>] vfs_readdir+0x8d/0xb4
> >   [<ffffffff8112270b>] sys_getdents+0x81/0xd1
> >   [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
  Thanks for the report. These bdi pointers are a mess. As Chris pointed
out, btrfs forgets to properly initialize inode->i_mapping.backing_dev_info
for directories and special inodes and thus these were previously attached
to default_backing_dev_info which probably isn't what Chris would like to
see.
  I've also got a similar report for ecryptfs which also does not
initialize inode->i_mapping.backing_dev_info although it sets sb->s_bdi and
thus again its inodes get filed to default_backing_dev_info lists.  Quick
search seems to reveal that other filesystems using handcrafted bdi's get
it wrong as well and thus their inodes end up in the default_backing_dev_info
lists which is generally undesirable (this was happening already before my
patch, my code just started complaining about that).
  That suggests that we should probably handle such cases in a more generic
way by changing the code in inode_init_always(). The patch below makes at
least btrfs happy for me... Could you maybe test it? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 29f60c2b08ff9637a10439d1513805835ddcc746 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Sep 2010 23:56:48 +0200
Subject: [PATCH] bdi: Initialize inode->i_mapping.backing_dev_info to sb->s_bdi

Currently, we initialize inode->i_mapping.backing_dev_info to the bdi of device
sb->s_bdev points to. However there is quite a big number of filesystems that
do not set sb->s_bdev (because they do not have one) but do set sb->s_bdi.
These filesystems would generally benefit from setting
inode->i_mapping.backing_dev_info to their s_bdi because otherwise their inodes
would point to default_backing_dev_info and thus dirty inode tracking would
happen there. So change inode initialization code to use sb->s_bdi if it
is available.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8646433..e415be4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -172,15 +172,21 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	mapping->writeback_index = 0;
 
 	/*
-	 * If the block_device provides a backing_dev_info for client
-	 * inodes then use that.  Otherwise the inode share the bdev's
-	 * backing_dev_info.
+	 * If the filesystem provides a backing_dev_info for client inodes
+	 * then use that. Otherwise inodes share default_backing_dev_info.
 	 */
-	if (sb->s_bdev) {
-		struct backing_dev_info *bdi;
-
-		bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
-		mapping->backing_dev_info = bdi;
+	if (sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) {
+		/*
+		 * Catch cases where filesystem might be bitten by using s_bdi
+		 * instead of sb->s_bdev. Can be removed in 2.6.38.
+		 */
+		if (sb->s_bdev) {
+			struct backing_dev_info *bdi =
+			  sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
+			WARN(bdi != sb->s_bdi, "s_bdev bdi %s != s_bdi %s\n",
+			     bdi->name, sb->s_bdi->name);
+		}
+		mapping->backing_dev_info = sb->s_bdi;
 	}
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
-- 
1.6.4.2

