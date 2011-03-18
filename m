From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [PATCH] Btrfs: check items for correctness as we search V3
Date: Fri, 18 Mar 2011 16:05:36 +0300
Message-ID: <AANLkTikkxAGf-d3Q-6wSuu3KzR1nZxssDk2wktosJkH1@mail.gmail.com>
References: <1300305863-2609-1-git-send-email-josef@redhat.com>
 <1300385915-3317-1-git-send-email-josef@redhat.com> <AANLkTingDAF7XfLNEUGVDzLd5XYV9J23A3t=qB-Modj2@mail.gmail.com>
 <1300409520-sup-5343@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300409520-sup-5343@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2011 at 3:52 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Andrey Kuzmin's message of 2011-03-17 15:12:32 -0400:
>> On Thu, Mar 17, 2011 at 9:18 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > Currently if we have corrupted items things will blow up in specta=
cular ways.
>> > So as we read in blocks and they are leaves, check the entire leaf=
 to make sure
>> > all of the items are correct and point to valid parts in the leaf =
for the item
>> > data the are responsible for. =C2=A0If the item is corrupt we will=
 kick back EIO and
>> > not read any of the copies since they are likely to not be correct=
 either. =C2=A0This
>> > will catch generic corruptions, it will be up to the individual ca=
llers of
>> > btrfs_search_slot to make sure their items are right. =C2=A0Thanks=
,
>> >
>> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> > index 495b1ac..9f31e11 100644
>> > --- a/fs/btrfs/disk-io.c
>> > +++ b/fs/btrfs/disk-io.c
>> > @@ -323,6 +323,7 @@ static int btree_read_extent_buffer_pages(stru=
ct btrfs_root *root,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int num_copies =3D 0;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int mirror_num =3D 0;
>> >
>> > + =C2=A0 =C2=A0 =C2=A0 clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflag=
s);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0io_tree =3D &BTRFS_I(root->fs_info->btr=
ee_inode)->io_tree;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0while (1) {
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D rea=
d_extent_buffer_pages(io_tree, eb, start, 1,
>> > @@ -331,6 +332,14 @@ static int btree_read_extent_buffer_pages(str=
uct btrfs_root *root,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0!verify_parent_transid(io_tree, eb, parent_transid))
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0return ret;
>> >
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* This bu=
ffer's crc is fine, but its contents are corrupted, so
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* there i=
s no reason to read the other copies, they won't be
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* any les=
s wrong.
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>>
>> This sounds like an overstatement to me. You may be dealing with an
>> error pattern CRC faled to catch, so giving up reading a mirror at
>> this point seems premature.
>
> But we have no way to tell which one is more correct, at least not
> without a full fsck.

Voting with two participants (would be better to have at least three,
though theory says even this is insufficient in the presence of
failures  :)) is naturally deficient, so you are right in general
except one particular case: when 2nd copy passes CRC _and_
verification, and two copies differ by a bit pattern undetectable by
CRC in use.

This is a corner case, of course, but the price to pay for false
positive (full fsck with associated downtime) is high enough to make
it worth a deeper dive.

Regards,
Andrey

>
> -chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
