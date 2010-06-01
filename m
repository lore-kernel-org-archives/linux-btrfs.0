From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
Date: Tue, 1 Jun 2010 09:19:22 -0400
Message-ID: <20100601131922.GJ8980@think>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
 <1274461422-18433-6-git-send-email-josef@redhat.com>
 <AANLkTiljjXsML35vHoUc-XXTrbOft6TO1KKZyYdj3HUn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTiljjXsML35vHoUc-XXTrbOft6TO1KKZyYdj3HUn@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 30, 2010 at 07:33:33PM +1000, Dmitri Nikulin wrote:
> On Sat, May 22, 2010 at 3:03 AM, Josef Bacik <josef@redhat.com> wrote=
:
> > + =A0 =A0 =A0 while (1) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock_extent(tree, start, end, GFP_NOF=
S);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ordered =3D btrfs_lookup_ordered_exte=
nt(inode, start);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ordered)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_extent(tree, start, end, GFP_N=
OFS);
>=20
> Is it ok not to unlock_extent if !ordered?
> I don't know if you fixed this in a later version but it stuck out to=
 me :)

The construct is confusing.  Ordered extents track things that we have
allocated on disk and need to write.  New ones can't be created while w=
e
have the extent range locked.  But we can't force old ones to disk with
the lock held.

So, we lock then lookup and if we find nothing we can safely do our
operation because no io is in progress.  We unlock a little later on, o=
r
at endio time.

If we find an ordered extent we drop the lock and wait for that IO to
finish, then loop again.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
