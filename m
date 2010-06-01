From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
Date: Wed, 2 Jun 2010 09:20:20 +1000
Message-ID: <AANLkTikeSoXZYQF_SkWbgejM6b65LUvy6JH8Pavxo8Iz@mail.gmail.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
	<1274461422-18433-6-git-send-email-josef@redhat.com> <AANLkTiljjXsML35vHoUc-XXTrbOft6TO1KKZyYdj3HUn@mail.gmail.com>
	<20100601131922.GJ8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100601131922.GJ8980@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 1, 2010 at 11:19 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
>> Is it ok not to unlock_extent if !ordered?
>> I don't know if you fixed this in a later version but it stuck out t=
o me :)
>
> The construct is confusing. =C2=A0Ordered extents track things that w=
e have
> allocated on disk and need to write. =C2=A0New ones can't be created =
while we
> have the extent range locked. =C2=A0But we can't force old ones to di=
sk with
> the lock held.
>
> So, we lock then lookup and if we find nothing we can safely do our
> operation because no io is in progress. =C2=A0We unlock a little late=
r on, or
> at endio time.
>
> If we find an ordered extent we drop the lock and wait for that IO to
> finish, then loop again.

Ok, that's fair enough. Maybe it's worth commenting, I'm sure I'm not
the only one surprised.

Thanks,

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
