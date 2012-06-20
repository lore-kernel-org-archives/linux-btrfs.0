Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:58227 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2FTDWN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 23:22:13 -0400
Message-ID: <4FE141DB.1080308@zytor.com>
Date: Tue, 19 Jun 2012 20:22:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: Subvolumes and /proc/self/mountinfo
References: <20120619234919.GA4102@shiny> <CBFTB8kPCXB@helmut.hullen.de> <CAE5mzvitiXX9N=qjM=xRgqhHQ9kY6WHXa4jWKGs6xRNOtd7uEA@mail.gmail.com>
In-Reply-To: <CAE5mzvitiXX9N=qjM=xRgqhHQ9kY6WHXa4jWKGs6xRNOtd7uEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2012 06:16 PM, cwillu wrote:
>>> The big reason it isn't here yet is because Kay had this neat patch
>>> to blkid and udev to just put all the info you need into /dev/btrfs
>>> (or some other suitable location).  It would allow you to see which
>>> devices belong to which filesystems etc.
>>
>> "btrfs" should work even without any "udev" installation.
> 
> It does; you can always mount with an explicit -o
> device=/dev/foo,device=/dev/bar if you're inclined to punish
> yourself^w^w^w^w^w your requirements dictate that you don't rely on
> udev.

I think you're misunderstanding what this is about.

I'm working on trying to make the Syslinux installer for btrfs as robust
as it possibly can be.  I really don't like leaving corner cases where
it will do the wrong thing and leave your system unbootable.

Now, that having been said, there are a lot of things that are not
really very clear how they should work given btrfs.  Specifically, what
is needed is:

1. The underlying device(s) for boot block installation.
2. A concept of a root.
3. A concept of a path within that root to the installation directory,
   where we can find syslinux.cfg and the other bootloader modules.

All of this needs to be installed in the fixed-sized boot block, so a
compact representation is very much a plus.

The concept of what is the "root" and what is the "path" is
straightforward for lesser filesystems: the root of the filesystem is
defined by the root inode, and the path is a unique sequence of
directories from that root.  Note that this is completely independent of
how the filesystem was mounted when the boot loader was installed.

For btrfs, a lot of things aren't so clear-cut, especially in the light
of explicit and implicit subvolumes.  Furthermore, sorting out these
semantic issues is really important in order to support the "atomic
update" scenario:

a. Make a snapshot of the current root;
b. Mount said snapshot;
c. Install the new distro on the snapshot;
d. Change the bootloader configuration *inside* the snapshot to point
   to the snapshot as the root;
e. Install the bootloader on the snapshot, thereby making the boot
   block point to it and making it "live".

If the root also contains subvolumes, e.g. /boot may be a subvolume
because it has different policies, this gets pretty gnarly to get right.
 It is also a very high value to get right.

So it is possible I'm approaching this wrong.  I would love to have a
discussion about this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

