From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Two way mirror in BRTFS
Date: Fri, 30 Dec 2011 20:27:24 +0700
Message-ID: <CAG1y0sd2AvxucVJ5BKc4ysu08gS6SF7GJNX2DiP17co_NN6xLg@mail.gmail.com>
References: <135478.27027.62193-16529-1080748879-1325245275@email.cz>
	<135518.24516.61340-2734-1521609493-1325248365@email.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: jaromir.zdrazil@email.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <135518.24516.61340-2734-1521609493-1325248365@email.cz>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/30 Jaromir Zdrazil <jaromir.zdrazil@email.cz>:
> Sorry fo the typo in the subject!
>
> Just to add, I would like to see a two way mirror solution, but if it=
 will not work now/is not implemnted yet, I would propably choose betwe=
en drbd in asynchronous mode or make a some kind if "incremental" snaps=
hot to a remote mapped disk (I do not know yet, if brtfs support it) =A0=
- it means have one shapshop and let's say have a daily incremental upd=
ate of this snapshot.

You mean like "zfs send -i"? If yes, why not just use zfs? There's
zfsonlinux project, with easy-to-install ppa for ubuntu. Or you could
compile it manually.

>
> How would you do it?

If you DO mean zfs-send-like-functionality, then you should ask about
"btrfs send and receive", not "two way mirror" (which is not an
accurate way to describe what you want). Also, send/receive ability
does not mean it can act as two-way mirror. It CAN be an alternative
to drbd async though.

I don't think there's any publicly available code for it yet though.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
