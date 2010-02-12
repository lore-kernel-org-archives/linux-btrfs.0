From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: zero-length files in snapshots
Date: Fri, 12 Feb 2010 08:18:01 -0800
Message-ID: <93cdabd21002120818g4c47e2b6k3083a368286651e5@mail.gmail.com>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
	 <m38wazywow.fsf@pullcord.laptop.org>
	 <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
	 <20100212151940.GA4191@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100212151940.GA4191@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2010 at 7:19 AM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Feb 11, 2010 at 08:50:48PM -0800, Mike Fedyk wrote:
>> On Thu, Feb 11, 2010 at 7:11 PM, Chris Ball <cjb@laptop.org> wrote:
>> > =C2=A0 > echo x1 > /mnt/x/d/foo.txt || exit 2
>> > =C2=A0 > btrfsctl -s /mnt/x/snap /mnt/x/d
>> >
>> > You're just missing a sync/fsync() between these two lines.
>> >
>> > We argued on IRC a while ago about whether this is a sensible defa=
ult;
>> > cmason wants the no-sync version of snapshot creation to be availa=
ble,
>> > but was amenable to the idea of changing the default to be sync be=
fore
>> > snapshot, since it was pointed out that no-one other than him had
>> > understood we were supposed to be running sync first.
>> >
>> You're saying that it only snapshots the on-disk data structures and
>> not the in-memory versions? =C2=A0That can only lead to pain. =C2=A0=
What do you
>> do if something else during this race condition? =C2=A0What would a =
sync do
>> to solve this? =C2=A0Have the semantics of sync been changed in btrf=
s from
>> "sync everything that hasn't been written yet" to "sync this
>> subvolume"?
>>
>
> Welcome to delalloc. =C2=A0You either get fast writes or you get all =
of your data on
> the disk every 5 seconds. =C2=A0If you don't like delalloc, use ext3.=
 =C2=A0The data
> you've written to memory doesn't go down to disk unless explicitly to=
ld to, such
> as
>
> 1) fsync - this is obvious
> 2) vm - the vm has decided that this dirty page has been sitting arou=
nd long
> enough and should be written back to the disk, could happen now, coul=
d happen 10
> years from now.
> 3) sync - this is not as obvious. =C2=A0sync doesn't mean anything th=
an "start
> writing back dirty data to the fs", and returns before it's done. =C2=
=A0For btrfs
> what that means is we run through _every_ inode that has delalloc pag=
es
> associated with them and start writeback on them. =C2=A0This will get=
 most of your
> data into the current transaction, which is when the snapshot happens=
=2E
>
> If you don't want empty files, do something like this
>
> btrfsctl -c /dir/to/volume
> btrfsctl -s /dir/to/volume/snapshotname /dir/to/volume
>
> this is what we do with yum and its rollback plugin, and it works out=
 quite
> well. =C2=A0Thanks,
>

Then you broke your ordering guarantee.  If the data isn't there, the
meta-data shouldn't be there either.  So the snapshots made before the
data hits a transaction shouldn't have the file at all.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
