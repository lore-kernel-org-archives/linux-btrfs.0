From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: zero-length files in snapshots
Date: Thu, 11 Feb 2010 20:50:48 -0800
Message-ID: <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
	 <m38wazywow.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m38wazywow.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2010 at 7:11 PM, Chris Ball <cjb@laptop.org> wrote:
> =C2=A0 > echo x1 > /mnt/x/d/foo.txt || exit 2
> =C2=A0 > btrfsctl -s /mnt/x/snap /mnt/x/d
>
> You're just missing a sync/fsync() between these two lines.
>
> We argued on IRC a while ago about whether this is a sensible default=
;
> cmason wants the no-sync version of snapshot creation to be available=
,
> but was amenable to the idea of changing the default to be sync befor=
e
> snapshot, since it was pointed out that no-one other than him had
> understood we were supposed to be running sync first.
>
You're saying that it only snapshots the on-disk data structures and
not the in-memory versions?  That can only lead to pain.  What do you
do if something else during this race condition?  What would a sync do
to solve this?  Have the semantics of sync been changed in btrfs from
"sync everything that hasn't been written yet" to "sync this
subvolume"?

=46rom what I understand what should be happening is much like what LVM=
 should do:

step 1: defer all other writes to subvolume (userspace processes get
stuck in D state until step 4)
step 2: sync all changes not already committed to subvolume
step 3: create snapshot
step 4: resume writes from userspace

Now if all 4 steps can be done with in-memory data structures without
forcing data (not necessarily meta-data) to disk, so much the better.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
