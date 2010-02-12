From: Josef Bacik <josef@redhat.com>
Subject: Re: zero-length files in snapshots
Date: Fri, 12 Feb 2010 11:22:08 -0500
Message-ID: <20100212162207.GB4191@localhost.localdomain>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com> <m38wazywow.fsf@pullcord.laptop.org> <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com> <20100212151940.GA4191@localhost.localdomain> <93cdabd21002120818g4c47e2b6k3083a368286651e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002120818g4c47e2b6k3083a368286651e5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2010 at 08:18:01AM -0800, Mike Fedyk wrote:
> On Fri, Feb 12, 2010 at 7:19 AM, Josef Bacik <josef@redhat.com> wrote=
:
> > On Thu, Feb 11, 2010 at 08:50:48PM -0800, Mike Fedyk wrote:
> >> On Thu, Feb 11, 2010 at 7:11 PM, Chris Ball <cjb@laptop.org> wrote=
:
> >> > =A0 > echo x1 > /mnt/x/d/foo.txt || exit 2
> >> > =A0 > btrfsctl -s /mnt/x/snap /mnt/x/d
> >> >
> >> > You're just missing a sync/fsync() between these two lines.
> >> >
> >> > We argued on IRC a while ago about whether this is a sensible de=
fault;
> >> > cmason wants the no-sync version of snapshot creation to be avai=
lable,
> >> > but was amenable to the idea of changing the default to be sync =
before
> >> > snapshot, since it was pointed out that no-one other than him ha=
d
> >> > understood we were supposed to be running sync first.
> >> >
> >> You're saying that it only snapshots the on-disk data structures a=
nd
> >> not the in-memory versions? =A0That can only lead to pain. =A0What=
 do you
> >> do if something else during this race condition? =A0What would a s=
ync do
> >> to solve this? =A0Have the semantics of sync been changed in btrfs=
 from
> >> "sync everything that hasn't been written yet" to "sync this
> >> subvolume"?
> >>
> >
> > Welcome to delalloc. =A0You either get fast writes or you get all o=
f your data on
> > the disk every 5 seconds. =A0If you don't like delalloc, use ext3. =
=A0The data
> > you've written to memory doesn't go down to disk unless explicitly =
told to, such
> > as
> >
> > 1) fsync - this is obvious
> > 2) vm - the vm has decided that this dirty page has been sitting ar=
ound long
> > enough and should be written back to the disk, could happen now, co=
uld happen 10
> > years from now.
> > 3) sync - this is not as obvious. =A0sync doesn't mean anything tha=
n "start
> > writing back dirty data to the fs", and returns before it's done. =A0=
=46or btrfs
> > what that means is we run through _every_ inode that has delalloc p=
ages
> > associated with them and start writeback on them. =A0This will get =
most of your
> > data into the current transaction, which is when the snapshot happe=
ns.
> >
> > If you don't want empty files, do something like this
> >
> > btrfsctl -c /dir/to/volume
> > btrfsctl -s /dir/to/volume/snapshotname /dir/to/volume
> >
> > this is what we do with yum and its rollback plugin, and it works o=
ut quite
> > well. =A0Thanks,
> >
>=20
> Then you broke your ordering guarantee.  If the data isn't there, the
> meta-data shouldn't be there either.  So the snapshots made before th=
e
> data hits a transaction shouldn't have the file at all.

Nope, what is happening is

fd =3D creat("file")  <- this is metadata that needs to be written
write(fd, buf)      <- because of delalloc there is no metadata that is=
 created
for this operation, therefore it doesn't need to be written out.
close(fd)

so the file has metadata created for it, which needs to be written out.=
  Because
of delalloc there are no extents created or anything for the data, ther=
efore
there is nothing to write.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
