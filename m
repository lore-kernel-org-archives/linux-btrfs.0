From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Fwd: What to do about subvolumes?
Date: Fri, 3 Dec 2010 14:47:44 +0100
Message-ID: <AANLkTi=5vyGqdoFPC=c5yf-g_A8uLvi4txvWm4iq65bK@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<4CF76BB3.3020705@gmx.net>
	<1291306150-sup-7861@think>
	<4CF7D40D.508@electric-spoon.com>
	<AANLkTinBzpoCnci+1a=0pjXbAdQ7mzpdr2k8GOo7HUc8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinBzpoCnci+1a=0pjXbAdQ7mzpdr2k8GOo7HUc8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/12/2 David Pottage <david@electric-spoon.com>:
>
> Therefore I think it is a bad idea if potentially different files on =
btrfs
> can have the same inode number. It will break all sorts of tools.
>
> Instead of maintaining a big complicated reference count of used inod=
e
> numbers, could btrfs use bit masks to create a the userland visible i=
node
> number from the subvolume id and the real internal inode number. Some=
thing
> like:
>
> userland_inode =3D ( volume_id << 48 ) & internal_inode;
>
> Please forgive me if this is impossible, or if that C snippet is
> syntactically incorrect. I am not a filesystem or kernel developer, a=
nd I
> have not coded in C for many years.
>
> --
> David Pottage
>

Expanding on the idea: what about a pool of IDs for subvolumes and
inode numbers inside a subvolume having the subvolume ID as a prefix?
It gives each inode a unique number, doesn't require cheating the
userland and is less costly than keeping reference count for each
inode. The obvious downside that I can see is limitation on number of
subvolumes that it would be possible to create. It also lowers the
maximum number of inodes in a filesystem (because of bits taken up by
subvolume ID). I expect there are also less-than obvious downsides.

Just an idea by a kernel and FS ignorant.

--
Pawe=C5=82 Brodacki
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
