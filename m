From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: break out of orphan cleanup if we can't make
 progress V2
Date: Mon, 10 Oct 2011 10:08:30 -0500
Message-ID: <CAKcLGm_Ro1GS0Nkh+Km_AH=2kAwFHbMjO9gS2C9Mq7jpUMrT-Q@mail.gmail.com>
References: <1317743692-10794-1-git-send-email-josef@redhat.com>
	<CAKcLGm-XbksMab=qbzN5O15T42OdDg6zERSDfhskuTgueKnA3Q@mail.gmail.com>
	<20111010002813.GB25337@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111010002813.GB25337@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 9, 2011 at 7:28 PM, Josef Bacik <josef@redhat.com> wrote:
> On Sun, Oct 09, 2011 at 02:14:19PM -0500, Mitch Harder wrote:
>> On Tue, Oct 4, 2011 at 10:54 AM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > I noticed while running xfstests 83 that if we didn't have enough =
space to
>> > delete our inode the orphan cleanup would just loop. =A0This is be=
cause it keeps
>> > finding the same orphan item and keeps trying to kill it but can't=
 because we
>> > don't get an error back from iput for deleting the inode. =A0So ke=
ep track of the
>> > last guy we tried to kill, if it's the same as the one we're tryin=
g to kill
>> > currently we know we are having problems and can just error out. =A0=
I don't have a
>> > way to test this so look hard and make sure it's right. =A0Thanks,
>> >
>> > Signed-off-by: Josef Bacik <josef@redhat.com>
>> > ---
>> > V1->V2: set last_objectid properly
>> >
>> > =A0fs/btrfs/inode.c | =A0 11 +++++++++++
>> > =A01 files changed, 11 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> > index 446531a..595a807 100644
>> > --- a/fs/btrfs/inode.c
>> > +++ b/fs/btrfs/inode.c
>> > @@ -2230,6 +2230,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *=
root)
>> > =A0 =A0 =A0 =A0struct btrfs_key key, found_key;
>> > =A0 =A0 =A0 =A0struct btrfs_trans_handle *trans;
>> > =A0 =A0 =A0 =A0struct inode *inode;
>> > + =A0 =A0 =A0 u64 last_objectid =3D 0;
>> > =A0 =A0 =A0 =A0int ret =3D 0, nr_unlink =3D 0, nr_truncate =3D 0;
>> >
>> > =A0 =A0 =A0 =A0if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_=
CLEANUP_STARTED))
>> > @@ -2281,6 +2282,16 @@ int btrfs_orphan_cleanup(struct btrfs_root =
*root)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * crossing root thing. =A0we store=
 the inode number in the
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * offset of the orphan item.
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (found_key.offset =3D=3D last_obj=
ectid) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "btr=
fs: Error removing orphan entry, "
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"stop=
ping orphan cleanup\n");
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_objectid =3D found_key.offset;
>> > +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0found_key.objectid =3D found_key.of=
fset;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0found_key.type =3D BTRFS_INODE_ITEM=
_KEY;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0found_key.offset =3D 0;
>> > --
>> > 1.7.5.2
>> >
>>
>> Just in case it gets lost in the shuffle between github and
>> git.kernel.org, and also for the benefit of those testing Chris
>> Mason's integration-test branch on github, please note that version =
1
>> of this patch is still in Chris' integration-test branch, as well as
>> in Josef's github kernel repos (master and for-chris branch only, th=
e
>> unstable branch has this version of the patch).
>
> I've migrated back to git.kernel.org btw so the right version should =
be in
> git.kernel.org. =A0Would it be usefull if I keep up the github tree a=
s well?
> Thanks,
>
> Josef
>

As far as I'm concerned, maintaining multiple public trees isn't necess=
ary.

I just wanted to make sure this patch wasn't lost in the shuffle.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
