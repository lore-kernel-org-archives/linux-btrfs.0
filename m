From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
Date: Sun, 30 May 2010 19:33:33 +1000
Message-ID: <AANLkTiljjXsML35vHoUc-XXTrbOft6TO1KKZyYdj3HUn@mail.gmail.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
	<1274461422-18433-6-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1274461422-18433-6-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 22, 2010 at 3:03 AM, Josef Bacik <josef@redhat.com> wrote:
> + =C2=A0 =C2=A0 =C2=A0 while (1) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lock_extent(tree, =
start, end, GFP_NOFS);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ordered =3D btrfs_=
lookup_ordered_extent(inode, start);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ordered)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unlock_extent(tree=
, start, end, GFP_NOFS);

Is it ok not to unlock_extent if !ordered?
I don't know if you fixed this in a later version but it stuck out to m=
e :)

--=20
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
