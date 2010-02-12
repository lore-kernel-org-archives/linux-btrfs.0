From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: zero-length files in snapshots
Date: Fri, 12 Feb 2010 08:27:00 -0800
Message-ID: <93cdabd21002120827k493a4c1ao2ba4b6840f2ab427@mail.gmail.com>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
	 <m38wazywow.fsf@pullcord.laptop.org>
	 <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
	 <20100212151940.GA4191@localhost.localdomain>
	 <93cdabd21002120818g4c47e2b6k3083a368286651e5@mail.gmail.com>
	 <20100212162207.GB4191@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100212162207.GB4191@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2010 at 8:22 AM, Josef Bacik <josef@redhat.com> wrote:
> On Fri, Feb 12, 2010 at 08:18:01AM -0800, Mike Fedyk wrote:
>> On Fri, Feb 12, 2010 at 7:19 AM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > On Thu, Feb 11, 2010 at 08:50:48PM -0800, Mike Fedyk wrote:
>> >> On Thu, Feb 11, 2010 at 7:11 PM, Chris Ball <cjb@laptop.org> wrot=
e:
>> >> > =C2=A0 > echo x1 > /mnt/x/d/foo.txt || exit 2
>> >> > =C2=A0 > btrfsctl -s /mnt/x/snap /mnt/x/d
>> >> >
>> >> > You're just missing a sync/fsync() between these two lines.
>> >> >
>> >> > We argued on IRC a while ago about whether this is a sensible d=
efault;
>> >> > cmason wants the no-sync version of snapshot creation to be ava=
ilable,
>> >> > but was amenable to the idea of changing the default to be sync=
 before
>> >> > snapshot, since it was pointed out that no-one other than him h=
ad
>> >> > understood we were supposed to be running sync first.
>> >> >
>> >> You're saying that it only snapshots the on-disk data structures =
and
>> >> not the in-memory versions? =C2=A0That can only lead to pain. =C2=
=A0What do you
>> >> do if something else during this race condition? =C2=A0What would=
 a sync do
>> >> to solve this? =C2=A0Have the semantics of sync been changed in b=
trfs from
>> >> "sync everything that hasn't been written yet" to "sync this
>> >> subvolume"?
>> >>
>> >
>> > Welcome to delalloc. =C2=A0You either get fast writes or you get a=
ll of your data on
>> > the disk every 5 seconds. =C2=A0If you don't like delalloc, use ex=
t3. =C2=A0The data
>> > you've written to memory doesn't go down to disk unless explicitly=
 told to, such
>> > as
>> >
>> > 1) fsync - this is obvious
>> > 2) vm - the vm has decided that this dirty page has been sitting a=
round long
>> > enough and should be written back to the disk, could happen now, c=
ould happen 10
>> > years from now.
>> > 3) sync - this is not as obvious. =C2=A0sync doesn't mean anything=
 than "start
>> > writing back dirty data to the fs", and returns before it's done. =
=C2=A0For btrfs
>> > what that means is we run through _every_ inode that has delalloc =
pages
>> > associated with them and start writeback on them. =C2=A0This will =
get most of your
>> > data into the current transaction, which is when the snapshot happ=
ens.
>> >
>> > If you don't want empty files, do something like this
>> >
>> > btrfsctl -c /dir/to/volume
>> > btrfsctl -s /dir/to/volume/snapshotname /dir/to/volume
>> >
>> > this is what we do with yum and its rollback plugin, and it works =
out quite
>> > well. =C2=A0Thanks,
>> >
>>
>> Then you broke your ordering guarantee. =C2=A0If the data isn't ther=
e, the
>> meta-data shouldn't be there either. =C2=A0So the snapshots made bef=
ore the
>> data hits a transaction shouldn't have the file at all.
>
> Nope, what is happening is
>
> fd =3D creat("file") =C2=A0<- this is metadata that needs to be writt=
en
> write(fd, buf) =C2=A0 =C2=A0 =C2=A0<- because of delalloc there is no=
 metadata that is created
> for this operation, therefore it doesn't need to be written out.
> close(fd)
>
> so the file has metadata created for it, which needs to be written ou=
t. =C2=A0Because
> of delalloc there are no extents created or anything for the data, th=
erefore
> there is nothing to write. =C2=A0Thanks,
>

So file creation is effectively synchronous?  So I could create a
benchmark that creates millions of files and it would be limited to
the IO OP performance of the disks?

Why does file creation need to hit the disk before the contents (with
limits to size of data that can fit in one transaction)?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
