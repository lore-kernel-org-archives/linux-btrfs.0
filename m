From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Tue, 25 Jan 2011 09:59:39 -0800
Message-ID: <AANLkTim+3+aHoX0Shc5_Fzym6_xsLAKyEA6c352nCPuD@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<201101221455.45968.hka@qbs.com.pl>
	<4D3F087F.20905@schleiser.de>
	<201101251843.21037.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kaspar Schleiser <kaspar@schleiser.de>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101251843.21037.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 25, 2011 at 9:43 AM, Hubert Kario <hka@qbs.com.pl> wrote:
> Besides, I don't see *why* this should be done...
>
> And as far as I know ZFS doesn't support different reduncancy levels for
> different files residing in the same directory. You can have
> ~/1billion$-project.tar.gz with triple redundancy and ~/temp.video.mkv with no
> reduncancy with btrfs...

With ZFS, redundancy (mirror, raidz1, raidz2, raidz3) is done at the
storage pool layer, and affects the entire pool.  You can mix and
match redundancy levels (combine mirror vdevs and raidz vdevs in the
same pool), but there's no way to control what data blocks go to which
vdev, as it's all just one giant pool of storage.

However, there is a "copies" property for each filesystem that affects
how many copies of data blocks are stored, to increase the redundancy
for that filesystem.  For example, you can create a storage pool using
2 mirror vdevs (4 drives; equivalent to a RAID10 setup); then create a
filesystem with copies=2.  Thus, any blocks written to that filesystem
will be stored twice, each of which is then striped across the two
vdevs, and then mirrored to each disk in the vdevs, potentially
leading to 4 (or more) blocks of data written to disk.

This is similar to using Linux md to create RAID arrays underneath LVM
volume groups.  The redundancy is managed via md; the filesystems just
see a collection of blocks to write to.

The big difference (from what I understand) between ZFS and Btrfs is
the layering.  ZFS separate storage management from filesystem
management, so redundancy happens at lower layers and the filesystem
just sends blocks to the pool.  Whereas Btrfs combines them into one,
so that redundancy is managed at the filesystem level and can be
changed on a per-directory (or per-sub-volume?) basis, with the
filesystem handling the writes and the redundancy.

I don't pretend to understand all the intricacies of how Btrfs works
(I'm working on it), but the layering in ZFS is very nice and easy to
work with in comparison.  Interesting how ZFS is considered the
"rampant layering violation", though.  ;)  :)  :D

-- 
Freddie Cash
fjwcash@gmail.com
