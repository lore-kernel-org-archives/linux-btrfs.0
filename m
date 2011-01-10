From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Synching a Backup Server
Date: Mon, 10 Jan 2011 14:14:05 +0100
Message-ID: <201101101414.05963.hka@qbs.com.pl>
References: <201101060935.14059.CACook@quantum-sci.com> <201101071720.08298.hka@qbs.com.pl> <4D29A033.7000803@chandlerfamily.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Alan Chandler <alan@chandlerfamily.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D29A033.7000803@chandlerfamily.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 09 of January 2011 12:46:59 Alan Chandler wrote:
> On 07/01/11 16:20, Hubert Kario wrote:
> > I usually create subvolumes in btrfs root volume:
> >=20
> > /mnt/btrfs/
> >=20
> >          |- server-a
> >          |- server-b
> >         =20
> >          \- server-c
> >=20
> > then create snapshots of these directories:
> >=20
> > /mnt/btrfs/
> >=20
> >          |- server-a
> >          |- server-b
> >          |- server-c
> >          |- snapshots-server-a
> >          |
> >                   |- @GMT-2010.12.21-16.48.09
> > 	           =20
> > 	            \- @GMT-2010.12.22-16.45.14
> >          |
> >          |- snapshots-server-b
> >         =20
> >          \- snapshots-server-c
> >=20
> > This way I can use the shadow_copy module for samba to publish the
> > snapshots to windows clients.
>=20
> Can you post some actual commands to do this part

# create the default subvolume and mount it
mkfs.btrfs /dev/sdx
mount /dev/sdx /mnt/btrfs
# to be able to snapshot individual servers we have to put them to indi=
vidual
# subvolumes
btrfs subvolume create /mnt/btrfs/server-a
btrfs subvolume create /mnt/btrfs/server-b
btrfs subvolume create /mnt/btrfs/server-c
# copy data over
rsync --exclude /proc [...] root@server-a:/ /mnt/btrfs/server-a
rsync --exclude /proc [...] root@server-b:/ /mnt/btrfs/server-b
rsync --exclude /proc [...] root@server-c:/ /mnt/btrfs/server-c
# create snapshot directories (in the default subvolume)
mkdir /mnt/btrfs/{snapshots-server-a,snapshots-server-b,snapshots-serve=
r-c}
# create snapshot from the synced data:
btrfs subvolume snapshot /mnt/btrfs/server-a /mnt/btrfs/snapshots-serve=
r-
a/@GMT-2010.12.21-16.48.09
# copy new data over:
rsync --inplace --exclude /proc [...] root@server-a:/ /mnt/btrfs/server=
-a
# make a new snapshot
btrfs subvolume snapshot /mnt/btrfs/server-a /mnt/btrfs/snapshots-serve=
r-
a/@GMT-2010.12.22-16.45.14

in the end we have 5 subvolumes, 2 of witch are snapshots of the server=
-a
>=20
> I am extremely confused about btrfs subvolumes v the root filesystem =
and
> mounting, particularly in relation to the default subvolume.
>=20
> For instance, if I create the initial file system using mkfs.btrfs an=
d
> then mount it on /mnt/btrfs is there already a default subvolume?  or=
 do
> I have to make one?  What happens when you unmount the whole filesyst=
em
> and then come back
>=20
> The wiki also makes the following statement
>=20
> *"Note:* to be mounted the subvolume or snapshot have to be in the ro=
ot
> of the btrfs filesystem."
>=20
>=20
> but you seems to have snapshots at one layer down from the root.
>=20
>=20
> I am trying to use this method for my offsite backups - to a large sp=
are
> sata disk loaded via a usb port.
>=20
> I want to create the main filesystem (and possibly a subvolume - this=
 is
> where I start to get confused) and rsync my current daily backup file=
s
> to it.  I would then also (just so I get the correct time - rather th=
an
> do it at the next cycle, as explained below) take a snapshot with a t=
ime
> label. I would transport this disk offsite.
>=20
> I would repeat this in a months time with a totally different disk
>=20
> In a couple of months time - when I come to recycle the first disk fo=
r
> my offsite backup, I would mount the retrieved disk (and again I am
> confused - mount the complete filesystem or the subvolume?)  rsync
> (--inplace ? - is this necessary) again the various backup files from=
 my
> server and take another snapshot.

you mount the default, this way you have access to all the data on the =
HDD, --
inplace is necessary=20

>=20
> I am hoping that this would effectively allow me to leave the snapsho=
t I
> took last time in place, as because not everything will have changed =
it
> won't have used much space - so effectively I can keep quite a long
> stream of backup snapshots in place offsite.

yes

>=20
> Eventually of course the disk will start to become full, but I assume=
 I
> can reclaim the space by deleting some of the old snapshots.

yes, of course:

btrfs subvolume delete /mnt/btrfs/snapshots-server-a/@GMT-2010.12.21-16=
=2E48.09

will reclaim the space used up by the deltas

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
