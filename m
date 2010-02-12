From: Josef Bacik <josef@redhat.com>
Subject: Re: zero-length files in snapshots
Date: Fri, 12 Feb 2010 10:19:40 -0500
Message-ID: <20100212151940.GA4191@localhost.localdomain>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com> <m38wazywow.fsf@pullcord.laptop.org> <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2010 at 08:50:48PM -0800, Mike Fedyk wrote:
> On Thu, Feb 11, 2010 at 7:11 PM, Chris Ball <cjb@laptop.org> wrote:
> > =A0 > echo x1 > /mnt/x/d/foo.txt || exit 2
> > =A0 > btrfsctl -s /mnt/x/snap /mnt/x/d
> >
> > You're just missing a sync/fsync() between these two lines.
> >
> > We argued on IRC a while ago about whether this is a sensible defau=
lt;
> > cmason wants the no-sync version of snapshot creation to be availab=
le,
> > but was amenable to the idea of changing the default to be sync bef=
ore
> > snapshot, since it was pointed out that no-one other than him had
> > understood we were supposed to be running sync first.
> >
> You're saying that it only snapshots the on-disk data structures and
> not the in-memory versions?  That can only lead to pain.  What do you
> do if something else during this race condition?  What would a sync d=
o
> to solve this?  Have the semantics of sync been changed in btrfs from
> "sync everything that hasn't been written yet" to "sync this
> subvolume"?
>=20

Welcome to delalloc.  You either get fast writes or you get all of your=
 data on
the disk every 5 seconds.  If you don't like delalloc, use ext3.  The d=
ata
you've written to memory doesn't go down to disk unless explicitly told=
 to, such
as

1) fsync - this is obvious
2) vm - the vm has decided that this dirty page has been sitting around=
 long
enough and should be written back to the disk, could happen now, could =
happen 10
years from now.
3) sync - this is not as obvious.  sync doesn't mean anything than "sta=
rt
writing back dirty data to the fs", and returns before it's done.  For =
btrfs
what that means is we run through _every_ inode that has delalloc pages
associated with them and start writeback on them.  This will get most o=
f your
data into the current transaction, which is when the snapshot happens.

If you don't want empty files, do something like this

btrfsctl -c /dir/to/volume
btrfsctl -s /dir/to/volume/snapshotname /dir/to/volume

this is what we do with yum and its rollback plugin, and it works out q=
uite
well.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
