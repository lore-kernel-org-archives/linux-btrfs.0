From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [stable] Dirtiable inode bdi default != sb bdi btrfs
Date: Fri, 24 Sep 2010 20:39:41 +0200
Message-ID: <4C9CF06D.2050201@fusionio.com>
References: <4C9AA546.6050201@cesarb.net> <20100923123849.8975fe47.akpm@linux-foundation.org> <4C9BAD1E.2030007@fusionio.com> <20100923205300.GA6853@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	<linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	<linux-fsdevel@vger.kernel.org>, <stable@kernel.org>,
	<linux-btrfs@vger.kernel.org>,
	Cesar Eduardo Barros <cesarb@cesarb.net>
To: Greg KH <greg@kroah.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100923205300.GA6853@kroah.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-09-23 22:53, Greg KH wrote:
> On Thu, Sep 23, 2010 at 09:40:14PM +0200, Jens Axboe wrote:
>> On 2010-09-23 21:38, Andrew Morton wrote:
>>>
>>> (Cc stable@kernel.org)
>>>
>>> On Wed, 22 Sep 2010 21:54:30 -0300
>>> Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
>>>
>>>> This started appearing for me on v2.6.36-rc5-49-gc79bd89; it did not 
>>>> happen on v2.6.36-rc5-33-g1ce1e41, probably because it does not have 
>>>> commit 692ebd17c2905313fff3c504c249c6a0faad16ec which introduces the 
>>>> warning.
>>>>
>>>> [...]
>>>> device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342 
>>>> /dev/mapper/vg_cesarbinspiro-lv_home
>>>> SELinux: initialized (dev dm-3, type btrfs), uses xattr
>>>> ------------[ cut here ]------------
>>>> WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
>>>> Hardware name: Inspiron N4010
>>>> Dirtiable inode bdi default != sb bdi btrfs
>>>> Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb 
>>>> snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hda_intel 
>>>> iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev snd_seq 
>>>> snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl32 btusb 
>>>> cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi dell_laptop snd 
>>>> pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_page_alloc 
>>>> rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd aes_x86_64 
>>>> aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_helper drm 
>>>> i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
>>>> Pid: 1073, comm: find Not tainted 2.6.36-rc5+ #8
>>>> Call Trace:
>>>>   [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
>>>>   [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
>>>>   [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
>>>>   [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
>>>>   [<ffffffff81127168>] touch_atime+0x107/0x12a
>>>>   [<ffffffff81122384>] ? filldir+0x0/0xd0
>>>>   [<ffffffff8112259b>] vfs_readdir+0x8d/0xb4
>>>>   [<ffffffff8112270b>] sys_getdents+0x81/0xd1
>>>>   [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
>>>
>>> Thanks.  692ebd17c2905313fff3c504c249c6a0faad16ec had a cc:stable in
>>> the changelog.  I'd suggest it not be merged into -stable until this
>>> regression is sorted out!
>>
>> It was just added, I'm discussing this with Chris on irc as I type this.
>> But yes, lets not replace a regression with a new regression :-). So
>> Greg, please hold off on these for a little while.
> 
> Ok, so which ones should I take out of the -stable tree?  Just this one:
> 	692ebd17c2905313fff3c504c249c6a0faad16ec
> or it and something else?

You can keep 1/2, just hold off on the one labeled:

bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends

for now. I'm off to Japan in the morning, perhaps Jan can comment
if he's available.

-- 
Jens Axboe
