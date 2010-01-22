From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 22 Jan 2010 10:33:46 +0100
Message-ID: <20100122093346.GW29256@jeru.org>
References: <201001212029.26681.kreijack@libero.it> <20100122011107.7bc36b2b@simplux>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, David Nicol <davidnicol@gmail.com>,
	taruishi.hiroak@jp.fujitsu.com
To: Michael Niederle <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100122011107.7bc36b2b@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Le 22 janvier 2010 =E0 01:11, Michael Niederle a =E9crit:
> >         btrfs clone|-c <source> [<dest>/]<name>    =20
> >                 Clone the subvolume <source> with the name <name> i=
n the=20
> > <dest>
> >                 directory.                                         =
           =20

Maybe you should add the "writable snapshot" in the description, since
everyone is using the word "snapshot" on the mailing list.
When I hear "clone", I understand "dump".

> >         btrfs delete|-d
> > <subvolume> Delete the subvolume <subvolume>.                      =
       =20

> >         btrfs rem|-R <dev> <path>
> >                 Remove a device to a filesystem

> Just a small suggestion:
> "btrfs remove" instead of "btrfs rem"

Why not "btrfs rm", which reminds "git rm" ?
Actually, I would do something like:

btrfs vol add
btrfs vol rm

btrfs dev add
btrfs dev rm=20

It would bet simpler, wouldn't it ?

--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
