From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Synching a Backup Server
Date: Tue, 25 Jan 2011 19:36:28 +0100
Message-ID: <201101251936.28264.hka@qbs.com.pl>
References: <201101060935.14059.CACook@quantum-sci.com> <201101251843.21037.hka@qbs.com.pl> <AANLkTim+3+aHoX0Shc5_Fzym6_xsLAKyEA6c352nCPuD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Kaspar Schleiser <kaspar@schleiser.de>, linux-btrfs@vger.kernel.org
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim+3+aHoX0Shc5_Fzym6_xsLAKyEA6c352nCPuD@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, January 25, 2011 18:59:39 Freddie Cash wrote:
> On Tue, Jan 25, 2011 at 9:43 AM, Hubert Kario <hka@qbs.com.pl> wrote:
> > Besides, I don't see *why* this should be done...
> >=20
> > And as far as I know ZFS doesn't support different reduncancy level=
s for
> > different files residing in the same directory. You can have
> > ~/1billion$-project.tar.gz with triple redundancy and ~/temp.video.=
mkv
> > with no reduncancy with btrfs...
>=20
> With ZFS, redundancy (mirror, raidz1, raidz2, raidz3) is done at the
> storage pool layer, and affects the entire pool.  You can mix and
> match redundancy levels (combine mirror vdevs and raidz vdevs in the
> same pool), but there's no way to control what data blocks go to whic=
h
> vdev, as it's all just one giant pool of storage.
>=20
> However, there is a "copies" property for each filesystem that affect=
s
> how many copies of data blocks are stored, to increase the redundancy
> for that filesystem.  For example, you can create a storage pool usin=
g
> 2 mirror vdevs (4 drives; equivalent to a RAID10 setup); then create =
a
> filesystem with copies=3D2.  Thus, any blocks written to that filesys=
tem
> will be stored twice, each of which is then striped across the two
> vdevs, and then mirrored to each disk in the vdevs, potentially
> leading to 4 (or more) blocks of data written to disk.
>=20
> This is similar to using Linux md to create RAID arrays underneath LV=
M
> volume groups.  The redundancy is managed via md; the filesystems jus=
t
> see a collection of blocks to write to.
>=20
> The big difference (from what I understand) between ZFS and Btrfs is
> the layering.  ZFS separate storage management from filesystem
> management, so redundancy happens at lower layers and the filesystem
> just sends blocks to the pool.  Whereas Btrfs combines them into one,
> so that redundancy is managed at the filesystem level and can be
> changed on a per-directory (or per-sub-volume?) basis, with the
> filesystem handling the writes and the redundancy.

Right now you can't change the raid level at all but there are hooks pl=
anned=20
to enable selecting raid level on a per file basis.

btrfs allows for better management of space ond less over provisioning.

So I'd say that management of storage space with btrfs is even easier t=
han=20
with ZFS:

admin sets the default redundancy level for whole file system (let's sa=
y that=20
it's a 4 disk system) to a RAID1 with two copies.
After seting up the system sets the redundancy level in directories wit=
h=20
databases to RAID10
Users storing big files use RAID5 for some files.

one of the drives fails, admin removes the drive from set, schedules=20
reballance.

the set is smaller but all reduncancy is preserved

New drives arrive, they are added to fs. FS is reballanced for the seco=
nd time=20
to achive better performance (the space would be usable even without it=
).

=20
> I don't pretend to understand all the intricacies of how Btrfs works
> (I'm working on it), but the layering in ZFS is very nice and easy to
> work with in comparison.  Interesting how ZFS is considered the
> "rampant layering violation", though.  ;)  :)  :D

btrfs is much simpler from user point of view :)

as for rampant layering violation: most of the code that deals with sto=
red=20
data isn't concerned with raid level, in contrast with zfs. In other wo=
rds,=20
its in the code, not interface.

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
