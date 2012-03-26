From: Not Zippy <notzippy@gmail.com>
Subject: Re: btrfs: open_ctree failed
Date: Mon, 26 Mar 2012 15:36:13 -0700
Message-ID: <CANDob0JDQKObq8L2s8E7D9x_=k=MgsaMu=g0DBaZqGqCO_O70Q@mail.gmail.com>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
 <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com> <20120326215740.GA2597@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Not Zippy <notzippy@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120326215740.GA2597@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo
I did try the dangerdonteveruse branch and thats the error btrfsck
--repair gave me. Looks like the btrfs-restore command may work
(thanks!). And yes I do have backups for the important data - I had
some other data on there which would need to be d/l again..

I don't dabble that much with the kernel - this is a straight ubuntu
which I regularly do their updates - Can I advance the kernel beyond ?
If your recommending this I will definitely look into it (since I dont
want a repeat of this to occur) Does this article describe the update
well enough ? http://www.upubuntu.com/2012/03/how-to-install-linux-33-k=
ernel-in.html

Thanks for the help
Nz

>
> =A0 btrfsck doesn't fix anything. It just checks the FS and tells you
> that there's something wrong (which it just did). If you're feeling
> very very brave, there's the "dangerdonteveruse" branch of the
> btrfs-progs tools in cmason's git, which might fix things.
> Alternatively, it might fuck up your filesystem so badly there's no
> way you can retrieve any remaining data from it. Your choice.
>
>> My kernel 3.0.0-16-generic, any hope for this ? Or is he dead jim ? =
I
> =A0 =A0 =A0 =A0 =A0 =A0^^^^^ Old, old, old. It's a bit late now, but =
you should
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0really keep up with the latest ker=
nels. That should help
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mi=
nimise this kind of event.
>
>> don't have any snapshots of the partition.
>
> =A0 btrfs snapshots wouldn't help here. LVM snapshots would, of cours=
e.
>
> =A0 There's a restore tool that may allow you to copy off any data
> that's not backed up (you *do* have backups, right? for an
> experimental filesystem?). See the wiki at [1].
>
> =A0 Hugo.
>
> [1] http://btrfs.ipv5.de/index.php?title=3DRestore
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org=
=2Euk
> =A0 =A0--- "I will not be pushed, =A0filed, stamped, indexed, briefed=
, ---
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 debriefed or numbered. =A0My life is my o=
wn."
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
