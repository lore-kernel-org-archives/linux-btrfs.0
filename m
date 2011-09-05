From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Snapshot of root makes an undeletable folder
Date: Mon, 5 Sep 2011 13:29:50 -0400
Message-ID: <CALJXSJq7O=9xddctdZtmiTvRk8u9wBtjr52pNQ0CJ_W5Sv-Avg@mail.gmail.com>
References: <CALJXSJprxWVE3Ms1PLzWBgWa4MutRLeG0f7xx2Q58LW0nhbFrw@mail.gmail.com>
 <20110904210552.GA1403@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ilya Dryomov <idryomov@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110904210552.GA1403@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 4, 2011 at 5:05 PM, Ilya Dryomov <idryomov@gmail.com> wrote=
:
> On Sun, Sep 04, 2011 at 11:29:43AM -0400, J=C3=A9r=C3=B4me Poulin wro=
te:
>> Then I though about my folder organization again and renamed music t=
o
>> downloads, this is still OK and then create music in downloads, I wa=
s
>> told "music" already exists, however I can't neither see it, list it=
,
>> cd to it or remove it.
>
> This is because music directory actually exists. =C2=A0When you execu=
ted
>
> btrfs sub snap . music
>
> btrfs created music directory item in your default subvolume and *the=
n*
> took a snapshot of the default subvolume with that music directory it=
em
> already in it. =C2=A0Btrfs readdir skips references from the snapshot=
 to
> itself, so you can't see it. =C2=A0Even though you renamed your snaps=
hot to
> "downloads", snapshot's contents still don't allow you to create a
> "music" directory in it.
>

I understand that btrfs creates a snapshot containing the snapshot
directory however in my tests on a clean FS, as soon as I create a
second snapshot I am able to rmdir it.

> The correct way to do what you want is to create a subvolume "music",
> and move folders from default to music. =C2=A0Then you can snapshot y=
our
> newly created music subvolume in a clean way, rename it, etc.
>

This is where cp --reflink=3Dalways is useful as move copies the files
across subvolumes.

>> I then made a snapshot of downloads to music and now music is listed=
 as:
>> ls: cannot access /mnt/btrfs/downloads/music: No such file or direct=
ory
>> d????????? ? ? =C2=A0 =C2=A0 =C2=A0? =C2=A0 =C2=A0 =C2=A0 =C2=A0 ? =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0? music
>
> What command and in what directory did you run to make a snapshot of
> downloads to music ? =C2=A0I can't reproduce this off-hand.
>

I wasn't able to reproduce this unreadable directory using a clean FS
or similar operations, this was just 'ls' trying to list the downloads
directory.

>> btrfsck gives me:
=2E..
>>
>> There is also a OOPS associated to it:
=2E..
>>
>>
>> So as a workaround I applied to my kernel 2 patches:
>> * Btrfs-reverse-enough-space-for-file-clone.patch
>> (I hope this patch is in 3.1, as it could cause DoS else.)
>> * 2-2-btrfs-allow-cross-subvolume-BTRFS_IOC_CLONE.patch
>>

Any idea why those patch aren't part of the main tree yet?

>> I snapshotted the btrfs volume using LVM to test, made a new
>> subvolume, cp -a --reflink=3Dalways the content of the downloads
>> subvolume except music, then deleted the other subvolume, and now
>> everything works, btrfsck is happy and no more problems.
>>

And will the filesystem be stable if I use this method? Or should I
re-make a new btrfs ?

>> I will keep working with the old subvolume until I get an answer in
>> case you need more informations.

Should I keep it?

>> I can also tell that this is half-reproducible using a new btrfs
>> filesystem and snapshotting the root, except that after the second
>> snapshot the folder won't appear as unlistable, however it is not
>> removable unless you delete the original subvolume.
>
> I'm not sure what do you mean by "it's not removable" part, but the p=
art
> where after a second snapshot you can see the folder is expected
> behaviour due to the fact that Btrfs allows subvolumes (and snapshots=
)
> anywhere in the tree, but with only one access point (the dentry adde=
d
> on creation). =C2=A0This is done to avoid various problems related to=
 hard
> links, and the rest of those points appear as empty directories with =
a
> special inode number.
>

This is to be expected after what you explained.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
