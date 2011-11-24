From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: btrfs encryption problems
Date: Thu, 24 Nov 2011 16:06:17 -0500
Message-ID: <20111124160617.680b676f@zougloub.eu>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
	<20111123110956.GB31800@attic.humilis.net>
	<CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: sander@humilis.net, linux-btrfs@vger.kernel.org
To: 810d4rk <810d4rk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 Nov 2011 19:38:37 +0000
810d4rk <810d4rk@gmail.com> wrote:

> [ 4836.897206] sd 20:0:0:0: [sdc] Attached SCSI disk
> [ 4844.803652] EXT3-fs (dm-1): error: can't find ext3 filesystem on dev dm-1.
> [ 4844.856054] EXT2-fs (dm-1): error: can't find an ext2 filesystem on dev dm-1.
> [ 4844.902679] EXT4-fs (dm-1): VFS: Can't find ext4 filesystem
> [ 4932.637108] EXT3-fs (dm-1): error: can't find ext3 filesystem on dev dm-1.
> [ 4932.686841] EXT2-fs (dm-1): error: can't find an ext2 filesystem on dev dm-1.
> [ 4932.738999] EXT4-fs (dm-1): VFS: Can't find ext4 filesystem
> [ 4949.142867] EXT3-fs (dm-1): error: can't find ext3 filesystem on dev dm-1.
> [ 4949.197596] EXT2-fs (dm-1): error: can't find an ext2 filesystem on dev dm-1.
> [ 4949.241721] EXT4-fs (dm-1): VFS: Can't find ext4 filesystem

These printks indicate that the encryption or password is not the same as used when creating the device.
So at this stage, this has nothing to do with btrfs.
 
> In my experience btrfs + encryption eats the data, this is not the
> first time I had this problem with btrfs so I am considering switching
> to ext4, but can I still get the other data back on the broken btrfs??

Don't worry, btrfs doesn't need encryption to eat your data.
If you use it, keep backups.
Good luck with getting back the data !

-- 
cJ
