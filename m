From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: Btrfs partition lost after RAID1 mirror disk failure?
Date: Tue, 3 Jan 2012 15:49:36 -0600
Message-ID: <CAGAVQTGMH0Y_5BvC6nxGsMcb3Dg2r8VEC10SN+gKRc08B1yDpA@mail.gmail.com>
References: <CA+h3BtujUZbu17t0FSEht2wytE7Kj8T9DbAS7T74+c0bOWNnGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Dan Garton <dan.garton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+h3BtujUZbu17t0FSEht2wytE7Kj8T9DbAS7T74+c0bOWNnGA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 3, 2012 at 8:44 AM, Dan Garton <dan.garton@gmail.com> wrote=
:
>
>  [...]
> =C2=A01327 =C2=A0btrfs-vol -a
> =C2=A01328 =C2=A0btrfs-vol -a /nuvat
> =C2=A01329 =C2=A0btrfs-vol -a asdasd /nuvat
> =C2=A01330 =C2=A0btrfs-vol -a missing /nuvat
> =C2=A01331 =C2=A0btrfs-vol -a /dev/sdc /nuvat
> =C2=A01332 =C2=A0btrfs-vol -a /dev/sdb /nuvat
> =C2=A01334 =C2=A0btrfs-vol -a missing /nuvat
>  [...]

these look destructive to me ... adding the wrong devices and the
existing devices back to the current array?  IIRC you should have `-r
missing`, but in general, do not use the btrfsctl utility at all -- it
won't have as much visibility/exception-handling/recovery as the
`btrfs` utility.

at what point did your FS become inaccessible?  your command history
suggest it was working until shortly after these commands ... :-(

--=20

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
