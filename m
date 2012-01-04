From: Dan Garton <dan.garton@gmail.com>
Subject: Btrfs partition lost after RAID1 mirror disk failure?
Date: Wed, 4 Jan 2012 20:35:02 +0000
Message-ID: <CA+h3Btv8gt4SFiXe7p5GEwyRU3pi3F_-dTzRbUiQUc_U75j4fg@mail.gmail.com>
References: <CA+h3BtujUZbu17t0FSEht2wytE7Kj8T9DbAS7T74+c0bOWNnGA@mail.gmail.com>
	<CAGAVQTGMH0Y_5BvC6nxGsMcb3Dg2r8VEC10SN+gKRc08B1yDpA@mail.gmail.com>
	<CA+h3BtsdcOnvXfjcUzRvEYFw_RavNE38hMP61RFXiSNoCHsGvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+h3BtsdcOnvXfjcUzRvEYFw_RavNE38hMP61RFXiSNoCHsGvg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, thanks for the reply.

Yes, I agree, after going back over the commands, those ones you
highlighted seem very suspicious....
These commands were executed weeks ago amid a fair amount of confusion.

But yes, I think that you are right - from memory the FS became
inaccessible at about the time you mention.
I would say that was the best theory as regards this problem.

Assuming that this is the case, do I stand a chance of retrieving that
volume and accessing that data again?
Or does "destructive" imply total loss? (In which case, I'll cut my los=
ses....)



On 3 January 2012 21:49, C Anthony Risinger <anthony@xtfx.me> wrote:
>
> On Tue, Jan 3, 2012 at 8:44 AM, Dan Garton <dan.garton@gmail.com> wro=
te:
> >
> > =C2=A0[...]
> > =C2=A01327 =C2=A0btrfs-vol -a
> > =C2=A01328 =C2=A0btrfs-vol -a /nuvat
> > =C2=A01329 =C2=A0btrfs-vol -a asdasd /nuvat
> > =C2=A01330 =C2=A0btrfs-vol -a missing /nuvat
> > =C2=A01331 =C2=A0btrfs-vol -a /dev/sdc /nuvat
> > =C2=A01332 =C2=A0btrfs-vol -a /dev/sdb /nuvat
> > =C2=A01334 =C2=A0btrfs-vol -a missing /nuvat
> > =C2=A0[...]
>
> these look destructive to me ... adding the wrong devices and the
> existing devices back to the current array? =C2=A0IIRC you should hav=
e `-r
> missing`, but in general, do not use the btrfsctl utility at all -- i=
t
> won't have as much visibility/exception-handling/recovery as the
> `btrfs` utility.
>
> at what point did your FS become inaccessible? =C2=A0your command his=
tory
> suggest it was working until shortly after these commands ... :-(
>
> --
>
> C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
